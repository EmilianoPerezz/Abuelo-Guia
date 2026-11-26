import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../data/requisitos.dart';
import 'tramite.dart';

class GeminiError implements Exception {
  final String mensaje;
  GeminiError(this.mensaje);

  @override
  String toString() => mensaje;
}

class GeminiService {
  static const String apiKey = String.fromEnvironment('GEMINI_API_KEY');
  static const String modelo =
      String.fromEnvironment('GEMINI_MODEL', defaultValue: 'gemini-3.5-flash-lite');
  static const String modeloRespaldo = 'gemini-3.8-flash';

  static bool get tieneClave => apiKey.isNotEmpty && apiKey != 'PEGUE_AQUI_SU_CLAVE';

  static String get _reglas {
    final lista = requisitos.map((r) => '- ${r.id}: ${r.nombre}. ${r.detalle}').join('\n');
    return '''
Eres Abuelo Guía, un asistente amable que ayuda a personas adultas mayores de México con el trámite "$nombreTramite".
Habla siempre de "usted", con palabras sencillas, frases cortas y tono cálido y paciente.
No uses tecnicismos, listas, asteriscos, emojis ni formato Markdown, porque tu respuesta se leerá en voz alta.
Usa solo esta lista oficial de requisitos y no inventes otros:
$lista
- También debe llevar un número de teléfono propio y uno de un familiar o persona de confianza.
Si no sabes algo con seguridad, dilo y recomienda confirmar en su Módulo de Bienestar o en gob.mx/bienestar.
Nunca pidas ni repitas datos personales completos como números de CURP, INE o direcciones.
''';
  }

  static Future<Revision> revisarDocumento(Uint8List foto, String tipo) async {
    final hoy = DateTime.now();
    final fecha = '${hoy.day}/${hoy.month}/${hoy.year}';
    final instrucciones = '''
Hoy es $fecha. Mira la foto y dime qué documento es y si sirve para el trámite.
Reglas:
- "requisito" debe ser uno de: identificacion, curp, acta, domicilio, ninguno.
- "sirve" es true solo si el documento corresponde a un requisito, se lee bien y cumple la condición (vigente, o comprobante con máximo 6 meses).
- Si la foto está borrosa, oscura o cortada, "sirve" es false y en "siguiente_paso" pide tomar otra foto con más luz y la hoja completa.
- "documento": nombre corto del documento, por ejemplo "Credencial del INE".
- "explicacion": máximo 2 frases cortas que digan qué es y si sirve o por qué no.
- "siguiente_paso": 1 o 2 frases cortas con lo que debe hacer ahora.
${tramite.resumenParaIA()}
No copies números ni datos personales del documento en tu respuesta.
''';

    final cuerpo = {
      'systemInstruction': {
        'parts': [
          {'text': _reglas}
        ]
      },
      'contents': [
        {
          'role': 'user',
          'parts': [
            {'text': instrucciones},
            {
              'inlineData': {'mimeType': tipo, 'data': base64Encode(foto)}
            },
          ],
        }
      ],
      'generationConfig': {
        'responseMimeType': 'application/json',
        'responseJsonSchema': {
          'type': 'object',
          'properties': {
            'requisito': {
              'type': 'string',
              'enum': ['identificacion', 'curp', 'acta', 'domicilio', 'ninguno'],
            },
            'documento': {'type': 'string'},
            'sirve': {'type': 'boolean'},
            'explicacion': {'type': 'string'},
            'siguiente_paso': {'type': 'string'},
          },
          'required': ['requisito', 'documento', 'sirve', 'explicacion', 'siguiente_paso'],
        },
      },
    };

    final texto = await _enviar(cuerpo);
    try {
      final limpio = texto.replaceAll('```json', '').replaceAll('```', '').trim();
      return Revision.desdeJson(jsonDecode(limpio) as Map<String, dynamic>);
    } catch (_) {
      throw GeminiError('No pude leer bien el documento. Intente tomar otra foto con más luz.');
    }
  }

  static Future<String> preguntar(String pregunta) async {
    final contenidos = <Map<String, dynamic>>[
      {
        'role': 'user',
        'parts': [
          {'text': 'Situación actual de la persona: ${tramite.resumenParaIA()}'}
        ],
      },
      {
        'role': 'model',
        'parts': [
          {'text': 'Entendido. Le ayudo con gusto.'}
        ],
      },
    ];

    var historial = tramite.conversacion;
    if (historial.isNotEmpty && historial.last.esUsuario) {
      historial = historial.sublist(0, historial.length - 1);
    }
    final inicio = historial.length > 10 ? historial.length - 10 : 0;
    for (final m in historial.sublist(inicio)) {
      contenidos.add({
        'role': m.esUsuario ? 'user' : 'model',
        'parts': [
          {'text': m.texto}
        ],
      });
    }
    contenidos.add({
      'role': 'user',
      'parts': [
        {'text': '$pregunta\n(Responde en máximo 3 frases cortas.)'}
      ],
    });

    final texto = await _enviar({
      'systemInstruction': {
        'parts': [
          {'text': _reglas}
        ]
      },
      'contents': contenidos,
    });
    return texto.replaceAll(RegExp(r'[*#_`]'), '').trim();
  }

  static Future<String> _enviar(Map<String, dynamic> cuerpo) async {
    if (!tieneClave) {
      throw GeminiError('Falta conectar la clave de Gemini. Revise el archivo .env.');
    }

    final modelos = [modelo, if (modelo != modeloRespaldo) modeloRespaldo];
    final intentos = [for (final m in modelos) ...[m, m]];
    late http.Response respuesta;

    for (var i = 0; i < intentos.length; i++) {
      final url = Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/${intentos[i]}:generateContent');
      try {
        respuesta = await http
            .post(
              url,
              headers: {
                'Content-Type': 'application/json',
                'x-goog-api-key': apiKey,
              },
              body: jsonEncode(cuerpo),
            )
            .timeout(const Duration(seconds: 60));
      } on SocketException {
        throw GeminiError('No hay conexión a internet. Revise su señal e intente otra vez.');
      } on TimeoutException {
        throw GeminiError('La respuesta tardó mucho. Intente otra vez en un momento.');
      } catch (_) {
        throw GeminiError('No pude conectarme. Intente otra vez.');
      }
      final ocupado = respuesta.statusCode == 503 || respuesta.statusCode == 500;
      if (!ocupado || i == intentos.length - 1) break;
      await Future.delayed(Duration(seconds: 2 + i * 2));
    }

    if (respuesta.statusCode == 503 || respuesta.statusCode == 500) {
      throw GeminiError('El asistente está muy ocupado en este momento. Intente otra vez en un minuto.');
    }

    final error = respuesta.body.toLowerCase();
    if (respuesta.statusCode == 403 || error.contains('api key') || error.contains('api_key')) {
      throw GeminiError('La clave de Gemini no funciona. Pida ayuda a quien instaló la app.');
    }
    if (respuesta.statusCode == 429) {
      throw GeminiError('Hay muchas consultas en este momento. Espere un minuto e intente otra vez.');
    }
    if (respuesta.statusCode != 200) {
      throw GeminiError('Hubo un problema con el asistente. Intente otra vez.');
    }

    final datos = jsonDecode(utf8.decode(respuesta.bodyBytes)) as Map<String, dynamic>;
    final candidatos = datos['candidates'] as List?;
    if (candidatos == null || candidatos.isEmpty) {
      throw GeminiError('No obtuve respuesta. Intente decirlo de otra forma.');
    }
    final partes = (candidatos.first['content']?['parts'] as List?) ?? [];
    final texto = partes
        .where((p) => p['thought'] != true && p['text'] != null)
        .map((p) => p['text'].toString())
        .join();
    if (texto.trim().isEmpty) {
      throw GeminiError('No obtuve respuesta. Intente decirlo de otra forma.');
    }
    return texto;
  }
}

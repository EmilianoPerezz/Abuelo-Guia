import 'package:material_ui/material_ui.dart';

import '../services/gemini_service.dart';
import '../services/tramite.dart';
import '../services/voz_service.dart';
import '../theme/app_colors.dart';
import '../widgets/cargando.dart';
import '../widgets/info_card.dart';
import '../widgets/secondary_button.dart';
import '../widgets/voice_button.dart';

class PreguntarScreen extends StatefulWidget {
  const PreguntarScreen({super.key});

  @override
  State<PreguntarScreen> createState() => _PreguntarScreenState();
}

class _PreguntarScreenState extends State<PreguntarScreen> {
  final ScrollController _scroll = ScrollController();
  bool _escuchando = false;
  bool _pensando = false;
  String _loQueEscucho = '';
  String? _error;

  static const List<String> _sugerencias = [
    '¿Qué documentos necesito?',
    '¿Dónde hago el trámite?',
    '¿Qué es un comprobante de domicilio?',
  ];

  @override
  void dispose() {
    VozService.dejarDeEscuchar();
    VozService.callar();
    _scroll.dispose();
    super.dispose();
  }

  void _bajar() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _tocarMicrofono() async {
    if (_pensando) return;
    if (_escuchando) {
      await VozService.dejarDeEscuchar();
      setState(() => _escuchando = false);
      return;
    }
    setState(() {
      _error = null;
      _loQueEscucho = '';
      _escuchando = true;
    });
    final funciona = await VozService.escuchar(
      alEscuchar: (texto, terminado) {
        if (!mounted) return;
        setState(() => _loQueEscucho = texto);
        if (terminado && texto.trim().isNotEmpty) {
          setState(() => _escuchando = false);
          _enviar(texto);
        }
      },
      alTerminar: () {
        if (!mounted) return;
        setState(() => _escuchando = false);
      },
    );
    if (!funciona && mounted) {
      setState(() {
        _escuchando = false;
        _error = 'No pude usar el micrófono. Puede escribir su pregunta.';
      });
    }
  }

  Future<void> _enviar(String pregunta) async {
    final texto = pregunta.trim();
    if (texto.isEmpty || _pensando) return;
    setState(() {
      _error = null;
      _loQueEscucho = '';
      _pensando = true;
    });
    tramite.conversacion.add(Mensaje(true, texto));
    _bajar();
    try {
      final respuesta = await GeminiService.preguntar(texto);
      tramite.conversacion.add(Mensaje(false, respuesta));
      VozService.hablar(respuesta);
    } catch (e) {
      final mensaje = e is GeminiError ? e.mensaje : 'Algo salió mal. Intente otra vez.';
      tramite.conversacion.removeLast();
      _error = mensaje;
      VozService.hablar(mensaje);
    }
    if (!mounted) return;
    setState(() => _pensando = false);
    _bajar();
  }

  Future<void> _escribir() async {
    final control = TextEditingController();
    final texto = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Escriba su pregunta', style: TextStyle(fontSize: 24)),
        content: TextField(
          controller: control,
          autofocus: true,
          minLines: 2,
          maxLines: 4,
          style: const TextStyle(fontSize: 22),
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(fontSize: 20)),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, control.text),
            child: const Text('Preguntar', style: TextStyle(fontSize: 20)),
          ),
        ],
      ),
    );
    if (texto != null) _enviar(texto);
  }

  @override
  Widget build(BuildContext context) {
    final mensajes = tramite.conversacion;
    final ultimaRespuesta =
        mensajes.isNotEmpty && !mensajes.last.esUsuario ? mensajes.last.texto : null;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                controller: _scroll,
                padding: const EdgeInsets.all(24),
                children: [
                  SecondaryButton(
                    texto: 'Volver al inicio',
                    icono: Icons.home,
                    onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
                  ),
                  const SizedBox(height: 24),
                  Text('¿Qué quiere saber?',
                      style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 16),
                  if (mensajes.isEmpty && !_pensando) ...[
                    Text('Toque el micrófono y hable, o elija una pregunta:',
                        style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 16),
                    for (final s in _sugerencias) ...[
                      SecondaryButton(texto: s, onPressed: () => _enviar(s)),
                      const SizedBox(height: 12),
                    ],
                  ],
                  for (final m in mensajes) ...[
                    InfoCard(
                      titulo: m.esUsuario ? 'Usted' : 'Abuelo Guía',
                      texto: m.texto,
                      fondo: m.esUsuario ? Colors.white : const Color(0xFFE3EEF6),
                      borde: m.esUsuario ? const Color(0xFF9FB4C4) : AppColors.primario,
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (_escuchando && _loQueEscucho.isNotEmpty) ...[
                    InfoCard(titulo: 'Usted', texto: _loQueEscucho),
                    const SizedBox(height: 16),
                  ],
                  if (_pensando) ...[
                    const Cargando(texto: 'Estoy pensando su respuesta...'),
                    const SizedBox(height: 16),
                  ],
                  if (_error != null) ...[
                    InfoCard(
                      titulo: 'Intente otra vez',
                      texto: _error!,
                      fondo: const Color(0xFFFFF0F0),
                      borde: AppColors.error,
                      icono: Icons.info_outline,
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (ultimaRespuesta != null && !_pensando)
                    SecondaryButton(
                      texto: 'Escuchar respuesta',
                      icono: Icons.volume_up,
                      onPressed: () => VozService.hablar(ultimaRespuesta),
                    ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              decoration: const BoxDecoration(
                color: AppColors.fondo,
                border: Border(top: BorderSide(color: Color(0xFFD5DEE5), width: 2)),
              ),
              child: Column(
                children: [
                  VoiceButton(escuchando: _escuchando, onPressed: _tocarMicrofono),
                  TextButton.icon(
                    onPressed: _pensando ? null : _escribir,
                    icon: const Icon(Icons.keyboard, size: 28),
                    label: const Text('Prefiero escribir', style: TextStyle(fontSize: 20)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

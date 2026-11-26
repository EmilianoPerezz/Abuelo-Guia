import '../data/requisitos.dart';

class Revision {
  final String requisito;
  final String documento;
  final bool sirve;
  final String explicacion;
  final String siguientePaso;

  Revision({
    required this.requisito,
    required this.documento,
    required this.sirve,
    required this.explicacion,
    required this.siguientePaso,
  });

  factory Revision.desdeJson(Map<String, dynamic> json) {
    return Revision(
      requisito: json['requisito']?.toString() ?? 'ninguno',
      documento: json['documento']?.toString() ?? 'Documento',
      sirve: json['sirve'] == true,
      explicacion: json['explicacion']?.toString() ?? '',
      siguientePaso: json['siguiente_paso']?.toString() ?? '',
    );
  }
}

class Mensaje {
  final bool esUsuario;
  final String texto;

  Mensaje(this.esUsuario, this.texto);
}

class Tramite {
  final Set<String> completos = {};
  Revision? ultimaRevision;
  final List<Mensaje> conversacion = [];

  void guardarRevision(Revision revision) {
    ultimaRevision = revision;
    if (revision.sirve && revision.requisito != 'ninguno') {
      completos.add(revision.requisito);
    }
  }

  bool tiene(String id) => completos.contains(id);

  List<Requisito> get faltantes =>
      requisitos.where((r) => !completos.contains(r.id)).toList();

  String resumenParaIA() {
    final tiene = requisitos.where((r) => completos.contains(r.id)).map((r) => r.nombre);
    final falta = faltantes.map((r) => r.nombre);
    return 'Documentos que ya revisó con foto: ${tiene.isEmpty ? 'ninguno' : tiene.join(', ')}. '
        'Documentos que le faltan: ${falta.isEmpty ? 'ninguno' : falta.join(', ')}.';
  }
}

final tramite = Tramite();

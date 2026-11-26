import 'package:material_ui/material_ui.dart';

class Requisito {
  final String id;
  final String nombre;
  final String detalle;

  const Requisito(this.id, this.nombre, this.detalle);
}

class TipoTramite {
  final String id;
  final String titulo;
  final String nombreOficial;
  final String paraQuien;
  final IconData icono;
  final List<String> documentos;
  final String notaExtra;

  const TipoTramite({
    required this.id,
    required this.titulo,
    required this.nombreOficial,
    required this.paraQuien,
    required this.icono,
    required this.documentos,
    required this.notaExtra,
  });

  List<Requisito> get requisitos => documentos.map((id) => catalogo[id]!).toList();
}

const Map<String, Requisito> catalogo = {
  'identificacion': Requisito(
    'identificacion',
    'Identificación oficial vigente',
    'Credencial del INE, pasaporte u otra identificación oficial que no esté vencida.',
  ),
  'curp': Requisito(
    'curp',
    'CURP',
    'Clave Única de Registro de Población, impresa y reciente.',
  ),
  'acta': Requisito(
    'acta',
    'Acta de nacimiento',
    'Acta de nacimiento que se pueda leer bien.',
  ),
  'domicilio': Requisito(
    'domicilio',
    'Comprobante de domicilio',
    'Recibo de luz, agua, teléfono o predial con fecha de máximo 6 meses.',
  ),
  'fotografia': Requisito(
    'fotografia',
    'Fotografía reciente',
    'Foto de la cara de la persona, reciente, de frente y con fondo claro.',
  ),
};

const List<TipoTramite> tramites = [
  TipoTramite(
    id: 'pension',
    titulo: 'Pensión para adultos mayores',
    nombreOficial: 'Pensión para el Bienestar de las Personas Adultas Mayores',
    paraQuien: 'Para personas de 65 años o más',
    icono: Icons.elderly,
    documentos: ['identificacion', 'curp', 'acta', 'domicilio'],
    notaExtra:
        'Lleve también por escrito un número de teléfono de usted y otro de un familiar o persona de confianza.',
  ),
  TipoTramite(
    id: 'inapam',
    titulo: 'Credencial INAPAM',
    nombreOficial: 'Credencial del Instituto Nacional de las Personas Adultas Mayores (INAPAM)',
    paraQuien: 'Para personas de 60 años o más. Da descuentos.',
    icono: Icons.badge_outlined,
    documentos: ['identificacion', 'curp', 'acta', 'domicilio', 'fotografia'],
    notaExtra:
        'El trámite es gratuito y en persona. Lleve originales y copias, y pregunte en el módulo el tamaño de la fotografía.',
  ),
  TipoTramite(
    id: 'mujeres',
    titulo: 'Pensión Mujeres Bienestar',
    nombreOficial: 'Pensión Mujeres Bienestar',
    paraQuien: 'Para mujeres de 60 a 64 años',
    icono: Icons.woman,
    documentos: ['identificacion', 'curp', 'acta', 'domicilio'],
    notaExtra:
        'Lleve también un número de teléfono de contacto. El registro es en persona, solo en las fechas que anuncie la Secretaría de Bienestar.',
  ),
];

const String notaOficial =
    'Esta app solo lo orienta. Confirme los requisitos en el módulo oficial o en gob.mx antes de ir.';

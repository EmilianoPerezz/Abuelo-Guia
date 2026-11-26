class Requisito {
  final String id;
  final String nombre;
  final String detalle;

  const Requisito(this.id, this.nombre, this.detalle);
}

const String nombreTramite = 'Pensión para el Bienestar de las Personas Adultas Mayores';

const List<Requisito> requisitos = [
  Requisito(
    'identificacion',
    'Identificación oficial vigente',
    'Credencial del INE, pasaporte u otra identificación oficial que no esté vencida.',
  ),
  Requisito(
    'curp',
    'CURP',
    'Clave Única de Registro de Población, impresa y reciente.',
  ),
  Requisito(
    'acta',
    'Acta de nacimiento',
    'Acta de nacimiento que se pueda leer bien.',
  ),
  Requisito(
    'domicilio',
    'Comprobante de domicilio',
    'Recibo de luz, agua, teléfono o predial con fecha de máximo 6 meses.',
  ),
];

const String notaTelefonos =
    'Lleve también por escrito un número de teléfono de usted y otro de un familiar o persona de confianza.';

const String notaOficial =
    'Esta app solo lo orienta. Confirme los requisitos en su Módulo de Bienestar o en gob.mx/bienestar.';

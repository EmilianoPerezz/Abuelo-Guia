
import 'package:flutter_test/flutter_test.dart';

import 'package:abuelo_guia/backend/utils/question_formatter.dart';
import 'package:abuelo_guia/backend/validators/question_validator.dart';

void main() {
  group('QuestionValidator', () {
    test('Rechaza preguntas vacías', () {
      expect(QuestionValidator.validate(''), isNotNull);
    });

    test('Rechaza preguntas con espacios', () {
      expect(QuestionValidator.validate('    '), isNotNull);
    });

    test('Rechaza preguntas mayores a 1000 caracteres', () {
      final pregunta = 'a' * 1001;

      expect(QuestionValidator.validate(pregunta), isNotNull);
    });

    test('Acepta preguntas de hasta 1000 caracteres', () {
      final pregunta = 'a' * 1000;

      expect(QuestionValidator.validate(pregunta), isNull);
    });

    test('Acepta preguntas válidas', () {
      expect(
        QuestionValidator.validate('¿Qué documentos necesito?'),
        isNull,
      );
    });
  });

  group('QuestionFormatter', () {
    test('Elimina espacios al principio y al final', () {
      expect(
        QuestionFormatter.format('  Hola  '),
        'Hola',
      );
    });

    test('Reemplaza espacios repetidos', () {
      expect(
        QuestionFormatter.format('Hola     mundo'),
        'Hola mundo',
      );
    });

    test('Normaliza saltos de línea', () {
      expect(
        QuestionFormatter.format('Hola\n\nmundo'),
        'Hola mundo',
      );
    });

    test('Mantiene preguntas normales', () {
      expect(
        QuestionFormatter.format('¿Qué documentos necesito?'),
        '¿Qué documentos necesito?',
      );
    });
  });
}

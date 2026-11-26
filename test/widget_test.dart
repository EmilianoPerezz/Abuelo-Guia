import 'package:flutter_test/flutter_test.dart';

import 'package:abuelo_guia/main.dart';
import 'package:abuelo_guia/services/tramite.dart';

void main() {
  testWidgets('La pantalla de inicio muestra las dos opciones', (tester) async {
    await tester.pumpWidget(const AbueloGuiaApp());

    expect(find.text('Hola, soy Abuelo Guía'), findsOneWidget);
    expect(find.text('Tomar foto de mi documento'), findsOneWidget);
    expect(find.text('Hablar con el asistente'), findsOneWidget);
  });

  test('Un documento que sirve se marca en la lista', () {
    final t = Tramite();
    t.guardarRevision(Revision(
      requisito: 'curp',
      documento: 'CURP',
      sirve: true,
      explicacion: '',
      siguientePaso: '',
    ));
    t.guardarRevision(Revision(
      requisito: 'acta',
      documento: 'Acta',
      sirve: false,
      explicacion: '',
      siguientePaso: '',
    ));

    expect(t.tiene('curp'), isTrue);
    expect(t.tiene('acta'), isFalse);
    expect(t.faltantes.length, 3);
  });
}

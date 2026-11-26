import 'package:flutter_test/flutter_test.dart';

import 'package:abuelo_guia/data/requisitos.dart';
import 'package:abuelo_guia/main.dart';
import 'package:abuelo_guia/services/tramite.dart';

Revision revision(String requisito, bool sirve) => Revision(
      requisito: requisito,
      documento: requisito,
      sirve: sirve,
      explicacion: '',
      siguientePaso: '',
    );

void main() {
  testWidgets('La pantalla de inicio muestra los tres trámites y las opciones', (tester) async {
    await tester.pumpWidget(const AbueloGuiaApp());

    expect(find.text('Hola, soy Abuelo Guía'), findsOneWidget);
    expect(find.text('Pensión para adultos mayores'), findsOneWidget);
    expect(find.text('Credencial INAPAM'), findsOneWidget);
    expect(find.text('Pensión Mujeres Bienestar'), findsOneWidget);
    expect(find.text('Tomar foto de mi documento'), findsOneWidget);
    expect(find.text('Hablar con el asistente'), findsOneWidget);
  });

  test('Un documento que sirve se marca en la lista', () {
    final t = Tramite();
    t.guardarRevision(revision('curp', true));
    t.guardarRevision(revision('acta', false));

    expect(t.tiene('curp'), isTrue);
    expect(t.tiene('acta'), isFalse);
    expect(t.faltantes.length, 3);
  });

  test('Los documentos revisados sirven para los otros trámites', () {
    final t = Tramite();
    t.guardarRevision(revision('identificacion', true));
    t.conversacion.add(Mensaje(true, 'hola'));

    final inapam = tramites.firstWhere((x) => x.id == 'inapam');
    t.elegir(inapam);

    expect(t.actual.id, 'inapam');
    expect(t.requisitos.length, 5);
    expect(t.listosDe(inapam), 1);
    expect(t.conversacion, isEmpty);
  });

  test('Un requisito desconocido no se marca', () {
    final t = Tramite();
    t.guardarRevision(revision('ninguno', true));
    expect(t.completos, isEmpty);
  });
}

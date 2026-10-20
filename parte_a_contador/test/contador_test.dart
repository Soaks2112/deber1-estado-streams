import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:parte_a_contador/main.dart' as app;

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({'contador': 0}));

  testWidgets('incrementa, vuelve y recupera el valor persistido',
      (tester) async {
    app.main();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ir a Control'));
    await tester.pumpAndSettle();
    for (var i = 0; i < 3; i++) {
      await tester.tap(find.text('+1'));
      await tester.pumpAndSettle();
    }
    await tester.tap(find.text('Volver'));
    await tester.pumpAndSettle();
    expect(find.text('Contador: 3'), findsOneWidget);
    expect((await SharedPreferences.getInstance()).getInt('contador'), 3);
    await tester.pumpWidget(const SizedBox.shrink());
    app.main();
    await tester.pumpAndSettle();
    expect(find.text('Contador: 3'), findsOneWidget);
  });

  testWidgets('atrás del sistema conserva el estado según la versión',
      (tester) async {
    app.main();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ir a Control'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('+1'));
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    const esSetState = bool.fromEnvironment('SETSTATE');
    expect(find.text('Contador: ${esSetState ? 0 : 1}'), findsOneWidget);
    expect((await SharedPreferences.getInstance()).getInt('contador'), 1);
  });
}

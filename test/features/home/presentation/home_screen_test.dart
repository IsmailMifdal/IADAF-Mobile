import 'package:flutter_test/flutter_test.dart';
import 'package:iadaf/features/home/presentation/home_screen.dart';
import 'package:material_ui/material_ui.dart';

import '../../../helpers/pump_app.dart';

void main() {
  testWidgets('shows the welcome message', (tester) async {
    await tester.pumpApp(const HomeScreen());

    expect(find.byKey(const Key('home-welcome')), findsOneWidget);
  });

  testWidgets('is laid out right to left in Arabic', (tester) async {
    await tester.pumpApp(const HomeScreen(), locale: const Locale('ar'));

    final context = tester.element(find.byType(HomeScreen));
    expect(Directionality.of(context), TextDirection.rtl);
  });

  testWidgets('is laid out left to right in English', (tester) async {
    await tester.pumpApp(const HomeScreen(), locale: const Locale('en'));

    final context = tester.element(find.byType(HomeScreen));
    expect(Directionality.of(context), TextDirection.ltr);
  });
}

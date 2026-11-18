import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:iadaf/main.dart' as app;
import 'package:material_ui/material_ui.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('the application starts and shows the welcome message', (
    tester,
  ) async {
    app.main();
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('home-welcome')), findsOneWidget);
  });
}

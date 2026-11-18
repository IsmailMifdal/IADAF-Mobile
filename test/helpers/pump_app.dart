import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iadaf/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

extension PumpApp on WidgetTester {
  /// Monte un écran avec les langues et des fournisseurs Riverpod remplaçables.
  Future<void> pumpApp(
    Widget screen, {
    Locale locale = const Locale('fr'),
    List<Override> overrides = const [],
  }) async {
    await pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: MaterialApp(
          locale: locale,
          localizationsDelegates: [
            AppLocalizations.delegate,
            ...GlobalMaterialLocalizations.delegates,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: screen,
        ),
      ),
    );
    await pumpAndSettle();
  }
}

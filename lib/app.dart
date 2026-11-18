import 'package:material_ui/material_ui.dart';

import 'features/home/presentation/home_screen.dart';
import 'l10n/app_localizations.dart';

/// Racine de l'application : thème, langues et premier écran.
class IadafApp extends StatelessWidget {
  const IadafApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      localizationsDelegates: [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HomeScreen(),
    );
  }
}

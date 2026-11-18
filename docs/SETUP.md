# Installer l'environnement (Windows)

Versions utilisées : Flutter **3.50.0** (stable), Dart 3.14, Android SDK 36.

## 1. Flutter
```powershell
git clone https://github.com/flutter/flutter.git -b stable --depth 1 C:\Users\<toi>\dev\flutter
# ajouter C:\Users\<toi>\dev\flutter\bin au PATH utilisateur, puis ouvrir un nouveau terminal
flutter doctor
```

## 2. Android
Avoir Android Studio (ou les `cmdline-tools`) puis, si `flutter doctor` le demande :
```powershell
sdkmanager "platforms;android-36" "build-tools;28.0.3"
```
`ANDROID_HOME` doit pointer vers le dossier du SDK (`%LOCALAPPDATA%\Android\Sdk`).

## 3. Le projet
```bash
git clone https://github.com/IsmailMifdal/IADAF-Mobile.git
cd IADAF-Mobile
flutter pub get
flutter gen-l10n        # génère les traductions
flutter test
flutter run             # sur un émulateur ou un téléphone branché
```

## Notes
- **iOS** : la compilation iOS demande un Mac (ou la CI macOS). Sous Windows on ne teste que Android.
- **Visual Studio / Windows desktop** : inutile, l'application ne cible que Android et iOS.
- Avant de pousser : `dart format lib test integration_test`, `flutter analyze --fatal-infos`, `flutter test --coverage`.

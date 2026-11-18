# Pôle Mobile : l'application Flutter

Ce document organise le pôle Mobile : l'équipe, les branches de travail, les tests,
la qualité du code avec SonarQube Cloud, et ce qu'une pull request doit passer avant
que Kylian l'approuve. Il s'applique à ce dépôt, `IADAF-Mobile`.

## L'équipe

| Qui | Rôle |
|---|---|
| Kylian | Responsable du pôle : réalise le plan de travail, relit et **approuve** les PR de l'application |
| Kévin | Développeur |
| Hugo | Développeur |

## Le plan de travail

Kylian réalise le plan de travail du pôle : les tâches, leur ordre et qui fait quoi.

## Branches et pull requests : comme pour le site

| Branche | Rôle | Qui y fusionne |
|---|---|---|
| Branches de travail | Une par tâche, quelques jours au plus | Leur auteur y pousse ses commits |
| `dev` | Intégration de l'équipe : tout le travail validé | Kylian, après les vérifications et deux approbations |
| `preprod` | Les versions qui partent en test (TestFlight, Google Play test interne) | Kylian, par une PR `dev` → `preprod` approuvée par Ismail |
| `prod` | Les versions publiées sur les stores | Kylian, par une PR `preprod` → `prod` approuvée par Ismail |

1. Une tâche Linear, une branche, une PR. La branche part de **`dev`** et porte
   l'identifiant de la tâche : le nom copié depuis Linear (« Copy git branch name »),
   ou `<type>/ism-<n>-<sujet>`, par exemple `feat/ism-77-socle-flutter`.
2. La branche est poussée **sur ce dépôt, pas sur un fork** : depuis un fork,
   GitHub ne donne pas à la CI le jeton SonarQube, et l'analyse de qualité ne
   tourne pas.
3. La PR vise **`dev`**. Sa description contient `Fixes ISM-<n>` : à la fusion,
   la tâche passe en Done dans Linear.
4. Une PR reste petite : relisible en 20 minutes, sinon on la découpe.
5. Fusion en **squash**, par Kylian, une fois les vérifications et les deux
   approbations obtenues.

Les PR de promotion (`dev` → `preprod`, `preprod` → `prod`) se fusionnent avec un
**commit de fusion** (pas en squash), pour que les trois branches gardent le même
historique et ne divergent pas. Chaque promotion déclenche le build correspondant
(voir `.github/workflows/`).

Il n'y a **pas de branche qui dure** en dehors de `dev`, `preprod` et `prod` : une branche
qui vit des semaines s'éloigne de `dev` et finit en conflits.

## Les branches à créer

### Les préfixes

| Préfixe | Pour | Exemple |
|---|---|---|
| `feat/` | Une fonctionnalité nouvelle | `feat/ism-78-navigation-ecrans` |
| `fix/` | Un bug | `fix/ism-130-crash-liste-vide` |
| `test/` | Des tests seuls, sans changer le code | `test/ism-131-tests-dossiers` |
| `refactor/` | Réorganiser le code sans changer ce qu'il fait | `refactor/ism-132-client-api` |
| `docs/` | La documentation | `docs/ism-133-guide-mobile` |
| `chore/` | Outils, dépendances, configuration | `chore/ism-85-builds-test` |
| `ci/` | La CI | `ci/ism-134-job-sonar` |

Le nom : préfixe, identifiant Linear en minuscules, deux à quatre mots sans accent
séparés par des tirets.

### Le plan des branches

Une branche par tâche Linear. Kylian décide de l'ordre et de qui prend chaque tâche
dans son plan de travail.

| Tâche Linear | Branche | Tests attendus dans la PR |
|---|---|---|
| ISM-77 Créer le projet Flutter | `feat/ism-77-socle-flutter` | L'application démarre (test de widget), CI et SonarQube au vert |
| ISM-78 Navigation et écrans avec des données simulées | `feat/ism-78-navigation-ecrans` | Un test de widget par écran, un test par route |
| ISM-79 4 langues et arabe de droite à gauche | `feat/ism-79-langues-rtl` | Les 4 fichiers ARB ont les mêmes clés ; un écran en arabe est de droite à gauche |
| ISM-80 Connexion dans l'application | `feat/ism-80-connexion` | Connexion réussie, mot de passe faux, jeton expiré puis renouvelé, déconnexion |
| ISM-81 Assistant dans sa langue | `feat/ism-81-assistant` | Envoi d'une question, réponse affichée, erreur réseau, réponse en arabe |
| ISM-82 Liste et détail des dossiers | `feat/ism-82-dossiers` | Liste pleine, liste vide, erreur ; détail d'un dossier ; dossier en retard |
| ISM-83 Photographier une pièce et la faire vérifier | `feat/ism-83-photo-piece` | Photo envoyée, refusée (format, taille), verdict affiché |
| ISM-84 Notifications push | `feat/ism-84-notifications-push` | Réception d'un rappel, ouverture du bon dossier au toucher |
| ISM-85 Builds de test TestFlight et Google Play | `chore/ism-85-builds-test` | Parcours d'intégration au vert sur les deux plateformes |
| ISM-100 Publication sur les stores | `chore/ism-100-publication-stores` | Parcours d'intégration au vert sur la version publiée |

Les branches ISM-78 et ISM-79 partent de `dev` **après** la fusion d'ISM-77 : elles
ont besoin du projet. ISM-80 attend l'API mobile du pôle Back (ISM-39 et ISM-40).

### Les commandes, du début à la fin d'une tâche

```bash
# 1. Partir de dev à jour
git switch dev
git pull

# 2. Créer la branche de la tâche
git switch -c feat/ism-78-navigation-ecrans

# 3. Coder, tester, puis enregistrer (messages en anglais)
git add .
git commit -m "feat: add navigation and mock screens (ISM-78)"

# 4. Pousser sur ce dépôt (pas sur un fork)
git push -u origin feat/ism-78-navigation-ecrans

# 5. Ouvrir la PR vers dev
gh pr create --base dev \
  --title "feat: navigation and mock screens (ISM-78)" \
  --body "Fixes ISM-78"

# 6. Si dev a avancé pendant la relecture : se remettre à jour
git fetch origin
git rebase origin/dev
git push --force-with-lease          # seulement sur sa propre branche

# 7. Après la fusion par Kylian : nettoyer
git switch dev
git pull
git branch -d feat/ism-78-navigation-ecrans
```

GitHub supprime la branche distante tout seul après la fusion.

## Les tests

### Trois niveaux

| Niveau | Ce qu'il teste | Où | Quand il tourne | Part des tests |
|---|---|---|---|---|
| **Unitaire** | Une règle du `domain/`, une conversion du `data/` | `test/features/<f>/domain/`, `test/features/<f>/data/` | À chaque PR, dans la CI | Environ 70 % |
| **Widget** | Un écran ou un composant : ce qui s'affiche, ce qui se passe au clic, l'arabe de droite à gauche | `test/features/<f>/presentation/` | À chaque PR, dans la CI | Environ 25 % |
| **Intégration** | Un parcours complet sur un émulateur : se connecter, ouvrir un dossier, envoyer une pièce | `integration_test/` | Avant chaque version de test, et en local avant une PR qui touche un parcours | Environ 5 % |

### Ce que chaque PR doit tester

| Le code ajouté | Les tests exigés |
|---|---|
| Une règle dans `domain/` | Un test par cas : le cas normal, chaque cas d'erreur, les limites (liste vide, date passée…) |
| Un appel à l'API dans `data/` | La conversion de la réponse, et le comportement sur une erreur 401, 404, 500 et sans réseau. L'API est remplacée par un faux (`mocktail`) : **aucun test n'appelle le vrai serveur** |
| Un écran | Au moins un test de widget : l'écran s'affiche avec des données, avec une liste vide, avec une erreur ; et un test en arabe qui vérifie le sens de droite à gauche |
| Un texte affiché | Sa clé dans les 4 fichiers ARB ; un test vérifie que les 4 langues ont les mêmes clés |
| Un bug corrigé | Un test qui échouait avant la correction et passe après |

### Règles d'écriture

- Un fichier de test par fichier de code, même chemin : `lib/features/dossiers/domain/dossier.dart`
  se teste dans `test/features/dossiers/domain/dossier_test.dart`.
- Le nom d'un test dit le comportement attendu, en anglais comme le code :
  `test('marks the file late when the deadline has passed', …)`.
- Un test ne dépend ni de l'heure réelle, ni du réseau, ni d'un autre test : l'heure
  et l'API sont injectées, donc remplaçables.
- Un test instable (qui passe une fois sur deux) est corrigé ou supprimé dans la
  journée, jamais ignoré : sinon plus personne ne croit la CI.
- Jamais de vraie pièce d'identité ni de vraie donnée personnelle dans les tests :
  des données inventées, visiblement fausses.

### Le guide des tests, avec des exemples à copier

Les exemples rangent le code par fonctionnalité (`lib/features/<f>/domain`, `data`,
`presentation`) et chaque test au même chemin sous `test/`. Le nom du paquet est
`iadaf` ; adaptez les imports au projet de Kylian.

**Les dépendances de test**, dans `pubspec.yaml` (versions du jour du setup) :

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter
  flutter_lints: any      # remplacer « any » par la version du setup
  mocktail: any
```

**Les traductions**, dans `l10n.yaml`, pour que les tests importent les textes
générés (déjà mis en forme, pour que la vérification de format de la CI passe) :

```yaml
arb-dir: lib/l10n
template-arb-file: app_fr.arb
output-localization-file: app_localizations.dart
synthetic-package: false
format: true
```

#### 1. Test unitaire d'une règle (`domain/`)

`test/features/dossiers/domain/dossier_test.dart` :

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:iadaf/features/dossiers/domain/dossier.dart';

void main() {
  group('Dossier.isLate', () {
    final today = DateTime(2026, 11, 18);

    test('is late when the deadline has passed', () {
      final dossier = Dossier(id: '1', deadline: DateTime(2026, 11, 17));
      expect(dossier.isLate(today), isTrue);
    });

    test('is not late on the deadline day', () {
      final dossier = Dossier(id: '1', deadline: DateTime(2026, 11, 18));
      expect(dossier.isLate(today), isFalse);
    });
  });
}
```

La date du jour est passée en paramètre : le test donne le même résultat demain.

#### 2. Test d'un appel à l'API (`data/`), avec un faux client

`test/features/dossiers/data/dossier_repository_test.dart` :

```dart
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iadaf/core/errors.dart';
import 'package:iadaf/features/dossiers/data/dossier_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio dio;
  late DossierRepository repository;

  setUp(() {
    dio = MockDio();
    repository = DossierRepository(dio);
  });

  test('returns the files sent by the API', () async {
    when(() => dio.get<List<dynamic>>(any())).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/dossiers'),
        statusCode: 200,
        data: [
          {'id': '1', 'deadline': '2026-12-01'},
        ],
      ),
    );

    final dossiers = await repository.fetchAll();

    expect(dossiers.single.id, '1');
  });

  test('throws SessionExpired when the API answers 401', () async {
    when(() => dio.get<List<dynamic>>(any())).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: '/dossiers'),
        response: Response(requestOptions: RequestOptions(path: '/dossiers'), statusCode: 401),
      ),
    );

    expect(repository.fetchAll(), throwsA(isA<SessionExpired>()));
  });
}
```

Le chemin `/dossiers` est un exemple : les vraies routes viendront du contrat
d'API du pôle Back (ISM-39).

#### 3. Test d'un écran (widget), en français et en arabe

Une aide commune, `test/helpers/pump_app.dart`, monte un écran avec les langues et
les fournisseurs Riverpod remplacés par des faux :

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iadaf/l10n/app_localizations.dart';

extension PumpApp on WidgetTester {
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
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: screen,
        ),
      ),
    );
    await pumpAndSettle();
  }
}
```

`test/features/dossiers/presentation/dossiers_screen_test.dart` :

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iadaf/features/dossiers/presentation/dossiers_screen.dart';
import 'package:iadaf/features/dossiers/presentation/dossiers_provider.dart';

import '../../../helpers/pump_app.dart';

void main() {
  testWidgets('shows a message when there is no file', (tester) async {
    await tester.pumpApp(
      const DossiersScreen(),
      overrides: [dossiersProvider.overrideWith((ref) async => [])],
    );

    expect(find.byKey(const Key('dossiers-empty')), findsOneWidget);
  });

  testWidgets('is laid out right to left in Arabic', (tester) async {
    await tester.pumpApp(
      const DossiersScreen(),
      locale: const Locale('ar'),
      overrides: [dossiersProvider.overrideWith((ref) async => [])],
    );

    final context = tester.element(find.byType(DossiersScreen));
    expect(Directionality.of(context), TextDirection.rtl);
  });
}
```

On cherche les éléments par **clé** (`Key('dossiers-empty')`) plutôt que par leur
texte : le test marche alors dans les 4 langues, et ne casse pas quand on reformule
une phrase.

#### 4. Test des traductions : les 4 langues ont les mêmes clés

`test/l10n/arb_keys_test.dart` :

```dart
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

Set<String> keysOf(String lang) {
  final arb = jsonDecode(File('lib/l10n/app_$lang.arb').readAsStringSync()) as Map<String, dynamic>;
  return arb.keys.where((key) => !key.startsWith('@')).toSet();
}

void main() {
  test('every language has the same keys as French', () {
    final french = keysOf('fr');
    for (final lang in ['en', 'ar', 'es']) {
      expect(keysOf(lang), french, reason: 'app_$lang.arb');
    }
  });
}
```

#### 5. Test d'un parcours complet (intégration)

`integration_test/open_file_test.dart`, lancé sur un émulateur ou un téléphone
branché :

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iadaf/main.dart' as app;
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('opens a file from the list', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('dossier-1')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('dossier-detail')), findsOneWidget);
  });
}
```

L'application démarre alors sur une **fausse API** (données simulées), choisie au
lancement : `--dart-define=API_MODE=fake`. Elle ne touche jamais au vrai serveur.

### Les commandes de test

```bash
flutter test                                              # tous les tests
flutter test test/features/dossiers/                      # un dossier
flutter test test/features/dossiers/domain/dossier_test.dart   # un fichier
flutter test --plain-name "is late"                       # les tests dont le nom contient « is late »
flutter test --coverage                                   # avec la couverture (coverage/lcov.info)
flutter test integration_test --dart-define=API_MODE=fake # les parcours, émulateur lancé
```

### Avant de pousser, en local

```bash
dart format lib test                      # met le code en forme (et integration_test/ quand il existe)
flutter analyze                           # 0 avertissement
flutter test --coverage                   # tous les tests, avec la couverture
```

Les mêmes commandes tournent dans la CI : si elles passent en local, la CI passe.

### Couverture

- **Code nouveau d'une PR : au moins 80 %** des lignes couvertes par des tests.
  C'est la porte de qualité SonarQube qui le vérifie (voir plus bas).
- **Tout le dossier `lib/` : au moins 70 %.** C'est la CI qui le vérifie.
- Ne comptent pas : le code généré (traductions, `*.g.dart`, `*.freezed.dart`) et
  `lib/main.dart`.

## La qualité du code avec SonarQube Cloud

### Ce que fait SonarQube

À chaque PR, SonarQube Cloud lit le code Dart du dépôt et la couverture des tests,
puis publie dans la PR :

- les **bugs** probables (par exemple un `Future` non attendu, une valeur nulle non gérée) ;
- les **failles** et les **points sensibles** à vérifier (un secret écrit dans le code, une
  connexion non chiffrée) ;
- le **code difficile à maintenir** (fonction trop complexe, code mort, mauvais nommage) ;
- le **code dupliqué** ;
- la **couverture** du code nouveau par les tests.

Il juge **le code nouveau** de la PR, pas l'existant : une PR propre passe, même si
un vieux fichier a des défauts.

### La porte de qualité

Le pôle utilise la porte de qualité par défaut de Sonar, « Sonar way ». Une PR ne
passe que si, sur son code nouveau :

| Condition | Seuil |
|---|---|
| Nouveaux bugs | Note A (aucun bug) |
| Nouvelles failles | Note A (aucune faille) |
| Points sensibles de sécurité | 100 % vérifiés |
| Maintenabilité | Note A |
| Couverture par les tests | ≥ 80 % |
| Lignes dupliquées | ≤ 3 % |

La CI attend le verdict de SonarQube : si la porte est « Failed », le job
« CI (format, analyze, test, Sonar) » échoue et la PR ne peut pas être fusionnée.

### Quand SonarQube signale un problème

| Signalement | Ce qu'on fait |
|---|---|
| Bug ou faille | On corrige dans la PR. Pas d'exception |
| Point sensible de sécurité | Kylian le vérifie dans SonarQube et le marque « Safe » s'il n'y a pas de risque, avec une phrase qui dit pourquoi ; sinon on corrige |
| Code difficile à maintenir | On corrige. Si on n'est pas d'accord avec la règle, on le marque « Accepted » avec la raison, et Kylian valide |
| Couverture insuffisante | On ajoute les tests manquants |

Marquer un signalement « False positive » ou « Accepted » sans explication est refusé en relecture.

### Pourquoi l'analyse passe par la CI

L'**analyse automatique** de SonarQube Cloud ne prend pas en charge le Dart : le code
Flutter doit être analysé **depuis la CI**, qui envoie aussi la couverture des tests.
Le projet SonarQube de ce dépôt est donc réglé en analyse depuis la CI.

## Ce qu'une PR doit passer avant l'approbation de Kylian

Kylian n'approuve **que si tout est vert**. GitHub bloque la fusion sinon.

| Vérification | Ce qu'elle contrôle | Seuil |
|---|---|---|
| Le job **CI (format, analyze, test, Sonar)** | Mise en forme, analyse sans avertissement, tous les tests, couverture, porte de qualité SonarQube | Tout passe ; couverture de `lib/` ≥ 70 %, du code nouveau ≥ 80 % |
| Deux approbations | Un coéquipier (Kévin ou Hugo), puis Kylian | Kylian est propriétaire du code du dépôt |

Quand Kylian est l'auteur de la PR, la deuxième approbation est celle d'Ismail.

## Les réglages du dépôt (au setup)

Ces réglages rendent les règles ci-dessus automatiques.

1. **Branches** : créer `dev`, `preprod` et `prod` depuis `main`, faire de `dev` la branche par défaut du
   dépôt.
2. **SonarQube Cloud** (Ismail, administrateur de l'organisation) :
   - importer le dépôt `IADAF-Mobile` dans l'organisation et choisir l'analyse
     depuis la CI (pas l'analyse automatique) ;
   - générer un jeton d'analyse et l'enregistrer dans GitHub comme secret `SONAR_TOKEN` ;
   - garder la porte de qualité « Sonar way ».
3. **`sonar-project.properties`**, à la racine :

   ```properties
   sonar.projectKey=IsmailMifdal_IADAF-Mobile
   sonar.organization=ismailmifdal
   sonar.projectName=IADAF Mobile
   sonar.sources=lib
   sonar.tests=test,integration_test
   sonar.exclusions=lib/l10n/**,**/*.g.dart,**/*.freezed.dart
   sonar.coverage.exclusions=lib/main.dart,lib/l10n/**,**/*.g.dart,**/*.freezed.dart
   sonar.dart.lcov.reportPaths=coverage/lcov.info
   sonar.qualitygate.wait=true
   ```

   La clé du projet et celle de l'organisation sont celles que SonarQube Cloud affiche
   à l'import : les recopier si elles diffèrent.
4. **CI** : `.github/workflows/ci.yml`.

   ```yaml
   name: CI

   on:
     pull_request:
     push:
       branches: [dev, preprod, prod]

   jobs:
     ci:
       name: CI (format, analyze, test, Sonar)
       runs-on: ubuntu-latest
       steps:
         - uses: actions/checkout@v4
           with:
             fetch-depth: 0            # SonarQube a besoin de l'historique
         - uses: subosito/flutter-action@v2
           with:
             channel: stable
             flutter-version: "[version fixée au setup]"
             cache: true
         - name: Format, analyse, tests
           run: |
             flutter pub get
             dart format --output=none --set-exit-if-changed $(ls -d lib test integration_test 2>/dev/null)
             flutter analyze --fatal-infos
             flutter test --coverage
         - name: Couverture de lib/ ≥ 70 %
           run: |
             awk -F: '/^LF:/{lf+=$2} /^LH:/{lh+=$2}
               END{p = lf ? 100*lh/lf : 0; printf "Couverture : %.1f %%\n", p; exit (p < 70)}' coverage/lcov.info
         - name: Analyse SonarQube Cloud (attend la porte de qualité)
           uses: SonarSource/sonarqube-scan-action@v5   # dernière version stable au setup (une v6 existe)
           env:
             SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
   ```

5. **CODEOWNERS** : `.github/CODEOWNERS` avec la ligne
   `*  @SoulSkunk @IsmailMifdal` (Kylian et Ismail). L'approbation de Kylian est
   alors exigée sur chaque PR ; celle d'Ismail la remplace quand Kylian est l'auteur.
6. **Protection des branches** `dev`, `preprod` et `prod` (Ismail, dans les réglages GitHub) :
   PR obligatoire, deux approbations dont celle d'un propriétaire du code,
   vérification « CI (format, analyze, test, Sonar) » obligatoire, conversations
   résolues, fusion en squash vers `dev`, commit de fusion vers `preprod` et `prod`, pas de force push.
7. **Linear** : ajouter `IADAF-Mobile` aux dépôts de l'intégration GitHub de Linear,
   pour que `Fixes ISM-<n>` relie les PR aux tâches.

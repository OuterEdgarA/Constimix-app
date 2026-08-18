# Spanish (Mexico) localization kickoff

The app currently keeps user-facing strings directly in widgets. Migrate them in
small feature groups so English remains usable while Mexican Spanish coverage
grows. This follows Flutter's official internationalization workflow:
https://docs.flutter.dev/ui/internationalization

## 1. Enable Flutter localization generation

Add the SDK localization package and intl to pubspec.yaml, then enable code
generation:

    dependencies:
      flutter_localizations:
        sdk: flutter
      intl: any

    flutter:
      generate: true

Create l10n.yaml at the project root:

    arb-dir: lib/l10n
    template-arb-file: app_en.arb
    output-localization-file: app_localizations.dart
    untranslated-messages-file: build/untranslated_messages.json

## 2. Create the initial ARB catalogs

Create lib/l10n/app_en.arb as the source catalog and
lib/l10n/app_es_MX.arb for Mexican Spanish. Start with navigation and shared
actions, then migrate one screen at a time.

    {
      "@@locale": "en",
      "appTitle": "#YoSoyConstiMix",
      "save": "Save",
      "cancel": "Cancel",
      "gradesTitle": "Grades"
    }

    {
      "@@locale": "es_MX",
      "appTitle": "#YoSoyConstiMix",
      "save": "Guardar",
      "cancel": "Cancelar",
      "gradesTitle": "Calificaciones"
    }

Run flutter gen-l10n, then import the generated AppLocalizations source from the
output location configured by l10n.yaml.

## 3. Register locales in the app

Set these properties on MaterialApp:

    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,

Use AppLocalizations.of(context)! in widgets instead of hard-coded labels.
Do not force a locale at first: devices set to es-MX will select Mexican
Spanish and other devices will fall back to the English template.

## 4. Migration order

1. Navigation, authentication, shared buttons, validation, and dialogs.
2. Enrollment and account administration.
3. Semester administration, schedules, grades, registry, and board.
4. Remaining accessibility labels, tooltips, empty states, and PDF text.

Use placeholders for values rather than concatenating translated fragments.
Use intl formats for dates and numbers; keep CURP, registrations, subject keys,
and stored enum values locale-independent. Add widget tests under both
Locale('en') and Locale('es', 'MX'), and monitor
build/untranslated_messages.json in CI until it is empty.

## 5. Mexican Spanish conventions

- Use DD/MM/YYYY for displayed dates and 24-hour time.
- Prefer school terminology already used by the institution: semestre, grupo,
  matricula, CURP, docente, and tutor.
- Translate display labels, not database keys or authorization roles.
- Review formal versus informal voice before translating the full catalog; use
  one voice consistently in actions, errors, and confirmations.
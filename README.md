# ConstiMix App

Starter Flutter source scaffold based on `App1917.docx`.

The brief describes a mobile-first Student Information System for Constitucion de 1917 Mixta with:

- Role-based access for Level 1 system admins, Level 2 semester admins, Level 3 teachers, and Level 4 students.
- Community board with approval flow.
- Progressive enrollment and re-enrollment forms.
- Offline-capable schedules, subjects, profiles, enrollment lists, and grades.
- Grading tools, class registry, document generation, and schedule administration.
- Material 3, 8dp spacing, light/dark themes, AA accessibility, and low-end Android performance targets.

## Local Setup

Flutter is not currently available on this machine's PATH. After installing Flutter, run:

```powershell
cd constimix_app
flutter create .
flutter pub get
flutter run
```

The current scaffold intentionally uses only the Flutter SDK so the first bootstrap is low-friction.

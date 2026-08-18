// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Constitución de 1917 Mixta';

  @override
  String get save => 'Guardar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get gradesTitle => 'Calificaciones';

  @override
  String get usernameOrCurp => 'Username or CURP';

  @override
  String get passwordOrRegistration => 'Password or registration';

  @override
  String get signIn => 'Sign in';

  @override
  String get studentSignUp => 'Student sign up';

  @override
  String get invalidCredentials => 'Invalid credentials.';

  @override
  String get navHome => 'Home';

  @override
  String get navBoard => 'Board';

  @override
  String get navEnroll => 'Enroll';

  @override
  String get navSchedule => 'Schedule';

  @override
  String get navGrades => 'Grades';

  @override
  String get navProfile => 'Profile';

  @override
  String get navAdmin => 'Admin';

  @override
  String get useLightMode => 'Use light mode';

  @override
  String get useDarkMode => 'Use dark mode';
}

/// The translations for Spanish Castilian, as used in Mexico (`es_MX`).
class AppLocalizationsEsMx extends AppLocalizationsEs {
  AppLocalizationsEsMx() : super('es_MX');

  @override
  String get appTitle => 'Constitución de 1917 Mixta';

  @override
  String get save => 'Guardar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get gradesTitle => 'Calificaciones';

  @override
  String get usernameOrCurp => 'Usuario o CURP';

  @override
  String get passwordOrRegistration => 'Contraseña o Matrícula';

  @override
  String get signIn => 'Iniciar Sesión';

  @override
  String get studentSignUp => 'Registro';

  @override
  String get invalidCredentials => 'Credenciales incorrectas.';

  @override
  String get navHome => 'Inicio';

  @override
  String get navBoard => 'Comunidad';

  @override
  String get navEnroll => 'Matrícula';

  @override
  String get navSchedule => 'Horario';

  @override
  String get navGrades => 'Calificaciones';

  @override
  String get navProfile => 'Perfil';

  @override
  String get navAdmin => 'Administrador';

  @override
  String get useLightMode => 'Usar modo claro';

  @override
  String get useDarkMode => 'Usar modo oscuro';
}

import '../data/mock_repository.dart';
import '../models/app_user.dart';
import '../models/user_role.dart';

class AuthService {
  AuthService.seeded();

  AppUser? signIn(String username, String password) {
    final normalized = username.trim().toLowerCase();
    final users = MockRepository.users;

    for (final user in users) {
      if (!user.isActive) continue;
      final studentLogin = user.role == UserRole.level4Student &&
          user.curp?.toLowerCase() == normalized &&
          user.registration == password;
      final storedPassword = user.password;
      final staffLogin = user.username.toLowerCase() == normalized &&
          (storedPassword == null
              ? password.isNotEmpty
              : storedPassword == password);

      if (studentLogin || staffLogin) return user;
    }

    return null;
  }
}

import 'user_role.dart';

class AppUser {
  const AppUser({
    required this.id,
    required this.displayName,
    required this.username,
    required this.role,
    this.fatherSurname = '',
    this.motherSurname = '',
    this.name = '',
    this.curp,
    this.registration,
    this.semester,
    this.group,
    this.password,
    this.profileDescription,
    this.profileAvatarIndex = 0,
    this.isActive = true,
  });

  final String id;
  final String displayName;
  final String username;
  final UserRole role;
  final String fatherSurname;
  final String motherSurname;
  final String name;
  final String? curp;
  final String? registration;
  final int? semester;
  final String? group;
  final String? password;
  final String? profileDescription;
  final int profileAvatarIndex;
  final bool isActive;

  bool matchesSearch(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return true;
    return displayName.toLowerCase().contains(normalized) ||
        fatherSurname.toLowerCase().contains(normalized) ||
        motherSurname.toLowerCase().contains(normalized) ||
        name.toLowerCase().contains(normalized) ||
        username.toLowerCase().contains(normalized) ||
        (curp?.toLowerCase().contains(normalized) ?? false) ||
        (registration?.toLowerCase().contains(normalized) ?? false);
  }

  AppUser copyWith({
    String? displayName,
    String? username,
    UserRole? role,
    String? fatherSurname,
    String? motherSurname,
    String? name,
    String? curp,
    String? registration,
    int? semester,
    String? group,
    String? password,
    String? profileDescription,
    int? profileAvatarIndex,
    bool? isActive,
  }) {
    return AppUser(
      id: id,
      displayName: displayName ?? this.displayName,
      username: username ?? this.username,
      role: role ?? this.role,
      fatherSurname: fatherSurname ?? this.fatherSurname,
      motherSurname: motherSurname ?? this.motherSurname,
      name: name ?? this.name,
      curp: curp ?? this.curp,
      registration: registration ?? this.registration,
      semester: semester ?? this.semester,
      group: group ?? this.group,
      password: password ?? this.password,
      profileDescription: profileDescription ?? this.profileDescription,
      profileAvatarIndex: profileAvatarIndex ?? this.profileAvatarIndex,
      isActive: isActive ?? this.isActive,
    );
  }
}

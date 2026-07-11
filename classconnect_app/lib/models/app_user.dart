enum UserRole { teacher, student }

extension UserRoleX on UserRole {
  String get label => switch (this) {
    UserRole.teacher => 'Teacher',
    UserRole.student => 'Student',
  };

  String get value => name;

  static UserRole fromValue(String value) {
    return UserRole.values.firstWhere(
      (role) => role.value == value,
      orElse: () => UserRole.student,
    );
  }
}

class AppUser {
  const AppUser({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
  });

  final String uid;
  final String email;
  final String name;
  final UserRole role;

  factory AppUser.fromMap(String uid, Map<String, dynamic> map) {
    return AppUser(
      uid: uid,
      email: map['email'] as String? ?? '',
      name: map['name'] as String? ?? '',
      role: UserRoleX.fromValue(map['role'] as String? ?? 'student'),
    );
  }

  Map<String, dynamic> toMap() {
    return {'email': email, 'name': name, 'role': role.value};
  }
}

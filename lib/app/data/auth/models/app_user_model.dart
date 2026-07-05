import '../../../domain/auth/entities/app_user.dart';

class AppUserModel {
  const AppUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.password,
  });

  final String id;
  final String name;
  final String email;
  final String role;
  final String password;

  AppUser toEntity() {
    return AppUser(
      id: id,
      name: name,
      email: email,
      role: role,
    );
  }

  AppUserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? password,
  }) {
    return AppUserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      password: password ?? this.password,
    );
  }
}

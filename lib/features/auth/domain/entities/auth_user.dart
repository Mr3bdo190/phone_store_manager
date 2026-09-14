// lib/features/auth/domain/entities/auth_user.dart
/// Lightweight auth session entity.
library;

import '../../../core/constants/enums.dart';
import '../../../features/shared/domain/entities/user.dart';

class AuthUser {
  final int id;
  final String username;
  final UserRole role;
  final bool isActive;

  AuthUser({
    required this.id,
    required this.username,
    required this.role,
    required this.isActive,
  });

  factory AuthUser.fromUser(User user) => AuthUser(
        id: user.id!,
        username: user.username,
        role: user.role,
        isActive: user.isActive,
      );

  AuthUser copyWith({
    int? id,
    String? username,
    UserRole? role,
    bool? isActive,
  }) {
    return AuthUser(
      id: id ?? this.id,
      username: username ?? this.username,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
    );
  }
}

// lib/features/shared/domain/entities/user.dart
/// User entity — admin or employee.
library;

import '../../../core/constants/enums.dart';

class User {
  final int? id;
  final String username;
  final String passwordHash;
  final String? passwordSalt;
  final UserRole role;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? lastLoginAt;

  User({
    this.id,
    required this.username,
    required this.passwordHash,
    this.passwordSalt,
    required this.role,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
    this.lastLoginAt,
  });

  User copyWith({
    int? id,
    String? username,
    String? passwordHash,
    String? passwordSalt,
    UserRole? role,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLoginAt,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      passwordHash: passwordHash ?? this.passwordHash,
      passwordSalt: passwordSalt ?? this.passwordSalt,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  bool get isAdmin => role == UserRole.admin;
  bool get canManageProducts => isAdmin;
  bool get canManageSuppliers => isAdmin;
  bool get canManageSettings => isAdmin;
  bool get canManageUsers => isAdmin;
}

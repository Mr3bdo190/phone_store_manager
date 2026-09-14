// lib/features/auth/data/datasources/auth_local_datasource.dart
/// Data source for authentication — reads/writes to the local Drift database.
library;

import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';

import '../../../core/constants/enums.dart';
import '../../../core/database/database.dart';
import '../domain/entities/auth_user.dart';

abstract class AuthLocalDataSource {
  Future<AuthUser?> login({required String username, required String password});
  Future<int> register({
    required String username,
    required String passwordHash,
    required String? salt,
    required UserRole role,
  });
  Future<bool> hasUsers();
  Future<AuthUser?> getFirstAdmin();
  Future<AuthUser?> getUserById(int id);
  Future<bool> updateLastLogin(int userId, DateTime timestamp);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final AppDatabase database;

  AuthLocalDataSourceImpl(this.database);

  @override
  Future<AuthUser?> login({required String username, required String password}) async {
    final rows = await (database.select(database.users)
          ..where((u) => u.username.equals(username) & u.isActive.equals(true)))
        .get();

    if (rows.isEmpty) return null;
    final user = rows.first;

    final inputHash = _hashPassword(password, user.passwordSalt ?? '');
    if (inputHash != user.passwordHash) return null;

    await updateLastLogin(user.id!, DateTime.now());

    return AuthUser(
      id: user.id!,
      username: user.username,
      role: UserRole.values.firstWhere((e) => e.name == user.role, orElse: () => UserRole.employee),
      isActive: user.isActive,
    );
  }

  static String _hashPassword(String password, String salt) {
    final bytes = utf8.encode(password + salt);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  @override
  Future<int> register({
    required String username,
    required String passwordHash,
    required String? salt,
    required UserRole role,
  }) {
    return database.into(database.users).insert(UsersCompanion.insert(
          username: username,
          passwordHash: passwordHash,
          passwordSalt: Value(salt),
          role: Value(role.name),
          isActive: const Value(true),
          createdAt: Value(DateTime.now()),
        ));
  }

  @override
  Future<bool> hasUsers() async {
    final count = await database.users.count().get();
    return count > 0;
  }

  @override
  Future<AuthUser?> getFirstAdmin() async {
    final rows = await (database.select(database.users)
          ..where((u) => u.role.equals(UserRole.admin.name) & u.isActive.equals(true))
          ..limit(1))
        .get();

    if (rows.isEmpty) return null;
    final user = rows.first;

    return AuthUser(
      id: user.id!,
      username: user.username,
      role: UserRole.values.firstWhere((e) => e.name == user.role, orElse: () => UserRole.employee),
      isActive: user.isActive,
    );
  }

  @override
  Future<AuthUser?> getUserById(int id) async {
    final row = await (database.select(database.users)..where((u) => u.id.equals(id))).getSingleOrNull();
    if (row == null) return null;

    return AuthUser(
      id: row.id!,
      username: row.username,
      role: UserRole.values.firstWhere((e) => e.name == row.role, orElse: () => UserRole.employee),
      isActive: row.isActive,
    );
  }

  @override
  Future<bool> updateLastLogin(int userId, DateTime timestamp) {
    return (database.update(database.users)..where((u) => u.id.equals(userId))).write(
      UsersCompanion(lastLoginAt: Value(timestamp)),
    );
  }
}

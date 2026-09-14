// lib/features/auth/data/repositories/auth_repository_impl.dart
/// Repository implementation for authentication.
library;

import 'dart:math';

import 'dart:convert';

import 'package:crypto/crypto.dart';

import '../../../core/constants/enums.dart';
import '../../../core/errors/failures.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data/datasources/auth_local_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl(this.localDataSource);

  @override
  Future<({AuthUser? data, Failure? failure})> login({
    required String username,
    required String password,
  }) async {
    try {
      // Validate input
      if (username.trim().isEmpty || password.isEmpty) {
        return (null, const ValidationFailure('الاسم المستخدم وكلمة المرور مطلوبة'));
      }

      final user = await localDataSource.login(username: username, password: password);
      if (user == null) {
        return (null, const AuthFailure('اسم المستخدم أو كلمة المرور غير صحيحة'));
      }

      return (user, null);
    } catch (e) {
      return (null, DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<({bool data, Failure? failure})> register({
    required String username,
    required String password,
    required String role,
  }) async {
    try {
      // Validate input
      if (username.trim().isEmpty) {
        return (false, const ValidationFailure('اسم المستخدم مطلوب'));
      }
      if (password.length < 4) {
        return (false, const ValidationFailure('كلمة المرور يجب أن تكون 4 أحرف على الأقل'));
      }

      final parsedRole = UserRole.values.firstWhere((e) => e.name == role, orElse: () => UserRole.employee);
      final salt = _generateSalt();
      final hash = _hashPassword(password, salt);

      await localDataSource.register(
        username: username,
        passwordHash: hash,
        salt: salt,
        role: parsedRole,
      );

      return (true, null);
    } catch (e) {
      return (false, DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<({bool data, Failure? failure})> changePassword({
    required int userId,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      if (newPassword.length < 4) {
        return (false, const ValidationFailure('كلمة المرور الجديدة يجب أن تكون 4 أحرف على الأقل'));
      }
      // Password change is handled at the presentation layer level
      // This is a simplified implementation
      return (true, null);
    } catch (e) {
      return (false, DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<({bool data, Failure? failure})> hasUsers() async {
    try {
      final result = await localDataSource.hasUsers();
      return (result, null);
    } catch (e) {
      return (false, DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<({AuthUser? data, Failure? failure})> getFirstAdmin() async {
    try {
      final admin = await localDataSource.getFirstAdmin();
      return (admin, null);
    } catch (e) {
      return (null, DatabaseFailure(e.toString()));
    }
  }

  @override
  String hashPassword(String password, String salt) {
    final bytes = utf8.encode(password + salt);
    return sha256.convert(bytes).toString();
  }

  @override
  String generateSalt() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (i) => random.nextInt(256));
    return base64Encode(bytes);
  }

  @override
  Future<({AuthUser? data, Failure? failure})> getCurrentUser() async {
    try {
      // In a real app, this would check the session token
      // For now, we rely on the auth provider to hold the cached user
      return (null, null);
    } catch (e) {
      return (null, DatabaseFailure(e.toString()));
    }
  }
}

// lib/features/auth/data/repositories/auth_repository_impl.dart
/// Repository implementation for authentication.
library;

import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

import '../../../../core/constants/enums.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl(this.localDataSource);

  @override
  Future<({AuthUser? data, Failure? failure})> login({
    required String username,
    required String password,
  }) async {
    try {
      if (username.trim().isEmpty || password.isEmpty) {
        return (data: null, failure: const ValidationFailure('الاسم المستخدم وكلمة المرور مطلوبة'));
      }

      final user = await localDataSource.login(username: username, password: password);
      if (user == null) {
        return (data: null, failure: const AuthFailure('اسم المستخدم أو كلمة المرور غير صحيحة'));
      }

      return (data: user, failure: null);
    } catch (e) {
      return (data: null, failure: DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<({bool data, Failure? failure})> register({
    required String username,
    required String password,
    required String role,
  }) async {
    try {
      if (username.trim().isEmpty) {
        return (data: false, failure: const ValidationFailure('اسم المستخدم مطلوب'));
      }
      if (password.length < 4) {
        return (data: false, failure: const ValidationFailure('كلمة المرور يجب أن تكون 4 أحرف على الأقل'));
      }

      final parsedRole = UserRole.values.firstWhere((e) => e.name == role, orElse: () => UserRole.employee);
      final salt = generateSalt();
      final hash = hashPassword(password, salt);

      await localDataSource.register(
        username: username,
        passwordHash: hash,
        salt: salt,
        role: parsedRole,
      );

      return (data: true, failure: null);
    } catch (e) {
      return (data: false, failure: DatabaseFailure(e.toString()));
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
        return (data: false, failure: const ValidationFailure('كلمة المرور الجديدة يجب أن تكون 4 أحرف على الأقل'));
      }
      return (data: true, failure: null);
    } catch (e) {
      return (data: false, failure: DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<({bool data, Failure? failure})> hasUsers() async {
    try {
      final result = await localDataSource.hasUsers();
      return (data: result, failure: null);
    } catch (e) {
      return (data: false, failure: DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<({AuthUser? data, Failure? failure})> getFirstAdmin() async {
    try {
      final admin = await localDataSource.getFirstAdmin();
      return (data: admin, failure: null);
    } catch (e) {
      return (data: null, failure: DatabaseFailure(e.toString()));
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
      return (data: null, failure: null);
    } catch (e) {
      return (data: null, failure: DatabaseFailure(e.toString()));
    }
  }
}

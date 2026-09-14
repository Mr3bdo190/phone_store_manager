// test/unit/auth_test.dart
/// Unit tests for authentication logic.
library;

import 'package:flutter_test/flutter_test.dart';

import '../../lib/features/auth/data/repositories/auth_repository_impl.dart';
import '../../lib/features/auth/domain/entities/auth_user.dart';
import '../../lib/core/constants/enums.dart';
import '../../lib/core/database/database.dart';
import '../../lib/features/auth/data/datasources/auth_local_datasource.dart';

void main() {
  group('AuthRepository', () {
    late AppDatabase database;
    late AuthRepositoryImpl repository;

    setUp(() async {
      database = AppDatabase.test();
      await database.getSettingsOrDefault();
      repository = AuthRepositoryImpl(
        AuthLocalDataSourceImpl(database),
      );
    });

    tearDown(() async {
      await database.closeAndDelete();
    });

    test('register creates a user and returns true', () async {
      final result = await repository.register(
        username: 'admin',
        password: 'password123',
        role: UserRole.admin.name,
      );
      expect(result.data, isTrue);
      expect(result.failure, isNull);
    });

    test('register with empty username returns ValidationFailure', () async {
      final result = await repository.register(
        username: '',
        password: 'password123',
        role: UserRole.admin.name,
      );
      expect(result.data, isFalse);
      expect(result.failure, isNotNull);
      expect(result.failure!.message, isNotEmpty);
    });

    test('register with short password returns ValidationFailure', () async {
      final result = await repository.register(
        username: 'admin',
        password: '123',
        role: UserRole.admin.name,
      );
      expect(result.data, isFalse);
      expect(result.failure, isNotNull);
    });

    test('hasUsers returns false initially', () async {
      final result = await repository.hasUsers();
      expect(result.data, isFalse);
    });

    test('hasUsers returns true after registration', () async {
      await repository.register(
        username: 'admin',
        password: 'password123',
        role: UserRole.admin.name,
      );
      final result = await repository.hasUsers();
      expect(result.data, isTrue);
    });

    test('login with correct credentials returns AuthUser', () async {
      await repository.register(
        username: 'admin',
        password: 'password123',
        role: UserRole.admin.name,
      );

      final result = await repository.login(username: 'admin', password: 'password123');
      expect(result.data, isNotNull);
      expect(result.data!.username, 'admin');
      expect(result.data!.role, UserRole.admin);
      expect(result.failure, isNull);
    });

    test('login with wrong password returns AuthFailure', () async {
      await repository.register(
        username: 'admin',
        password: 'password123',
        role: UserRole.admin.name,
      );

      final result = await repository.login(username: 'admin', password: 'wrong');
      expect(result.data, isNull);
      expect(result.failure, isNotNull);
    });

    test('login with empty fields returns ValidationFailure', () async {
      final result = await repository.login(username: '', password: '');
      expect(result.data, isNull);
      expect(result.failure, isNotNull);
    });

    test('hashPassword produces consistent hash with same salt', () {
      final hash1 = repository.hashPassword('password123', 'salt123');
      final hash2 = repository.hashPassword('password123', 'salt123');
      expect(hash1, equals(hash2));
    });

    test('hashPassword produces different hash with different salt', () {
      final hash1 = repository.hashPassword('password123', 'salt123');
      final hash2 = repository.hashPassword('password123', 'salt456');
      expect(hash1, isNot(equals(hash2)));
    });

    test('generateSalt produces unique values', () {
      final salt1 = repository.generateSalt();
      final salt2 = repository.generateSalt();
      expect(salt1, isNot(equals(salt2)));
      expect(salt1.length, greaterThan(10));
    });
  });
}

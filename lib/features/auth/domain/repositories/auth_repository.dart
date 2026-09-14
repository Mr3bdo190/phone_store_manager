// lib/features/auth/domain/repositories/auth_repository.dart
/// Abstract repository contract for authentication operations.
library;

import '../../../core/errors/failures.dart';
import '../../domain/entities/auth_user.dart';

/// Result type for repository operations — simplified Either.
typedef AuthResult<T> = ({T? data, Failure? failure})?;

abstract class AuthRepository {
  /// Authenticate a user with [username] and [password].
  ///
  /// Returns the [AuthUser] on success, or a [Failure] on error.
  Future<({AuthUser? data, Failure? failure})> login({
    required String username,
    required String password,
  });

  /// Register a new user (admin only).
  Future<({bool data, Failure? failure})> register({
    required String username,
    required String password,
    required String role,
  });

  /// Change password for the given user.
  Future<({bool data, Failure? failure})> changePassword({
    required int userId,
    required String oldPassword,
    required String newPassword,
  });

  /// Check if any user exists (to determine first-run / setup).
  Future<({bool data, Failure? failure})> hasUsers();

  /// Get the first admin user.
  Future<({AuthUser? data, Failure? failure})> getFirstAdmin();

  /// Hash a password using a simple salted hash.
  /// In production, use a proper key derivation function.
  String hashPassword(String password, String salt);

  /// Generate a random salt.
  String generateSalt();

  /// Get the currently logged-in user, or null if not authenticated.
  Future<({AuthUser? data, Failure? failure})> getCurrentUser();
}

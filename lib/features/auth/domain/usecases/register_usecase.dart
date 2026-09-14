// lib/features/auth/domain/usecases/register_usecase.dart
/// Use case: register a new user (admin only).
library;

import '../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<({bool data, Failure? failure})> call({
    required String username,
    required String password,
    required String role,
  }) {
    return repository.register(
      username: username,
      password: password,
      role: role,
    );
  }
}

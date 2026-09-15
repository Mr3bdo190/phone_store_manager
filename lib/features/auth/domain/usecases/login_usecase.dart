// lib/features/auth/domain/usecases/login_usecase.dart
/// Use case: authenticate a user.
library;

import '../../../../core/errors/failures.dart';
import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<({AuthUser? data, Failure? failure})> call({
    required String username,
    required String password,
  }) {
    return repository.login(username: username, password: password);
  }
}

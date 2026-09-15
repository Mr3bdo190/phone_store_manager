// lib/features/auth/domain/usecases/check_has_users_usecase.dart
/// Use case: check if any users exist (for first-run setup).
library;

import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class CheckHasUsersUseCase {
  final AuthRepository repository;

  CheckHasUsersUseCase(this.repository);

  Future<({bool data, Failure? failure})> call() {
    return repository.hasUsers();
  }
}

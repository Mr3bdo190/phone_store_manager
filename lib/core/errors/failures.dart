// lib/core/errors/failures.dart
/// Failure classes representing the result of a failed operation.
///
/// Used with Either/Result patterns in the repository layer.
library;

/// Base failure class.
abstract class Failure {
  final String message;
  final String? code;

  const Failure(this.message, {this.code});

  @override
  String toString() => '$runtimeType: $message';
}

/// General server/database failure.
class DatabaseFailure extends Failure {
  const DatabaseFailure(String message)
      : super(message, code: 'DATABASE_FAILURE');
}

/// Validation failure — input did not pass rules.
class ValidationFailure extends Failure {
  const ValidationFailure(String message)
      : super(message, code: 'VALIDATION_FAILURE');
}

/// Business rule failure — operation violates domain rules.
class BusinessRuleFailure extends Failure {
  const BusinessRuleFailure(String message)
      : super(message, code: 'BUSINESS_FAILURE');
}

/// Not found failure.
class NotFoundFailure extends Failure {
  const NotFoundFailure(String message)
      : super(message, code: 'NOT_FOUND_FAILURE');
}

/// Authentication failure.
class AuthFailure extends Failure {
  const AuthFailure(String message) : super(message, code: 'AUTH_FAILURE');
}

/// Backup/restore failure.
class BackupFailure extends Failure {
  const BackupFailure(String message) : super(message, code: 'BACKUP_FAILURE');
}

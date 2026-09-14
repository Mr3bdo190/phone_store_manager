// lib/core/errors/app_exceptions.dart
/// Centralized exception hierarchy for the application.
///
/// Every exception extends [AppException] so that UI layers can
/// catch and translate them into user-friendly messages.
library;

/// Base exception class for all application-level errors.
class AppException implements Exception {
  final String message;
  final String? code;

  AppException(this.message, {this.code});

  @override
  String toString() => 'AppException: $message';
}

/// Thrown when a validation rule fails.
class ValidationException extends AppException {
  ValidationException(String message) : super(message, code: 'VALIDATION_ERROR');
}

/// Thrown when a database operation fails.
class DatabaseException extends AppException {
  DatabaseException(String message) : super(message, code: 'DATABASE_ERROR');
}

/// Thrown when an entity is not found.
class NotFoundException extends AppException {
  NotFoundException(String message) : super(message, code: 'NOT_FOUND');
}

/// Thrown when a business rule is violated (e.g., insufficient stock).
class BusinessRuleException extends AppException {
  BusinessRuleException(String message)
      : super(message, code: 'BUSINESS_RULE_ERROR');
}

/// Thrown during authentication failures.
class AuthenticationException extends AppException {
  AuthenticationException(String message)
      : super(message, code: 'AUTH_ERROR');
}

/// Thrown when backup/restore operations fail.
class BackupException extends AppException {
  BackupException(String message) : super(message, code: 'BACKUP_ERROR');
}

/// Thrown when network is required but unavailable.
class NetworkException extends AppException {
  NetworkException(String message) : super(message, code: 'NETWORK_ERROR');
}

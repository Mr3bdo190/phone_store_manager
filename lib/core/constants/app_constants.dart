// lib/core/constants/app_constants.dart
/// Application-wide constants used throughout Phone Store Manager.
///
/// These values are centralized to avoid magic strings and numbers
/// scattered across the codebase.
library;

/// No runtime constants yet — this file will hold app-wide string,
/// dimension, and configuration constants as features are added.
class AppConstants {
  AppConstants._();

  /// App display name
  static const String appName = "Phone Store Manager";

  /// Database name
  static const String dbName = "phone_store_manager.db";

  /// Current database schema version
  static const int dbVersion = 1;
}

// lib/core/database/db_path.dart
/// Platform-specific database path resolution.
///
/// This file is imported by [database.dart] to keep the database
/// definition decoupled from `package:path_provider` at the top level,
/// so that test environments (using `dart test` without Flutter)
/// can import [database.dart] without loading `dart:ui`.
///
/// In production, [getDatabaseDirectory] returns the app's documents
/// directory. It uses `package:path_provider` which requires a running
/// Flutter application — only called at database open time, never in tests.
library;

/// Returns the application documents directory path as a `String`.
///
/// This is a function reference that can be called at runtime.
/// It must be assigned before the production database is opened.
typedef GetDatabaseDirectory = Future<String> Function();

/// Default implementation using `package:path_provider`.
///
/// This function is assigned lazily (not at import time) so that
/// `package:path_provider` is only loaded when actually needed.
GetDatabaseDirectory? _directoryProvider;

/// Sets the platform-specific directory provider.
/// Called from DI setup or platform initialization.
void setDirectoryProvider(GetDatabaseDirectory provider) {
  _directoryProvider = provider;
}

/// Returns the database directory path.
///
/// Throws if no provider has been set — this should never happen
/// in production since [setDirectoryProvider] is called during startup.
Future<String> getDatabaseDirectory() {
  final provider = _directoryProvider;
  if (provider == null) {
    throw StateError(
      'Database directory provider not set. Call setDatabaseDirectoryProvider() first.',
    );
  }
  return provider();
}

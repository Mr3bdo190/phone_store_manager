// lib/core/database/db_path.dart
/// Platform-specific database path resolution.
///
/// Uses `dart:io` only (no Flutter dependency) to determine the
/// database directory, so that test environments using `dart test`
/// are not pulled into loading `dart:ui` through `package:path_provider`.
library;

import 'dart:io';

import 'package:path/path.dart' as p;

/// Returns the application documents directory path as a `String`.
///
/// On Android, this reads from the environment or a known platform path.
/// During testing, the database file is never used (in-memory test DB is),
/// so this function is never called in test environments.
Future<String> getDatabaseDirectory() async {
  final envHome = Platform.environment['ANDROID_DATA'] ?? '';
  if (envHome.isNotEmpty) {
    // Android: use the app's data directory
    // In production, this would be /data/data/com.phone.storemanager
    return p.join(envHome, 'com.phone.storemanager', 'databases');
  }
  // Fallback for testing/other platforms
  return p.join(Platform.environment['HOME'] ?? '/tmp', '.phone_store_manager');
}

// test/helpers/test_helpers.dart
/// Test helpers and utilities for the Phone Store Manager test suite.
library;

import '../lib/core/database/database.dart';

/// Creates an in-memory Drift database for testing.
///
/// This uses Drift's [VmDatabase.memory()] which does not require
/// a file on disk, making tests fast and isolated.
AppDatabase createTestDatabase() {
  return AppDatabase.test();
}

// lib/main.dart
/// Application entry point.
///
/// Initializes the database, registers dependencies, then launches
/// the Flutter app. Settings and auth providers load asynchronously
/// inside the app widget tree.
library;

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'app.dart';
import 'core/database/database.dart';
import 'core/database/db_path.dart';
import 'core/services/di.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set the platform-specific database directory provider.
  // Uses path_provider to get the app's documents directory.
  setDirectoryProvider(() async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  });

  // Initialize database and ensure default settings exist
  final database = AppDatabase();
  await database.getSettingsOrDefault();

  // Register dependencies (database, data sources, repositories)
  await initDependencies(database);

  runApp(const PhoneStoreManagerApp());
}

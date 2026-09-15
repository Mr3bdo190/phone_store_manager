// lib/main.dart
/// Application entry point.
///
/// Initializes the database, registers dependencies, loads settings,
/// then launches the Flutter app.
library;

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'core/database/database.dart';
import 'core/database/db_path.dart';
import 'core/services/di.dart';
import 'features/settings/presentation/providers/settings_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set the platform-specific database directory provider.
  // Must be called before AppDatabase() in production.
  setDirectoryProvider(() async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  });

  // Initialize database
  final database = AppDatabase();
  await database.getSettingsOrDefault();

  // Register dependencies
  await initDependencies(database);

  // Load settings for theme/locale
  final settingsProvider = SettingsProvider();
  await settingsProvider.loadSettings();

  runApp(
    ChangeNotifierProvider.value(
      value: settingsProvider,
      child: const PhoneStoreManagerApp(),
    ),
  );
}

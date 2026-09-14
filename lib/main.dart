// lib/main.dart
/// Application entry point.
///
/// Initializes the database, registers dependencies, loads settings,
/// then launches the Flutter app.
library;

import 'package:flutter/material.dart';

import 'app.dart';
import 'core/database/database.dart';
import 'core/services/di.dart';
import 'features/settings/data/datasources/settings_local_datasource.dart';
import 'features/settings/data/repositories/settings_repository_impl.dart';
import 'features/settings/domain/repositories/settings_repository.dart';
import 'features/settings/presentation/providers/settings_provider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

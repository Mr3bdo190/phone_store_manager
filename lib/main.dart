// lib/main.dart
/// Application entry point.
///
/// Initializes the database, registers dependencies, then launches
/// the Flutter app. Settings and auth providers load asynchronously
/// inside the app widget tree.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'app.dart';
import 'core/database/database.dart';
import 'core/database/db_path.dart';
import 'core/services/di.dart';

void main() {
  // Catch unhandled Flutter errors and display them on screen instead of
  // showing a blank/white screen that hides the actual exception.
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    FlutterError.presentError(details);
  };

  runZonedGuarded<Future<void>>(
    () async {
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
    },
    (error, stack) {
      // This catches async errors that occur before runApp() can render.
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stack,
          context: ErrorDescription('while running app'),
        ),
      );
    },
  );
}

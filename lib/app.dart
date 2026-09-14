// lib/app.dart
/// Root application widget with theme and localization configuration.
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/settings/presentation/providers/settings_provider.dart';
import 'routes.dart';

class PhoneStoreManagerApp extends StatelessWidget {
  const PhoneStoreManagerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: Consumer2<AuthProvider, SettingsProvider>(
        builder: (context, auth, settings, _) {
          final themeMode = settings.settings?.themeMode ?? 'light';
          final languageCode = settings.settings?.languageCode ?? 'ar';

          return MaterialApp(
            title: 'Phone Store Manager',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: _parseThemeMode(themeMode),
            locale: Locale(languageCode),
            localizationsDelegates: const [
              // Will be extended with app-specific delegates later
            ],
            supportedLocales: const [
              Locale('ar'), // Arabic (RTL)
              Locale('en'), // English
            ],
            localeResolutionCallback: (locale, supported) {
              // Force RTL for Arabic
              if (locale?.languageCode == 'ar') {
                return const Locale('ar');
              }
              return supported;
            },
            initialRoute: '/',
            routes: AppRoutes.routes,
          );
        },
      ),
    );
  }

  ThemeMode _parseThemeMode(String mode) {
    switch (mode) {
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      case 'light':
      default:
        return ThemeMode.light;
    }
  }
}

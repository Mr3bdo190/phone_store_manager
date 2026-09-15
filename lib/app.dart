// lib/app.dart
/// Root application widget with theme and localization configuration.
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/settings/presentation/providers/settings_provider.dart';
import 'l10n/app_localizations.dart';
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
      child: const _AppContent(),
    );
  }
}

class _AppContent extends StatelessWidget {
  const _AppContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final auth = Provider.of<AuthProvider>(context, listen: false);

    // Show loading screen until settings are loaded
    if (settings.isLoading) {
      return MaterialApp(
        title: 'Phone Store Manager',
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 24),
                Text(
                  'جاري التحميل...',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      );
    }

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
        AppLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar'), // Arabic (RTL)
        Locale('en'), // English
      ],
      localeResolutionCallback: (locale, supported) {
        final code = locale?.languageCode ?? 'ar';
        if (supported?.contains(Locale(code)) ?? false) {
          return Locale(code);
        }
        return const Locale('ar');
      },
      initialRoute: auth.isAuthenticated ? '/dashboard' : '/',
      routes: AppRoutes.routes,
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

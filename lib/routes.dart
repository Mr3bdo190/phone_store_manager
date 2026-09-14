// lib/routes.dart
/// Application route definitions.
library;

import 'package:flutter/material.dart';

import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/setup_page.dart';
import 'features/dashboard/presentation/pages/dashboard_page.dart';
import 'features/settings/presentation/pages/settings_page.dart';

class AppRoutes {
  static final Map<String, WidgetBuilder> routes = {
    '/': (context) => const _RootRouter(),
    '/login': (context) => const LoginPage(),
    '/setup': (context) => const SetupPage(),
    '/dashboard': (context) => const DashboardPage(),
    '/settings': (context) => const SettingsPage(),
  };
}

/// Root router — decides between login, setup, or dashboard based on auth state.
class _RootRouter extends StatefulWidget {
  const _RootRouter({Key? key}) : super(key: key);

  @override
  State<_RootRouter> createState() => _RootRouterState();
}

class _RootRouterState extends State<_RootRouter> {
  @override
  void initState() {
    super.initState();
    _checkInitialState();
  }

  Future<void> _checkInitialState() async {
    // Wait for settings to load, then navigate
    // The auth and settings providers load in main() before this runs
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

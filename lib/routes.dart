// lib/routes.dart
/// Application route definitions.
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/setup_page.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/dashboard/presentation/pages/dashboard_page.dart';
import 'features/settings/presentation/pages/settings_page.dart';
import 'features/products/presentation/pages/products_list_page.dart';
import 'features/categories/presentation/pages/categories_page.dart';
import 'features/brands/presentation/pages/brands_page.dart';
import 'features/customers/presentation/pages/customers_page.dart';
import 'features/pos/presentation/pages/pos_page.dart';
import 'features/inventory/presentation/pages/inventory_page.dart';
import 'features/phones/presentation/pages/phones_page.dart';

class AppRoutes {
  static final Map<String, WidgetBuilder> routes = {
    '/': (context) => const _RootRouter(),
    '/login': (context) => const LoginPage(),
    '/setup': (context) => const SetupPage(),
    '/dashboard': (context) => const DashboardPage(),
    '/settings': (context) => const SettingsPage(),
    '/products': (context) => const ProductsListPage(),
    '/categories': (context) => const CategoriesPage(),
    '/brands': (context) => const BrandsPage(),
    '/customers': (context) => const CustomersPage(),
    '/pos': (context) => const PosPage(),
    '/inventory': (context) => const InventoryPage(),
    '/phones': (context) => const PhonesPage(),
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
    final auth = Provider.of<AuthProvider>(context, listen: false);

    // Check if any users exist (first-run detection)
    final isFirstRun = await auth.checkFirstRun();

    if (!mounted) return;

    if (isFirstRun) {
      Navigator.of(context).pushReplacementNamed('/setup');
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

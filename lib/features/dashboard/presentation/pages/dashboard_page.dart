// lib/features/dashboard/presentation/pages/dashboard_page.dart
/// Main dashboard showing key metrics and quick actions.
library;

import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Store Manager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.of(context).pushNamed('/settings'),
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'اللوحة الرئيسية - سيتم تطويرها في الفترات القادمة',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

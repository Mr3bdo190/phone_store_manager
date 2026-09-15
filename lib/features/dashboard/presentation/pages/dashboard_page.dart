// lib/features/dashboard/presentation/pages/dashboard_page.dart
/// Main dashboard showing key metrics and quick actions.
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../presentation/providers/dashboard_provider.dart';
import '../../presentation/widgets/dashboard_card.dart';
import 'package:phone_store_manager/features/settings/presentation/providers/settings_provider.dart';
import 'package:phone_store_manager/l10n/app_localizations.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final currencySymbol = settings.settings?.currencySymbol ?? 'ر.س';

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.dashboard ?? 'اللوحة الرئيسية'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<DashboardProvider>(context, listen: false).refresh();
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.of(context).pushNamed('/settings'),
          ),
        ],
      ),
      body: ChangeNotifierProvider(
        create: (_) => DashboardProvider(),
        child: Consumer<DashboardProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.errorMessage != null) {
              return Center(
                child: Text(
                  provider.errorMessage!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              );
            }

            final m = provider.metrics;
            if (m == null) {
              return const Center(child: Text('No data available'));
            }

            return RefreshIndicator(
              onRefresh: () => provider.refresh(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Metrics grid
                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        DashboardCard(
                          icon: Icons.payments,
                          title: AppLocalizations.of(context)?.todaySales ?? 'مبيعات اليوم',
                          value: '${m.todaySales.toStringAsFixed(2)} $currencySymbol',
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        DashboardCard(
                          icon: Icons.account_balance_wallet,
                          title: AppLocalizations.of(context)?.cashBalance ?? 'رصيد النقدية',
                          value: '${m.cashBalance.toStringAsFixed(2)} $currencySymbol',
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        DashboardCard(
                          icon: Icons.currency_exchange,
                          title: AppLocalizations.of(context)?.totalSales ?? 'إجمالي المبيعات',
                          value: '${m.totalSales.toStringAsFixed(2)} $currencySymbol',
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        DashboardCard(
                          icon: Icons.person,
                          title: AppLocalizations.of(context)?.customers ?? 'العملاء',
                          value: '${m.customerCount}',
                          color: Colors.blue,
                        ),
                        DashboardCard(
                          icon: Icons.inventory,
                          title: AppLocalizations.of(context)?.lowStock ?? 'مخزون منخفض',
                          value: '${m.lowStockCount}',
                          color: Colors.orange,
                        ),
                        DashboardCard(
                          icon: Icons.money_off,
                          title: AppLocalizations.of(context)?.customerDebts ?? 'ديون العملاء',
                          value: '${m.customerDebts.toStringAsFixed(2)} $currencySymbol',
                          color: Colors.red,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Quick actions
                    Text(
                      AppLocalizations.of(context)?.quickActions ?? 'إجراءات سريعة',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 12),
                    GridView.count(
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _QuickAction(
                          icon: Icons.point_of_sale,
                          label: AppLocalizations.of(context)?.pos ?? 'نقطة البيع',
                          onTap: () => Navigator.of(context).pushNamed('/pos'),
                        ),
                        _QuickAction(
                          icon: Icons.inventory_2,
                          label: AppLocalizations.of(context)?.products ?? 'المنتجات',
                          onTap: () => Navigator.of(context).pushNamed('/products'),
                        ),
                        _QuickAction(
                          icon: Icons.category,
                          label: AppLocalizations.of(context)?.inventory ?? 'المخزون',
                          onTap: () => Navigator.of(context).pushNamed('/inventory'),
                        ),
                        _QuickAction(
                          icon: Icons.person,
                          label: AppLocalizations.of(context)?.customers ?? 'العملاء',
                          onTap: () => Navigator.of(context).pushNamed('/customers'),
                        ),
                        _QuickAction(
                          icon: Icons.phone_android,
                          label: 'الهواتف',
                          onTap: () => Navigator.of(context).pushNamed('/phones'),
                        ),
                        _QuickAction(
                          icon: Icons.receipt_long,
                          label: 'الفواتورات',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAction({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 28,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// lib/features/pos/domain/usecases/get_dashboard_metrics_usecase.dart
/// Use case for fetching dashboard summary metrics.
library;

import '../../../../core/errors/failures.dart';

class DashboardMetrics {
  final double todaySales;
  final double totalSales;
  final double cashBalance;
  final double customerDebts;
  final int lowStockCount;
  final int productCount;
  final int customerCount;

  DashboardMetrics({
    required this.todaySales,
    required this.totalSales,
    required this.cashBalance,
    required this.customerDebts,
    required this.lowStockCount,
    required this.productCount,
    required this.customerCount,
  });
}

typedef DashboardMetricsResult = ({DashboardMetrics? data, Failure? failure})?;

abstract class GetDashboardMetricsUseCase {
  Future<DashboardMetricsResult> call();
}

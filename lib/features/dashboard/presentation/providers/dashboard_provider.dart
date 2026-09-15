// lib/features/dashboard/presentation/providers/dashboard_provider.dart
/// State management for dashboard metrics.
library;

import 'package:flutter/foundation.dart';

import '../../../../core/services/di.dart';
import '../../../customers/domain/repositories/customer_repository.dart';
import '../../../inventory/domain/repositories/inventory_repository.dart';
import '../../../pos/domain/repositories/sales_repository.dart';
import '../../../pos/domain/usecases/get_dashboard_metrics_usecase.dart';
import '../../../products/domain/repositories/product_repository.dart';

class DashboardProvider extends ChangeNotifier {
  final SalesRepository _salesRepository;
  final ProductRepository _productRepository;
  final InventoryRepository _inventoryRepository;
  final CustomerRepository _customerRepository;

  DashboardProvider()
      : _salesRepository = di.get<SalesRepository>(),
        _productRepository = di.get<ProductRepository>(),
        _inventoryRepository = di.get<InventoryRepository>(),
        _customerRepository = di.get<CustomerRepository>() {
    _loadMetrics();
  }

  DashboardMetrics? _metrics;
  bool _isLoading = false;
  String? _errorMessage;

  DashboardMetrics? get metrics => _metrics;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> _loadMetrics() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final todaySales = await _salesRepository.getTodaySalesTotal();
      final totalSales = await _salesRepository.getTotalSales();
      final cashBalance = await _salesRepository.getCashBalance();
      final customerDebts = await _salesRepository.getCustomerDebts();

      final activeProducts = await _productRepository.getActiveProducts();
      final lowStock = await _inventoryRepository.getLowStockProducts();
      final customers = await _customerRepository.getAllCustomers();

      _metrics = DashboardMetrics(
        todaySales: todaySales,
        totalSales: totalSales,
        cashBalance: cashBalance,
        customerDebts: customerDebts,
        lowStockCount: lowStock.length,
        productCount: activeProducts.length,
        customerCount: customers.length,
      );
    } catch (e) {
      _errorMessage = e.toString();
      _metrics = DashboardMetrics(
        todaySales: 0,
        totalSales: 0,
        cashBalance: 0,
        customerDebts: 0,
        lowStockCount: 0,
        productCount: 0,
        customerCount: 0,
      );
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    await _loadMetrics();
  }
}

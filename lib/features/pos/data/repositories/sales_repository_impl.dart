// lib/features/pos/data/repositories/sales_repository_impl.dart
/// Repository implementation for sales/POS.
library;

import '../../../../core/errors/failures.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/sales_repository.dart';
import '../datasources/sales_local_datasource.dart';

class SalesRepositoryImpl implements SalesRepository {
  final SalesLocalDataSource localDataSource;

  SalesRepositoryImpl(this.localDataSource);

  @override
  Future<String> generateInvoiceNumber(String prefix) {
    return localDataSource.generateInvoiceNumber(prefix);
  }

  @override
  Future<({int? data, Failure? failure})> createSale({
    required int? customerId,
    required String paymentMethod,
    required double subtotal,
    required double discount,
    required double tax,
    required double total,
    required double paidAmount,
    required List<CartItem> items,
    int? createdBy,
  }) async {
    try {
      // Validate inputs
      if (total < 0) {
        return (
          data: null,
          failure: const ValidationFailure('الإجمالي لا يمكن أن يكون سالباً')
        );
      }
      if (paidAmount < 0) {
        return (
          data: null,
          failure:
              const ValidationFailure('المبلغ المدفوع لا يمكن أن يكون سالباً')
        );
      }
      if (paidAmount > total) {
        // Overpayment — still allowed, change due
      }
      if (items.isEmpty) {
        return (data: null, failure: const ValidationFailure('السلة فارغة'));
      }

      final result = await localDataSource.createSale(
        customerId: customerId,
        paymentMethod: paymentMethod,
        subtotal: subtotal,
        discount: discount,
        tax: tax,
        total: total,
        paidAmount: paidAmount,
        items: items,
        createdBy: createdBy,
      );

      if (result.error != null) {
        return (data: null, failure: BusinessRuleFailure(result.error!));
      }
      return (data: result.data, failure: null);
    } catch (e) {
      return (data: null, failure: DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<double> getTodaySalesTotal() => localDataSource.getTodaySalesTotal();

  @override
  Future<double> getTotalSales() => localDataSource.getTotalSales();

  @override
  Future<double> getCashBalance() => localDataSource.getCashBalance();

  @override
  Future<double> getCustomerDebts() => localDataSource.getCustomerDebts();
}

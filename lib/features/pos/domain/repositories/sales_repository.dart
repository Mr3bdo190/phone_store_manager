// lib/features/pos/domain/repositories/sales_repository.dart
/// Abstract repository contract for sales/POS operations.
library;

import '../../../../core/errors/failures.dart';
import '../../../pos/domain/entities/cart_item.dart';

typedef SalesResult<T> = ({T? data, Failure? failure})?;

abstract class SalesRepository {
  /// Generate the next invoice number with the given prefix.
  Future<String> generateInvoiceNumber(String prefix);

  /// Create a sale transaction atomically.
  /// Validates stock, creates sale + items + payments, updates inventory,
  /// updates IMEI/phone status.
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
  });

  /// Get today's sales total.
  Future<double> getTodaySalesTotal();

  /// Get total sales (all time).
  Future<double> getTotalSales();

  /// Get the current cash balance.
  Future<double> getCashBalance();

  /// Get customer debt total.
  Future<double> getCustomerDebts();
}

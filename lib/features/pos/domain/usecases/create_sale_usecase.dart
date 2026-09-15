// lib/features/pos/domain/usecases/create_sale_usecase.dart
/// Use case for creating a sale transaction.
library;

import '../../../../core/errors/failures.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/sales_repository.dart';

class CreateSaleUseCase {
  final SalesRepository repository;

  CreateSaleUseCase(this.repository);

  Future<({int? data, Failure? failure})> call({
    required int? customerId,
    required String paymentMethod,
    required double subtotal,
    required double discount,
    required double tax,
    required double total,
    required double paidAmount,
    required List<CartItem> items,
    int? createdBy,
  }) {
    return repository.createSale(
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
  }
}

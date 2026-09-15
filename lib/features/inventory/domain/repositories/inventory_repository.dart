// lib/features/inventory/domain/repositories/inventory_repository.dart
/// Abstract repository contract for inventory operations.
library;

import '../../../../core/errors/failures.dart';
import '../../../products/domain/entities/product.dart';

typedef InventoryResult<T> = ({T? data, Failure? failure})?;

abstract class InventoryRepository {
  Future<List<Product>> getLowStockProducts();
  Future<List<Product>> searchProducts(String query);
  Future<({bool data, Failure? failure})> adjustStock({
    required int productId,
    required int newQuantity,
    required String reason,
    int? userId,
  });
  Future<List<Map<String, dynamic>>> getMovementHistory(int productId);
}

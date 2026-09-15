// lib/features/inventory/data/repositories/inventory_repository_impl.dart
/// Repository implementation for inventory operations.
library;

import '../../../../core/errors/failures.dart';
import '../../../products/domain/entities/product.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../datasources/inventory_local_datasource.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryLocalDataSource localDataSource;

  InventoryRepositoryImpl(this.localDataSource);

  @override
  Future<List<Product>> getLowStockProducts() {
    return localDataSource.getLowStockProducts();
  }

  @override
  Future<List<Product>> searchProducts(String query) {
    return localDataSource.searchProducts(query);
  }

  @override
  Future<({bool data, Failure? failure})> adjustStock({
    required int productId,
    required int newQuantity,
    required String reason,
    int? userId,
  }) async {
    try {
      if (newQuantity < 0) {
        return (data: false, failure: const ValidationFailure('الكمية لا يمكن أن تكون سالية'));
      }
      if (reason.trim().isEmpty) {
        return (data: false, failure: const ValidationFailure('سبب التعديل مطلوب'));
      }
      final success = await localDataSource.adjustStock(
        productId: productId,
        newQuantity: newQuantity,
        reason: reason,
        userId: userId,
      );
      return (data: success, failure: null);
    } catch (e) {
      return (data: false, failure: DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getMovementHistory(int productId) {
    return localDataSource.getMovementHistory(productId);
  }
}

// lib/features/products/domain/repositories/product_repository.dart
/// Abstract repository contract for product operations.
library;

import '../../../../core/errors/failures.dart';
import '../entities/product.dart';

typedef ProductResult<T> = ({T? data, Failure? failure})?;

abstract class ProductRepository {
  Future<List<Product>> getAllProducts();
  Future<List<Product>> getActiveProducts();
  Future<List<Product>> searchProducts(String query);
  Future<Product?> getProductBySku(String sku);
  Future<Product?> getProductByBarcode(String barcode);
  Future<({int? data, Failure? failure})> createProduct({
    required String name,
    required String sku,
    required String barcode,
    int? categoryId,
    int? brandId,
    String? model,
    String? color,
    String? storage,
    String? ram,
    double purchasePrice = 0,
    double sellingPrice = 0,
    double costPrice = 0,
    int quantity = 0,
    int minStock = 0,
    String? notes,
  });
  Future<({bool data, Failure? failure})> updateProduct(Product product);
  Future<({bool data, Failure? failure})> deleteProduct(int id);
  Future<List<Product>> getLowStockProducts();
}

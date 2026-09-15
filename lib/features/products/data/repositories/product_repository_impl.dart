// lib/features/products/data/repositories/product_repository_impl.dart
/// Repository implementation for products.
library;

import '../../../../core/errors/failures.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductLocalDataSource localDataSource;

  ProductRepositoryImpl(this.localDataSource);

  @override
  Future<List<Product>> getAllProducts() {
    return localDataSource.getAllProducts();
  }

  @override
  Future<List<Product>> getActiveProducts() {
    return localDataSource.getActiveProducts();
  }

  @override
  Future<List<Product>> searchProducts(String query) {
    return localDataSource.searchProducts(query);
  }

  @override
  Future<Product?> getProductBySku(String sku) {
    return localDataSource.getProductBySku(sku);
  }

  @override
  Future<Product?> getProductByBarcode(String barcode) {
    return localDataSource.getProductByBarcode(barcode);
  }

  @override
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
  }) async {
    try {
      if (name.trim().isEmpty) {
        return (data: null, failure: const ValidationFailure('اسم المنتج مطلوب'));
      }
      if (sku.trim().isEmpty) {
        return (data: null, failure: const ValidationFailure('رمز المنتج (SKU) مطلوب'));
      }
      if (barcode.trim().isEmpty) {
        return (data: null, failure: const ValidationFailure('الباركود مطلوب'));
      }
      if (purchasePrice < 0) {
        return (data: null, failure: const ValidationFailure('سعر الشراء لا يمكن أن يكون سالباً'));
      }
      if (sellingPrice < 0) {
        return (data: null, failure: const ValidationFailure('سعر البيع لا يمكن أن يكون سالباً'));
      }
      if (quantity < 0) {
        return (data: null, failure: const ValidationFailure('الكمية لا يمكن أن تكون سالبة'));
      }
      if (minStock < 0) {
        return (data: null, failure: const ValidationFailure('الحد الأدنى للمخزون غير صالح'));
      }

      final id = await localDataSource.createProduct(
        name: name,
        sku: sku,
        barcode: barcode,
        categoryId: categoryId,
        brandId: brandId,
        model: model,
        color: color,
        storage: storage,
        ram: ram,
        purchasePrice: purchasePrice,
        sellingPrice: sellingPrice,
        costPrice: costPrice,
        quantity: quantity,
        minStock: minStock,
        notes: notes,
      );
      return (data: id, failure: null);
    } catch (e) {
      return (data: null, failure: DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<({bool data, Failure? failure})> updateProduct(Product product) async {
    try {
      if (product.purchasePrice < 0) {
        return (data: false, failure: const ValidationFailure('سعر الشراء غير صالح'));
      }
      if (product.sellingPrice < 0) {
        return (data: false, failure: const ValidationFailure('سعر البيع غير صالح'));
      }
      if (product.quantity < 0) {
        return (data: false, failure: const ValidationFailure('الكمية غير صالحة'));
      }

      final success = await localDataSource.updateProduct(product);
      return (data: success, failure: null);
    } catch (e) {
      return (data: false, failure: DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<({bool data, Failure? failure})> deleteProduct(int id) async {
    try {
      final success = await localDataSource.deleteProduct(id);
      return (data: success, failure: null);
    } catch (e) {
      return (data: false, failure: DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<List<Product>> getLowStockProducts() {
    return localDataSource.getLowStockProducts();
  }
}

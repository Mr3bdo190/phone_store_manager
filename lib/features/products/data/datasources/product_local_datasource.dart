// lib/features/products/data/datasources/product_local_datasource.dart
/// Data source for products — reads/writes to local Drift database.
library;

import 'package:drift/drift.dart';

import '../../../../core/database/database.dart' as db;
import '../../domain/entities/product.dart';

abstract class ProductLocalDataSource {
  Future<List<Product>> getAllProducts();
  Future<List<Product>> getActiveProducts();
  Future<List<Product>> searchProducts(String query);
  Future<Product?> getProductBySku(String sku);
  Future<Product?> getProductByBarcode(String barcode);
  Future<int> createProduct({
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
  Future<bool> updateProduct(Product product);
  Future<bool> deleteProduct(int id);
  Future<List<Product>> getLowStockProducts();
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final db.AppDatabase database;

  ProductLocalDataSourceImpl(this.database);

  Product _fromRow(db.Product row) => Product(
        id: row.id,
        name: row.name,
        sku: row.sku,
        barcode: row.barcode,
        categoryId: row.categoryId,
        brandId: row.brandId,
        model: row.model,
        color: row.color,
        storage: row.storage,
        ram: row.ram,
        purchasePrice: row.purchasePrice,
        sellingPrice: row.sellingPrice,
        costPrice: row.costPrice,
        quantity: row.quantity,
        minStock: row.minStock,
        notes: row.notes,
        isActive: row.isActive,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
        deletedAt: row.deletedAt,
      );

  @override
  Future<List<Product>> getAllProducts() async {
    final rows = await database.getAllProducts();
    return rows.map(_fromRow).toList();
  }

  @override
  Future<List<Product>> getActiveProducts() async {
    final rows = await database.getActiveProducts();
    return rows.map(_fromRow).toList();
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    final rows = await database.searchProducts(query);
    return rows.map(_fromRow).toList();
  }

  @override
  Future<Product?> getProductBySku(String sku) async {
    final row = await database.getProductBySku(sku);
    return row == null ? null : _fromRow(row);
  }

  @override
  Future<Product?> getProductByBarcode(String barcode) async {
    final row = await database.getProductByBarcode(barcode);
    return row == null ? null : _fromRow(row);
  }

  @override
  Future<int> createProduct({
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
  }) {
    return database.createProduct(db.ProductsCompanion.insert(
      name: name,
      sku: sku,
      barcode: barcode,
      categoryId: Value(categoryId),
      brandId: Value(brandId),
      model: Value(model),
      color: Value(color),
      storage: Value(storage),
      ram: Value(ram),
      purchasePrice: Value(purchasePrice),
      sellingPrice: Value(sellingPrice),
      costPrice: Value(costPrice),
      quantity: Value(quantity),
      minStock: Value(minStock),
      notes: Value(notes),
      isActive: const Value(true),
      createdAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    ));
  }

  @override
  Future<bool> updateProduct(Product product) async {
    if (product.id == null) return false;
    return database.updateProduct(db.ProductsCompanion(
      id: Value(product.id!),
      name: Value(product.name),
      sku: Value(product.sku),
      barcode: Value(product.barcode),
      categoryId: Value(product.categoryId),
      brandId: Value(product.brandId),
      model: Value(product.model),
      color: Value(product.color),
      storage: Value(product.storage),
      ram: Value(product.ram),
      purchasePrice: Value(product.purchasePrice),
      sellingPrice: Value(product.sellingPrice),
      costPrice: Value(product.costPrice),
      quantity: Value(product.quantity),
      minStock: Value(product.minStock),
      notes: Value(product.notes),
      isActive: Value(product.isActive),
      updatedAt: Value(DateTime.now()),
    ));
  }

  @override
  Future<bool> deleteProduct(int id) async {
    final result = await (database.update(database.products)..where((p) => p.id.equals(id))).write(
      db.ProductsCompanion(deletedAt: Value(DateTime.now())),
    );
    return result > 0;
  }

  @override
  Future<List<Product>> getLowStockProducts() async {
    final rows = await database.getLowStockProducts();
    return rows.map(_fromRow).toList();
  }
}

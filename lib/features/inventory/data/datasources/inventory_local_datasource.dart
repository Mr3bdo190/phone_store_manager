// lib/features/inventory/data/datasources/inventory_local_datasource.dart
/// Data source for inventory — reads/writes to local Drift database.
library;

import 'package:drift/drift.dart';

import '../../../../core/database/database.dart' as db;
import '../../../products/domain/entities/product.dart';

abstract class InventoryLocalDataSource {
  Future<List<Product>> getLowStockProducts();
  Future<List<Product>> searchProducts(String query);
  Future<bool> adjustStock({
    required int productId,
    required int newQuantity,
    required String reason,
    int? userId,
  });
  Future<List<Map<String, dynamic>>> getMovementHistory(int productId);
}

class InventoryLocalDataSourceImpl implements InventoryLocalDataSource {
  final db.AppDatabase database;

  InventoryLocalDataSourceImpl(this.database);

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
  Future<List<Product>> getLowStockProducts() async {
    final rows = await database.getLowStockProducts();
    return rows.map(_fromRow).toList();
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    final rows = await database.searchProducts(query);
    return rows.map(_fromRow).toList();
  }

  @override
  Future<bool> adjustStock({
    required int productId,
    required int newQuantity,
    required String reason,
    int? userId,
  }) async {
    try {
      final product = await (database.select(database.products)
            ..where((p) => p.id.equals(productId)))
          .getSingle();

      if (product.deletedAt != null) return false;

      final previousQuantity = product.quantity;

      final result = await (database.update(database.products)
            ..where((p) => p.id.equals(productId)))
          .write(
        db.ProductsCompanion(quantity: Value(newQuantity)),
      );

      if (result == 0) return false;

      await database.insertMovement(db.InventoryMovementsCompanion.insert(
        productId: Value(productId),
        movementType: 'adjustment',
        quantity: newQuantity - previousQuantity,
        previousQuantity: previousQuantity,
        newQuantity: newQuantity,
        unitPrice: Value(product.costPrice),
        referenceType: Value('manual_adjustment'),
        userId: userId ?? 1,
        notes: Value(reason),
        createdAt: Value(DateTime.now()),
      ));

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getMovementHistory(int productId) async {
    final rows = await (database.select(database.inventoryMovements)
          ..where((m) => m.productId.equals(productId))
          ..orderBy([(m) => OrderingTerm.desc(m.createdAt)]))
        .get();

    return rows.map((row) {
      return {
        'id': row.id,
        'movementType': row.movementType,
        'quantity': row.quantity,
        'previousQuantity': row.previousQuantity,
        'newQuantity': row.newQuantity,
        'unitPrice': row.unitPrice,
        'notes': row.notes,
        'createdAt': row.createdAt,
      };
    }).toList();
  }
}

// lib/features/brands/data/datasources/brand_local_datasource.dart
/// Data source for brands — reads/writes to local Drift database.
library;

import 'package:drift/drift.dart';

import '../../../../core/database/database.dart' as db;
import '../../domain/entities/brand.dart';

abstract class BrandLocalDataSource {
  Future<List<Brand>> getAllBrands();
  Future<Brand?> getBrandById(int id);
  Future<int> createBrand({required String name, String? description});
  Future<bool> updateBrand(Brand brand);
  Future<bool> deleteBrand(int id);
}

class BrandLocalDataSourceImpl implements BrandLocalDataSource {
  final db.AppDatabase database;

  BrandLocalDataSourceImpl(this.database);

  Brand _fromRow(db.Brand row) => Brand(
        id: row.id,
        name: row.name,
        description: row.description,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
        deletedAt: row.deletedAt,
      );

  @override
  Future<List<Brand>> getAllBrands() async {
    final rows = await database.getAllBrands();
    return rows.map(_fromRow).toList();
  }

  @override
  Future<Brand?> getBrandById(int id) async {
    final rows = await database.getAllBrands();
    for (final row in rows) {
      if (row.id == id) return _fromRow(row);
    }
    return null;
  }

  @override
  Future<int> createBrand({required String name, String? description}) {
    return database.createBrand(db.BrandsCompanion.insert(
      name: name,
      description: Value(description),
      createdAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    ));
  }

  @override
  Future<bool> updateBrand(Brand brand) async {
    if (brand.id == null) return false;
    return database.updateBrand(db.BrandsCompanion(
      id: Value(brand.id!),
      name: Value(brand.name),
      description: Value(brand.description),
      updatedAt: Value(DateTime.now()),
    ));
  }

  @override
  Future<bool> deleteBrand(int id) async {
    final result = await (database.update(database.brands)
          ..where((b) => b.id.equals(id)))
        .write(
      db.BrandsCompanion(deletedAt: Value(DateTime.now())),
    );
    return result > 0;
  }
}

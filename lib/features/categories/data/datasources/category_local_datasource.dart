// lib/features/categories/data/datasources/category_local_datasource.dart
/// Data source for categories — reads/writes to local Drift database.
library;

import 'package:drift/drift.dart';

import '../../../../core/database/database.dart' as db;
import '../../domain/entities/category.dart';

abstract class CategoryLocalDataSource {
  Future<List<Category>> getAllCategories();
  Future<Category?> getCategoryById(int id);
  Future<int> createCategory({required String name, String? description});
  Future<bool> updateCategory(Category category);
  Future<bool> deleteCategory(int id);
}

class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  final db.AppDatabase database;

  CategoryLocalDataSourceImpl(this.database);

  Category _fromRow(db.Category row) => Category(
        id: row.id,
        name: row.name,
        description: row.description,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
        deletedAt: row.deletedAt,
      );

  @override
  Future<List<Category>> getAllCategories() async {
    final rows = await database.getAllCategories();
    return rows.map(_fromRow).toList();
  }

  @override
  Future<Category?> getCategoryById(int id) async {
    final rows = await database.getAllCategories();
    for (final row in rows) {
      if (row.id == id) return _fromRow(row);
    }
    return null;
  }

  @override
  Future<int> createCategory({required String name, String? description}) {
    return database.createCategory(db.CategoriesCompanion.insert(
      name: name,
      description: Value(description),
      createdAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    ));
  }

  @override
  Future<bool> updateCategory(Category category) async {
    if (category.id == null) return false;
    return database.updateCategory(db.CategoriesCompanion(
      id: Value(category.id!),
      name: Value(category.name),
      description: Value(category.description),
      updatedAt: Value(DateTime.now()),
    ));
  }

  @override
  Future<bool> deleteCategory(int id) async {
    final result = await (database.update(database.categories)
          ..where((c) => c.id.equals(id)))
        .write(
      db.CategoriesCompanion(deletedAt: Value(DateTime.now())),
    );
    return result > 0;
  }
}

// lib/features/categories/data/repositories/category_repository_impl.dart
/// Repository implementation for categories.
library;

import '../../../../core/errors/failures.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_local_datasource.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryLocalDataSource localDataSource;

  CategoryRepositoryImpl(this.localDataSource);

  @override
  Future<List<Category>> getAllCategories() {
    return localDataSource.getAllCategories();
  }

  @override
  Future<Category?> getCategoryById(int id) {
    return localDataSource.getCategoryById(id);
  }

  @override
  Future<({int? data, Failure? failure})> createCategory({
    required String name,
    String? description,
  }) async {
    try {
      if (name.trim().isEmpty) {
        return (data: null, failure: const ValidationFailure('اسم الفئة مطلوب'));
      }
      final id = await localDataSource.createCategory(name: name, description: description);
      return (data: id, failure: null);
    } catch (e) {
      return (data: null, failure: DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<({bool data, Failure? failure})> updateCategory(Category category) async {
    try {
      final success = await localDataSource.updateCategory(category);
      return (data: success, failure: null);
    } catch (e) {
      return (data: false, failure: DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<({bool data, Failure? failure})> deleteCategory(int id) async {
    try {
      final success = await localDataSource.deleteCategory(id);
      return (data: success, failure: null);
    } catch (e) {
      return (data: false, failure: DatabaseFailure(e.toString()));
    }
  }
}

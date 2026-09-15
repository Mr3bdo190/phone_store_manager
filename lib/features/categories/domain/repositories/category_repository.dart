// lib/features/categories/domain/repositories/category_repository.dart
/// Abstract repository contract for category operations.
library;

import '../../../../core/errors/failures.dart';
import '../entities/category.dart';

typedef CategoryResult<T> = ({T? data, Failure? failure})?;

abstract class CategoryRepository {
  Future<List<Category>> getAllCategories();
  Future<Category?> getCategoryById(int id);
  Future<({int? data, Failure? failure})> createCategory({
    required String name,
    String? description,
  });
  Future<({bool data, Failure? failure})> updateCategory(Category category);
  Future<({bool data, Failure? failure})> deleteCategory(int id);
}

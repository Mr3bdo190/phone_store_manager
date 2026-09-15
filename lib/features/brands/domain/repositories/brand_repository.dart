// lib/features/brands/domain/repositories/brand_repository.dart
/// Abstract repository contract for brand operations.
library;

import '../../../../core/errors/failures.dart';
import '../entities/brand.dart';

typedef BrandResult<T> = ({T? data, Failure? failure})?;

abstract class BrandRepository {
  Future<List<Brand>> getAllBrands();
  Future<Brand?> getBrandById(int id);
  Future<({int? data, Failure? failure})> createBrand({
    required String name,
    String? description,
  });
  Future<({bool data, Failure? failure})> updateBrand(Brand brand);
  Future<({bool data, Failure? failure})> deleteBrand(int id);
}

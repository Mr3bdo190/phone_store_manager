// lib/features/brands/data/repositories/brand_repository_impl.dart
/// Repository implementation for brands.
library;

import '../../../../core/errors/failures.dart';
import '../../domain/entities/brand.dart';
import '../../domain/repositories/brand_repository.dart';
import '../datasources/brand_local_datasource.dart';

class BrandRepositoryImpl implements BrandRepository {
  final BrandLocalDataSource localDataSource;

  BrandRepositoryImpl(this.localDataSource);

  @override
  Future<List<Brand>> getAllBrands() {
    return localDataSource.getAllBrands();
  }

  @override
  Future<Brand?> getBrandById(int id) {
    return localDataSource.getBrandById(id);
  }

  @override
  Future<({int? data, Failure? failure})> createBrand({
    required String name,
    String? description,
  }) async {
    try {
      if (name.trim().isEmpty) {
        return (data: null, failure: const ValidationFailure('اسم العلامة التجارية مطلوب'));
      }
      final id = await localDataSource.createBrand(name: name, description: description);
      return (data: id, failure: null);
    } catch (e) {
      return (data: null, failure: DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<({bool data, Failure? failure})> updateBrand(Brand brand) async {
    try {
      final success = await localDataSource.updateBrand(brand);
      return (data: success, failure: null);
    } catch (e) {
      return (data: false, failure: DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<({bool data, Failure? failure})> deleteBrand(int id) async {
    try {
      final success = await localDataSource.deleteBrand(id);
      return (data: success, failure: null);
    } catch (e) {
      return (data: false, failure: DatabaseFailure(e.toString()));
    }
  }
}

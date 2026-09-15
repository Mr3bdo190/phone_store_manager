// lib/features/phones/data/repositories/phone_repository_impl.dart
/// Repository implementation for phones and IMEI management.
library;

import '../../../../core/errors/failures.dart';
import '../../domain/entities/imei.dart';
import '../../domain/entities/phone.dart';
import '../../domain/repositories/phone_repository.dart';
import '../datasources/phone_local_datasource.dart';

class PhoneRepositoryImpl implements PhoneRepository {
  final PhoneLocalDataSource localDataSource;

  PhoneRepositoryImpl(this.localDataSource);

  @override
  Future<List<Phone>> getAllPhones() {
    return localDataSource.getAllPhones();
  }

  @override
  Future<List<Phone>> getPhonesByStatus(String status) {
    return localDataSource.getPhonesByStatus(status);
  }

  @override
  Future<({int? data, Failure? failure})> createPhone({
    required String name,
    required String sku,
    required String serialNumber,
    int? categoryId,
    int? brandId,
    String? model,
    String? color,
    String? storage,
    String? ram,
    double purchasePrice = 0,
    double sellingPrice = 0,
    int quantity = 1,
    String? notes,
    List<String>? imeis,
  }) async {
    try {
      if (name.trim().isEmpty) {
        return (data: null, failure: const ValidationFailure('اسم الجهاز مطلوب'));
      }
      if (sku.trim().isEmpty) {
        return (data: null, failure: const ValidationFailure('رمز المنتج (SKU) مطلوب'));
      }
      if (serialNumber.trim().isEmpty) {
        return (data: null, failure: const ValidationFailure('رقم التسلسل مطلوب'));
      }
      if (purchasePrice < 0) {
        return (data: null, failure: const ValidationFailure('سعر الشراء غير صالح'));
      }
      if (sellingPrice < 0) {
        return (data: null, failure: const ValidationFailure('سعر البيع غير صالح'));
      }
      if (quantity < 0) {
        return (data: null, failure: const ValidationFailure('الكمية غير صالحة'));
      }

      // Validate IMEIs if provided
      if (imeis != null) {
        for (final imei in imeis) {
          if (imei.isNotEmpty && !ImeiValidator.isValid(imei)) {
            return (data: null, failure: ValidationFailure('رقم IMEI غير صالح: $imei'));
          }
        }
      }

      // Check IMEI uniqueness before creating
      if (imeis != null) {
        for (final imei in imeis) {
          if (imei.isNotEmpty) {
            final isUnique = await localDataSource.isImeiUnique(imei);
            if (!isUnique) {
              return (data: null, failure: ValidationFailure('رقم IMEI مكرر: $imei'));
            }
          }
        }
      }

      final id = await localDataSource.createPhone(
        name: name,
        sku: sku,
        serialNumber: serialNumber,
        categoryId: categoryId,
        brandId: brandId,
        model: model,
        color: color,
        storage: storage,
        ram: ram,
        purchasePrice: purchasePrice,
        sellingPrice: sellingPrice,
        quantity: quantity,
        notes: notes,
        imeis: imeis,
      );
      return (data: id, failure: null);
    } catch (e) {
      return (data: null, failure: DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<({bool data, Failure? failure})> updatePhone(Phone phone) async {
    try {
      final success = await localDataSource.updatePhone(phone);
      return (data: success, failure: null);
    } catch (e) {
      return (data: false, failure: DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<({bool data, Failure? failure})> sellPhone(int phoneId, int? customerId) async {
    try {
      final success = await localDataSource.sellPhone(phoneId, customerId);
      // Deactivate IMEIs when phone is sold
      if (success) {
        await localDataSource.deactivateImeisForPhone(phoneId);
      }
      return (data: success, failure: null);
    } catch (e) {
      return (data: false, failure: DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<List<Imei>> getImeisForPhone(int phoneId) {
    return localDataSource.getImeisForPhone(phoneId);
  }

  @override
  Future<({bool data, Failure? failure})> addImei({
    required int phoneId,
    required String imei,
    int? excludeImeiId,
  }) async {
    try {
      if (!ImeiValidator.isValid(imei)) {
        return (data: false, failure: const ValidationFailure('رقم IMEI غير صالح'));
      }

      final isUnique = await localDataSource.isImeiUnique(imei, excludePhoneId: excludeImeiId);
      if (!isUnique) {
        return (data: false, failure: const ValidationFailure('رقم IMEI مستخدم من قبل جهاز آخر'));
      }

      await localDataSource.insertImei(phoneId, imei);
      return (data: true, failure: null);
    } catch (e) {
      return (data: false, failure: DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<bool> isImeiUnique(String imei, {int? excludePhoneId}) {
    return localDataSource.isImeiUnique(imei, excludePhoneId: excludePhoneId);
  }
}

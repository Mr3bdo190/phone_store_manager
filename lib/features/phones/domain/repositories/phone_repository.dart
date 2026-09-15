// lib/features/phones/domain/repositories/phone_repository.dart
/// Abstract repository contract for phone/IMEI operations.
library;

import '../../../../core/errors/failures.dart';
import '../entities/imei.dart';
import '../entities/phone.dart';

typedef PhoneResult<T> = ({T? data, Failure? failure})?;

abstract class PhoneRepository {
  Future<List<Phone>> getAllPhones();
  Future<List<Phone>> getPhonesByStatus(String status);
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
  });
  Future<({bool data, Failure? failure})> updatePhone(Phone phone);
  Future<({bool data, Failure? failure})> sellPhone(
      int phoneId, int? customerId);
  Future<List<Imei>> getImeisForPhone(int phoneId);
  Future<({bool data, Failure? failure})> addImei({
    required int phoneId,
    required String imei,
    int? excludeImeiId,
  });
  Future<bool> isImeiUnique(String imei, {int? excludePhoneId});
}

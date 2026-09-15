// lib/features/phones/data/datasources/phone_local_datasource.dart
/// Data source for phones/IMEI — reads/writes to local Drift database.
library;

import 'package:drift/drift.dart';

import '../../../../core/database/database.dart' as db;
import '../../domain/entities/imei.dart';
import '../../domain/entities/phone.dart';

abstract class PhoneLocalDataSource {
  Future<List<Phone>> getAllPhones();
  Future<List<Phone>> getPhonesByStatus(String status);
  Future<int> createPhone({
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
  Future<bool> updatePhone(Phone phone);
  Future<bool> sellPhone(int phoneId, int? customerId);
  Future<List<Imei>> getImeisForPhone(int phoneId);
  Future<int> insertImei(int phoneId, String imei);
  Future<int> deactivateImeisForPhone(int phoneId);
  Future<bool> isImeiUnique(String imei, {int? excludePhoneId});
}

class PhoneLocalDataSourceImpl implements PhoneLocalDataSource {
  final db.AppDatabase database;

  PhoneLocalDataSourceImpl(this.database);

  Phone _fromRow(db.Phone row) => Phone(
        id: row.id,
        name: row.name,
        sku: row.sku,
        serialNumber: row.serialNumber,
        categoryId: row.categoryId,
        brandId: row.brandId,
        model: row.model,
        color: row.color,
        storage: row.storage,
        ram: row.ram,
        purchasePrice: row.purchasePrice,
        sellingPrice: row.sellingPrice,
        quantity: row.quantity,
        status: row.status,
        customerId: row.customerId,
        saleDate: row.saleDate,
        warrantyInfo: row.warrantyInfo,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
        deletedAt: row.deletedAt,
        notes: row.notes,
      );

  Imei _imeiFromRow(db.Imei row) => Imei(
        id: row.id,
        phoneId: row.phoneId,
        imei: row.imei,
        active: row.active,
        createdAt: row.createdAt,
        deactivatedAt: row.deactivatedAt,
      );

  @override
  Future<List<Phone>> getAllPhones() async {
    final rows = await database.getAllPhones();
    return rows.map(_fromRow).toList();
  }

  @override
  Future<List<Phone>> getPhonesByStatus(String status) async {
    final rows = await database.getPhonesByStatus(status);
    return rows.map(_fromRow).toList();
  }

  @override
  Future<int> createPhone({
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
    final phoneId = await database.createPhone(db.PhonesCompanion.insert(
      name: name,
      sku: sku,
      serialNumber: serialNumber,
      categoryId: Value(categoryId),
      brandId: Value(brandId),
      model: Value(model),
      color: Value(color),
      storage: Value(storage),
      ram: Value(ram),
      purchasePrice: Value(purchasePrice),
      sellingPrice: Value(sellingPrice),
      quantity: Value(quantity),
      status: const Value('in_stock'),
      warrantyInfo: const Value(''),
      createdAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
      notes: Value(notes),
    ));

    if (imeis != null) {
      for (final imei in imeis) {
        if (imei.isNotEmpty) {
          await database.insertImei(db.ImeisCompanion.insert(
            phoneId: phoneId,
            imei: imei,
            active: const Value(true),
            createdAt: Value(DateTime.now()),
          ));
        }
      }
    }

    return phoneId;
  }

  @override
  Future<bool> updatePhone(Phone phone) async {
    if (phone.id == null) return false;
    return database.updatePhone(db.PhonesCompanion(
      id: Value(phone.id!),
      name: Value(phone.name),
      sku: Value(phone.sku),
      serialNumber: Value(phone.serialNumber),
      categoryId: Value(phone.categoryId),
      brandId: Value(phone.brandId),
      model: Value(phone.model),
      color: Value(phone.color),
      storage: Value(phone.storage),
      ram: Value(phone.ram),
      purchasePrice: Value(phone.purchasePrice),
      sellingPrice: Value(phone.sellingPrice),
      quantity: Value(phone.quantity),
      status: Value(phone.status),
      customerId: Value(phone.customerId),
      saleDate: Value(phone.saleDate),
      warrantyInfo: Value(phone.warrantyInfo),
      updatedAt: Value(DateTime.now()),
      notes: Value(phone.notes),
    ));
  }

  @override
  Future<bool> sellPhone(int phoneId, int? customerId) {
    return database.sellPhone(phoneId, customerId);
  }

  @override
  Future<List<Imei>> getImeisForPhone(int phoneId) async {
    final rows = await database.getImeisForPhone(phoneId);
    return rows.map(_imeiFromRow).toList();
  }

  @override
  Future<int> insertImei(int phoneId, String imei) {
    return database.insertImei(db.ImeisCompanion.insert(
      phoneId: phoneId,
      imei: imei,
      active: const Value(true),
      createdAt: Value(DateTime.now()),
    ));
  }

  @override
  Future<int> deactivateImeisForPhone(int phoneId) {
    return database.deactivateImeisForPhone(phoneId);
  }

  @override
  Future<bool> isImeiUnique(String imei, {int? excludePhoneId}) {
    return database.isImeiUnique(imei, excludePhoneId: excludePhoneId);
  }
}

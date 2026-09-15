// lib/core/database/database.dart
/// Database connection and [AppDatabase] definition.
///
/// Uses Drift with native SQLite implementation.
library;

import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;

import 'tables.dart';
import 'db_path.dart';

part 'database.g.dart';

/// Database for Phone Store Manager.
@DriftDatabase(
  tables: [
    Users, Settings, Categories, Brands, Products, Phones, Imeis,
    Customers, Suppliers, Sales, SaleItems, SalePayments,
    Purchases, PurchaseItems, PurchasePayments,
    Returns, ReturnItems,
    InventoryMovements, Expenses, CashTransactions,
    Repairs, RepairPhotos, AuditLogs,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// Production constructor — uses a file-based database.
  AppDatabase() : super(_openConnection());

  /// Internal constructor — accepts a custom [QueryExecutor].
  /// Used by tests to pass an in-memory database.
  AppDatabase._internal(super.connector);

  /// Factory for creating an in-memory test database.
  factory AppDatabase.test() => AppDatabase._internal(NativeDatabase.memory());

  @override
  int get schemaVersion => 1;

  // ── Settings ──

  Future<Setting> getSettings() {
    return (select(settings)..where((t) => t.id.equals(1))).getSingle();
  }

  Future<Setting> getSettingsOrDefault() async {
    final result = await (select(settings)..where((t) => t.id.equals(1))).getSingleOrNull();
    if (result == null) {
      await into(settings).insert(SettingsCompanion(
        id: const Value(1),
        storeName: const Value('Phone Store Manager'),
        currencySymbol: const Value('ر.س'),
        currencyCode: const Value('SAR'),
        invoicePrefix: const Value('INV'),
        themeMode: const Value('light'),
        languageCode: const Value('ar'),
        enableInvoiceNumber: const Value(true),
        enableBiometric: const Value(false),
        enableAutoBackup: const Value(false),
        sessionTimeoutMinutes: const Value(15),
      ));
      return (await (select(settings)..where((t) => t.id.equals(1))).getSingle());
    }
    return result;
  }

  Future<int> insertOrUpdateSettings(SettingsCompanion s) {
    return into(settings).insert(s, mode: InsertMode.insertOrReplace);
  }

  // ── Users ──

  Future<User> getUserById(int id) {
    return (select(users)..where((u) => u.id.equals(id))).getSingle();
  }

  Future<List<User>> getAllActiveUsers() {
    return (select(users)..where((u) => u.isActive.equals(true))).get();
  }

  Future<int> createUser(UsersCompanion user) {
    return into(users).insert(user);
  }

  Future<bool> updateUser(UsersCompanion user) async {
    if (!user.id.present) return false;
    final result = await (update(users)..where((u) => u.id.equals(user.id.value))).write(user);
    return result > 0;
  }

  Future<int> deleteUser(int id) {
    return (delete(users)..where((u) => u.id.equals(id))).go();
  }

  Future<List<User>> getAllUsers() {
    return select(users).get();
  }

  // ── Categories ──

  Future<List<Category>> getAllCategories() {
    return (select(categories)
          ..where((c) => c.deletedAt.isNull())
          ..orderBy([(c) => OrderingTerm.asc(c.name)]))
        .get();
  }

  Future<Category?> getCategoryById(int id) {
    return (select(categories)
          ..where((c) => c.id.equals(id) & c.deletedAt.isNull()))
        .getSingleOrNull();
  }

  Future<int> createCategory(CategoriesCompanion category) {
    return into(categories).insert(category);
  }

  // ── Brands ──

  Future<List<Brand>> getAllBrands() {
    return (select(brands)
          ..where((b) => b.deletedAt.isNull())
          ..orderBy([(b) => OrderingTerm.asc(b.name)]))
        .get();
  }

  Future<int> createBrand(BrandsCompanion brand) {
    return into(brands).insert(brand);
  }

  // ── Products ──

  Future<List<Product>> searchProducts(String query) {
    final pattern = '%$query%';
    return (select(products)
          ..where((p) =>
              p.deletedAt.isNull() &
              (p.name.like(pattern) |
                  p.sku.like(pattern) |
                  p.barcode.like(pattern)))
          ..limit(50))
        .get();
  }

  Future<Product?> getProductBySku(String sku) {
    return (select(products)
          ..where((p) => p.sku.equals(sku) & p.deletedAt.isNull()))
        .getSingleOrNull();
  }

  Future<Product?> getProductByBarcode(String barcode) {
    return (select(products)
          ..where((p) => p.barcode.equals(barcode) & p.deletedAt.isNull()))
        .getSingleOrNull();
  }

  // ── Phones ──

  Future<Phone?> getPhoneById(int id) {
    return (select(phones)..where((p) => p.id.equals(id))).getSingleOrNull();
  }

  Future<Phone?> getPhoneBySerial(String serial) {
    return (select(phones)..where((p) => p.serialNumber.equals(serial))).getSingleOrNull();
  }

  Future<bool> isImeiUnique(String imei, {int? excludePhoneId}) async {
    final existing = await (select(imeis)..where((i) => i.imei.equals(imei) & i.active.equals(true))).get();
    if (existing.isEmpty) return true;
    if (excludePhoneId != null) {
      for (final row in existing) {
        if (row.phoneId != excludePhoneId) return false;
      }
    } else {
      return false;
    }
    return true;
  }

  // ── Inventory movements ──

  Future<int> insertMovement(InventoryMovementsCompanion movement) {
    return into(inventoryMovements).insert(movement);
  }

  // ── Audit logs ──

  Future<int> insertAuditLog(AuditLogsCompanion log) {
    return into(auditLogs).insert(log);
  }

  // ── Low stock / out of stock ──

  Future<List<Product>> getLowStockProducts() {
    return (select(products)
          ..where((p) => p.deletedAt.isNull() & (p.quantity.isSmallerOrEqual(p.minStock)))
          ..orderBy([(p) => OrderingTerm.asc(p.quantity)]))
        .get();
  }

  Future<List<Phone>> getOutOfStockPhones() {
    return (select(phones)
          ..where((p) => p.deletedAt.isNull() & p.quantity.equals(0))
          ..orderBy([(p) => OrderingTerm.desc(p.id)]))
        .get();
  }
}

/// Opens the Drift connection with the correct SQLite library.
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getDatabaseDirectory();
    final file = File(p.join(dir, 'phone_store_manager.db'));
    return NativeDatabase(file);
  });
}

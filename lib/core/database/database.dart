// lib/core/database/database.dart
/// Database connection and [AppDatabase] definition.
///
/// Uses Drift with `sqlite3_flutter_libs` for the SQLite implementation.
library;

import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/directory_names.dart';
import 'package:path_provider/paths.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

import 'tables.dart';

part 'database.g.dart';

/// Database for Phone Store Manager.
///
/// All tables are defined in `tables.dart` and imported here.
/// The generated companion file (`database.g.dart`) is produced
/// by running:  `dart run build_runner build`
@DriftAccessor(
  tables: [
    Users,
    Settings,
    Categories,
    Brands,
    Products,
    Phones,
    Imeis,
    Customers,
    Suppliers,
    Sales,
    SaleItems,
    SalePayments,
    Purchases,
    PurchaseItems,
    PurchasePayments,
    Returns,
    ReturnItems,
    InventoryMovements,
    Expenses,
    CashTransactions,
    Repairs,
    RepairPhotos,
    AuditLogs,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// Production constructor — uses a file-based database.
  AppDatabase() : super(_openConnection());

  /// Internal constructor — accepts a custom [QueryExecutor].
  /// Used by tests to pass an in-memory database.
  AppDatabase._internal(QueryExecutor connector) : super(connector);

  /// Factory for creating an in-memory test database.
  factory AppDatabase.test() => AppDatabase._internal(VmDatabase.memory());

  @override
  int get schemaVersion => 1;

  // ── Settings ──────────────────────────────────────────────

  Future<Setting> getSettings() {
    return (select(settings)..where((t) => t.id.equals(1))).getSingle();
  }

  Future<Setting> getSettingsOrDefault() async {
    final result = await (select(settings)..where((t) => t.id.equals(1))).getSingleOrNull();
    if (result == null) {
      final companion = SettingsCompanion(
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
      );
      await into(settings).insert(companion);
      return companion.value;
    }
    return result;
  }

  Future<int> insertOrUpdateSettings(SettingsCompanion s) {
    return into(settings).insert(s, mode: Mode.insertOrReplace);
  }

  // ── Users ─────────────────────────────────────────────────

  Future<User> getUserById(int id) {
    return (select(users)..where((u) => u.id.equals(id))).getSingle();
  }

  Future<List<User>> getAllActiveUsers() {
    return (select(users)..where((u) => u.isActive.equals(true))).get();
  }

  Future<int> createUser(UsersCompanion user) {
    return into(users).insert(user);
  }

  Future<bool> updateUser(UsersCompanion user) {
    if (user.id.unwrapOr(0) == 0) return Future.value(false);
    return (update(users)..where((u) => u.id.equals(user.id.value))).update(user);
  }

  Future<int> deleteUser(int id) {
    return (delete(users)..where((u) => u.id.equals(id))).go();
  }

  Future<List<User>> getAllUsers() {
    return select(users).get();
  }

  // ── Categories ────────────────────────────────────────────

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

  // ── Brands ────────────────────────────────────────────────

  Future<List<Brand>> getAllBrands() {
    return (select(brands)
          ..where((b) => b.deletedAt.isNull())
          ..orderBy([(b) => OrderingTerm.asc(b.name)]))
        .get();
  }

  Future<int> createBrand(BrandsCompanion brand) {
    return into(brands).insert(brand);
  }

  // ── Products ──────────────────────────────────────────────

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

  // ── Phones ────────────────────────────────────────────────

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

  // ── Inventory movements ───────────────────────────────────

  Future<int> insertMovement(InventoryMovementsCompanion movement) {
    return into(inventoryMovements).insert(movement);
  }

  // ── Audit logs ────────────────────────────────────────────

  Future<int> insertAuditLog(AuditLogsCompanion log) {
    return into(auditLogs).insert(log);
  }

  // ── Low stock / out of stock ──────────────────────────────

  Future<List<Product>> getLowStockProducts() {
    return (select(products)
          ..where((p) => p.deletedAt.isNull() & (p.quantity.isSmallerOrEqual(p.minStock)))
          ..orderBy([(p) => OrderingTerm.asc(p.quantity)]))
        .get();
  }

  Future<List<Phone>> getOutOfStockPhones() {
    return (select(phones)
          ..where((p) => p.deletedAt.isNull() & p.quantity.equals(0))
          ..orderBy([(p) => OrderingTerm.asc(p.saleDate)]))
        .get();
  }
}

/// Opens the Drift connection with the correct SQLite library.
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'phone_store_manager.db'));

    // Also copy the sqlite3 library if needed (Android only)
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3Part1(dbFolder);
      await applyWorkaroundToOpenSqlite3Part2();
    }

    return VmDatabase(file);
  });
}

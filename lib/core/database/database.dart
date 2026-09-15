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
    final result = await (select(settings)..where((t) => t.id.equals(1)))
        .getSingleOrNull();
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
      return (await (select(settings)..where((t) => t.id.equals(1)))
          .getSingle());
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
    final result = await (update(users)
          ..where((u) => u.id.equals(user.id.value)))
        .write(user);
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

  Future<bool> updateCategory(CategoriesCompanion category) async {
    if (!category.id.present) return false;
    final result = await (update(categories)
          ..where((c) => c.id.equals(category.id.value)))
        .write(category);
    return result > 0;
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

  Future<bool> updateBrand(BrandsCompanion brand) async {
    if (!brand.id.present) return false;
    final result = await (update(brands)
          ..where((b) => b.id.equals(brand.id.value)))
        .write(brand);
    return result > 0;
  }

  // ── Products ──

  Future<List<Product>> getAllProducts() {
    return (select(products).get());
  }

  Future<List<Product>> getActiveProducts() {
    return (select(products)
          ..where((p) => p.deletedAt.isNull() & p.isActive.equals(true))
          ..orderBy([(p) => OrderingTerm.asc(p.name)]))
        .get();
  }

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

  Future<int> createProduct(ProductsCompanion product) {
    return into(products).insert(product);
  }

  Future<bool> updateProduct(ProductsCompanion product) async {
    if (!product.id.present) return false;
    final result = await (update(products)
          ..where((p) => p.id.equals(product.id.value)))
        .write(product);
    return result > 0;
  }

  // ── Phones / Devices ──

  Future<Phone?> getPhoneById(int id) {
    return (select(phones)..where((p) => p.id.equals(id))).getSingleOrNull();
  }

  Future<Phone?> getPhoneBySerial(String serial) {
    return (select(phones)..where((p) => p.serialNumber.equals(serial)))
        .getSingleOrNull();
  }

  Future<List<Phone>> getAllPhones() {
    return (select(phones)..orderBy([(p) => OrderingTerm.desc(p.id)])).get();
  }

  Future<List<Phone>> getPhonesByStatus(String status) {
    return (select(phones)..where((p) => p.status.equals(status))).get();
  }

  Future<int> createPhone(PhonesCompanion phone) {
    return into(phones).insert(phone);
  }

  Future<bool> updatePhone(PhonesCompanion phone) async {
    if (!phone.id.present) return false;
    final result = await (update(phones)
          ..where((p) => p.id.equals(phone.id.value)))
        .write(phone);
    return result > 0;
  }

  Future<bool> sellPhone(int phoneId, int? customerId) async {
    final result =
        await (update(phones)..where((p) => p.id.equals(phoneId))).write(
      PhonesCompanion(
        status: const Value('sold'),
        customerId: Value(customerId),
        saleDate: Value(DateTime.now()),
      ),
    );
    return result > 0;
  }

  // ── IMEI ──

  Future<bool> isImeiUnique(String imei, {int? excludePhoneId}) async {
    final existing = await (select(imeis)
          ..where((i) => i.imei.equals(imei) & i.active.equals(true)))
        .get();
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

  Future<List<Imei>> getImeisForPhone(int phoneId) {
    return (select(imeis)..where((i) => i.phoneId.equals(phoneId))).get();
  }

  Future<int> insertImei(ImeisCompanion imei) {
    return into(imeis).insert(imei);
  }

  Future<int> deactivateImeisForPhone(int phoneId) {
    return (update(imeis)..where((i) => i.phoneId.equals(phoneId))).write(
      ImeisCompanion(
          active: const Value(false), deactivatedAt: Value(DateTime.now())),
    );
  }

  // ── Inventory Movements ──

  Future<int> insertMovement(InventoryMovementsCompanion movement) {
    return into(inventoryMovements).insert(movement);
  }

  // ── Audit Logs ──

  Future<int> insertAuditLog(AuditLogsCompanion log) {
    return into(auditLogs).insert(log);
  }

  // ── Low stock / out of stock ──

  Future<List<Product>> getLowStockProducts() {
    return (select(products)
          ..where((p) =>
              p.deletedAt.isNull() & (p.quantity.isSmallerOrEqual(p.minStock)))
          ..orderBy([(p) => OrderingTerm.asc(p.quantity)]))
        .get();
  }

  Future<List<Phone>> getOutOfStockPhones() {
    return (select(phones)
          ..where((p) => p.deletedAt.isNull() & p.quantity.equals(0))
          ..orderBy([(p) => OrderingTerm.desc(p.id)]))
        .get();
  }

  // ── Sales ──

  Future<int> createSale(SalesCompanion sale) {
    return into(sales).insert(sale);
  }

  Future<int> createSaleItem(SaleItemsCompanion item) {
    return into(saleItems).insert(item);
  }

  Future<int> createSalePayment(SalePaymentsCompanion payment) {
    return into(salePayments).insert(payment);
  }

  Future<List<Sale>> getSalesByDateRange(DateTime start, DateTime end) {
    return (select(sales)
          ..where((s) => s.saleDate.isBetweenValues(start, end))
          ..orderBy([(s) => OrderingTerm.desc(s.saleDate)]))
        .get();
  }

  Future<double> getTodaySalesTotal() async {
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day);
    final end = start.add(const Duration(days: 1));
    final salesList = await (select(sales)
          ..where((s) => s.saleDate.isBetweenValues(start, end)))
        .get();
    var sum = 0.0;
    for (final s in salesList) {
      sum += s.total;
    }
    return sum;
  }

  Future<double> getTotalSales() async {
    final rows = await select(sales).get();
    var sum = 0.0;
    for (final s in rows) {
      sum += s.total;
    }
    return sum;
  }

  Future<List<Sale>> getAllSales() {
    return (select(sales)..orderBy([(s) => OrderingTerm.desc(s.saleDate)]))
        .get();
  }

  Future<List<SaleItem>> getSaleItemsForSale(int saleId) {
    return (select(saleItems)..where((i) => i.saleId.equals(saleId))).get();
  }

  Future<List<CashTransaction>> getAllCashTransactions() {
    return (select(cashTransactions)
          ..orderBy([(t) => OrderingTerm.desc(t.transactionDate)]))
        .get();
  }

  Future<double> getCashBalance() async {
    final rows = await select(cashTransactions).get();
    var sum = 0.0;
    for (final t in rows) {
      sum += t.amount;
    }
    return sum;
  }

  Future<double> getCustomerDebts() async {
    final rows = await select(customers).get();
    var sum = 0.0;
    for (final c in rows) {
      sum += c.remainingDebt;
    }
    return sum;
  }

  // ── Customers ──

  Future<List<Customer>> getAllCustomers() {
    return (select(customers)
          ..where((c) => c.deletedAt.isNull())
          ..orderBy([(c) => OrderingTerm.asc(c.name)]))
        .get();
  }

  Future<List<Customer>> searchCustomers(String query) {
    final pattern = '%$query%';
    return (select(customers)
          ..where((c) =>
              c.deletedAt.isNull() &
              (c.name.like(pattern) | c.phone.like(pattern)))
          ..limit(50))
        .get();
  }

  Future<int> createCustomer(CustomersCompanion customer) {
    return into(customers).insert(customer);
  }

  Future<bool> updateCustomer(CustomersCompanion customer) async {
    if (!customer.id.present) return false;
    final result = await (update(customers)
          ..where((c) => c.id.equals(customer.id.value)))
        .write(customer);
    return result > 0;
  }

  Future<int> deleteCustomer(int id) {
    return (delete(customers)..where((c) => c.id.equals(id))).go();
  }
}

/// Opens the Drift connection with the correct SQLite library.
///
/// Uses [getDatabaseDirectory] from [db_path.dart], which is set
/// at runtime from the platform-specific implementation. This avoids
/// importing `package:path_provider` at the top level of this file,
/// allowing tests to import [AppDatabase] without Flutter.
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getDatabaseDirectory();
    final file = File(p.join(dir, 'phone_store_manager.db'));
    return NativeDatabase(file);
  });
}

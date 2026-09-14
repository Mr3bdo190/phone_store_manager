// lib/core/database/app_database.dart
/// Drift database definition for Phone Store Manager.
///
/// This file defines the Drift [AppDatabase] class, all tables,
/// and generates the DAO layer.
///
/// Run `dart run build_runner build` to regenerate the companion file.
library;

import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/paths.dart';
import 'package:path_provider/path_provider.dart';

import '../constants/enums.dart';

part 'app_database.g.dart';

/// Top-level database accessor — used by repositories.
late AppDatabase appDatabase;

/// Database for Phone Store Manager.
///
/// Tables:
///   users              — admin & employee accounts
///   settings           — single-row store settings
///   categories         — product categories
///   brands             — product brands
///   products           — general products (accessories, etc.)
///   phones             — phone-specific data
///   imeis              — IMEI records for phones
///   customers          — customer profiles
///   suppliers          — supplier profiles
///   sales              — sale header records
///   sale_items         — individual items in a sale
///   sale_payments      — payments for credit sales
///   purchases          — purchase header records
///   purchase_items     — individual items in a purchase
///   purchase_payments  — payments to suppliers
///   returns            — return header records
///   return_items       — items returned
///   inventory_movements — full audit trail of stock changes
///   expenses           — expense records
///   cash_transactions  — cash book entries
///   repairs            — repair tickets
///   repair_photos      — photos attached to repairs
///   audit_logs         — system audit log
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
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // ── Settings ──────────────────────────────────────────────

  Future<SettingsCompanion> getSettings() {
    return (select(settings)..where((t) => t.id.equals(1))).getSingleOrNull();
  }

  Future<int> insertOrUpdateSettings(SettingsCompanion settings) {
    return into(this.settings).insert(
          settings,
          mode: Mode.insertOrReplace,
        );
  }

  // ── Users ─────────────────────────────────────────────────

  Future<User> getUserById(int id) {
    return (select(users)..where((u) => u.id.equals(id))).getSingle();
  }

  Future<List<User>> getAllUsers() {
    return select(users).get();
  }

  Future<int> createUser(UsersCompanion user) {
    return into(users).insert(user);
  }

  Future<bool> updateUser(UsersCompanion user) {
    return (update(users)..where((u) => u.id.equals(user.id.value))).update(user);
  }

  Future<int> deleteUser(int id) {
    return (delete(users)..where((u) => u.id.equals(id))).go();
  }

  // ── Categories ────────────────────────────────────────────

  Future<List<Category>> getAllCategories() {
    return (select(categories)
          ..where((c) => c.deletedAt.isNull())
          ..orderBy([(c) => OrderingTerm.asc(c.name)]))
        .get();
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

  // ── Phones ────────────────────────────────────────────────

  Future<Phone> getPhoneById(int id) {
    return (select(phones)..where((p) => p.id.equals(id))).getSingle();
  }

  Future<bool> isImeiUnique(String imei, {int? excludePhoneId}) {
    final query = select(imeis)..where((i) => i.imei.equals(imei) & i.active.equals(true));
    if (excludePhoneId != null) {
      query.where((i) => i.phoneId.equals(excludePhoneId), mode: WhereMode.and);
    }
    return query.getSingleOrNull().then((row) => row == null);
  }

  // ── Inventory movements ───────────────────────────────────

  Future<int> insertMovement(InventoryMovementsCompanion movement) {
    return into(inventoryMovements).insert(movement);
  }

  // ── Audit logs ────────────────────────────────────────────

  Future<int> insertAuditLog(AuditLogsCompanion log) {
    return into(auditLogs).insert(log);
  }
}
"

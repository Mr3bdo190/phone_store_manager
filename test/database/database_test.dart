// test/database/database_test.dart
/// Database integration tests for Phone Store Manager.
///
/// Tests CRUD operations, transactions, and data integrity
/// using an in-memory Drift database.
library;

import 'package:drift/drift.dart';
import 'package:test/test.dart';

import 'package:phone_store_manager/core/database/database.dart';

void main() {
  group('Database Tests', () {
    late AppDatabase database;

    setUp(() async {
      database = AppDatabase.test();
    });

    tearDown(() async {
      await database.close();
    });

    group('Settings', () {
      test('getSettingsOrDefault returns default settings when none exist',
          () async {
        final result = await database.getSettingsOrDefault();
        expect(result.storeName, equals('Phone Store Manager'));
        expect(result.currencySymbol, equals('ر.س'));
        expect(result.languageCode, equals('ar'));
      });

      test('insertOrUpdateSettings saves custom settings', () async {
        final companion = SettingsCompanion(
          id: const Value(1),
          storeName: const Value('My Phone Shop'),
          currencySymbol: const Value('د.ك'),
          currencyCode: const Value('KWD'),
          invoicePrefix: const Value('SHOP'),
        );
        await database.insertOrUpdateSettings(companion);

        final saved = await database.getSettings();
        expect(saved.storeName, equals('My Phone Shop'));
        expect(saved.currencySymbol, equals('د.ك'));
        expect(saved.currencyCode, equals('KWD'));
      });
    });

    group('Categories', () {
      test('create and retrieve category', () async {
        final id = await database.createCategory(CategoriesCompanion.insert(
          name: 'هواتف',
          description: Value('هواتف ذكية'),
        ));
        expect(id, greaterThan(0));

        final all = await database.getAllCategories();
        expect(all.length, 1);
        expect(all.first.name, equals('هواتف'));
      });
    });

    group('Brands', () {
      test('create and retrieve brand', () async {
        final id = await database.createBrand(BrandsCompanion.insert(
          name: 'Apple',
          description: Value('شركة Apple'),
        ));
        expect(id, greaterThan(0));

        final all = await database.getAllBrands();
        expect(all.length, 1);
        expect(all.first.name, equals('Apple'));
      });
    });

    group('Products', () {
      test('search products by name', () async {
        await database.into(database.products).insert(
              ProductsCompanion.insert(
                name: 'آيفون 15 برو',
                sku: 'IP15PRO',
                barcode: '1234567890123',
              ),
            );

        final results = await database.searchProducts('آيفون');
        expect(results.length, 1);
        expect(results.first.name, contains('آيفون'));
      });

      test('search by SKU', () async {
        await database.into(database.products).insert(
              ProductsCompanion.insert(
                name: 'شاح آيفون',
                sku: 'IPCASE001',
                barcode: '9998887776666',
              ),
            );

        final results = await database.searchProducts('IPCASE001');
        expect(results.length, 1);
        expect(results.first.sku, equals('IPCASE001'));
      });

      test('search returns empty for no match', () async {
        final results = await database.searchProducts('nonexistent');
        expect(results, isEmpty);
      });
    });

    group('Users', () {
      test('create and retrieve user', () async {
        final id = await database.createUser(UsersCompanion.insert(
          username: 'admin',
          passwordHash: 'hashedpass',
          role: const Value('admin'),
        ));
        expect(id, greaterThan(0));

        final user = await database.getUserById(id);
        expect(user.username, equals('admin'));
        expect(user.role, equals('admin'));
      });

      test('getAllActiveUsers excludes inactive', () async {
        await database.createUser(UsersCompanion.insert(
          username: 'active_user',
          passwordHash: 'hash1',
          role: const Value('employee'),
        ));
        await database.createUser(UsersCompanion.insert(
          username: 'inactive_user',
          passwordHash: 'hash2',
          role: const Value('employee'),
          isActive: const Value(false),
        ));

        final active = await database.getAllActiveUsers();
        expect(active.length, 1);
        expect(active.first.username, equals('active_user'));
      });

      test('updateUser updates user data', () async {
        final id = await database.createUser(UsersCompanion.insert(
          username: 'admin',
          passwordHash: 'old_hash',
          role: const Value('admin'),
        ));

        await database.updateUser(UsersCompanion(
          id: Value(id),
          passwordHash: const Value('new_hash'),
        ));

        final user = await database.getUserById(id);
        expect(user.passwordHash, equals('new_hash'));
      });

      test('deleteUser removes user', () async {
        final id = await database.createUser(UsersCompanion.insert(
          username: 'temp',
          passwordHash: 'hash',
          role: const Value('employee'),
        ));

        await database.deleteUser(id);
        final all = await database.getAllUsers();
        expect(all.any((u) => u.id == id), isFalse);
      });
    });

    group('Inventory Movements', () {
      test('insert and retrieve movement', () async {
        // Create a product first
        final productId = await database.into(database.products).insert(
              ProductsCompanion.insert(
                name: 'iPhone 15',
                sku: 'IP15',
                barcode: '1111111111111',
                quantity: const Value(10),
              ),
            );

        final movementId = await database.insertMovement(
          InventoryMovementsCompanion.insert(
            productId: Value(productId),
            movementType: 'stock_in',
            quantity: 10,
            previousQuantity: 0,
            newQuantity: 10,
            unitPrice: const Value(0.0),
            userId: 1,
            notes: Value('Initial stock'),
          ),
        );
        expect(movementId, greaterThan(0));
      });
    });

    group('Audit Logs', () {
      test('insert audit log', () async {
        final id = await database.insertAuditLog(AuditLogsCompanion.insert(
          userId: 1,
          userName: 'admin',
          action: 'login',
          entityType: 'user',
          entityId: const Value(1),
          description: Value('User logged in'),
        ));
        expect(id, greaterThan(0));
      });
    });

    group('Soft Delete', () {
      test('categories support soft delete', () async {
        final id = await database.createCategory(CategoriesCompanion.insert(
          name: 'Test Category',
        ));

        // Soft delete
        await (database.update(database.categories)
              ..where((c) => c.id.equals(id)))
            .write(
          CategoriesCompanion(deletedAt: Value(DateTime.now())),
        );

        final all = await database.getAllCategories();
        expect(all, isEmpty);
      });
    });
  });
}

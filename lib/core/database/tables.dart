// lib/core/database/tables.dart
/// Drift table definitions for Phone Store Manager.
///
/// Each table class defines columns, foreign keys, indexes,
/// and unique constraints. This file is imported by app_database.dart
/// via the Drift [DriftAccessor] tables parameter.
library;

import 'package:drift/drift.dart';

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get username => text().withLength(min: 3, max: 50)();
  TextColumn get passwordHash => text()();
  TextColumn get passwordSalt => text().nullable()();
  TextColumn get role => text().withDefault(const Constant('employee'))();
  BooleanColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().clientDefault(const Constant(null))();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  DateTimeColumn get lastLoginAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Settings extends Table {
  IntColumn get id => integer()();
  TextColumn get storeName => text().withDefault(const Constant('Phone Store Manager'))();
  TextColumn get storePhone => text().nullable()();
  TextColumn get storeAddress => text().nullable()();
  TextColumn get currencySymbol => text().withDefault(const Constant('ر.س'))();
  TextColumn get currencyCode => text().withDefault(const Constant('SAR'))();
  BooleanColumn get enableInvoiceNumber => boolean().withDefault(const Constant(true))();
  TextColumn get invoicePrefix => text().withDefault(const Constant('INV'))();
  TextColumn get themeMode => text().withDefault(const Constant('light'))();
  TextColumn get languageCode => text().withDefault(const Constant('ar'))();
  BooleanColumn get enableBiometric => boolean().withDefault(const Constant(false))();
  BooleanColumn get enableAutoBackup => boolean().withDefault(const Constant(false))();
  IntColumn get sessionTimeoutMinutes => integer().withDefault(const Constant(15))();
  TextColumn get logoPath => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get description => text().nullable()();
  DateTimeColumn get createdAt => dateTime().clientDefault(const Constant(null))();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
}

class Brands extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get description => text().nullable()();
  DateTimeColumn get createdAt => dateTime().clientDefault(const Constant(null))();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
}

class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 200)();
  TextColumn get sku => text().withLength(min: 1, max: 50)();
  TextColumn get barcode => text().withLength(min: 1, max: 100)();
  IntColumn get categoryId => integer().nullable().customIndex()();
  IntColumn get brandId => integer().nullable().customIndex()();
  TextColumn get model => text().withLength(min: 1, max: 100).nullable()();
  TextColumn get color => text().withLength(min: 1, max: 50).nullable()();
  TextColumn get storage => text().withLength(min: 1, max: 50).nullable()();
  TextColumn get ram => text().withLength(min: 1, max: 50).nullable()();
  RealColumn get purchasePrice => real().withDefault(const Constant(0))();
  RealColumn get sellingPrice => real().withDefault(const Constant(0))();
  RealColumn get costPrice => real().withDefault(const Constant(0))();
  IntColumn get quantity => integer().withDefault(const Constant(0))();
  IntColumn get minStock => integer().withDefault(const Constant(0))();
  TextColumn get notes => text().nullable()();
  BooleanColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().clientDefault(const Constant(null))();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  List<ForeignKey> get customConstraints => [
        customExpression('FOREIGN KEY (category_id) REFERENCES categories (id) ON DELETE SET NULL'),
        customExpression('FOREIGN KEY (brand_id) REFERENCES brands (id) ON DELETE SET NULL'),
      ];
}

class Phones extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 200)();
  TextColumn get sku => text().withLength(min: 1, max: 50)();
  TextColumn get serialNumber => text().withLength(min: 1, max: 100).unique()();
  IntColumn get categoryId => integer().nullable().customIndex()();
  IntColumn get brandId => integer().nullable().customIndex()();
  TextColumn get model => text().withLength(min: 1, max: 100).nullable()();
  TextColumn get color => text().withLength(min: 1, max: 50).nullable()();
  TextColumn get storage => text().withLength(min: 1, max: 50).nullable()();
  TextColumn get ram => text().withLength(min: 1, max: 50).nullable()();
  RealColumn get purchasePrice => real().withDefault(const Constant(0))();
  RealColumn get sellingPrice => real().withDefault(const Constant(0))();
  IntColumn get quantity => integer().withDefault(const Constant(0))();
  TextColumn get status => text().withDefault(const Constant('in_stock'))();
  IntColumn get customerId => integer().nullable()();
  DateTimeColumn get saleDate => dateTime().nullable()();
  TextColumn get warrantyInfo => text().nullable()();
  DateTimeColumn get createdAt => dateTime().clientDefault(const Constant(null))();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  TextColumn get notes => text().nullable()();

  @override
  List<ForeignKey> get customConstraints => [
        customExpression('FOREIGN KEY (category_id) REFERENCES categories (id) ON DELETE SET NULL'),
        customExpression('FOREIGN KEY (brand_id) REFERENCES brands (id) ON DELETE SET NULL'),
        customExpression('FOREIGN KEY (customer_id) REFERENCES customers (id) ON DELETE SET NULL'),
      ];
}

class Imeis extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get phoneId => integer().customIndex()();
  TextColumn get imei => text().withLength(min: 1, max: 20).unique()();
  BooleanColumn get active => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().clientDefault(const Constant(null))();
  DateTimeColumn get deactivatedAt => dateTime().nullable()();

  @override
  List<ForeignKey> get customConstraints => [
        customExpression('FOREIGN KEY (phone_id) REFERENCES phones (id) ON DELETE CASCADE'),
      ];
}

class Customers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get phone => text().withLength(min: 1, max: 30).withUnique()();
  TextColumn get address => text().nullable()();
  TextColumn get notes => text().nullable()();
  RealColumn get totalPurchases => real().withDefault(const Constant(0))();
  RealColumn get totalPaid => real().withDefault(const Constant(0))();
  RealColumn get remainingDebt => real().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().clientDefault(const Constant(null))();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
}

class Suppliers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get phone => text().withLength(min: 1, max: 30).withUnique()();
  TextColumn get address => text().nullable()();
  TextColumn get notes => text().nullable()();
  RealColumn get totalPurchases => real().withDefault(const Constant(0))();
  RealColumn get totalPaid => real().withDefault(const Constant(0))();
  RealColumn get remainingDebt => real().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().clientDefault(const Constant(null))();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
}

class Sales extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get invoiceNumber => text().unique()();
  IntColumn get customerId => integer().nullable().customIndex()();
  TextColumn get paymentMethod => text().withDefault(const Constant('cash'))();
  RealColumn get subtotal => real().withDefault(const Constant(0))();
  RealColumn get discount => real().withDefault(const Constant(0))();
  RealColumn get tax => real().withDefault(const Constant(0))();
  RealColumn get total => real().withDefault(const Constant(0))();
  RealColumn get paidAmount => real().withDefault(const Constant(0))();
  TextColumn get saleType => text().withDefault(const Constant('cash'))();
  TextColumn get status => text().withDefault(const Constant('completed'))();
  DateTimeColumn get saleDate => dateTime()();
  IntColumn get createdBy => integer().customIndex()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().clientDefault(const Constant(null))();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  List<ForeignKey> get customConstraints => [
        customExpression('FOREIGN KEY (customer_id) REFERENCES customers (id) ON DELETE SET NULL'),
        customExpression('FOREIGN KEY (created_by) REFERENCES users (id) ON DELETE CASCADE'),
      ];
}

class SaleItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get saleId => integer().customIndex()();
  IntColumn get productId => integer().nullable().customIndex()();
  IntColumn get phoneId => integer().nullable().customIndex()();
  TextColumn get serialNumber => text().withLength(min: 1, max: 100).nullable()();
  IntColumn get quantity => integer().withDefault(const Constant(1))();
  RealColumn get unitPrice => real().withDefault(const Constant(0))();
  RealColumn get purchasePrice => real().withDefault(const Constant(0))();
  RealColumn get discount => real().withDefault(const Constant(0))();
  RealColumn get total => real().withDefault(const Constant(0))();
  TextColumn get imei1 => text().nullable()();
  TextColumn get imei2 => text().nullable()();

  @override
  List<ForeignKey> get customConstraints => [
        customExpression('FOREIGN KEY (sale_id) REFERENCES sales (id) ON DELETE CASCADE'),
        customExpression('FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE SET NULL'),
        customExpression('FOREIGN KEY (phone_id) REFERENCES phones (id) ON DELETE SET NULL'),
      ];
}

class SalePayments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get saleId => integer().customIndex()();
  RealColumn get amount => real()();
  TextColumn get method => text().withDefault(const Constant('cash'))();
  DateTimeColumn get paidAt => dateTime().clientDefault(const Constant(null))();
  TextColumn get notes => text().nullable()();

  @override
  List<ForeignKey> get customConstraints => [
        customExpression('FOREIGN KEY (sale_id) REFERENCES sales (id) ON DELETE CASCADE'),
      ];
}

class Purchases extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get invoiceNumber => text().unique()();
  IntColumn get supplierId => integer().nullable().customIndex()();
  RealColumn get subtotal => real().withDefault(const Constant(0))();
  RealColumn get discount => real().withDefault(const Constant(0))();
  RealColumn get tax => real().withDefault(const Constant(0))();
  RealColumn get total => real().withDefault(const Constant(0))();
  RealColumn get paidAmount => real().withDefault(const Constant(0))();
  TextColumn get paymentMethod => text().withDefault(const Constant('cash'))();
  TextColumn get status => text().withDefault(const Constant('completed'))();
  DateTimeColumn get purchaseDate => dateTime()();
  IntColumn get createdBy => integer().customIndex()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().clientDefault(const Constant(null))();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  List<ForeignKey> get customConstraints => [
        customExpression('FOREIGN KEY (supplier_id) REFERENCES suppliers (id) ON DELETE SET NULL'),
        customExpression('FOREIGN KEY (created_by) REFERENCES users (id) ON DELETE CASCADE'),
      ];
}

class PurchaseItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get purchaseId => integer().customIndex()();
  IntColumn get productId => integer().nullable().customIndex()();
  IntColumn get phoneId => integer().nullable().customIndex()();
  TextColumn get serialNumber => text().withLength(min: 1, max: 100).nullable()();
  IntColumn get quantity => integer().withDefault(const Constant(1))();
  RealColumn get unitPrice => real().withDefault(const Constant(0))();
  RealColumn get total => real().withDefault(const Constant(0))();
  TextColumn get imei1 => text().nullable()();
  TextColumn get imei2 => text().nullable()();

  @override
  List<ForeignKey> get customConstraints => [
        customExpression('FOREIGN KEY (purchase_id) REFERENCES purchases (id) ON DELETE CASCADE'),
        customExpression('FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE SET NULL'),
        customExpression('FOREIGN KEY (phone_id) REFERENCES phones (id) ON DELETE SET NULL'),
      ];
}

class PurchasePayments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get purchaseId => integer().customIndex()();
  RealColumn get amount => real()();
  TextColumn get method => text().withDefault(const Constant('cash'))();
  DateTimeColumn get paidAt => dateTime().clientDefault(const Constant(null))();
  TextColumn get notes => text().nullable()();

  @override
  List<ForeignKey> get customConstraints => [
        customExpression('FOREIGN KEY (purchase_id) REFERENCES purchases (id) ON DELETE CASCADE'),
      ];
}

class Returns extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get returnNumber => text().unique()();
  IntColumn get saleId => integer().customIndex()();
  TextColumn get returnType => text()();
  RealColumn get total => real().withDefault(const Constant(0))();
  TextColumn get reason => text().nullable()();
  IntColumn get createdBy => integer().customIndex()();
  DateTimeColumn get returnDate => dateTime()();
  DateTimeColumn get createdAt => dateTime().clientDefault(const Constant(null))();

  @override
  List<ForeignKey> get customConstraints => [
        customExpression('FOREIGN KEY (sale_id) REFERENCES sales (id) ON DELETE CASCADE'),
        customExpression('FOREIGN KEY (created_by) REFERENCES users (id) ON DELETE CASCADE'),
      ];
}

class ReturnItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get returnId => integer().customIndex()();
  IntColumn get productId => integer().nullable().customIndex()();
  IntColumn get phoneId => integer().nullable().customIndex()();
  IntColumn get quantity => integer().withDefault(const Constant(1))();
  RealColumn get unitPrice => real().withDefault(const Constant(0))();
  RealColumn get total => real().withDefault(const Constant(0))();
  TextColumn get reason => text().nullable()();

  @override
  List<ForeignKey> get customConstraints => [
        customExpression('FOREIGN KEY (return_id) REFERENCES returns (id) ON DELETE CASCADE'),
        customExpression('FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE SET NULL'),
        customExpression('FOREIGN KEY (phone_id) REFERENCES phones (id) ON DELETE SET NULL'),
      ];
}

class InventoryMovements extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get productId => integer().nullable().customIndex()();
  IntColumn get phoneId => integer().nullable().customIndex()();
  TextColumn get movementType => text()();
  IntColumn get quantity => integer()();
  IntColumn get previousQuantity => integer()();
  IntColumn get newQuantity => integer()();
  RealColumn get unitPrice => real().withDefault(const Constant(0))();
  TextColumn get referenceType => text().nullable()();
  IntColumn get referenceId => integer().nullable()();
  IntColumn get userId => integer().customIndex()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().clientDefault(const Constant(null))();

  @override
  List<ForeignKey> get customConstraints => [
        customExpression('FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE SET NULL'),
        customExpression('FOREIGN KEY (phone_id) REFERENCES phones (id) ON DELETE SET NULL'),
        customExpression('FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE'),
      ];
}

class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get category => text()();
  TextColumn get description => text().withLength(min: 1, max: 200)();
  RealColumn get amount => real()();
  TextColumn get paymentMethod => text().withDefault(const Constant('cash'))();
  DateTimeColumn get expenseDate => dateTime()();
  IntColumn get createdBy => integer().customIndex()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().clientDefault(const Constant(null))();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  List<ForeignKey> get customConstraints => [
        customExpression('FOREIGN KEY (created_by) REFERENCES users (id) ON DELETE CASCADE'),
      ];
}

class CashTransactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get transactionType => text()();
  RealColumn get amount => real()();
  RealColumn get balanceAfter => real()();
  TextColumn get description => text().withLength(min: 1, max: 200)();
  IntColumn get referenceId => integer().nullable()();
  TextColumn get referenceType => text().nullable()();
  IntColumn get userId => integer().customIndex()();
  DateTimeColumn get transactionDate => dateTime()();
  DateTimeColumn get createdAt => dateTime().clientDefault(const Constant(null))();

  @override
  List<ForeignKey> get customConstraints => [
        customExpression('FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE'),
      ];
}

class Repairs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get ticketNumber => text().unique()();
  IntColumn get customerId => integer().customIndex()();
  IntColumn get phoneId => integer().nullable().customIndex()();
  TextColumn get imei => text().nullable()();
  TextColumn get serialNumber => text().nullable()();
  TextColumn get problem => text().withLength(min: 1, max: 500)();
  TextColumn get deviceCondition => text().withLength(min: 1, max: 500)();
  TextColumn get accessoriesReceived => text().nullable()();
  RealColumn get estimatedCost => real().withDefault(const Constant(0))();
  RealColumn get actualCost => real().withDefault(const Constant(0))();
  RealColumn get deposit => real().withDefault(const Constant(0))();
  RealColumn get remainingAmount => real().withDefault(const Constant(0))();
  TextColumn get technician => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('received'))();
  DateTimeColumn get receivedDate => dateTime().clientDefault(const Constant(null))();
  DateTimeColumn get readyDate => dateTime().nullable()();
  DateTimeColumn get deliveredDate => dateTime().nullable()();
  IntColumn get createdBy => integer().customIndex()();
  DateTimeColumn get createdAt => dateTime().clientDefault(const Constant(null))();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  List<ForeignKey> get customConstraints => [
        customExpression('FOREIGN KEY (customer_id) REFERENCES customers (id) ON DELETE CASCADE'),
        customExpression('FOREIGN KEY (phone_id) REFERENCES phones (id) ON DELETE SET NULL'),
        customExpression('FOREIGN KEY (created_by) REFERENCES users (id) ON DELETE CASCADE'),
      ];
}

class RepairPhotos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get repairId => integer().customIndex()();
  TextColumn get photoPath => text()();
  DateTimeColumn get createdAt => dateTime().clientDefault(const Constant(null))();

  @override
  List<ForeignKey> get customConstraints => [
        customExpression('FOREIGN KEY (repair_id) REFERENCES repairs (id) ON DELETE CASCADE'),
      ];
}

class AuditLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().customIndex()();
  TextColumn get userName => text()();
  TextColumn get action => text()();
  TextColumn get entityType => text()();
  IntColumn get entityId => integer().nullable()();
  TextColumn get oldValue => text().nullable()();
  TextColumn get newValue => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get ipAddress => text().withDefault(const Constant('local'))();
  DateTimeColumn get timestamp => dateTime().clientDefault(const Constant(null))();

  @override
  Set<Column> get primaryKey => {id};
}

// lib/core/database/tables.dart
/// Drift table definitions for Phone Store Manager.
///
/// Each table class defines columns, foreign keys, indexes,
/// and unique constraints. This file is imported by database.dart.
library;

import 'package:drift/drift.dart';

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get username => text().withLength(min: 3, max: 50)();
  TextColumn get passwordHash => text()();
  TextColumn get passwordSalt => text().nullable()();
  TextColumn get role => text().withDefault(const Constant('employee'))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  DateTimeColumn get lastLoginAt => dateTime().nullable()();
}

class Settings extends Table {
  IntColumn get id => integer()();
  TextColumn get storeName => text().withDefault(const Constant('Phone Store Manager'))();
  TextColumn get storePhone => text().nullable()();
  TextColumn get storeAddress => text().nullable()();
  TextColumn get currencySymbol => text().withDefault(const Constant('ر.س'))();
  TextColumn get currencyCode => text().withDefault(const Constant('SAR'))();
  BoolColumn get enableInvoiceNumber => boolean().withDefault(const Constant(true))();
  TextColumn get invoicePrefix => text().withDefault(const Constant('INV'))();
  TextColumn get themeMode => text().withDefault(const Constant('light'))();
  TextColumn get languageCode => text().withDefault(const Constant('ar'))();
  BoolColumn get enableBiometric => boolean().withDefault(const Constant(false))();
  BoolColumn get enableAutoBackup => boolean().withDefault(const Constant(false))();
  IntColumn get sessionTimeoutMinutes => integer().withDefault(const Constant(15))();
  TextColumn get logoPath => text().nullable()();
}

class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get description => text().nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
}

class Brands extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get description => text().nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
}

class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 200)();
  TextColumn get sku => text().withLength(min: 1, max: 50)();
  TextColumn get barcode => text().withLength(min: 1, max: 100)();
  IntColumn get categoryId => integer().nullable()();
  IntColumn get brandId => integer().nullable()();
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
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

@override
  List<String> get customConstraints => [
    'FOREIGN KEY (category_id) REFERENCES categories (id) ON DELETE SET NULL',
    'FOREIGN KEY (brand_id) REFERENCES brands (id) ON DELETE SET NULL',
  ];

  List<Index> get indexes => [
    Index('products_category_idx', 'CREATE INDEX products_category_idx ON products (category_id)'),
    Index('products_brand_idx', 'CREATE INDEX products_brand_idx ON products (brand_id)'),
  ];
}

class Phones extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 200)();
  TextColumn get sku => text().withLength(min: 1, max: 50)();
  TextColumn get serialNumber => text().withLength(min: 1, max: 100).unique()();
  IntColumn get categoryId => integer().nullable()();
  IntColumn get brandId => integer().nullable()();
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
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  TextColumn get notes => text().nullable()();

@override
  List<String> get customConstraints => [
    'FOREIGN KEY (category_id) REFERENCES categories (id) ON DELETE SET NULL',
    'FOREIGN KEY (brand_id) REFERENCES brands (id) ON DELETE SET NULL',
    'FOREIGN KEY (customer_id) REFERENCES customers (id) ON DELETE SET NULL',
  ];

  List<Index> get indexes => [
    Index('phones_category_idx', 'CREATE INDEX phones_category_idx ON phones (category_id)'),
    Index('phones_brand_idx', 'CREATE INDEX phones_brand_idx ON phones (brand_id)'),
    Index('phones_customer_idx', 'CREATE INDEX phones_customer_idx ON phones (customer_id)'),
  ];
}

class Imeis extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get phoneId => integer()();
  TextColumn get imei => text().withLength(min: 1, max: 20).unique()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get deactivatedAt => dateTime().nullable()();

@override
  List<String> get customConstraints => [
    'FOREIGN KEY (phone_id) REFERENCES phones (id) ON DELETE CASCADE',
  ];

  List<Index> get indexes => [
    Index('imeis_phone_idx', 'CREATE INDEX imeis_phone_idx ON imeis (phone_id)'),
  ];
}

class Customers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get phone => text().withLength(min: 1, max: 30).customConstraint('UNIQUE')();
  TextColumn get address => text().nullable()();
  TextColumn get notes => text().nullable()();
  RealColumn get totalPurchases => real().withDefault(const Constant(0))();
  RealColumn get totalPaid => real().withDefault(const Constant(0))();
  RealColumn get remainingDebt => real().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
}

class Suppliers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get phone => text().withLength(min: 1, max: 30).customConstraint('UNIQUE')();
  TextColumn get address => text().nullable()();
  TextColumn get notes => text().nullable()();
  RealColumn get totalPurchases => real().withDefault(const Constant(0))();
  RealColumn get totalPaid => real().withDefault(const Constant(0))();
  RealColumn get remainingDebt => real().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
}

class Sales extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get invoiceNumber => text().unique()();
  IntColumn get customerId => integer().nullable()();
  TextColumn get paymentMethod => text().withDefault(const Constant('cash'))();
  RealColumn get subtotal => real().withDefault(const Constant(0))();
  RealColumn get discount => real().withDefault(const Constant(0))();
  RealColumn get tax => real().withDefault(const Constant(0))();
  RealColumn get total => real().withDefault(const Constant(0))();
  RealColumn get paidAmount => real().withDefault(const Constant(0))();
  TextColumn get saleType => text().withDefault(const Constant('cash'))();
  TextColumn get status => text().withDefault(const Constant('completed'))();
  DateTimeColumn get saleDate => dateTime()();
  IntColumn get createdBy => integer()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

@override
  List<String> get customConstraints => [
    'FOREIGN KEY (customer_id) REFERENCES customers (id) ON DELETE SET NULL',
    'FOREIGN KEY (created_by) REFERENCES users (id) ON DELETE CASCADE',
  ];

  List<Index> get indexes => [
    Index('sales_customer_idx', 'CREATE INDEX sales_customer_idx ON sales (customer_id)'),
    Index('sales_created_by_idx', 'CREATE INDEX sales_created_by_idx ON sales (created_by)'),
    Index('sales_date_idx', 'CREATE INDEX sales_date_idx ON sales (sale_date)'),
  ];
}

class SaleItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get saleId => integer()();
  IntColumn get productId => integer().nullable()();
  IntColumn get phoneId => integer().nullable()();
  TextColumn get serialNumber => text().withLength(min: 1, max: 100).nullable()();
  IntColumn get quantity => integer().withDefault(const Constant(1))();
  RealColumn get unitPrice => real().withDefault(const Constant(0))();
  RealColumn get purchasePrice => real().withDefault(const Constant(0))();
  RealColumn get discount => real().withDefault(const Constant(0))();
  RealColumn get total => real().withDefault(const Constant(0))();
  TextColumn get imei1 => text().nullable()();
  TextColumn get imei2 => text().nullable()();

@override
  List<String> get customConstraints => [
    'FOREIGN KEY (sale_id) REFERENCES sales (id) ON DELETE CASCADE',
    'FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE SET NULL',
    'FOREIGN KEY (phone_id) REFERENCES phones (id) ON DELETE SET NULL',
  ];

  List<Index> get indexes => [
    Index('sale_items_sale_idx', 'CREATE INDEX sale_items_sale_idx ON sale_items (sale_id)'),
    Index('sale_items_product_idx', 'CREATE INDEX sale_items_product_idx ON sale_items (product_id)'),
    Index('sale_items_phone_idx', 'CREATE INDEX sale_items_phone_idx ON sale_items (phone_id)'),
  ];
}

class SalePayments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get saleId => integer()();
  RealColumn get amount => real()();
  TextColumn get method => text().withDefault(const Constant('cash'))();
  DateTimeColumn get paidAt => dateTime().nullable()();
  TextColumn get notes => text().nullable()();

@override
  List<String> get customConstraints => [
    'FOREIGN KEY (sale_id) REFERENCES sales (id) ON DELETE CASCADE',
  ];

  List<Index> get indexes => [
    Index('sale_payments_sale_idx', 'CREATE INDEX sale_payments_sale_idx ON sale_payments (sale_id)'),
  ];
}

class Purchases extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get invoiceNumber => text().unique()();
  IntColumn get supplierId => integer().nullable()();
  RealColumn get subtotal => real().withDefault(const Constant(0))();
  RealColumn get discount => real().withDefault(const Constant(0))();
  RealColumn get tax => real().withDefault(const Constant(0))();
  RealColumn get total => real().withDefault(const Constant(0))();
  RealColumn get paidAmount => real().withDefault(const Constant(0))();
  TextColumn get paymentMethod => text().withDefault(const Constant('cash'))();
  TextColumn get status => text().withDefault(const Constant('completed'))();
  DateTimeColumn get purchaseDate => dateTime()();
  IntColumn get createdBy => integer()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

@override
  List<String> get customConstraints => [
    'FOREIGN KEY (supplier_id) REFERENCES suppliers (id) ON DELETE SET NULL',
    'FOREIGN KEY (created_by) REFERENCES users (id) ON DELETE CASCADE',
  ];

  List<Index> get indexes => [
    Index('purchases_supplier_idx', 'CREATE INDEX purchases_supplier_idx ON purchases (supplier_id)'),
    Index('purchases_created_by_idx', 'CREATE INDEX purchases_created_by_idx ON purchases (created_by)'),
    Index('purchases_date_idx', 'CREATE INDEX purchases_date_idx ON purchases (purchase_date)'),
  ];
}

class PurchaseItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get purchaseId => integer()();
  IntColumn get productId => integer().nullable()();
  IntColumn get phoneId => integer().nullable()();
  TextColumn get serialNumber => text().withLength(min: 1, max: 100).nullable()();
  IntColumn get quantity => integer().withDefault(const Constant(1))();
  RealColumn get unitPrice => real().withDefault(const Constant(0))();
  RealColumn get total => real().withDefault(const Constant(0))();
  TextColumn get imei1 => text().nullable()();
  TextColumn get imei2 => text().nullable()();

@override
  List<String> get customConstraints => [
    'FOREIGN KEY (purchase_id) REFERENCES purchases (id) ON DELETE CASCADE',
    'FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE SET NULL',
    'FOREIGN KEY (phone_id) REFERENCES phones (id) ON DELETE SET NULL',
  ];

  List<Index> get indexes => [
    Index('purchase_items_purchase_idx', 'CREATE INDEX purchase_items_purchase_idx ON purchase_items (purchase_id)'),
    Index('purchase_items_product_idx', 'CREATE INDEX purchase_items_product_idx ON purchase_items (product_id)'),
    Index('purchase_items_phone_idx', 'CREATE INDEX purchase_items_phone_idx ON purchase_items (phone_id)'),
  ];
}

class PurchasePayments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get purchaseId => integer()();
  RealColumn get amount => real()();
  TextColumn get method => text().withDefault(const Constant('cash'))();
  DateTimeColumn get paidAt => dateTime().nullable()();
  TextColumn get notes => text().nullable()();

@override
  List<String> get customConstraints => [
    'FOREIGN KEY (purchase_id) REFERENCES purchases (id) ON DELETE CASCADE',
  ];

  List<Index> get indexes => [
    Index('purchase_payments_purchase_idx', 'CREATE INDEX purchase_payments_purchase_idx ON purchase_payments (purchase_id)'),
  ];
}

class Returns extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get returnNumber => text().unique()();
  IntColumn get saleId => integer()();
  TextColumn get returnType => text()();
  RealColumn get total => real().withDefault(const Constant(0))();
  TextColumn get reason => text().nullable()();
  IntColumn get createdBy => integer()();
  DateTimeColumn get returnDate => dateTime()();
  DateTimeColumn get createdAt => dateTime().nullable()();

@override
  List<String> get customConstraints => [
    'FOREIGN KEY (sale_id) REFERENCES sales (id) ON DELETE CASCADE',
    'FOREIGN KEY (created_by) REFERENCES users (id) ON DELETE CASCADE',
  ];

  List<Index> get indexes => [
    Index('returns_sale_idx', 'CREATE INDEX returns_sale_idx ON returns (sale_id)'),
  ];
}

class ReturnItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get returnId => integer()();
  IntColumn get productId => integer().nullable()();
  IntColumn get phoneId => integer().nullable()();
  IntColumn get quantity => integer().withDefault(const Constant(1))();
  RealColumn get unitPrice => real().withDefault(const Constant(0))();
  RealColumn get total => real().withDefault(const Constant(0))();
  TextColumn get reason => text().nullable()();

@override
  List<String> get customConstraints => [
    'FOREIGN KEY (return_id) REFERENCES returns (id) ON DELETE CASCADE',
    'FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE SET NULL',
    'FOREIGN KEY (phone_id) REFERENCES phones (id) ON DELETE SET NULL',
  ];

  List<Index> get indexes => [
    Index('return_items_return_idx', 'CREATE INDEX return_items_return_idx ON return_items (return_id)'),
  ];
}

class InventoryMovements extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get productId => integer().nullable()();
  IntColumn get phoneId => integer().nullable()();
  TextColumn get movementType => text()();
  IntColumn get quantity => integer()();
  IntColumn get previousQuantity => integer()();
  IntColumn get newQuantity => integer()();
  RealColumn get unitPrice => real().withDefault(const Constant(0))();
  TextColumn get referenceType => text().nullable()();
  IntColumn get referenceId => integer().nullable()();
  IntColumn get userId => integer()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();

@override
  List<String> get customConstraints => [
    'FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE SET NULL',
    'FOREIGN KEY (phone_id) REFERENCES phones (id) ON DELETE SET NULL',
    'FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE',
  ];

  List<Index> get indexes => [
    Index('inventory_product_idx', 'CREATE INDEX inventory_product_idx ON inventory_movements (product_id)'),
    Index('inventory_phone_idx', 'CREATE INDEX inventory_phone_idx ON inventory_movements (phone_id)'),
    Index('inventory_user_idx', 'CREATE INDEX inventory_user_idx ON inventory_movements (user_id)'),
    Index('inventory_date_idx', 'CREATE INDEX inventory_date_idx ON inventory_movements (created_at)'),
  ];
}

class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get category => text()();
  TextColumn get description => text().withLength(min: 1, max: 200)();
  RealColumn get amount => real()();
  TextColumn get paymentMethod => text().withDefault(const Constant('cash'))();
  DateTimeColumn get expenseDate => dateTime()();
  IntColumn get createdBy => integer()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

@override
  List<String> get customConstraints => [
    'FOREIGN KEY (created_by) REFERENCES users (id) ON DELETE CASCADE',
  ];

  List<Index> get indexes => [
    Index('expenses_created_by_idx', 'CREATE INDEX expenses_created_by_idx ON expenses (created_by)'),
    Index('expenses_date_idx', 'CREATE INDEX expenses_date_idx ON expenses (expense_date)'),
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
  IntColumn get userId => integer()();
  DateTimeColumn get transactionDate => dateTime()();
  DateTimeColumn get createdAt => dateTime().nullable()();

@override
  List<String> get customConstraints => [
    'FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE',
  ];

  List<Index> get indexes => [
    Index('cash_user_idx', 'CREATE INDEX cash_user_idx ON cash_transactions (user_id)'),
    Index('cash_date_idx', 'CREATE INDEX cash_date_idx ON cash_transactions (transaction_date)'),
  ];
}

class Repairs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get ticketNumber => text().unique()();
  IntColumn get customerId => integer()();
  IntColumn get phoneId => integer().nullable()();
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
  DateTimeColumn get receivedDate => dateTime().nullable()();
  DateTimeColumn get readyDate => dateTime().nullable()();
  DateTimeColumn get deliveredDate => dateTime().nullable()();
  IntColumn get createdBy => integer()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

@override
  List<String> get customConstraints => [
    'FOREIGN KEY (customer_id) REFERENCES customers (id) ON DELETE CASCADE',
    'FOREIGN KEY (phone_id) REFERENCES phones (id) ON DELETE SET NULL',
    'FOREIGN KEY (created_by) REFERENCES users (id) ON DELETE CASCADE',
  ];

  List<Index> get indexes => [
    Index('repairs_customer_idx', 'CREATE INDEX repairs_customer_idx ON repairs (customer_id)'),
    Index('repairs_status_idx', 'CREATE INDEX repairs_status_idx ON repairs (status)'),
    Index('repairs_created_by_idx', 'CREATE INDEX repairs_created_by_idx ON repairs (created_by)'),
  ];
}

class RepairPhotos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get repairId => integer()();
  TextColumn get photoPath => text()();
  DateTimeColumn get createdAt => dateTime().nullable()();

@override
  List<String> get customConstraints => [
    'FOREIGN KEY (repair_id) REFERENCES repairs (id) ON DELETE CASCADE',
  ];

  List<Index> get indexes => [
    Index('repair_photos_repair_idx', 'CREATE INDEX repair_photos_repair_idx ON repair_photos (repair_id)'),
  ];
}

class AuditLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  TextColumn get userName => text()();
  TextColumn get action => text()();
  TextColumn get entityType => text()();
  IntColumn get entityId => integer().nullable()();
  TextColumn get oldValue => text().nullable()();
  TextColumn get newValue => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get ipAddress => text().withDefault(const Constant('local'))();
  DateTimeColumn get timestamp => dateTime().nullable()();

  List<Index> get indexes => [
    Index('audit_user_idx', 'CREATE INDEX audit_user_idx ON audit_logs (user_id)'),
    Index('audit_action_idx', 'CREATE INDEX audit_action_idx ON audit_logs (action)'),
    Index('audit_timestamp_idx', 'CREATE INDEX audit_timestamp_idx ON audit_logs (timestamp)'),
  ];
}

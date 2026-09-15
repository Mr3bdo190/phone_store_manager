// lib/features/customers/data/datasources/customer_local_datasource.dart
/// Data source for customers — reads/writes to local Drift database.
library;

import 'package:drift/drift.dart';

import '../../../../core/database/database.dart' as db;
import '../../domain/entities/customer.dart';

abstract class CustomerLocalDataSource {
  Future<List<Customer>> getAllCustomers();
  Future<List<Customer>> searchCustomers(String query);
  Future<int> createCustomer({required String name, required String phone, String? address, String? notes});
  Future<bool> updateCustomer(Customer customer);
  Future<bool> deleteCustomer(int id);
}

class CustomerLocalDataSourceImpl implements CustomerLocalDataSource {
  final db.AppDatabase database;

  CustomerLocalDataSourceImpl(this.database);

  Customer _fromRow(db.Customer row) => Customer(
        id: row.id,
        name: row.name,
        phone: row.phone,
        address: row.address,
        notes: row.notes,
        totalPurchases: row.totalPurchases,
        totalPaid: row.totalPaid,
        remainingDebt: row.remainingDebt,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
        deletedAt: row.deletedAt,
      );

  @override
  Future<List<Customer>> getAllCustomers() async {
    final rows = await database.getAllCustomers();
    return rows.map(_fromRow).toList();
  }

  @override
  Future<List<Customer>> searchCustomers(String query) async {
    final rows = await database.searchCustomers(query);
    return rows.map(_fromRow).toList();
  }

  @override
  Future<int> createCustomer({required String name, required String phone, String? address, String? notes}) {
    return database.createCustomer(db.CustomersCompanion.insert(
      name: name,
      phone: phone,
      address: Value(address),
      notes: Value(notes),
      createdAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    ));
  }

  @override
  Future<bool> updateCustomer(Customer customer) async {
    if (customer.id == null) return false;
    return database.updateCustomer(db.CustomersCompanion(
      id: Value(customer.id!),
      name: Value(customer.name),
      phone: Value(customer.phone),
      address: Value(customer.address),
      notes: Value(customer.notes),
      totalPurchases: Value(customer.totalPurchases),
      totalPaid: Value(customer.totalPaid),
      remainingDebt: Value(customer.remainingDebt),
      updatedAt: Value(DateTime.now()),
    ));
  }

  @override
  Future<bool> deleteCustomer(int id) async {
    final result = await (database.update(database.customers)..where((c) => c.id.equals(id))).write(
      db.CustomersCompanion(deletedAt: Value(DateTime.now())),
    );
    return result > 0;
  }
}

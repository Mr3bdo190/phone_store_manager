// lib/features/customers/data/repositories/customer_repository_impl.dart
/// Repository implementation for customers.
library;

import '../../../../core/errors/failures.dart';
import '../../domain/entities/customer.dart';
import '../../domain/repositories/customer_repository.dart';
import '../datasources/customer_local_datasource.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final CustomerLocalDataSource localDataSource;

  CustomerRepositoryImpl(this.localDataSource);

  @override
  Future<List<Customer>> getAllCustomers() {
    return localDataSource.getAllCustomers();
  }

  @override
  Future<List<Customer>> searchCustomers(String query) {
    return localDataSource.searchCustomers(query);
  }

  @override
  Future<({int? data, Failure? failure})> createCustomer({
    required String name,
    required String phone,
    String? address,
    String? notes,
  }) async {
    try {
      if (name.trim().isEmpty) {
        return (
          data: null,
          failure: const ValidationFailure('اسم العميل مطلوب')
        );
      }
      if (phone.trim().isEmpty) {
        return (
          data: null,
          failure: const ValidationFailure('رقم هاتف العميل مطلوب')
        );
      }
      final id = await localDataSource.createCustomer(
          name: name, phone: phone, address: address, notes: notes);
      return (data: id, failure: null);
    } catch (e) {
      return (data: null, failure: DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<({bool data, Failure? failure})> updateCustomer(
      Customer customer) async {
    try {
      if (customer.name.trim().isEmpty) {
        return (
          data: false,
          failure: const ValidationFailure('اسم العميل مطلوب')
        );
      }
      if (customer.phone.trim().isEmpty) {
        return (
          data: false,
          failure: const ValidationFailure('رقم هاتف العميل مطلوب')
        );
      }
      final success = await localDataSource.updateCustomer(customer);
      return (data: success, failure: null);
    } catch (e) {
      return (data: false, failure: DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<({bool data, Failure? failure})> deleteCustomer(int id) async {
    try {
      final success = await localDataSource.deleteCustomer(id);
      return (data: success, failure: null);
    } catch (e) {
      return (data: false, failure: DatabaseFailure(e.toString()));
    }
  }
}

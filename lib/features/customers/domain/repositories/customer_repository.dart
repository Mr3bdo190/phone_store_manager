// lib/features/customers/domain/repositories/customer_repository.dart
/// Abstract repository contract for customer operations.
library;

import '../../../../core/errors/failures.dart';
import '../entities/customer.dart';

typedef CustomerResult<T> = ({T? data, Failure? failure})?;

abstract class CustomerRepository {
  Future<List<Customer>> getAllCustomers();
  Future<List<Customer>> searchCustomers(String query);
  Future<({int? data, Failure? failure})> createCustomer({
    required String name,
    required String phone,
    String? address,
    String? notes,
  });
  Future<({bool data, Failure? failure})> updateCustomer(Customer customer);
  Future<({bool data, Failure? failure})> deleteCustomer(int id);
}

// lib/features/customers/domain/entities/customer.dart
/// Customer entity.
library;

class Customer {
  final int? id;
  final String name;
  final String phone;
  final String? address;
  final String? notes;
  final double totalPurchases;
  final double totalPaid;
  final double remainingDebt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  Customer({
    this.id,
    required this.name,
    required this.phone,
    this.address,
    this.notes,
    this.totalPurchases = 0,
    this.totalPaid = 0,
    this.remainingDebt = 0,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  Customer copyWith({
    int? id,
    String? name,
    String? phone,
    String? address,
    String? notes,
    double? totalPurchases,
    double? totalPaid,
    double? remainingDebt,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      totalPurchases: totalPurchases ?? this.totalPurchases,
      totalPaid: totalPaid ?? this.totalPaid,
      remainingDebt: remainingDebt ?? this.remainingDebt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}

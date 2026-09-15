// lib/features/phones/domain/entities/phone.dart
/// Phone / device entity.
library;

class Phone {
  final int? id;
  final String name;
  final String sku;
  final String serialNumber;
  final int? categoryId;
  final int? brandId;
  final String? model;
  final String? color;
  final String? storage;
  final String? ram;
  final double purchasePrice;
  final double sellingPrice;
  final int quantity;
  final String status;
  final int? customerId;
  final DateTime? saleDate;
  final String? warrantyInfo;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final String? notes;

  Phone({
    this.id,
    required this.name,
    required this.sku,
    required this.serialNumber,
    this.categoryId,
    this.brandId,
    this.model,
    this.color,
    this.storage,
    this.ram,
    this.purchasePrice = 0,
    this.sellingPrice = 0,
    this.quantity = 0,
    this.status = 'in_stock',
    this.customerId,
    this.saleDate,
    this.warrantyInfo,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.notes,
  });

  Phone copyWith({
    int? id,
    String? name,
    String? sku,
    String? serialNumber,
    int? categoryId,
    int? brandId,
    String? model,
    String? color,
    String? storage,
    String? ram,
    double? purchasePrice,
    double? sellingPrice,
    int? quantity,
    String? status,
    int? customerId,
    DateTime? saleDate,
    String? warrantyInfo,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    String? notes,
  }) {
    return Phone(
      id: id ?? this.id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      serialNumber: serialNumber ?? this.serialNumber,
      categoryId: categoryId ?? this.categoryId,
      brandId: brandId ?? this.brandId,
      model: model ?? this.model,
      color: color ?? this.color,
      storage: storage ?? this.storage,
      ram: ram ?? this.ram,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      quantity: quantity ?? this.quantity,
      status: status ?? this.status,
      customerId: customerId ?? this.customerId,
      saleDate: saleDate ?? this.saleDate,
      warrantyInfo: warrantyInfo ?? this.warrantyInfo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      notes: notes ?? this.notes,
    );
  }

  bool get isSold => status == 'sold';
  bool get isInStock => status == 'in_stock';
}

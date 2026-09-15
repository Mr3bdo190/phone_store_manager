// lib/features/products/domain/entities/product.dart
/// Product entity — represents a sellable item in the store.
library;

class Product {
  final int? id;
  final String name;
  final String sku;
  final String barcode;
  final int? categoryId;
  final int? brandId;
  final String? model;
  final String? color;
  final String? storage;
  final String? ram;
  final double purchasePrice;
  final double sellingPrice;
  final double costPrice;
  final int quantity;
  final int minStock;
  final String? notes;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  Product({
    this.id,
    required this.name,
    required this.sku,
    required this.barcode,
    this.categoryId,
    this.brandId,
    this.model,
    this.color,
    this.storage,
    this.ram,
    this.purchasePrice = 0,
    this.sellingPrice = 0,
    this.costPrice = 0,
    this.quantity = 0,
    this.minStock = 0,
    this.notes,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  Product copyWith({
    int? id,
    String? name,
    String? sku,
    String? barcode,
    int? categoryId,
    int? brandId,
    String? model,
    String? color,
    String? storage,
    String? ram,
    double? purchasePrice,
    double? sellingPrice,
    double? costPrice,
    int? quantity,
    int? minStock,
    String? notes,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      categoryId: categoryId ?? this.categoryId,
      brandId: brandId ?? this.brandId,
      model: model ?? this.model,
      color: color ?? this.color,
      storage: storage ?? this.storage,
      ram: ram ?? this.ram,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      costPrice: costPrice ?? this.costPrice,
      quantity: quantity ?? this.quantity,
      minStock: minStock ?? this.minStock,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  bool get isLowStock => quantity <= minStock;
  bool get isOutOfStock => quantity == 0;
  double get profitPerUnit => sellingPrice - costPrice;
  double get totalValue => sellingPrice * quantity;
}

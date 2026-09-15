// lib/features/pos/domain/entities/cart_item.dart
/// Cart item for POS — represents a line item in the sale cart.
library;

class CartItem {
  final int? productId;
  final int? phoneId;
  final String productName;
  final String sku;
  final int quantity;
  final double unitPrice;
  final double purchasePrice;
  final double discount;
  final String? imei1;
  final String? imei2;

  CartItem({
    this.productId,
    this.phoneId,
    required this.productName,
    required this.sku,
    required this.quantity,
    required this.unitPrice,
    this.purchasePrice = 0,
    this.discount = 0,
    this.imei1,
    this.imei2,
  });

  double get totalPrice => (unitPrice - discount) * quantity;
  double get profit => (unitPrice - purchasePrice - discount) * quantity;

  CartItem copyWith({
    int? productId,
    int? phoneId,
    String? productName,
    String? sku,
    int? quantity,
    double? unitPrice,
    double? purchasePrice,
    double? discount,
    String? imei1,
    String? imei2,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      phoneId: phoneId ?? this.phoneId,
      productName: productName ?? this.productName,
      sku: sku ?? this.sku,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      discount: discount ?? this.discount,
      imei1: imei1 ?? this.imei1,
      imei2: imei2 ?? this.imei2,
    );
  }
}

// lib/features/pos/domain/entities/sale.dart
/// Sale entity — represents a completed sale transaction.
library;

class SaleSummary {
  final int id;
  final String invoiceNumber;
  final int? customerId;
  final String customerName;
  final String paymentMethod;
  final double subtotal;
  final double discount;
  final double tax;
  final double total;
  final double paidAmount;
  final String saleType;
  final String status;
  final DateTime saleDate;

  SaleSummary({
    required this.id,
    required this.invoiceNumber,
    this.customerId,
    required this.customerName,
    required this.paymentMethod,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.total,
    required this.paidAmount,
    required this.saleType,
    required this.status,
    required this.saleDate,
  });
}

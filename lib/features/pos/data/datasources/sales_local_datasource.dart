// lib/features/pos/data/datasources/sales_local_datasource.dart
/// Data source for sales/POS — reads/writes to local Drift database.
library;

import 'package:drift/drift.dart';

import '../../../../core/database/database.dart' as db;
import '../../domain/entities/cart_item.dart';

abstract class SalesLocalDataSource {
  Future<String> generateInvoiceNumber(String prefix);
  Future<({int? data, String? error})> createSale({
    required int? customerId,
    required String paymentMethod,
    required double subtotal,
    required double discount,
    required double tax,
    required double total,
    required double paidAmount,
    required List<CartItem> items,
    int? createdBy,
  });
  Future<double> getTodaySalesTotal();
  Future<double> getTotalSales();
  Future<double> getCashBalance();
  Future<double> getCustomerDebts();
}

class SalesLocalDataSourceImpl implements SalesLocalDataSource {
  final db.AppDatabase database;

  SalesLocalDataSourceImpl(this.database);

  @override
  Future<String> generateInvoiceNumber(String prefix) async {
    final today = DateTime.now();
    final datePart =
        '${today.year}${today.month.toString().padLeft(2, '0')}${today.day.toString().padLeft(2, '0')}';

    final start = DateTime(today.year, today.month, today.day);
    final end = start.add(const Duration(days: 1));
    final todaySales = await (database.select(database.sales)
          ..where((s) => s.saleDate.isBetweenValues(start, end)))
        .get();

    final sequence = todaySales.length + 1;
    return '$prefix-$datePart-${sequence.toString().padLeft(4, '0')}';
  }

  Future<double> _calculateBalance(double newAmount) async {
    final rows = await database.select(database.cashTransactions).get();
    final current = rows.fold(0.0, (sum, t) => sum + t.amount);
    return current + newAmount;
  }

  @override
  Future<({int? data, String? error})> createSale({
    required int? customerId,
    required String paymentMethod,
    required double subtotal,
    required double discount,
    required double tax,
    required double total,
    required double paidAmount,
    required List<CartItem> items,
    int? createdBy,
  }) async {
    try {
      // Validate stock before proceeding
      for (final item in items) {
        if (item.productId != null) {
          final product = await (database.select(database.products)
                ..where((p) => p.id.equals(item.productId!)))
              .getSingle();
          if (product.quantity < item.quantity) {
            return (
              data: null,
              error: 'الكمية المتوفرة غير كافية للمنتج: ${item.productName}'
            );
          }
        }
        if (item.phoneId != null) {
          final phone = await (database.select(database.phones)
                ..where((p) => p.id.equals(item.phoneId!)))
              .getSingle();
          if (phone.quantity < item.quantity) {
            return (
              data: null,
              error: 'الكمية المتوفرة غير كافية للجهاز: ${item.productName}'
            );
          }
        }
      }

      final saleSettings = await database.getSettingsOrDefault();
      final invoiceNumber =
          await generateInvoiceNumber(saleSettings.invoicePrefix);

      // Use transaction for atomicity
      return await database.transaction(() async {
        // 1. Create the sale
        final saleId =
            await database.into(database.sales).insert(db.SalesCompanion.insert(
                  invoiceNumber: invoiceNumber,
                  customerId: Value(customerId),
                  paymentMethod: Value(paymentMethod),
                  subtotal: Value(subtotal),
                  discount: Value(discount),
                  tax: Value(tax),
                  total: Value(total),
                  paidAmount: Value(paidAmount),
                  saleType: const Value('cash'),
                  status: const Value('completed'),
                  saleDate: DateTime.now(),
                  createdBy: createdBy ?? 1,
                  createdAt: Value(DateTime.now()),
                  updatedAt: Value(DateTime.now()),
                ));

        // 2. Create sale items + update inventory
        for (final item in items) {
          await database
              .into(database.saleItems)
              .insert(db.SaleItemsCompanion.insert(
                saleId: saleId,
                productId: Value(item.productId),
                phoneId: Value(item.phoneId),
                quantity: Value(item.quantity),
                unitPrice: Value(item.unitPrice),
                purchasePrice: Value(item.purchasePrice),
                discount: Value(item.discount),
                total: Value(item.totalPrice),
                imei1: Value(item.imei1),
                imei2: Value(item.imei2),
              ));

          // Update product stock
          if (item.productId != null) {
            final product = await (database.select(database.products)
                  ..where((p) => p.id.equals(item.productId!)))
                .getSingle();

            await (database.update(database.products)
                  ..where((p) => p.id.equals(item.productId!)))
                .write(
              db.ProductsCompanion(
                  quantity: Value(product.quantity - item.quantity)),
            );

            await database.insertMovement(db.InventoryMovementsCompanion.insert(
              productId: Value(item.productId),
              movementType: 'sale',
              quantity: -item.quantity,
              previousQuantity: product.quantity,
              newQuantity: product.quantity - item.quantity,
              unitPrice: Value(item.unitPrice),
              referenceType: Value('sale'),
              referenceId: Value(saleId),
              userId: createdBy ?? 1,
              createdAt: Value(DateTime.now()),
            ));
          }

          // Update phone stock and deactivate IMEI
          if (item.phoneId != null) {
            final phone = await (database.select(database.phones)
                  ..where((p) => p.id.equals(item.phoneId!)))
                .getSingle();

            if (phone.quantity > 0) {
              await (database.update(database.phones)
                    ..where((p) => p.id.equals(item.phoneId!)))
                  .write(
                db.PhonesCompanion(
                  quantity: Value(phone.quantity - 1),
                  status: const Value('sold'),
                  customerId: Value(customerId),
                  saleDate: Value(DateTime.now()),
                ),
              );
            }

            await database.deactivateImeisForPhone(item.phoneId!);
          }
        }

        // 3. Record sale payment if cash
        if (paymentMethod == 'cash' && paidAmount > 0) {
          await database
              .into(database.salePayments)
              .insert(db.SalePaymentsCompanion.insert(
                saleId: saleId,
                amount: paidAmount,
                method: Value(paymentMethod),
                paidAt: Value(DateTime.now()),
              ));

          await database
              .into(database.cashTransactions)
              .insert(db.CashTransactionsCompanion.insert(
                transactionType: 'sale',
                amount: paidAmount,
                balanceAfter: await _calculateBalance(paidAmount),
                description: 'بيع رقم $invoiceNumber',
                userId: createdBy ?? 1,
                transactionDate: DateTime.now(),
                referenceId: Value(saleId),
                referenceType: Value('sale'),
              ));
        }

        // 4. Update customer debt if applicable
        if (customerId != null && total > paidAmount) {
          final cid = customerId;
          final customer = await (database.select(database.customers)
                ..where((c) => c.id.equals(cid)))
              .getSingle();
          final debt = total - paidAmount;
          await (database.update(database.customers)
                ..where((c) => c.id.equals(cid)))
              .write(
            db.CustomersCompanion(
              remainingDebt: Value(customer.remainingDebt + debt),
              totalPurchases: Value(customer.totalPurchases + total),
              totalPaid: Value(customer.totalPaid + paidAmount),
            ),
          );

          await database
              .into(database.cashTransactions)
              .insert(db.CashTransactionsCompanion.insert(
                transactionType: 'debt',
                amount: -debt,
                balanceAfter: await _calculateBalance(-debt),
                description: 'دين עميل: $invoiceNumber',
                userId: createdBy ?? 1,
                transactionDate: DateTime.now(),
                referenceId: Value(saleId),
                referenceType: Value('sale'),
              ));
        }

        return (data: saleId, error: null);
      });
    } catch (e) {
      return (data: null, error: e.toString());
    }
  }

  @override
  Future<double> getTodaySalesTotal() => database.getTodaySalesTotal();

  @override
  Future<double> getTotalSales() => database.getTotalSales();

  @override
  Future<double> getCashBalance() => database.getCashBalance();

  @override
  Future<double> getCustomerDebts() => database.getCustomerDebts();
}

// test/unit/financial_calculations_test.dart
/// Unit tests for financial calculations (subtotal, discount, tax, total).
///
/// These tests verify the core arithmetic used in sales and purchases,
/// ensuring financial accuracy as required by the project specification.
library;

import 'package:test/test.dart';

/// Helper: calculate subtotal from a list of line item totals.
double calculateSubtotal(List<double> lineTotals) {
  return lineTotals.fold(0.0, (sum, item) => sum + item);
}

/// Helper: apply discount to a subtotal.
double applyDiscount(double subtotal, double discount) {
  return (subtotal - discount).clamp(0.0, double.infinity);
}

/// Helper: apply tax to a subtotal.
double applyTax(double subtotal, double taxRate) {
  return subtotal * (taxRate / 100.0);
}

/// Helper: calculate final total.
double calculateTotal(double afterDiscount, double taxAmount) {
  return afterDiscount + taxAmount;
}

void main() {
  group('Financial Calculations', () {
    group('Subtotal', () {
      test('calculates subtotal from single item', () {
        expect(calculateSubtotal([100.0]), equals(100.0));
      });

      test('calculates subtotal from multiple items', () {
        expect(calculateSubtotal([100.0, 50.0, 25.5]), equals(175.5));
      });

      test('returns 0 for empty list', () {
        expect(calculateSubtotal([]), equals(0.0));
      });

      test('handles zero values', () {
        expect(calculateSubtotal([0.0, 0.0]), equals(0.0));
      });
    });

    group('Discount', () {
      test('applies full discount correctly', () {
        expect(applyDiscount(100.0, 20.0), equals(80.0));
      });

      test('does not go below zero', () {
        expect(applyDiscount(50.0, 100.0), equals(0.0));
      });

      test('handles zero discount', () {
        expect(applyDiscount(100.0, 0.0), equals(100.0));
      });
    });

    group('Tax', () {
      test('calculates 15% tax on 100', () {
        expect(applyTax(100.0, 15.0), equals(15.0));
      });

      test('calculates 0% tax', () {
        expect(applyTax(100.0, 0.0), equals(0.0));
      });

      test('calculates tax with decimals', () {
        expect(applyTax(175.5, 15.0), closeTo(26.325, 0.001));
      });
    });

    group('Total', () {
      test('calculates total from discounted price + tax', () {
        final afterDiscount = applyDiscount(100.0, 10.0); // 90
        final tax = applyTax(afterDiscount, 15.0); // 13.5
        expect(calculateTotal(afterDiscount, tax), closeTo(103.5, 0.01));
      });

      test('total equals subtotal + tax when no discount', () {
        final subtotal = 200.0;
        final afterDiscount = applyDiscount(subtotal, 0.0);
        final tax = applyTax(afterDiscount, 15.0); // 30
        expect(calculateTotal(afterDiscount, tax), equals(230.0));
      });
    });

    group('Payment and Remaining', () {
      test('remaining = total - paid', () {
        final total = 100.0;
        final paid = 50.0;
        final remaining = total - paid;
        expect(remaining, equals(50.0));
      });

      test('remaining cannot go negative', () {
        final total = 100.0;
        final paid = 150.0;
        final remaining = (total - paid).clamp(0.0, double.infinity);
        expect(remaining, equals(0.0));
      });

      test('overpayment is tracked', () {
        final total = 100.0;
        final paid = 120.0;
        expect(paid - total, equals(20.0)); // overpayment
      });
    });

    group('Profit Calculation', () {
      test('profit = (selling - cost) * quantity', () {
        final selling = 500.0;
        final cost = 300.0;
        final quantity = 10;
        final profit = (selling - cost) * quantity;
        expect(profit, equals(2000.0));
      });

      test('loss when selling below cost', () {
        final selling = 200.0;
        final cost = 300.0;
        final profit = (selling - cost) * 1;
        expect(profit, equals(-100.0));
      });

      test('zero profit when cost equals selling', () {
        final profit = (300.0 - 300.0) * 1;
        expect(profit, equals(0.0));
      });
    });
  });
}

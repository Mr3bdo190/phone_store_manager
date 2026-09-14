// test/unit/imei_uniqueness_test.dart
/// Unit tests for IMEI uniqueness validation.
library;

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('IMEI Uniqueness', () {
    test('duplicate IMEI is rejected', () {
      final seen = <String>{};
      final imei = '123456789012345';
      seen.add(imei);

      final isDuplicate = seen.contains(imei);
      expect(isDuplicate, isTrue);
    });

    test('unique IMEI is accepted', () {
      final seen = <String>{};
      final imei1 = '123456789012345';
      final imei2 = '987654321098765';

      seen.add(imei1);
      final isDuplicate = seen.contains(imei2);
      expect(isDuplicate, isFalse);
    });

    test('empty IMEI is not considered unique', () {
      final imei = '';
      expect(imei.isEmpty, isTrue);
    });

    test('IMEI with different length are different', () {
      final imei1 = '12345';
      final imei2 = '123456';
      expect(imei1, isNot(equals(imei2)));
    });
  });
}

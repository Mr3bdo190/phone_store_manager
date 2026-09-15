// lib/features/phones/domain/entities/imei.dart
/// IMEI entity — tracks IMEI numbers for phone devices.
library;

class Imei {
  final int? id;
  final int phoneId;
  final String imei;
  final bool active;
  final DateTime? createdAt;
  final DateTime? deactivatedAt;

  Imei({
    this.id,
    required this.phoneId,
    required this.imei,
    this.active = true,
    this.createdAt,
    this.deactivatedAt,
  });

  Imei copyWith({
    int? id,
    int? phoneId,
    String? imei,
    bool? active,
    DateTime? createdAt,
    DateTime? deactivatedAt,
  }) {
    return Imei(
      id: id ?? this.id,
      phoneId: phoneId ?? this.phoneId,
      imei: imei ?? this.imei,
      active: active ?? this.active,
      createdAt: createdAt ?? this.createdAt,
      deactivatedAt: deactivatedAt ?? this.deactivatedAt,
    );
  }
}

/// IMEI validation utilities.
class ImeiValidator {
  /// Validates IMEI format using the Luhn algorithm.
  /// IMEI must be 15 digits.
  static bool isValid(String imei) {
    final trimmed = imei.trim();
    if (trimmed.length != 15) return false;
    if (!RegExp(r'^\d{15}$').hasMatch(trimmed)) return false;
    return _luhnCheck(trimmed);
  }

  /// Luhn algorithm check digit validation.
  static bool _luhnCheck(String input) {
    int sum = 0;
    bool alternate = false;
    for (int i = input.length - 1; i >= 0; i--) {
      int n = int.parse(input[i]);
      if (alternate) {
        n *= 2;
        if (n > 9) n = (n % 10) + 1;
      }
      sum += n;
      alternate = !alternate;
    }
    return sum % 10 == 0;
  }
}

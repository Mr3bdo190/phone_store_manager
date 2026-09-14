// lib/features/settings/domain/entities/store_info.dart
/// Store information entity extracted from [StoreSettings].
library;

class StoreInfo {
  final String storeName;
  final String? storePhone;
  final String? storeAddress;
  final String currencySymbol;
  final String currencyCode;

  StoreInfo({
    required this.storeName,
    this.storePhone,
    this.storeAddress,
    required this.currencySymbol,
    required this.currencyCode,
  });
}

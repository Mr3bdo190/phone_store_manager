// lib/features/shared/domain/entities/settings.dart
/// Application settings entity — single-row table.
library;

class StoreSettings {
  final int id; // always 1 (single row)
  final String storeName;
  final String? storePhone;
  final String? storeAddress;
  final String currencySymbol;
  final String currencyCode;
  final bool enableInvoiceNumber;
  final String invoicePrefix;
  final String themeMode; // 'light', 'dark', 'system'
  final String languageCode; // 'ar', 'en'
  final bool enableBiometric;
  final bool enableAutoBackup;
  final int sessionTimeoutMinutes;
  final String? logoPath;

  StoreSettings({
    this.id = 1,
    this.storeName = "Phone Store Manager",
    this.storePhone,
    this.storeAddress,
    this.currencySymbol = "ر.س",
    this.currencyCode = "SAR",
    this.enableInvoiceNumber = true,
    this.invoicePrefix = "INV",
    this.themeMode = "light",
    this.languageCode = "ar",
    this.enableBiometric = false,
    this.enableAutoBackup = false,
    this.sessionTimeoutMinutes = 15,
    this.logoPath,
  });

  StoreSettings copyWith({
    int? id,
    String? storeName,
    String? storePhone,
    String? storeAddress,
    String? currencySymbol,
    String? currencyCode,
    bool? enableInvoiceNumber,
    String? invoicePrefix,
    String? themeMode,
    String? languageCode,
    bool? enableBiometric,
    bool? enableAutoBackup,
    int? sessionTimeoutMinutes,
    String? logoPath,
  }) {
    return StoreSettings(
      id: id ?? this.id,
      storeName: storeName ?? this.storeName,
      storePhone: storePhone ?? this.storePhone,
      storeAddress: storeAddress ?? this.storeAddress,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      currencyCode: currencyCode ?? this.currencyCode,
      enableInvoiceNumber: enableInvoiceNumber ?? this.enableInvoiceNumber,
      invoicePrefix: invoicePrefix ?? this.invoicePrefix,
      themeMode: themeMode ?? this.themeMode,
      languageCode: languageCode ?? this.languageCode,
      enableBiometric: enableBiometric ?? this.enableBiometric,
      enableAutoBackup: enableAutoBackup ?? this.enableAutoBackup,
      sessionTimeoutMinutes:
          sessionTimeoutMinutes ?? this.sessionTimeoutMinutes,
      logoPath: logoPath ?? this.logoPath,
    );
  }
}

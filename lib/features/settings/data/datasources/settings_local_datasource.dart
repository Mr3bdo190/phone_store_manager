// lib/features/settings/data/datasources/settings_local_datasource.dart
/// Data source for settings — reads/writes to local Drift database.
library;

import 'package:drift/drift.dart';

import '../../../../core/database/database.dart';
import '../../../shared/domain/entities/settings.dart';

abstract class SettingsLocalDataSource {
  Future<StoreSettings> getSettings();
  Future<int> saveSettings(StoreSettings settings);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final AppDatabase database;

  SettingsLocalDataSourceImpl(this.database);

  @override
  Future<StoreSettings> getSettings() async {
    final row = await (database.select(database.settings)..where((s) => s.id.equals(1))).getSingleOrNull();
    if (row == null) {
      // Return default settings
      return StoreSettings();
    }
    return _fromRow(row);
  }

  @override
  Future<int> saveSettings(StoreSettings settings) {
    final companion = SettingsCompanion(
      id: Value(settings.id),
      storeName: Value(settings.storeName),
      storePhone: Value(settings.storePhone),
      storeAddress: Value(settings.storeAddress),
      currencySymbol: Value(settings.currencySymbol),
      currencyCode: Value(settings.currencyCode),
      enableInvoiceNumber: Value(settings.enableInvoiceNumber),
      invoicePrefix: Value(settings.invoicePrefix),
      themeMode: Value(settings.themeMode),
      languageCode: Value(settings.languageCode),
      enableBiometric: Value(settings.enableBiometric),
      enableAutoBackup: Value(settings.enableAutoBackup),
      sessionTimeoutMinutes: Value(settings.sessionTimeoutMinutes),
      logoPath: Value(settings.logoPath),
    );
    return database.into(database.settings).insert(
          companion,
          mode: InsertMode.insertOrReplace,
        );
  }

  StoreSettings _fromRow(Setting row) => StoreSettings(
        id: row.id,
        storeName: row.storeName,
        storePhone: row.storePhone,
        storeAddress: row.storeAddress,
        currencySymbol: row.currencySymbol,
        currencyCode: row.currencyCode,
        enableInvoiceNumber: row.enableInvoiceNumber,
        invoicePrefix: row.invoicePrefix,
        themeMode: row.themeMode,
        languageCode: row.languageCode,
        enableBiometric: row.enableBiometric,
        enableAutoBackup: row.enableAutoBackup,
        sessionTimeoutMinutes: row.sessionTimeoutMinutes,
        logoPath: row.logoPath,
      );
}

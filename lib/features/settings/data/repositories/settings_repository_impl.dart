// lib/features/settings/data/repositories/settings_repository_impl.dart
/// Repository implementation for settings.
library;

import '../../../../core/errors/failures.dart';
import '../../domain/entities/store_info.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../../shared/domain/entities/settings.dart';
import '../datasources/settings_local_datasource.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl(this.localDataSource);

  @override
  Future<({StoreSettings? data, Failure? failure})> getSettings() async {
    try {
      final settings = await localDataSource.getSettings();
      return (data: settings, failure: null);
    } catch (e) {
      return (data: null, failure: DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<({bool data, Failure? failure})> updateSettings(StoreSettings settings) async {
    try {
      await localDataSource.saveSettings(settings);
      return (data: true, failure: null);
    } catch (e) {
      return (data: false, failure: DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<({StoreInfo? data, Failure? failure})> getStoreInfo() async {
    try {
      final settings = await localDataSource.getSettings();
      final info = StoreInfo(
        storeName: settings.storeName,
        storePhone: settings.storePhone,
        storeAddress: settings.storeAddress,
        currencySymbol: settings.currencySymbol,
        currencyCode: settings.currencyCode,
      );
      return (data: info, failure: null);
    } catch (e) {
      return (data: null, failure: DatabaseFailure(e.toString()));
    }
  }
}

// lib/features/settings/domain/repositories/settings_repository.dart
/// Abstract repository contract for settings operations.
library;

import '../../../../core/errors/failures.dart';
import '../../../shared/domain/entities/settings.dart';
import '../entities/store_info.dart';

abstract class SettingsRepository {
  Future<({StoreSettings? data, Failure? failure})> getSettings();
  Future<({bool data, Failure? failure})> updateSettings(StoreSettings settings);
  Future<({StoreInfo? data, Failure? failure})> getStoreInfo();
}

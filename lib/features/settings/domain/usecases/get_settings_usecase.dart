// lib/features/settings/domain/usecases/get_settings_usecase.dart
library;

import '../../../core/errors/failures.dart';
import '../../shared/domain/entities/settings.dart';
import '../repositories/settings_repository.dart';

class GetSettingsUseCase {
  final SettingsRepository repository;

  GetSettingsUseCase(this.repository);

  Future<({StoreSettings? data, Failure? failure})> call() {
    return repository.getSettings();
  }
}

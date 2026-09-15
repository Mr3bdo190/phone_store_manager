// lib/features/settings/domain/usecases/update_settings_usecase.dart
library;

import '../../../../core/errors/failures.dart';
import '../../../shared/domain/entities/settings.dart';
import '../repositories/settings_repository.dart';

class UpdateSettingsUseCase {
  final SettingsRepository repository;

  UpdateSettingsUseCase(this.repository);

  Future<({bool data, Failure? failure})> call(StoreSettings settings) {
    return repository.updateSettings(settings);
  }
}

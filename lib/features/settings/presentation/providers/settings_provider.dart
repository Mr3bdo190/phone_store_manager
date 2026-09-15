// lib/features/settings/presentation/providers/settings_provider.dart
/// State management for app settings.
library;

import 'package:flutter/foundation.dart';

import '../../../../core/services/di.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/usecases/get_settings_usecase.dart';
import '../../domain/usecases/update_settings_usecase.dart';
import '../../../shared/domain/entities/settings.dart';

class SettingsProvider extends ChangeNotifier {
  final GetSettingsUseCase _getSettingsUseCase;
  final UpdateSettingsUseCase _updateSettingsUseCase;

  SettingsProvider()
      : _getSettingsUseCase = GetSettingsUseCase(di.get<SettingsRepository>()),
        _updateSettingsUseCase = UpdateSettingsUseCase(di.get<SettingsRepository>());

  StoreSettings? _settings;
  bool _isLoading = false;
  String? _errorMessage;

  StoreSettings? get settings => _settings;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadSettings() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _getSettingsUseCase();
    _isLoading = false;

    if (result.failure != null) {
      _errorMessage = result.failure!.message;
    } else {
      _settings = result.data;
    }
    notifyListeners();
  }

  Future<bool> saveSettings(StoreSettings settings) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _updateSettingsUseCase(settings);
    _isLoading = false;

    if (result.failure != null) {
      _errorMessage = result.failure!.message;
      notifyListeners();
      return false;
    }

    _settings = settings;
    notifyListeners();
    return true;
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

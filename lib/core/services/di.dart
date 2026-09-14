// lib/core/services/di.dart
/// Simple service locator / dependency injection.
///
/// Uses a lightweight manual DI container — no extra package needed.
library;

import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/settings/data/datasources/settings_local_datasource.dart';
import '../../features/settings/data/repositories/settings_repository_impl.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';
import '../database/database.dart';

/// Global service locator instance.
final di = DI();

class DI {
  DI._internal();
  static final DI _instance = DI._internal();

  factory DI() => _instance;

  final Map<Type, dynamic> _services = {};

  void register<T>(T instance) {
    _services[T] = instance;
  }

  T get<T>() {
    final instance = _services[T];
    if (instance == null) {
      throw Exception('Service of type $T is not registered in DI container.');
    }
    return instance as T;
  }

  bool isRegistered<T>() => _services.containsKey(T);
}

/// Call this once at app startup to register all dependencies.
Future<void> initDependencies(AppDatabase database) async {
  // Database
  di.register<AppDatabase>(database);

  // DataSources
  di.register<AuthLocalDataSource>(AuthLocalDataSourceImpl(database));
  di.register<SettingsLocalDataSource>(SettingsLocalDataSourceImpl(database));

  // Repositories
  di.register<AuthRepository>(AuthRepositoryImpl(di.get<AuthLocalDataSource>()));
  di.register<SettingsRepository>(
    SettingsRepositoryImpl(di.get<SettingsLocalDataSource>()),
  );
}

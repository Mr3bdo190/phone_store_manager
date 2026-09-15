// lib/core/services/di.dart
/// Simple service locator / dependency injection.
///
/// Uses a lightweight manual DI container — no extra package needed.
library;

import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/brands/data/datasources/brand_local_datasource.dart';
import '../../features/brands/data/repositories/brand_repository_impl.dart';
import '../../features/brands/domain/repositories/brand_repository.dart';
import '../../features/categories/data/datasources/category_local_datasource.dart';
import '../../features/categories/data/repositories/category_repository_impl.dart';
import '../../features/categories/domain/repositories/category_repository.dart';
import '../../features/customers/data/datasources/customer_local_datasource.dart';
import '../../features/customers/data/repositories/customer_repository_impl.dart';
import '../../features/customers/domain/repositories/customer_repository.dart';
import '../../features/inventory/data/datasources/inventory_local_datasource.dart';
import '../../features/inventory/data/repositories/inventory_repository_impl.dart';
import '../../features/inventory/domain/repositories/inventory_repository.dart';
import '../../features/phones/data/datasources/phone_local_datasource.dart';
import '../../features/phones/data/repositories/phone_repository_impl.dart';
import '../../features/phones/domain/repositories/phone_repository.dart';
import '../../features/pos/data/datasources/sales_local_datasource.dart';
import '../../features/pos/data/repositories/sales_repository_impl.dart';
import '../../features/pos/domain/repositories/sales_repository.dart';
import '../../features/products/data/datasources/product_local_datasource.dart';
import '../../features/products/data/repositories/product_repository_impl.dart';
import '../../features/products/domain/repositories/product_repository.dart';
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
  di.register<CategoryLocalDataSource>(CategoryLocalDataSourceImpl(database));
  di.register<BrandLocalDataSource>(BrandLocalDataSourceImpl(database));
  di.register<ProductLocalDataSource>(ProductLocalDataSourceImpl(database));
  di.register<CustomerLocalDataSource>(CustomerLocalDataSourceImpl(database));
  di.register<PhoneLocalDataSource>(PhoneLocalDataSourceImpl(database));
  di.register<InventoryLocalDataSource>(InventoryLocalDataSourceImpl(database));
  di.register<SalesLocalDataSource>(SalesLocalDataSourceImpl(database));

  // Repositories
  di.register<AuthRepository>(AuthRepositoryImpl(di.get<AuthLocalDataSource>()));
  di.register<SettingsRepository>(
    SettingsRepositoryImpl(di.get<SettingsLocalDataSource>()),
  );
  di.register<CategoryRepository>(CategoryRepositoryImpl(di.get<CategoryLocalDataSource>()));
  di.register<BrandRepository>(BrandRepositoryImpl(di.get<BrandLocalDataSource>()));
  di.register<ProductRepository>(ProductRepositoryImpl(di.get<ProductLocalDataSource>()));
  di.register<CustomerRepository>(CustomerRepositoryImpl(di.get<CustomerLocalDataSource>()));
  di.register<PhoneRepository>(PhoneRepositoryImpl(di.get<PhoneLocalDataSource>()));
  di.register<InventoryRepository>(InventoryRepositoryImpl(di.get<InventoryLocalDataSource>()));
  di.register<SalesRepository>(SalesRepositoryImpl(di.get<SalesLocalDataSource>()));
}

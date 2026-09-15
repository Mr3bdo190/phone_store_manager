// lib/features/auth/presentation/providers/auth_provider.dart
/// State management for authentication.
library;

import 'package:flutter/foundation.dart';

import '../../../../core/constants/enums.dart';
import '../../../../core/services/di.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/check_has_users_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

class AuthProvider extends ChangeNotifier {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final CheckHasUsersUseCase _checkHasUsersUseCase;

  AuthProvider()
      : _loginUseCase = LoginUseCase(di.get<AuthRepository>()),
        _registerUseCase = RegisterUseCase(di.get<AuthRepository>()),
        _checkHasUsersUseCase = CheckHasUsersUseCase(di.get<AuthRepository>());

  AuthUser? _currentUser;
  bool _isLoading = false;
  bool _hasCheckedInitial = false;
  String? _errorMessage;

  AuthUser? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  bool get isAdmin => _currentUser?.role == UserRole.admin;
  String? get errorMessage => _errorMessage;

  /// Check if this is first run (no users exist yet).
  Future<bool> checkFirstRun() async {
    if (_hasCheckedInitial) return false;
    _hasCheckedInitial = true;
    final result = await _checkHasUsersUseCase();
    return result.failure != null || result.data == false; // No users = first run
  }

  Future<bool> login({required String username, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _loginUseCase(username: username, password: password);
    _isLoading = false;

    if (result.failure != null) {
      _errorMessage = result.failure!.message;
      _currentUser = null;
      notifyListeners();
      return false;
    }

    _currentUser = result.data;
    notifyListeners();
    return true;
  }

  Future<bool> register({
    required String username,
    required String password,
    required String role,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _registerUseCase(username: username, password: password, role: role);
    _isLoading = false;

    if (result.failure != null) {
      _errorMessage = result.failure!.message;
      notifyListeners();
      return false;
    }

    // Auto-login after first admin registration
    if (result.data) {
      await login(username: username, password: password);
    }
    notifyListeners();
    return true;
  }

  void logout() {
    _currentUser = null;
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

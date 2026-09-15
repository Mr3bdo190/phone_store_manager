// lib/features/pos/presentation/providers/pos_provider.dart
/// State management for POS cart and sales.
library;

import 'package:flutter/foundation.dart';

import '../../../../core/services/di.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/sales_repository.dart';
import '../../domain/usecases/create_sale_usecase.dart';

class PosProvider extends ChangeNotifier {
  final CreateSaleUseCase _createSaleUseCase;

  PosProvider() : _createSaleUseCase = CreateSaleUseCase(di.get<SalesRepository>());

  final List<CartItem> _items = [];
  int? _customerId;
  String _customerName = '';
  double _discount = 0;
  double _taxRate = 0;
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  List<CartItem> get items => List.unmodifiable(_items);
  int? get customerId => _customerId;
  String get customerName => _customerName;
  double get discount => _discount;
  double get taxRate => _taxRate;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  double get subtotal => _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get afterDiscount => (subtotal - _discount).clamp(0.0, double.infinity);
  double get taxAmount => afterDiscount * (_taxRate / 100.0);
  double get total => afterDiscount + taxAmount;
  int get itemCount => _items.length;

  void addItem(CartItem item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      notifyListeners();
    }
  }

  void updateItemQuantity(int index, int newQuantity) {
    if (index >= 0 && index < _items.length) {
      final item = _items[index];
      _items[index] = item.copyWith(quantity: newQuantity);
      notifyListeners();
    }
  }

  void setDiscount(double value) {
    _discount = value.clamp(0.0, subtotal);
    notifyListeners();
  }

  void setTaxRate(double value) {
    _taxRate = value.clamp(0.0, 100.0);
    notifyListeners();
  }

  void setCustomer(int? customerId, String name) {
    _customerId = customerId;
    _customerName = name;
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _customerId = null;
    _customerName = '';
    _discount = 0;
    _taxRate = 0;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  Future<bool> checkout({
    required String paymentMethod,
    required double paidAmount,
    int? createdBy,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    // Validate stock
    if (_items.isEmpty) {
      _isLoading = false;
      _errorMessage = 'السلة فارغة';
      notifyListeners();
      return false;
    }

    final result = await _createSaleUseCase(
      customerId: _customerId,
      paymentMethod: paymentMethod,
      subtotal: subtotal,
      discount: _discount,
      tax: taxAmount,
      total: total,
      paidAmount: paidAmount,
      items: _items,
      createdBy: createdBy,
    );

    _isLoading = false;

    if (result.failure != null) {
      _errorMessage = result.failure!.message;
      notifyListeners();
      return false;
    }

    _successMessage = 'تم إكمال البيع بنجاح';
    notifyListeners();
    return true;
  }

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }
}

// lib/l10n/app_localizations.dart
/// Localization helper that loads strings from ARB files.
library;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;
  final Map<String, dynamic> _localizedValues = {};

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  Future<bool> load() async {
    final jsonString = await rootBundle.loadString(
      'lib/l10n/app_${locale.languageCode}.arb',
    );
    final Map<String, dynamic> decoded =
        jsonDecode(jsonString) as Map<String, dynamic>;
    _localizedValues.clear();
    _localizedValues.addAll(decoded);
    return true;
  }

  String _get(String key, String fallback) {
    return _localizedValues[key] ?? fallback;
  }

  String get appTitle => _get('appTitle', 'Phone Store Manager');
  String get dashboard => _get('dashboard', 'اللوحة الرئيسية');
  String get settings => _get('settings', 'الإعدادات');
  String get todaySales => _get('todaySales', 'مبيعات اليوم');
  String get totalSales => _get('totalSales', 'إجمالي المبيعات');
  String get cashBalance => _get('cashBalance', 'رصيد النقدية');
  String get customerDebts => _get('customerDebts', 'ديون العملاء');
  String get lowStock => _get('lowStock', 'مخزون منخفض');
  String get outOfStock => _get('outOfStock', 'نفاد المخزون');
  String get customers => _get('customers', 'العملاء');
  String get products => _get('products', 'المنتجات');
  String get inventory => _get('inventory', 'المخزون');
  String get pos => _get('pos', 'نقطة البيع');
  String get quickActions => _get('quickActions', 'إجراءات سريعة');
  String get search => _get('search', 'بحث');
  String get add => _get('add', 'إضافة');
  String get edit => _get('edit', 'تعديل');
  String get delete => _get('delete', 'حذف');
  String get save => _get('save', 'حفظ');
  String get cancel => _get('cancel', 'إلغاء');
  String get confirm => _get('confirm', 'تأكيد');
  String get storeName => _get('storeName', 'اسم المتجر');
  String get storePhone => _get('storePhone', 'هاتف المتجر');
  String get storeAddress => _get('storeAddress', 'عنوان المتجر');
  String get currency => _get('currency', 'العملة');
  String get language => _get('language', 'اللغة');
  String get theme => _get('theme', 'المظهر');
  String get logout => _get('logout', 'تسجيل الخروج');
  String get login => _get('login', 'تسجيل الدخول');
  String get username => _get('username', 'اسم المستخدم');
  String get password => _get('password', 'كلمة المرور');
  String get enterUsername => _get('enterUsername', 'أدخل اسم المستخدم');
  String get enterPassword => _get('enterPassword', 'أدخل كلمة المرور');
  String get createAccount => _get('createAccount', 'إنشاء حساب');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['ar', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}

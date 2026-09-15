// lib/features/settings/presentation/pages/settings_page.dart
/// Settings screen with store info, theme, language, and security.
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';
import '../../../shared/domain/entities/settings.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _storeNameController = TextEditingController();
  final _storePhoneController = TextEditingController();
  final _storeAddressController = TextEditingController();
  final _currencySymbolController = TextEditingController();
  final _currencyCodeController = TextEditingController();
  final _invoicePrefixController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSettings();
    });
  }

  @override
  void dispose() {
    _storeNameController.dispose();
    _storePhoneController.dispose();
    _storeAddressController.dispose();
    _currencySymbolController.dispose();
    _currencyCodeController.dispose();
    _invoicePrefixController.dispose();
    super.dispose();
  }

  void _loadSettings() {
    final provider = Provider.of<SettingsProvider>(context, listen: false);
    provider.loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SettingsProvider>(context);
    final settings = provider.settings;

    if (provider.isLoading && settings == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (settings == null) {
      return const Scaffold(body: Center(child: Text('فشل تحميل الإعدادات')));
    }

    // Populate controllers once
    if (_storeNameController.text.isEmpty) {
      _storeNameController.text = settings.storeName;
      _storePhoneController.text = settings.storePhone ?? '';
      _storeAddressController.text = settings.storeAddress ?? '';
      _currencySymbolController.text = settings.currencySymbol;
      _currencyCodeController.text = settings.currencyCode;
      _invoicePrefixController.text = settings.invoicePrefix;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: RefreshIndicator(
        onRefresh: () async => provider.loadSettings(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSection(
                context,
                'إعدادات المتجر',
                [
                  _buildTextField(_storeNameController, 'اسم المتجر', Icons.store),
                  _buildTextField(_storePhoneController, 'هاتف المتجر', Icons.phone, keyboardType: TextInputType.phone),
                  _buildTextField(_storeAddressController, 'عنوان المتجر', Icons.location_on),
                ],
              ),
              _buildSection(
                context,
                'إعدادات العملة',
                [
                  _buildTextField(_currencySymbolController, 'رمز العملة', Icons.monetization_on),
                  _buildTextField(_currencyCodeController, 'رمز العملة (3 أحرف)', Icons.code),
                  _buildTextField(_invoicePrefixController, 'بادئة الفاتورة', Icons.receipt_long),
                ],
              ),
              _buildSection(
                context,
                'المظهر',
                [
                  SwitchListTile(
                    title: const Text('وضع الليل'),
                    secondary: const Icon(Icons.dark_mode),
                    value: settings.themeMode == 'dark',
                    onChanged: (val) => _updateSetting((s) => s.copyWith(themeMode: val ? 'dark' : 'light')),
                  ),
                ],
              ),
              _buildSection(
                context,
                'اللغة',
                [
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: const Text('اللغة'),
                    trailing: DropdownButton<String>(
                      value: settings.languageCode,
                      items: const [
                        DropdownMenuItem(value: 'ar', child: Text('العربية')),
                        DropdownMenuItem(value: 'en', child: Text('English')),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          _updateSetting((s) => s.copyWith(languageCode: val));
                        }
                      },
                    ),
                  ),
                ],
              ),
              _buildSection(
                context,
                'الخصوصية والأمان',
                [
                  SwitchListTile(
                    title: const Text('المصادقة البيومترية'),
                    secondary: const Icon(Icons.fingerprint),
                    value: settings.enableBiometric,
                    onChanged: (val) => _updateSetting((s) => s.copyWith(enableBiometric: val)),
                  ),
                  SwitchListTile(
                    title: const Text('نسخ احتياطي تلقائي'),
                    secondary: const Icon(Icons.backup),
                    value: settings.enableAutoBackup,
                    onChanged: (val) => _updateSetting((s) => s.copyWith(enableAutoBackup: val)),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: provider.isLoading ? null : _saveSettings,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: provider.isLoading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('حفظ الإعدادات', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: Text(title, style: Theme.of(context).textTheme.titleMedium),
        ),
        ...children,
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon,
      {TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
      ),
    );
  }

  Future<void> _updateSetting(StoreSettings Function(StoreSettings) updater) async {
    final provider = Provider.of<SettingsProvider>(context, listen: false);
    if (provider.settings == null) return;
    final updated = updater(provider.settings!);
    final success = await provider.saveSettings(updated);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حفظ الإعدادات')),
      );
    }
  }

  Future<void> _saveSettings() async {
    final provider = Provider.of<SettingsProvider>(context, listen: false);
    if (provider.settings == null) return;

    final updated = provider.settings!.copyWith(
      storeName: _storeNameController.text.trim(),
      storePhone: _storePhoneController.text.trim(),
      storeAddress: _storeAddressController.text.trim(),
      currencySymbol: _currencySymbolController.text.trim(),
      currencyCode: _currencyCodeController.text.trim(),
      invoicePrefix: _invoicePrefixController.text.trim(),
    );

    final success = await provider.saveSettings(updated);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حفظ الإعدادات بنجاح')),
      );
    }
  }
}

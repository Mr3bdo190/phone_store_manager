// lib/features/pos/presentation/pages/pos_page.dart
/// POS / Point of Sale page with cart management.
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/services/di.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../products/domain/entities/product.dart';
import '../../../products/domain/repositories/product_repository.dart';
import '../../../settings/presentation/providers/settings_provider.dart';
import '../../domain/entities/cart_item.dart';
import '../providers/pos_provider.dart';

class PosPage extends StatefulWidget {
  const PosPage({Key? key}) : super(key: key);

  @override
  State<PosPage> createState() => _PosPageState();
}

class _PosPageState extends State<PosPage> {
  late ProductRepository _productRepository;
  final _searchController = TextEditingController();
  List<Product> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _productRepository = di.get<ProductRepository>();
  }

  void _searchProducts(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }
    setState(() => _isSearching = true);
    final results = await _productRepository.searchProducts(query);
    setState(() {
      _searchResults = results;
      _isSearching = false;
    });
  }

  void _addToCart(Product product) {
    final pos = Provider.of<PosProvider>(context, listen: false);
    final item = CartItem(
      productId: product.id,
      productName: product.name,
      sku: product.sku,
      quantity: 1,
      unitPrice: product.sellingPrice,
      purchasePrice: product.costPrice,
    );
    pos.addItem(item);
  }

  void _showPaymentDialog() async {
    final pos = Provider.of<PosProvider>(context, listen: false);
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final currencySymbol = settings.settings?.currencySymbol ?? 'ر.س';
    final total = pos.total;

    final paidController = TextEditingController(text: total.toStringAsFixed(2));

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إتمام البيع'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('الإجمالي: ${total.toStringAsFixed(2)} $currencySymbol'),
            const SizedBox(height: 12),
            TextField(
              controller: paidController,
              decoration: InputDecoration(
                labelText: 'المبلغ المدفوع',
                border: const OutlineInputBorder(),
                suffixText: currencySymbol,
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('إلغاء')),
          ElevatedButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('تأكيد')),
        ],
      ),
    );

    if (confirmed == true) {
      final paid = double.tryParse(paidController.text) ?? 0;
      final success = await pos.checkout(
        paymentMethod: 'cash',
        paidAmount: paid,
      );
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(pos.successMessage ?? 'تم البيع بنجاح')),
        );
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(pos.errorMessage ?? 'خطأ في البيع')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ChangeNotifierProvider(
      create: (_) => PosProvider(),
      child: Scaffold(
        appBar: AppBar(title: Text(l10n?.pos ?? 'نقطة البيع')),
        body: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: l10n?.search ?? 'بحث',
                  prefixIcon: const Icon(Icons.search),
                  border: const OutlineInputBorder(),
                ),
                onChanged: _searchProducts,
              ),
            ),

            // Search results or cart
            Expanded(
              child: _searchController.text.isNotEmpty ? _buildSearchResults() : const _CartView(),
            ),
          ],
        ),
        floatingActionButton: _buildCheckoutButton(),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_isSearching) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_searchResults.isEmpty) {
      return const Center(child: Text('لا توجد نتائج'));
    }
    return ListView.separated(
      itemCount: _searchResults.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final product = _searchResults[index];
        return ListTile(
          leading: const CircleAvatar(child: Icon(Icons.inventory_2)),
          title: Text(product.name),
          subtitle: Text('${product.sku} • ${product.sellingPrice.toStringAsFixed(2)} ر.س'),
          trailing: product.isOutOfStock
              ? const Icon(Icons.error, color: Colors.red)
              : const Icon(Icons.add_shopping_cart, color: Colors.green),
          onTap: product.isOutOfStock ? null : () => _addToCart(product),
        );
      },
    );
  }

  Widget? _buildCheckoutButton() {
    return Consumer<PosProvider>(
      builder: (context, pos, _) {
        if (pos.items.isEmpty) return const SizedBox.shrink();

        return FloatingActionButton.extended(
          onPressed: pos.isLoading ? null : _showPaymentDialog,
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          label: pos.isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text('إتمام (${pos.total.toStringAsFixed(2)} ر.س)'),
        );
      },
    );
  }
}

class _CartView extends StatelessWidget {
  const _CartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pos = Provider.of<PosProvider>(context);
    final settings = Provider.of<SettingsProvider>(context);
    final currencySymbol = settings.settings?.currencySymbol ?? 'ر.س';

    if (pos.items.isEmpty) {
      return Center(
        child: Text(
          'السلة فارغة',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: pos.items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final item = pos.items[index];
              return Card(
                child: ListTile(
                  title: Text(item.productName),
                  subtitle: Text('الكمية: ${item.quantity} × ${item.unitPrice.toStringAsFixed(2)} $currencySymbol'),
                  trailing: Text(
                    '${item.totalPrice.toStringAsFixed(2)} $currencySymbol',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSummaryRow('المجموع', pos.subtotal, currencySymbol, context),
              _buildSummaryRow('الخصم', pos.discount, currencySymbol, context),
              _buildSummaryRow('الضريبة', pos.taxAmount, currencySymbol, context),
              const Divider(thickness: 2),
              _buildSummaryRow('الإجمالي', pos.total, currencySymbol, context, isTotal: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, double amount, String currency, BuildContext context, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: isTotal
              ? Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)
              : Theme.of(context).textTheme.bodyMedium),
          Text(
            '${amount.toStringAsFixed(2)} $currency',
            style: isTotal
                ? Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)
                : Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

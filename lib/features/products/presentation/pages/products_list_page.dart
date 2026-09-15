// lib/features/products/presentation/pages/products_list_page.dart
/// Products list page with search and filtering.
library;

import 'package:flutter/material.dart';

import '../../../../core/services/di.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/entities/product.dart';

class ProductsListPage extends StatefulWidget {
  const ProductsListPage({Key? key}) : super(key: key);

  @override
  State<ProductsListPage> createState() => _ProductsListPageState();
}

class _ProductsListPageState extends State<ProductsListPage> {
  final _searchController = TextEditingController();
  late ProductRepository _repository;
  List<Product> _filtered = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _repository = di.get<ProductRepository>();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    final items = await _repository.getActiveProducts();
    setState(() {
      _filtered = items;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.products ?? 'المنتجات'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: _ProductSearchDelegate(_repository, l10n),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _filtered.isEmpty
              ? Center(
                  child: Text(
                    'لا توجد منتجات',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                )
              : ListView.separated(
                  itemCount: _filtered.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final product = _filtered[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                        child: const Icon(Icons.inventory_2),
                      ),
                      title: Text(product.name),
                      subtitle: Text(
                        '${product.sku} • ${product.barcode}\nالكمية: ${product.quantity} | السعر: ${product.sellingPrice}',
                        maxLines: 2,
                      ),
                      trailing: product.isLowStock
                          ? const Icon(Icons.warning, color: Colors.orange)
                          : null,
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('إضافة منتج قيد التطوير')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class _ProductSearchDelegate extends SearchDelegate<String> {
  final ProductRepository repository;
  final AppLocalizations? l10n;

  _ProductSearchDelegate(this.repository, this.l10n);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return const BackButton();
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    if (query.isEmpty) {
      return Center(
        child: Text(
          'ابحث عن منتج...',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    return FutureBuilder<List<Product>>(
      future: repository.searchProducts(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final results = snapshot.data ?? [];
        if (results.isEmpty) {
          return Center(
            child: Text(
              l10n?.search ?? 'بحث',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        }
        return ListView.separated(
          itemCount: results.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final product = results[index];
            return ListTile(
              title: Text(product.name),
              subtitle: Text('${product.sku} | ${product.sellingPrice.toStringAsFixed(2)} ر.س'),
              onTap: () => close(context, product.name),
            );
          },
        );
      },
    );
  }
}

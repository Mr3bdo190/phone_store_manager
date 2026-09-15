// lib/features/inventory/presentation/pages/inventory_page.dart
/// Inventory management page — shows low stock and out of stock items.
library;

import 'package:flutter/material.dart';

import '../../../../core/services/di.dart';
import '../../../products/domain/repositories/product_repository.dart';
import '../../domain/repositories/inventory_repository.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('المخزون'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'منخفض'),
              Tab(text: 'نفد'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _LowStockContent(),
            _OutOfStockContent(),
          ],
        ),
      ),
    );
  }
}

class _LowStockContent extends StatelessWidget {
  const _LowStockContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final repository = di.get<InventoryRepository>();
    return FutureBuilder(
      future: repository.getLowStockProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        final lowStock = snapshot.data ?? [];
        if (lowStock.isEmpty) {
          return const Center(child: Text('جميع المنتجات متوفرة'));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: lowStock.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final product = lowStock[index];
            return Card(
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.inventory_2)),
                title: Text(product.name),
                subtitle: Text(
                    'SKU: ${product.sku} | متوفر: ${product.quantity} | الحد الأدنى: ${product.minStock}'),
                trailing: const Icon(Icons.warning, color: Colors.orange),
              ),
            );
          },
        );
      },
    );
  }
}

class _OutOfStockContent extends StatelessWidget {
  const _OutOfStockContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productRepository = di.get<ProductRepository>();
    return FutureBuilder(
      future: productRepository.getActiveProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        final allProducts = snapshot.data ?? [];
        final outOfStock = allProducts.where((p) => p.isOutOfStock).toList();
        if (outOfStock.isEmpty) {
          return const Center(child: Text('جميع المنتجات متوفرة'));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: outOfStock.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final product = outOfStock[index];
            return Card(
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.inventory_2)),
                title: Text(product.name),
                subtitle: Text('SKU: ${product.sku}'),
                trailing: const Icon(Icons.error, color: Colors.red),
              ),
            );
          },
        );
      },
    );
  }
}

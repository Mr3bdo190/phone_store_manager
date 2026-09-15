// lib/features/phones/presentation/pages/phones_page.dart
/// Phones / devices management page.
library;

import 'package:flutter/material.dart';

import '../../../../core/services/di.dart';
import '../../domain/entities/phone.dart';
import '../../domain/repositories/phone_repository.dart';

class PhonesPage extends StatefulWidget {
  const PhonesPage({Key? key}) : super(key: key);

  @override
  State<PhonesPage> createState() => _PhonesPageState();
}

class _PhonesPageState extends State<PhonesPage> {
  late PhoneRepository _repository;
  List<Phone> _phones = [];
  List<Phone> _filtered = [];
  bool _isLoading = true;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _repository = di.get<PhoneRepository>();
    _loadPhones();
  }

  Future<void> _loadPhones() async {
    setState(() => _isLoading = true);
    final items = await _repository.getAllPhones();
    setState(() {
      _phones = items;
      _filtered = items;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الهواتف'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: _PhoneSearchDelegate(_phones, _repository),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _filtered.isEmpty
              ? const Center(child: Text('لا توجد هواتف'))
              : ListView.separated(
                  itemCount: _filtered.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final phone = _filtered[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: phone.isSold
                            ? Colors.grey.withValues(alpha: 0.2)
                            : Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: 0.1),
                        child: Icon(
                          Icons.phone_android,
                          color: phone.isSold
                              ? Colors.grey
                              : Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      title: Text(phone.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('SNR: ${phone.serialNumber}'),
                          Text(
                              'السعر: ${phone.sellingPrice.toStringAsFixed(2)} ر.س | الكمية: ${phone.quantity}'),
                        ],
                      ),
                      trailing: Chip(
                        label: Text(
                          phone.status == 'sold'
                              ? 'مباع'
                              : phone.status == 'in_stock'
                                  ? 'متوفر'
                                  : phone.status,
                          style: TextStyle(
                            color: phone.isSold
                                ? Colors.grey[700]
                                : Colors.green[700],
                            fontSize: 12,
                          ),
                        ),
                        backgroundColor: phone.isSold
                            ? Colors.grey[300]
                            : Colors.green.withValues(alpha: 0.2),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("إضافة هاتف قيد التطوير")),
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

class _PhoneSearchDelegate extends SearchDelegate<String> {
  final List<Phone> phones;
  final PhoneRepository repository;

  _PhoneSearchDelegate(this.phones, this.repository);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return const BackButton();
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = phones
        .where((p) =>
            p.name.contains(query) ||
            p.sku.contains(query) ||
            p.serialNumber.contains(query))
        .toList();
    return _buildList(results);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = phones
        .where((p) => p.name.contains(query) || p.sku.contains(query))
        .toList();
    return _buildList(suggestions);
  }

  Widget _buildList(List<Phone> items) {
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final phone = items[index];
        return ListTile(
          title: Text(phone.name),
          subtitle: Text(phone.serialNumber),
          trailing: Text('${phone.sellingPrice.toStringAsFixed(2)} ر.س'),
        );
      },
    );
  }
}

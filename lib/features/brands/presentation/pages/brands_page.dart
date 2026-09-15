// lib/features/brands/presentation/pages/brands_page.dart
/// Brands management page.
library;

import 'package:flutter/material.dart';

import '../../../../core/services/di.dart';
import '../../domain/entities/brand.dart';
import '../../domain/repositories/brand_repository.dart';

class BrandsPage extends StatefulWidget {
  const BrandsPage({Key? key}) : super(key: key);

  @override
  State<BrandsPage> createState() => _BrandsPageState();
}

class _BrandsPageState extends State<BrandsPage> {
  late BrandRepository _repository;
  List<Brand> _brands = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _repository = di.get<BrandRepository>();
    _loadBrands();
  }

  Future<void> _loadBrands() async {
    final items = await _repository.getAllBrands();
    setState(() {
      _brands = items;
      _isLoading = false;
    });
  }

  Future<void> _addBrand() async {
    final result = await _showEditDialog();
    if (result != null) {
      await _repository.createBrand(
          name: result.name, description: result.description);
      await _loadBrands();
    }
  }

  Future<Brand?> _showEditDialog({Brand? brand}) async {
    final nameController = TextEditingController(text: brand?.name ?? '');
    final descController =
        TextEditingController(text: brand?.description ?? '');

    final result = await showDialog<Brand>(
      context: context,
      builder: (context) => AlertDialog(
        title:
            Text(brand == null ? 'إضافة علامة تجارية' : 'تعديل علامة تجارية'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'الاسم',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descController,
              decoration: const InputDecoration(
                labelText: 'الوصف',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isEmpty) return;
              Navigator.of(context).pop(Brand(
                id: brand?.id,
                name: nameController.text.trim(),
                description: descController.text.trim(),
              ));
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('العلامات التجارية')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _brands.isEmpty
              ? const Center(child: Text('لا توجد علامات تجارية'))
              : ListView.separated(
                  itemCount: _brands.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final b = _brands[index];
                    return ListTile(
                      leading: const CircleAvatar(
                          child: Icon(Icons.branding_watermark)),
                      title: Text(b.name),
                      subtitle:
                          b.description != null ? Text(b.description!) : null,
                      trailing: IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: () async {
                          final result = await _showEditDialog(brand: b);
                          if (result != null) {
                            await _repository.updateBrand(result);
                            await _loadBrands();
                          }
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addBrand,
        child: const Icon(Icons.add),
      ),
    );
  }
}

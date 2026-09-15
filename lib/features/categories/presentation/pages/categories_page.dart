// lib/features/categories/presentation/pages/categories_page.dart
/// Categories management page.
library;

import 'package:flutter/material.dart';

import '../../../../core/services/di.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  late CategoryRepository _repository;
  List<Category> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _repository = di.get<CategoryRepository>();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final items = await _repository.getAllCategories();
    setState(() {
      _categories = items;
      _isLoading = false;
    });
  }

  Future<void> _addCategory() async {
    final result = await _showEditDialog();
    if (result != null) {
      await _repository.createCategory(name: result.name, description: result.description);
      await _loadCategories();
    }
  }

  Future<Category?> _showEditDialog({Category? category}) async {
    final nameController = TextEditingController(text: category?.name ?? '');
    final descController = TextEditingController(text: category?.description ?? '');

    final result = await showDialog<Category>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(category == null
            ? '${AppLocalizations.of(context)?.add ?? 'إضافة'} فئة'
            : 'تعديل فئة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)?.storeName ?? 'الاسم',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descController,
              decoration: InputDecoration(
                labelText: 'الوصف',
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: Text(AppLocalizations.of(context)?.cancel ?? 'إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isEmpty) return;
              Navigator.of(context).pop(Category(
                id: category?.id,
                name: nameController.text.trim(),
                description: descController.text.trim(),
              ));
            },
            child: Text(AppLocalizations.of(context)?.save ?? 'حفظ'),
          ),
        ],
      ),
    );

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الفئات')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _categories.isEmpty
              ? Center(
                  child: Text(
                    'لا توجد فئات',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                )
              : ListView.separated(
                  itemCount: _categories.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    return ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.category)),
                      title: Text(cat.name),
                      subtitle: cat.description != null ? Text(cat.description!) : null,
                      trailing: IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: () async {
                          final result = await _showEditDialog(category: cat);
                          if (result != null) {
                            await _repository.updateCategory(result);
                            await _loadCategories();
                          }
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCategory,
        child: const Icon(Icons.add),
      ),
    );
  }
}

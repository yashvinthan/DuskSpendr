import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/categorization/transaction_categorizer.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../common/widgets/navigation/top_app_bar.dart';

/// SS-058: Category Management UI
/// List/create/edit categories, icon/color picker
class CategoryManagementScreen extends ConsumerStatefulWidget {
  const CategoryManagementScreen({super.key});

  @override
  ConsumerState<CategoryManagementScreen> createState() =>
      _CategoryManagementScreenState();
}

class _CategoryManagementScreenState
    extends ConsumerState<CategoryManagementScreen> {
  final CustomCategoryStore _store = CustomCategoryStore();
  List<CustomCategory> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() => _isLoading = true);
    final categories = await _store.getAll();
    if (mounted) {
      setState(() {
        _categories = categories;
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteCategory(CustomCategory category) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkSurface,
        title: Text(
          'Delete Category',
          style: AppTypography.h3.copyWith(color: AppColors.textPrimary),
        ),
        content: Text(
          'Are you sure you want to delete "${category.name}"?',
          style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _store.delete(category.id);
      await _loadCategories();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Category "${category.name}" deleted'),
            backgroundColor: AppColors.darkSurface,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: const AppTopBar(title: 'Manage Categories'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Custom Categories',
                        style: AppTypography.h3.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _showCreateDialog(),
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Add Category'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _categories.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.category_outlined,
                                size: 64,
                                color: AppColors.textMuted,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Text(
                                'No custom categories yet',
                                style: AppTypography.bodyLarge.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              TextButton(
                                onPressed: () => _showCreateDialog(),
                                child: const Text('Create your first category'),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                          ),
                          itemCount: _categories.length,
                          itemBuilder: (context, index) {
                            final category = _categories[index];
                            return Card(
                              color: AppColors.darkSurface,
                              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Color(category.colorValue)
                                      .withValues(alpha: 0.2),
                                  child: Icon(
                                    IconData(
                                      category.iconCodePoint,
                                      fontFamily: 'MaterialIcons',
                                    ),
                                    color: Color(category.colorValue),
                                  ),
                                ),
                                title: Text(
                                  category.name,
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                subtitle: category.keywords.isNotEmpty
                                    ? Text(
                                        'Keywords: ${category.keywords.join(", ")}',
                                        style: AppTypography.caption.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                      )
                                    : null,
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, size: 20),
                                      onPressed: () =>
                                          _showEditDialog(category),
                                      color: AppColors.textSecondary,
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, size: 20),
                                      onPressed: () => _deleteCategory(category),
                                      color: AppColors.error,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDialog(),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showCreateDialog() {
    _showCategoryDialog();
  }

  void _showEditDialog(CustomCategory category) {
    _showCategoryDialog(category: category);
  }

  void _showCategoryDialog({CustomCategory? category}) {
    final nameController = TextEditingController(text: category?.name ?? '');
    final keywordsController = TextEditingController(
      text: category?.keywords.join(', ') ?? '',
    );
    Color selectedColor = category != null
        ? Color(category.colorValue)
        : AppColors.primary;
    int selectedIcon = category?.iconCodePoint ?? Icons.category.codePoint;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppColors.darkSurface,
          title: Text(
            category == null ? 'Create Category' : 'Edit Category',
            style: AppTypography.h3.copyWith(color: AppColors.textPrimary),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Category Name',
                    labelStyle: TextStyle(color: AppColors.textSecondary),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.textMuted),
                    ),
                  ),
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: keywordsController,
                  decoration: InputDecoration(
                    labelText: 'Keywords (comma-separated)',
                    hintText: 'e.g., swiggy, zomato, food',
                    labelStyle: TextStyle(color: AppColors.textSecondary),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.textMuted),
                    ),
                  ),
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Icon',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  children: [
                    Icons.restaurant,
                    Icons.shopping_bag,
                    Icons.movie,
                    Icons.school,
                    Icons.local_hospital,
                    Icons.directions_car,
                    Icons.sports_esports,
                    Icons.home,
                    Icons.work,
                    Icons.fitness_center,
                  ].map((icon) {
                    final isSelected = icon.codePoint == selectedIcon;
                    return GestureDetector(
                      onTap: () {
                        setDialogState(() => selectedIcon = icon.codePoint);
                      },
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? selectedColor.withValues(alpha: 0.3)
                              : AppColors.darkCard,
                          border: Border.all(
                            color: isSelected
                                ? selectedColor
                                : AppColors.textMuted,
                            width: isSelected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          icon,
                          color: isSelected
                              ? selectedColor
                              : AppColors.textSecondary,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Color',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  children: [
                    AppColors.primary,
                    AppColors.categoryFood,
                    AppColors.categoryTransport,
                    AppColors.categoryEntertainment,
                    AppColors.categoryEducation,
                    AppColors.categoryShopping,
                    AppColors.categoryBills,
                    AppColors.categoryHealth,
                    AppColors.accent,
                    AppColors.warning,
                  ].map((color) {
                    final isSelected = color.toARGB32() == selectedColor.toARGB32();
                    return GestureDetector(
                      onTap: () {
                        setDialogState(() => selectedColor = color);
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? Colors.white
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text.trim();
                if (name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Name is required')),
                  );
                  return;
                }

                final keywords = keywordsController.text
                    .split(',')
                    .map((s) => s.trim())
                    .where((s) => s.isNotEmpty)
                    .toList();

                final newCategory = CustomCategory(
                  id: category?.id ?? const Uuid().v4(),
                  name: name,
                  iconCodePoint: selectedIcon,
                  colorValue: selectedColor.toARGB32(),
                  keywords: keywords,
                  createdAt: category?.createdAt ?? DateTime.now(),
                );

                if (category == null) {
                  await _store.add(newCategory);
                } else {
                  await _store.update(newCategory);
                }

                await _loadCategories();
                if (!mounted) return;
                Navigator.pop(context);
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      category == null
                          ? 'Category created'
                          : 'Category updated',
                    ),
                    backgroundColor: AppColors.darkSurface,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: Text(category == null ? 'Create' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }
}

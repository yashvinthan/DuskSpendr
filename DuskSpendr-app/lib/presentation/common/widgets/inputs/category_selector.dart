import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';

/// Category model for selection
class Category {
  final String name;
  final IconData icon;
  final Color color;
  final String? emoji;

  const Category({
    required this.name,
    required this.icon,
    required this.color,
    this.emoji,
  });
}

/// Default expense categories
class ExpenseCategories {
  static const food = Category(
    name: 'Food',
    icon: Icons.restaurant,
    color: AppColors.categoryFood,
    emoji: '🍔',
  );
  static const transport = Category(
    name: 'Transport',
    icon: Icons.directions_car,
    color: AppColors.categoryTransport,
    emoji: '🚗',
  );
  static const entertainment = Category(
    name: 'Entertainment',
    icon: Icons.movie,
    color: AppColors.categoryEntertainment,
    emoji: '🎮',
  );
  static const education = Category(
    name: 'Education',
    icon: Icons.school,
    color: AppColors.categoryEducation,
    emoji: '📚',
  );
  static const shopping = Category(
    name: 'Shopping',
    icon: Icons.shopping_bag,
    color: AppColors.categoryShopping,
    emoji: '🛒',
  );
  static const bills = Category(
    name: 'Bills',
    icon: Icons.receipt_long,
    color: AppColors.categoryBills,
    emoji: '📄',
  );
  static const savings = Category(
    name: 'Savings',
    icon: Icons.savings,
    color: AppColors.categorySavings,
    emoji: '💰',
  );
  static const health = Category(
    name: 'Health',
    icon: Icons.local_hospital,
    color: Color(0xFFE91E63),
    emoji: '🏥',
  );
  
  static const List<Category> all = [
    food,
    transport,
    entertainment,
    education,
    shopping,
    bills,
    savings,
    health,
  ];
}

/// Category selector widget showing grid of category options
class CategorySelector extends StatelessWidget {
  final Category? selectedCategory;
  final ValueChanged<Category> onSelected;
  final List<Category> categories;
  final bool showAllOption;
  final int crossAxisCount;

  const CategorySelector({
    super.key,
    this.selectedCategory,
    required this.onSelected,
    this.categories = const [],
    this.showAllOption = false,
    this.crossAxisCount = 4,
  });

  List<Category> get _categories {
    if (categories.isNotEmpty) return categories;
    return ExpenseCategories.all;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: _categories.map((category) {
        final isSelected = selectedCategory?.name == category.name;
        return _CategoryItem(
          category: category,
          isSelected: isSelected,
          onTap: () => onSelected(category),
        );
      }).toList(),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final Category category;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryItem({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 72,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? category.color.withValues(alpha: 0.2)
              : AppColors.darkSurface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isSelected
                ? category.color
                : AppColors.dusk700.withValues(alpha: 0.5),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (category.emoji != null)
              Text(
                category.emoji!,
                style: const TextStyle(fontSize: 24),
              )
            else
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: category.color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    category.icon,
                    color: category.color,
                    size: 22,
                  ),
                ),
              ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              category.name,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

/// Horizontal scrollable category filter chips
class CategoryFilterChips extends StatelessWidget {
  final String? selectedCategory;
  final ValueChanged<String?> onSelected;
  final List<Category> categories;

  const CategoryFilterChips({
    super.key,
    this.selectedCategory,
    required this.onSelected,
    this.categories = const [],
  });

  List<Category> get _categories {
    if (categories.isNotEmpty) return categories;
    return ExpenseCategories.all;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _FilterChip(
            label: 'All',
            isSelected: selectedCategory == null,
            onTap: () => onSelected(null),
          ),
          const SizedBox(width: AppSpacing.sm),
          ..._categories.map((category) {
            final isSelected = selectedCategory == category.name;
            return Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: _FilterChip(
                label: category.name,
                icon: category.emoji,
                isSelected: isSelected,
                onTap: () => onSelected(category.name),
                color: category.color,
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final String? icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;

  const _FilterChip({
    required this.label,
    this.icon,
    required this.isSelected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.gradientDusk : null,
          color: isSelected ? null : AppColors.darkSurface,
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: isSelected
              ? null
              : Border.all(
                  color: AppColors.dusk700.withValues(alpha: 0.5),
                ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Text(icon!, style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/typography.dart';
import '../../../providers/auth_providers.dart';
import '../../../providers/data_providers.dart';

class BudgetCreateScreen extends ConsumerStatefulWidget {
  const BudgetCreateScreen({super.key});

  @override
  ConsumerState<BudgetCreateScreen> createState() => _BudgetCreateScreenState();
}

class _BudgetCreateScreenState extends ConsumerState<BudgetCreateScreen> {
  final _nameController = TextEditingController();
  final _limitController = TextEditingController();
  String _period = 'monthly';

  @override
  void dispose() {
    _nameController.dispose();
    _limitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.gradientNight),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenHorizontal,
              vertical: AppSpacing.screenVertical,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                ),
                Text('Create Budget',
                    style: AppTypography.h2.copyWith(
                      color: AppColors.textPrimary,
                    )),
                const SizedBox(height: AppSpacing.lg),
                TextField(
                  controller: _nameController,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(hintText: 'Name'),
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: _limitController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(hintText: 'Limit (₹)'),
                ),
                const SizedBox(height: AppSpacing.md),
                DropdownButtonFormField<String>(
                  value: _period,
                  dropdownColor: AppColors.darkSurface,
                  items: const [
                    DropdownMenuItem(value: 'daily', child: Text('Daily')),
                    DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
                    DropdownMenuItem(value: 'monthly', child: Text('Monthly')),
                  ],
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() => _period = value);
                  },
                  decoration: const InputDecoration(hintText: 'Period'),
                ),
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final token =
                          await ref.read(sessionStoreProvider).readToken();
                      if (token == null) return;
                      final limit =
                          int.tryParse(_limitController.text.trim()) ?? 0;
                      if (limit <= 0) return;
                      await ref.read(budgetsApiProvider).create(
                            token: token,
                            name: _nameController.text.trim(),
                            limitPaisa: limit * 100,
                            period: _period,
                          );
                      if (!mounted) return;
                      ref.invalidate(budgetsProvider);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Create Budget'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

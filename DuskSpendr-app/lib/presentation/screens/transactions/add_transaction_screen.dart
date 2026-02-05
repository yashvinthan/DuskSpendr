import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/typography.dart';
import '../../../providers/auth_providers.dart';
import '../../../providers/data_providers.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  ConsumerState<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _amountController = TextEditingController();
  final _merchantController = TextEditingController();
  String _category = 'food';

  @override
  void dispose() {
    _amountController.dispose();
    _merchantController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
              Text('Add Expense',
                  style: AppTypography.h2.copyWith(
                    color: AppColors.textPrimary,
                  )),
              const SizedBox(height: AppSpacing.lg),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(hintText: 'Amount (₹)'),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _merchantController,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(hintText: 'Merchant'),
              ),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<String>(
                value: _category,
                dropdownColor: AppColors.darkSurface,
                items: const [
                  DropdownMenuItem(value: 'food', child: Text('Food')),
                  DropdownMenuItem(value: 'transportation', child: Text('Transport')),
                  DropdownMenuItem(value: 'entertainment', child: Text('Entertainment')),
                  DropdownMenuItem(value: 'education', child: Text('Education')),
                  DropdownMenuItem(value: 'shopping', child: Text('Shopping')),
                  DropdownMenuItem(value: 'utilities', child: Text('Utilities')),
                  DropdownMenuItem(value: 'other', child: Text('Other')),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _category = value);
                },
                decoration: const InputDecoration(hintText: 'Category'),
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final token =
                        await ref.read(sessionStoreProvider).readToken();
                    if (token == null) return;
                    final amount =
                        int.tryParse(_amountController.text.trim()) ?? 0;
                    if (amount <= 0) return;
                    await ref.read(transactionsApiProvider).create(
                          token: token,
                          amountPaisa: amount * 100,
                          type: 'debit',
                          category: _category,
                          source: 'manual',
                          timestamp: DateTime.now(),
                          merchantName: _merchantController.text.trim(),
                        );
                    if (!mounted) return;
                    ref.invalidate(transactionsProvider);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Transaction saved')),
                    );
                  },
                  child: const Text('Save Transaction'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

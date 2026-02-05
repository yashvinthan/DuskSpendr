import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/typography.dart';
import '../../../data/models/transaction_model.dart';
import '../../../providers/auth_providers.dart';
import '../../../providers/data_providers.dart';

class EditTransactionScreen extends ConsumerStatefulWidget {
  const EditTransactionScreen({super.key, required this.tx});

  final TransactionModel tx;

  @override
  ConsumerState<EditTransactionScreen> createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends ConsumerState<EditTransactionScreen> {
  late final TextEditingController _amountController;
  late final TextEditingController _merchantController;
  late String _category;

  @override
  void initState() {
    super.initState();
    _amountController =
        TextEditingController(text: (widget.tx.amountPaisa / 100).toString());
    _merchantController =
        TextEditingController(text: widget.tx.merchantName ?? '');
    _category = widget.tx.category;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _merchantController.dispose();
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
                Text('Edit Transaction',
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
                      await ref.read(transactionsApiProvider).update(
                            token: token,
                            id: widget.tx.id,
                            amountPaisa: amount * 100,
                            type: widget.tx.type,
                            category: _category,
                            source: widget.tx.source,
                            timestamp: widget.tx.timestamp,
                            merchantName: _merchantController.text.trim(),
                            description: widget.tx.description,
                          );
                      if (!mounted) return;
                      ref.invalidate(transactionsProvider);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Save Changes'),
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

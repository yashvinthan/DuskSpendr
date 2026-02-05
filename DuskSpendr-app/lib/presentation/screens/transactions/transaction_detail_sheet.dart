import 'package:flutter/material.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/typography.dart';
import '../../../data/models/transaction_model.dart';
import 'edit_transaction_screen.dart';

class TransactionDetailSheet extends StatelessWidget {
  const TransactionDetailSheet({super.key, required this.tx});

  final TransactionModel tx;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.dusk700,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(tx.merchantName ?? 'Transaction',
              style: AppTypography.h2.copyWith(
                color: AppColors.textPrimary,
              )),
          const SizedBox(height: AppSpacing.sm),
          Text(tx.amountLabel,
              style: AppTypography.displayLarge.copyWith(
                fontSize: 32,
                color: tx.type == 'credit'
                    ? AppColors.success
                    : AppColors.textPrimary,
              )),
          const SizedBox(height: AppSpacing.md),
          _DetailRow(label: 'Category', value: tx.category),
          _DetailRow(label: 'Source', value: tx.source),
          _DetailRow(label: 'Time', value: tx.timestamp.toLocal().toString()),
          if (tx.description != null)
            _DetailRow(label: 'Note', value: tx.description!),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => EditTransactionScreen(tx: tx),
                  ),
                );
              },
              child: const Text('Edit Transaction'),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Expanded(
            child: Text(label,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                )),
          ),
          Expanded(
            child: Text(value,
                textAlign: TextAlign.right,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                )),
          ),
        ],
      ),
    );
  }
}

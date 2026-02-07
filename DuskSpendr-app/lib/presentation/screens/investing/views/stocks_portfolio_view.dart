import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../providers/investing_providers.dart';
import '../widgets/stock_holding_card.dart';

class StocksPortfolioView extends ConsumerWidget {
  const StocksPortfolioView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stocksAsync = ref.watch(stockHoldingsProvider);

    return stocksAsync.when(
      data: (stocks) => ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: stocks.length,
        itemBuilder: (context, index) {
          return StockHoldingCard(holding: stocks[index]);
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: AppColors.error))),
    );
  }
}

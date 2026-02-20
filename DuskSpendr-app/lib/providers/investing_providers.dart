import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/repositories/investing_repository.dart';
import '../data/repository/mock_investing_repository.dart';
import '../domain/entities/investing/portfolio_summary.dart';
import '../domain/entities/investing/stock_holding.dart';
import '../domain/entities/investing/mf_holding.dart';
import '../domain/entities/investing/fixed_deposit.dart';
import '../domain/entities/investing/savings_goal.dart';
import '../domain/entities/investing/emergency_fund.dart';

final investingRepositoryProvider = Provider<InvestingRepository>((ref) {
  return MockInvestingRepository();
});

final portfolioSummaryProvider = FutureProvider<PortfolioSummary>((ref) async {
  final repository = ref.watch(investingRepositoryProvider);
  return repository.getPortfolioSummary();
});

final stockHoldingsProvider = FutureProvider<List<StockHolding>>((ref) async {
  final repository = ref.watch(investingRepositoryProvider);
  return repository.getStockHoldings();
});

final mutualFundHoldingsProvider = FutureProvider<List<MFHolding>>((ref) async {
  final repository = ref.watch(investingRepositoryProvider);
  return repository.getMFHoldings();
});

final fixedDepositsProvider = FutureProvider<List<FixedDeposit>>((ref) async {
  final repository = ref.watch(investingRepositoryProvider);
  return repository.getFixedDeposits();
});

final savingsGoalsProvider = FutureProvider<List<SavingsGoal>>((ref) async {
  final repository = ref.watch(investingRepositoryProvider);
  return repository.getSavingsGoals();
});

final emergencyFundProvider = FutureProvider<EmergencyFund>((ref) async {
  final repository = ref.watch(investingRepositoryProvider);
  return repository.getEmergencyFund();
});

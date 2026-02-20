import '../entities/investing/portfolio_summary.dart';
import '../entities/investing/stock_holding.dart';
import '../entities/investing/mf_holding.dart';
import '../entities/investing/fixed_deposit.dart';
import '../entities/investing/savings_goal.dart';
import '../entities/investing/emergency_fund.dart';

abstract class InvestingRepository {
  Future<PortfolioSummary> getPortfolioSummary();
  Future<List<StockHolding>> getStockHoldings();
  Future<List<MFHolding>> getMFHoldings();
  Future<List<FixedDeposit>> getFixedDeposits();
  Future<List<SavingsGoal>> getSavingsGoals();
  Future<EmergencyFund> getEmergencyFund();
}

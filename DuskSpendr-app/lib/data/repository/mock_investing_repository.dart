import '../../domain/entities/money.dart';
import '../../domain/entities/investing/asset_class.dart';
import '../../domain/entities/investing/portfolio_summary.dart';
import '../../domain/entities/investing/stock_holding.dart';
import '../../domain/entities/investing/mf_holding.dart';
import '../../domain/entities/investing/fixed_deposit.dart';
import '../../domain/entities/investing/savings_goal.dart';
import '../../domain/entities/investing/emergency_fund.dart';
import '../../domain/repositories/investing_repository.dart';

class MockInvestingRepository implements InvestingRepository {
  @override
  Future<PortfolioSummary> getPortfolioSummary() async {
    return PortfolioSummary(
      totalValue: Money.fromRupees(245680),
      invested: Money.fromRupees(218500),
      returns: Money.fromRupees(27180),
      returnsPercentage: 12.4,
      allocation: {
        AssetClass.equity: 45,
        AssetClass.mutualFund: 30,
        AssetClass.fixedDeposit: 15,
        AssetClass.gold: 8,
        AssetClass.savings: 2,
      },
      upcomingEvents: [
        UpcomingEvent(
          date: DateTime.now().add(const Duration(days: 2)),
          title: 'SIP - Axis Small Cap',
          amount: Money.fromRupees(1000),
          type: EventType.sip,
        ),
        UpcomingEvent(
          date: DateTime.now().add(const Duration(days: 7)),
          title: 'FD Maturity',
          amount: Money.fromRupees(15000),
          type: EventType.fdMaturity,
        ),
      ],
    );
  }

  @override
  Future<List<StockHolding>> getStockHoldings() async {
    return [
      StockHolding(
        symbol: 'RELIANCE',
        name: 'Reliance Industries Ltd',
        quantity: 5,
        buyPrice: Money.fromRupees(2450),
        currentPrice: Money.fromRupees(2520),
        purchaseDate: DateTime(2024, 1, 15),
        broker: 'Zerodha',
      ),
      StockHolding(
        symbol: 'INFY',
        name: 'Infosys Ltd',
        quantity: 10,
        buyPrice: Money.fromRupees(1420),
        currentPrice: Money.fromRupees(1510),
        purchaseDate: DateTime(2023, 11, 20),
        broker: 'Zerodha',
      ),
      StockHolding(
        symbol: 'TATAMOTORS',
        name: 'Tata Motors Ltd',
        quantity: 20,
        buyPrice: Money.fromRupees(650),
        currentPrice: Money.fromRupees(712),
        purchaseDate: DateTime(2023, 12, 10),
        broker: 'Groww',
      ),
    ];
  }

  @override
  Future<List<MFHolding>> getMFHoldings() async {
    return [
      MFHolding(
        schemeCode: 'AXIS_SMALL_CAP',
        schemeName: 'Axis Small Cap Fund Direct Growth',
        units: 420.5,
        nav: Money.fromRupees(76.45),
        invested: Money.fromRupees(24000),
        category: MFCategory.equitySmallCap,
        isSIP: true,
        sipDetails: SIPDetails(
          amount: Money.fromRupees(1000),
          dayOfMonth: 5,
          nextDueDate: DateTime.now().add(const Duration(days: 2)),
        ),
      ),
      MFHolding(
        schemeCode: 'UTI_NIFTY_50',
        schemeName: 'UTI Nifty 50 Index Fund Direct Growth',
        units: 180.2,
        nav: Money.fromRupees(176.45),
        invested: Money.fromRupees(28000),
        category: MFCategory.indexFund,
        isSIP: true,
        sipDetails: SIPDetails(
          amount: Money.fromRupees(2000),
          dayOfMonth: 15,
          nextDueDate: DateTime.now().add(const Duration(days: 12)),
        ),
      ),
    ];
  }

  @override
  Future<List<FixedDeposit>> getFixedDeposits() async {
    return [
      FixedDeposit(
        bankName: 'SBI',
        principal: Money.fromRupees(15000),
        interestRate: 7.25,
        startDate: DateTime(2024, 2, 10),
        maturityDate: DateTime(2025, 2, 10),
        maturityAmount: Money.fromRupees(16087),
      ),
      FixedDeposit(
        bankName: 'HDFC Bank',
        principal: Money.fromRupees(20000),
        interestRate: 7.75,
        startDate: DateTime(2023, 11, 15),
        maturityDate: DateTime(2025, 5, 15),
        maturityAmount: Money.fromRupees(22325),
        autoRenew: true,
      ),
    ];
  }

  @override
  Future<List<SavingsGoal>> getSavingsGoals() async {
    return [
      SavingsGoal(
        id: 'goal_1',
        name: 'Higher Studies',
        icon: 'education', // Assuming icon path or logic handled elsewhere
        targetAmount: Money.fromRupees(200000),
        savedAmount: Money.fromRupees(15000),
        deadline: DateTime(2026, 12, 31),
        priority: GoalPriority.high,
      ),
      SavingsGoal(
        id: 'goal_2',
        name: 'New Laptop',
        icon: 'laptop',
        targetAmount: Money.fromRupees(70000),
        savedAmount: Money.fromRupees(35000),
        deadline: DateTime(2025, 9, 30),
        priority: GoalPriority.medium,
      ),
    ];
  }

  @override
  Future<EmergencyFund> getEmergencyFund() async {
    return EmergencyFund(
      currentAmount: Money.fromRupees(4914),
      goalAmount: Money.fromRupees(50000),
      sources: [
        EmergencyFundSource(
          name: 'SBI Savings Account',
          amount: Money.fromRupees(2000),
          type: 'Savings Account',
        ),
        EmergencyFundSource(
          name: 'Nippon Liquid Fund',
          amount: Money.fromRupees(2914),
          type: 'Liquid Fund',
        ),
      ],
    );
  }
}

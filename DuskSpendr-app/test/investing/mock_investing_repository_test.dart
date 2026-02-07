import 'package:flutter_test/flutter_test.dart';
import 'package:duskspendr/data/repository/mock_investing_repository.dart';
import 'package:duskspendr/domain/entities/investing/asset_class.dart';
import 'package:duskspendr/domain/entities/investing/mf_holding.dart';

void main() {
  group('MockInvestingRepository', () {
    late MockInvestingRepository repository;

    setUp(() {
      repository = MockInvestingRepository();
    });

    test('getPortfolioSummary returns valid data', () async {
      final summary = await repository.getPortfolioSummary();
      expect(summary.totalValue.inRupees, 245680);
      expect(summary.allocation.containsKey(AssetClass.equity), true);
    });

    test('getStockHoldings returns list of stocks', () async {
      final stocks = await repository.getStockHoldings();
      expect(stocks.isNotEmpty, true);
      expect(stocks.first.symbol, 'RELIANCE');
    });

    test('getMFHoldings returns list of MFs', () async {
      final mfs = await repository.getMFHoldings();
      expect(mfs.isNotEmpty, true);
      expect(mfs.first.category, MFCategory.equitySmallCap);
    });
  });
}

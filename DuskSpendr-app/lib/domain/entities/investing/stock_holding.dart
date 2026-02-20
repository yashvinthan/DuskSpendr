import '../money.dart';

class StockHolding {
  final String symbol;
  final String name;
  final int quantity;
  final Money buyPrice;
  final Money currentPrice;
  final DateTime purchaseDate;
  final String? broker;

  StockHolding({
    required this.symbol,
    required this.name,
    required this.quantity,
    required this.buyPrice,
    required this.currentPrice,
    required this.purchaseDate,
    this.broker,
  });

  Money get totalValue => currentPrice * quantity;
  Money get investedValue => buyPrice * quantity;
  Money get returns => totalValue - investedValue;
  double get returnsPercentage {
    if (investedValue.paisa == 0) return 0;
    return (returns.paisa / investedValue.paisa) * 100;
  }
}

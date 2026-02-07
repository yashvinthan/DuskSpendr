import '../money.dart';
import 'asset_class.dart';

class PortfolioSummary {
  final Money totalValue;
  final Money invested;
  final Money returns;
  final double returnsPercentage;
  final Map<AssetClass, double> allocation;
  final List<UpcomingEvent> upcomingEvents;

  PortfolioSummary({
    required this.totalValue,
    required this.invested,
    required this.returns,
    required this.returnsPercentage,
    required this.allocation,
    required this.upcomingEvents,
  });
}

class UpcomingEvent {
  final DateTime date;
  final String title;
  final Money amount;
  final EventType type;

  UpcomingEvent({
    required this.date,
    required this.title,
    required this.amount,
    required this.type,
  });
}

enum EventType {
  sip,
  fdMaturity,
  dividend,
  other,
}

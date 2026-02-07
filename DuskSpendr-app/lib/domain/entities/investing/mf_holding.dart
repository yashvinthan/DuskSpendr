import '../money.dart';

class MFHolding {
  final String schemeCode;
  final String schemeName;
  final double units;
  final Money nav;
  final Money invested;
  final MFCategory category;
  final bool isSIP;
  final SIPDetails? sipDetails;

  MFHolding({
    required this.schemeCode,
    required this.schemeName,
    required this.units,
    required this.nav,
    required this.invested,
    required this.category,
    required this.isSIP,
    this.sipDetails,
  });

  Money get currentValue => nav * units;
  Money get returns => currentValue - invested;
  double get returnsPercentage {
    if (invested.paisa == 0) return 0;
    return (returns.paisa / invested.paisa) * 100;
  }
}

class SIPDetails {
  final Money amount;
  final int dayOfMonth;
  final DateTime nextDueDate;

  SIPDetails({
    required this.amount,
    required this.dayOfMonth,
    required this.nextDueDate,
  });
}

enum MFCategory {
  equityLargeCap,
  equityMidCap,
  equitySmallCap,
  equityFlexiCap,
  debt,
  hybrid,
  indexFund,
  elss,
  other,
}

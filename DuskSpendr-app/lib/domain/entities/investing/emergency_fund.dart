import '../money.dart';

class EmergencyFund {
  final Money currentAmount;
  final Money goalAmount;
  final List<EmergencyFundSource> sources;

  EmergencyFund({
    required this.currentAmount,
    required this.goalAmount,
    required this.sources,
  });

  double get percentageFunded {
    if (goalAmount.paisa == 0) return 0;
    return (currentAmount.paisa / goalAmount.paisa).clamp(0.0, 1.0);
  }
}

class EmergencyFundSource {
  final String name;
  final Money amount;
  final String type; // e.g. "Savings Account", "Liquid Fund"

  EmergencyFundSource({
    required this.name,
    required this.amount,
    required this.type,
  });
}

import '../money.dart';

class SavingsGoal {
  final String id;
  final String name;
  final String icon;
  final Money targetAmount;
  final Money savedAmount;
  final DateTime? deadline;
  final GoalPriority priority;

  SavingsGoal({
    required this.id,
    required this.name,
    required this.icon,
    required this.targetAmount,
    required this.savedAmount,
    this.deadline,
    this.priority = GoalPriority.medium,
  });

  double get progress {
    if (targetAmount.paisa == 0) return 0;
    return (savedAmount.paisa / targetAmount.paisa).clamp(0.0, 1.0);
  }
}

enum GoalPriority {
  low,
  medium,
  high,
}

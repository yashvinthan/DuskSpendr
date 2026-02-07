import '../money.dart';

class FixedDeposit {
  final String bankName;
  final Money principal;
  final double interestRate;
  final DateTime startDate;
  final DateTime maturityDate;
  final Money maturityAmount;
  final bool autoRenew;

  FixedDeposit({
    required this.bankName,
    required this.principal,
    required this.interestRate,
    required this.startDate,
    required this.maturityDate,
    required this.maturityAmount,
    this.autoRenew = false,
  });

  Money get interestEarned => maturityAmount - principal;
}

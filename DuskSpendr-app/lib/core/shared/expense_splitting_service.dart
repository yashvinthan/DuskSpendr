import 'dart:math';

import '../../domain/entities/entities.dart';

/// SS-101: Expense splitting calculator service
/// Handles all split type calculations with proper rounding

class ExpenseSplittingService {
  /// Calculate equal split among participants
  /// Handles rounding by distributing remainder to first participants
  List<Participant> calculateEqualSplit({
    required Money totalAmount,
    required List<Participant> participants,
  }) {
    if (participants.isEmpty) return [];

    final count = participants.length;
    final baseShare = totalAmount.paisa ~/ count;
    final remainder = totalAmount.paisa % count;

    return participants.asMap().entries.map((entry) {
      final index = entry.key;
      final participant = entry.value;
      // Distribute remainder to first N participants
      final extraPaisa = index < remainder ? 1 : 0;
      return participant.copyWith(
        share: Money.fromPaisa(baseShare + extraPaisa),
      );
    }).toList();
  }

  /// Calculate percentage-based split
  /// Validates that percentages sum to 100
  List<Participant> calculatePercentageSplit({
    required Money totalAmount,
    required List<Participant> participants,
  }) {
    if (participants.isEmpty) return [];

    // Validate percentages
    final totalPercentage = participants.fold<double>(
      0,
      (sum, p) => sum + (p.percentage ?? 0),
    );

    if ((totalPercentage - 100).abs() > 0.01) {
      throw ArgumentError('Percentages must sum to 100, got $totalPercentage');
    }

    // Calculate shares
    int allocatedPaisa = 0;
    final shares = <Participant>[];

    for (int i = 0; i < participants.length; i++) {
      final participant = participants[i];
      final percentage = participant.percentage ?? 0;

      // For last participant, give remainder to avoid rounding errors
      int sharePaisa;
      if (i == participants.length - 1) {
        sharePaisa = totalAmount.paisa - allocatedPaisa;
      } else {
        sharePaisa = (totalAmount.paisa * percentage / 100).round();
      }

      allocatedPaisa += sharePaisa;
      shares.add(participant.copyWith(
        share: Money.fromPaisa(sharePaisa),
      ));
    }

    return shares;
  }

  /// Calculate exact amount split
  /// Validates that amounts sum to total
  List<Participant> calculateExactSplit({
    required Money totalAmount,
    required List<Participant> participants,
  }) {
    if (participants.isEmpty) return [];

    // Validate that shares sum to total
    final totalShares = participants.fold<int>(
      0,
      (sum, p) => sum + p.share.paisa,
    );

    if (totalShares != totalAmount.paisa) {
      throw ArgumentError(
        'Exact amounts must sum to total. Expected ${totalAmount.paisa}, got $totalShares',
      );
    }

    // Shares are already set, just return
    return participants;
  }

  /// Calculate shares-based split (1x, 2x, 3x, etc.)
  /// Each participant has a share unit, total is divided proportionally
  List<Participant> calculateSharesSplit({
    required Money totalAmount,
    required List<Participant> participants,
  }) {
    if (participants.isEmpty) return [];

    final totalUnits = participants.fold<int>(
      0,
      (sum, p) => sum + (p.shareUnits ?? 1),
    );

    if (totalUnits == 0) {
      throw ArgumentError('Total share units must be > 0');
    }

    // Calculate per-unit value
    int allocatedPaisa = 0;
    final shares = <Participant>[];

    for (int i = 0; i < participants.length; i++) {
      final participant = participants[i];
      final units = participant.shareUnits ?? 1;

      // For last participant, give remainder
      int sharePaisa;
      if (i == participants.length - 1) {
        sharePaisa = totalAmount.paisa - allocatedPaisa;
      } else {
        sharePaisa = (totalAmount.paisa * units / totalUnits).round();
      }

      allocatedPaisa += sharePaisa;
      shares.add(participant.copyWith(
        share: Money.fromPaisa(sharePaisa),
      ));
    }

    return shares;
  }

  /// Calculate adjustment split (equal with manual adjustments)
  /// Base is equal, but some participants can have +/- adjustments
  List<Participant> calculateAdjustmentSplit({
    required Money totalAmount,
    required List<Participant> participants,
    required Map<String, int> adjustments, // participant ID -> adjustment in paisa
  }) {
    if (participants.isEmpty) return [];

    // First calculate equal split
    final equalSplit = calculateEqualSplit(
      totalAmount: totalAmount,
      participants: participants,
    );

    // Apply adjustments
    int totalAdjustment = adjustments.values.fold(0, (a, b) => a + b);
    if (totalAdjustment != 0) {
      throw ArgumentError('Adjustments must sum to 0, got $totalAdjustment');
    }

    return equalSplit.map((p) {
      final adjustment = adjustments[p.id] ?? 0;
      return p.copyWith(
        share: Money.fromPaisa(p.share.paisa + adjustment),
      );
    }).toList();
  }

  /// Universal split calculator that dispatches to correct method
  List<Participant> calculateSplit({
    required Money totalAmount,
    required SplitType splitType,
    required List<Participant> participants,
    Map<String, int>? adjustments,
  }) {
    switch (splitType) {
      case SplitType.equal:
        return calculateEqualSplit(
          totalAmount: totalAmount,
          participants: participants,
        );
      case SplitType.percentage:
        return calculatePercentageSplit(
          totalAmount: totalAmount,
          participants: participants,
        );
      case SplitType.exact:
        return calculateExactSplit(
          totalAmount: totalAmount,
          participants: participants,
        );
      case SplitType.shares:
        return calculateSharesSplit(
          totalAmount: totalAmount,
          participants: participants,
        );
      case SplitType.adjustment:
        return calculateAdjustmentSplit(
          totalAmount: totalAmount,
          participants: participants,
          adjustments: adjustments ?? {},
        );
    }
  }

  /// Validate that calculated shares equal total amount
  bool validateSplit({
    required Money totalAmount,
    required List<Participant> participants,
  }) {
    final totalShares = participants.fold<int>(
      0,
      (sum, p) => sum + p.share.paisa,
    );
    return totalShares == totalAmount.paisa;
  }

  /// Suggest equal split with smart rounding
  /// Returns formatted display string for each participant
  Map<String, String> suggestEqualSplitDisplay({
    required Money totalAmount,
    required List<String> participantNames,
  }) {
    final count = participantNames.length;
    if (count == 0) return {};

    final perPerson = totalAmount.paisa / count;
    final roundedDown = (perPerson / 100).floor() * 100; // Round to nearest rupee
    final roundedUp = roundedDown + 100;

    // How many people pay rounded up?
    final remainder = totalAmount.paisa - (roundedDown * count);
    final payingMore = (remainder / 100).round();

    final result = <String, String>{};
    for (int i = 0; i < participantNames.length; i++) {
      final amount = i < payingMore ? roundedUp : roundedDown;
      result[participantNames[i]] = '₹${amount ~/ 100}';
    }

    return result;
  }

  /// Calculate who owes whom after an expense
  /// Returns a map of (debtor -> creditor -> amount)
  Map<String, Map<String, Money>> calculateDebts({
    required SharedExpense expense,
    required String selfId, // 'self' or actual user ID
  }) {
    final debts = <String, Map<String, Money>>{};

    for (final participant in expense.participants) {
      if (participant.hasPaid) continue; // Already settled

      final owes = participant.share.paisa;
      if (owes <= 0) continue;

      // Participant owes the payer
      if (participant.id != expense.paidById) {
        debts[participant.id] ??= {};
        debts[participant.id]![expense.paidById] = Money.fromPaisa(owes);
      }
    }

    return debts;
  }

  /// Simplify debts within a group
  /// A→B ₹100, B→C ₹100 becomes A→C ₹100
  List<SimplifiedDebt> simplifyDebts(List<SharedExpense> expenses, String selfId) {
    // Calculate net balance for each pair
    final balances = <String, int>{}; // positive = owed, negative = owes

    for (final expense in expenses) {
      if (expense.isFullySettled) continue;

      for (final participant in expense.participants) {
        if (participant.hasPaid) continue;

        // Participant owes their share
        final payer = expense.paidById;
        final amount = participant.share.paisa;

        // Update balances
        balances[participant.id] = (balances[participant.id] ?? 0) - amount;
        balances[payer] = (balances[payer] ?? 0) + amount;
      }
    }

    // Generate simplified debts
    final debtors = balances.entries.where((e) => e.value < 0).toList()
      ..sort((a, b) => a.value.compareTo(b.value)); // Most debt first
    final creditors = balances.entries.where((e) => e.value > 0).toList()
      ..sort((a, b) => b.value.compareTo(a.value)); // Most owed first

    final simplified = <SimplifiedDebt>[];
    int di = 0, ci = 0;

    while (di < debtors.length && ci < creditors.length) {
      final debtor = debtors[di];
      final creditor = creditors[ci];

      final debtAmount = -debtor.value;
      final creditAmount = creditor.value;
      final transfer = min(debtAmount, creditAmount);

      if (transfer > 0) {
        simplified.add(SimplifiedDebt(
          from: debtor.key,
          to: creditor.key,
          amount: Money.fromPaisa(transfer),
        ));
      }

      balances[debtor.key] = debtor.value + transfer;
      balances[creditor.key] = creditor.value - transfer;

      if (balances[debtor.key]! >= 0) di++;
      if (balances[creditor.key]! <= 0) ci++;
    }

    return simplified;
  }
}

/// Simplified debt between two people
class SimplifiedDebt {
  final String from;
  final String to;
  final Money amount;

  const SimplifiedDebt({
    required this.from,
    required this.to,
    required this.amount,
  });
}

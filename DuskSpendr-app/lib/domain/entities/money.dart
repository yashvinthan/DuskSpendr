/// Money value class for handling currency amounts
/// Provides INR formatting and arithmetic operations
class Money {
  final int paisa; // Store as smallest unit (paisa) for precision

  const Money._(this.paisa);

  /// Create Money from rupees
  factory Money.fromRupees(double rupees) {
    return Money._((rupees * 100).round());
  }

  /// Create Money from paisa
  factory Money.fromPaisa(int paisa) {
    return Money._(paisa);
  }

  /// Zero amount
  static const Money zero = Money._(0);

  /// Get amount in rupees
  double get inRupees => paisa / 100;

  /// Get amount in rupees (alias for convenience)
  double get rupees => inRupees;

  /// Format as INR string (e.g., "₹1,234.56")
  String get formatted {
    final rupeeAmount = inRupees;
    final isNegative = rupeeAmount < 0;
    final absAmount = rupeeAmount.abs();

    // Indian number formatting: 1,23,456.78
    final parts = absAmount.toStringAsFixed(2).split('.');
    final intPart = parts[0];
    final decPart = parts[1];

    String formattedInt;
    if (intPart.length <= 3) {
      formattedInt = intPart;
    } else {
      // First 3 digits from right, then groups of 2
      final firstPart = intPart.substring(intPart.length - 3);
      var remaining = intPart.substring(0, intPart.length - 3);
      final groups = <String>[];

      while (remaining.length > 2) {
        groups.insert(0, remaining.substring(remaining.length - 2));
        remaining = remaining.substring(0, remaining.length - 2);
      }
      if (remaining.isNotEmpty) {
        groups.insert(0, remaining);
      }

      formattedInt = '${groups.join(',')},${firstPart}';
    }

    final sign = isNegative ? '-' : '';
    return '$sign₹$formattedInt.$decPart';
  }

  /// Format as compact string (e.g., "₹1.2K", "₹12L")
  String get compact {
    final rupees = inRupees.abs();
    final sign = paisa < 0 ? '-' : '';

    if (rupees >= 10000000) {
      return '$sign₹${(rupees / 10000000).toStringAsFixed(1)}Cr';
    } else if (rupees >= 100000) {
      return '$sign₹${(rupees / 100000).toStringAsFixed(1)}L';
    } else if (rupees >= 1000) {
      return '$sign₹${(rupees / 1000).toStringAsFixed(1)}K';
    } else {
      return '$sign₹${rupees.toStringAsFixed(0)}';
    }
  }

  // Arithmetic operators
  Money operator +(Money other) => Money._(paisa + other.paisa);
  Money operator -(Money other) => Money._(paisa - other.paisa);
  Money operator *(num factor) => Money._((paisa * factor).round());
  Money operator /(num divisor) => Money._((paisa / divisor).round());
  Money operator -() => Money._(-paisa);

  // Comparison operators
  bool operator <(Money other) => paisa < other.paisa;
  bool operator <=(Money other) => paisa <= other.paisa;
  bool operator >(Money other) => paisa > other.paisa;
  bool operator >=(Money other) => paisa >= other.paisa;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Money && paisa == other.paisa;

  @override
  int get hashCode => paisa.hashCode;

  @override
  String toString() => formatted;

  /// Convert to JSON (stores paisa)
  int toJson() => paisa;

  /// Create from JSON
  factory Money.fromJson(int paisa) => Money._(paisa);
}

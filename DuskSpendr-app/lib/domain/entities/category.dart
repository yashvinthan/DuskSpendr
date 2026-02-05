import 'package:flutter/material.dart';

/// Expense categories with icons, colors, and display names
enum TransactionCategory {
  food(
    icon: Icons.restaurant,
    color: Color(0xFFFF6B6B),
    label: 'Food',
    labelHi: 'खाना',
    keywords: [
      'swiggy',
      'zomato',
      'dominos',
      'mcdonalds',
      'kfc',
      'pizza',
      'restaurant',
      'cafe',
      'canteen',
    ],
  ),
  transportation(
    icon: Icons.directions_car,
    color: Color(0xFF4ECDC4),
    label: 'Transport',
    labelHi: 'यातायात',
    keywords: [
      'uber',
      'ola',
      'rapido',
      'metro',
      'irctc',
      'railway',
      'bus',
      'petrol',
      'diesel',
      'fuel',
    ],
  ),
  entertainment(
    icon: Icons.movie,
    color: Color(0xFFFF9F43),
    label: 'Entertainment',
    labelHi: 'मनोरंजन',
    keywords: [
      'netflix',
      'hotstar',
      'prime',
      'spotify',
      'cinema',
      'pvr',
      'inox',
      'game',
      'steam',
    ],
  ),
  education(
    icon: Icons.school,
    color: Color(0xFF6C5CE7),
    label: 'Education',
    labelHi: 'शिक्षा',
    keywords: [
      'college',
      'university',
      'course',
      'udemy',
      'coursera',
      'book',
      'stationary',
      'tuition',
    ],
  ),
  shopping(
    icon: Icons.shopping_bag,
    color: Color(0xFFE84393),
    label: 'Shopping',
    labelHi: 'खरीदारी',
    keywords: [
      'amazon',
      'flipkart',
      'myntra',
      'ajio',
      'nykaa',
      'meesho',
      'mall',
      'store',
    ],
  ),
  utilities(
    icon: Icons.bolt,
    color: Color(0xFF00B894),
    label: 'Utilities',
    labelHi: 'बिल',
    keywords: [
      'electricity',
      'water',
      'gas',
      'wifi',
      'broadband',
      'jio',
      'airtel',
      'vi',
      'bsnl',
      'recharge',
    ],
  ),
  healthcare(
    icon: Icons.local_hospital,
    color: Color(0xFFED4956),
    label: 'Healthcare',
    labelHi: 'स्वास्थ्य',
    keywords: [
      'hospital',
      'doctor',
      'pharmacy',
      'medicine',
      'apollo',
      'medplus',
      '1mg',
      'pharmeasy',
    ],
  ),
  subscriptions(
    icon: Icons.autorenew,
    color: Color(0xFF9B59B6),
    label: 'Subscriptions',
    labelHi: 'सब्सक्रिप्शन',
    keywords: ['subscription', 'membership', 'gym', 'cult', 'premium'],
  ),
  investments(
    icon: Icons.trending_up,
    color: Color(0xFF27AE60),
    label: 'Investments',
    labelHi: 'निवेश',
    keywords: [
      'zerodha',
      'groww',
      'upstox',
      'mutual',
      'sip',
      'stock',
      'fd',
      'gold',
    ],
  ),
  loans(
    icon: Icons.account_balance,
    color: Color(0xFFE17055),
    label: 'Loans',
    labelHi: 'ऋण',
    keywords: ['emi', 'loan', 'credit', 'lazypay', 'simpl', 'slice', 'uni'],
  ),
  shared(
    icon: Icons.group,
    color: Color(0xFF00CEC9),
    label: 'Shared',
    labelHi: 'साझा',
    keywords: ['split', 'shared', 'group'],
  ),
  pocketMoney(
    icon: Icons.wallet,
    color: Color(0xFFFFD93D),
    label: 'Pocket Money',
    labelHi: 'पॉकेट मनी',
    keywords: ['pocket', 'allowance', 'parents', 'family', 'transfer'],
  ),
  other(
    icon: Icons.category,
    color: Color(0xFF636E72),
    label: 'Other',
    labelHi: 'अन्य',
    keywords: [],
  );

  final IconData icon;
  final Color color;
  final String label;
  final String labelHi;
  final List<String> keywords;

  const TransactionCategory({
    required this.icon,
    required this.color,
    required this.label,
    required this.labelHi,
    required this.keywords,
  });

  /// Get localized label
  String getLabel({bool hindi = false}) => hindi ? labelHi : label;

  /// Try to match category from merchant/description text
  static TransactionCategory? matchFromText(String text) {
    final lowerText = text.toLowerCase();
    for (final category in TransactionCategory.values) {
      for (final keyword in category.keywords) {
        if (lowerText.contains(keyword)) {
          return category;
        }
      }
    }
    return null;
  }
}

/// Transaction type
enum TransactionType {
  debit('Debit', 'डेबिट'),
  credit('Credit', 'क्रेडिट');

  final String label;
  final String labelHi;

  const TransactionType(this.label, this.labelHi);

  String getLabel({bool hindi = false}) => hindi ? labelHi : label;
}

/// Transaction source - where the transaction data came from
enum TransactionSource {
  manual('Manual Entry'),
  sms('SMS'),
  upiNotification('UPI Notification'),
  bankApi('Bank API'),
  imported('Imported');

  final String label;

  const TransactionSource(this.label);
}

/// Payment method
enum PaymentMethod {
  upi('UPI', Icons.qr_code),
  card('Card', Icons.credit_card),
  netBanking('Net Banking', Icons.account_balance),
  cash('Cash', Icons.money),
  wallet('Wallet', Icons.account_balance_wallet),
  bnpl('Buy Now Pay Later', Icons.schedule);

  final String label;
  final IconData icon;

  const PaymentMethod(this.label, this.icon);
}

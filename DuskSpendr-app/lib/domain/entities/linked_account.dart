import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'money.dart';

/// Type of linked account
enum AccountType {
  bank('Bank', Icons.account_balance),
  upi('UPI', Icons.qr_code),
  wallet('Wallet', Icons.account_balance_wallet),
  bnpl('BNPL', Icons.schedule),
  investment('Investment', Icons.trending_up),
  creditCard('Credit Card', Icons.credit_card);

  final String label;
  final IconData icon;

  const AccountType(this.label, this.icon);
}

/// Supported providers
enum AccountProvider {
  // Banks
  sbi('State Bank of India', 'SBI', AccountType.bank, Color(0xFF2196F3)),
  hdfc('HDFC Bank', 'HDFC', AccountType.bank, Color(0xFF004C8F)),
  icici('ICICI Bank', 'ICICI', AccountType.bank, Color(0xFFFF5722)),
  axis('Axis Bank', 'Axis', AccountType.bank, Color(0xFF97144D)),

  // UPI
  gpay('Google Pay', 'GPay', AccountType.upi, Color(0xFF4285F4)),
  phonepe('PhonePe', 'PhonePe', AccountType.upi, Color(0xFF5F259F)),
  paytmUpi('Paytm UPI', 'Paytm', AccountType.upi, Color(0xFF00BAF2)),

  // Wallets
  amazonPay('Amazon Pay', 'Amazon', AccountType.wallet, Color(0xFFFF9900)),
  paytmWallet('Paytm Wallet', 'Paytm', AccountType.wallet, Color(0xFF00BAF2)),

  // BNPL
  lazypay('LazyPay', 'LazyPay', AccountType.bnpl, Color(0xFF6C63FF)),
  simpl('Simpl', 'Simpl', AccountType.bnpl, Color(0xFFFF4D4D)),
  amazonPayLater(
    'Amazon Pay Later',
    'APL',
    AccountType.bnpl,
    Color(0xFFFF9900),
  ),

  // Investment
  zerodha('Zerodha', 'Zerodha', AccountType.investment, Color(0xFF387ED1)),
  groww('Groww', 'Groww', AccountType.investment, Color(0xFF00D09C)),
  upstox('Upstox', 'Upstox', AccountType.investment, Color(0xFF8A2BE2)),
  angelOne('Angel One', 'Angel', AccountType.investment, Color(0xFFFF6600)),
  indmoney('INDmoney', 'INDm', AccountType.investment, Color(0xFF6366F1)),
  zerodhaCoins(
    'Coin by Zerodha',
    'Coin',
    AccountType.investment,
    Color(0xFF387ED1),
  );

  final String fullName;
  final String shortName;
  final AccountType type;
  final Color brandColor;

  const AccountProvider(
    this.fullName,
    this.shortName,
    this.type,
    this.brandColor,
  );
}

/// Connection/sync status
enum AccountStatus {
  active('Active', Colors.green),
  syncing('Syncing', Colors.orange),
  error('Error', Colors.red),
  expired('Expired', Colors.grey),
  pending('Pending', Colors.amber);

  final String label;
  final Color color;

  const AccountStatus(this.label, this.color);
}

/// Linked account entity
class LinkedAccount extends Equatable {
  final String id;
  final AccountProvider provider;
  final String? accountNumber; // Masked: XXXX1234
  final String? accountName; // User's name or account label
  final String? upiId; // For UPI accounts
  final Money? balance;
  final DateTime? balanceUpdatedAt;
  final AccountStatus status;
  final String? accessToken; // Encrypted
  final String? refreshToken; // Encrypted
  final DateTime? tokenExpiresAt;
  final DateTime lastSyncedAt;
  final DateTime linkedAt;
  final bool isPrimary;
  final Map<String, dynamic>? metadata;

  LinkedAccount({
    String? id,
    required this.provider,
    this.accountNumber,
    this.accountName,
    this.upiId,
    this.balance,
    this.balanceUpdatedAt,
    this.status = AccountStatus.pending,
    this.accessToken,
    this.refreshToken,
    this.tokenExpiresAt,
    DateTime? lastSyncedAt,
    DateTime? linkedAt,
    this.isPrimary = false,
    this.metadata,
  }) : id = id ?? const Uuid().v4(),
       lastSyncedAt = lastSyncedAt ?? DateTime.now(),
       linkedAt = linkedAt ?? DateTime.now();

  /// Get account type from provider
  AccountType get type => provider.type;

  /// Display name for the account
  String get displayName {
    if (accountName != null) return accountName!;
    if (upiId != null) return upiId!;
    if (accountNumber != null) return '${provider.shortName} $accountNumber';
    return provider.fullName;
  }

  /// Check if token needs refresh
  bool get needsTokenRefresh {
    if (tokenExpiresAt == null) return false;
    return DateTime.now().isAfter(
      tokenExpiresAt!.subtract(const Duration(minutes: 5)),
    );
  }

  /// Check if sync is stale (>5 minutes old)
  bool get isSyncStale {
    return DateTime.now().difference(lastSyncedAt).inMinutes > 5;
  }

  LinkedAccount copyWith({
    String? id,
    AccountProvider? provider,
    String? accountNumber,
    String? accountName,
    String? upiId,
    Money? balance,
    DateTime? balanceUpdatedAt,
    AccountStatus? status,
    String? accessToken,
    String? refreshToken,
    DateTime? tokenExpiresAt,
    DateTime? lastSyncedAt,
    DateTime? linkedAt,
    bool? isPrimary,
    Map<String, dynamic>? metadata,
  }) {
    return LinkedAccount(
      id: id ?? this.id,
      provider: provider ?? this.provider,
      accountNumber: accountNumber ?? this.accountNumber,
      accountName: accountName ?? this.accountName,
      upiId: upiId ?? this.upiId,
      balance: balance ?? this.balance,
      balanceUpdatedAt: balanceUpdatedAt ?? this.balanceUpdatedAt,
      status: status ?? this.status,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      tokenExpiresAt: tokenExpiresAt ?? this.tokenExpiresAt,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      linkedAt: linkedAt ?? this.linkedAt,
      isPrimary: isPrimary ?? this.isPrimary,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
    id,
    provider,
    accountNumber,
    upiId,
    balance?.paisa,
    status,
    lastSyncedAt,
    isPrimary,
  ];
}

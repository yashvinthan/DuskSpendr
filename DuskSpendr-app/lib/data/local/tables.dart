import 'package:drift/drift.dart';

/// Transactions table
@DataClassName('TransactionRow')
class Transactions extends Table {
  TextColumn get id => text()();
  IntColumn get amountPaisa => integer()();
  IntColumn get type => intEnum<TransactionTypeDb>()();
  IntColumn get category => intEnum<TransactionCategoryDb>()();
  TextColumn get merchantName => text().nullable()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get timestamp => dateTime()();
  IntColumn get source => intEnum<TransactionSourceDb>()();
  IntColumn get paymentMethod => intEnum<PaymentMethodDb>().nullable()();
  TextColumn get linkedAccountId => text().nullable()();
  TextColumn get referenceId => text().nullable()();
  RealColumn get categoryConfidence => real().nullable()();
  BoolColumn get isRecurring => boolean().withDefault(const Constant(false))();
  TextColumn get recurringPatternId => text().nullable()();
  BoolColumn get isShared => boolean().withDefault(const Constant(false))();
  TextColumn get sharedExpenseId => text().nullable()();
  TextColumn get tags =>
      text().withDefault(const Constant('[]'))(); // JSON array
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Linked accounts table
@DataClassName('LinkedAccountRow')
class LinkedAccounts extends Table {
  TextColumn get id => text()();
  IntColumn get provider => intEnum<AccountProviderDb>()();
  TextColumn get accountNumber => text().nullable()();
  TextColumn get accountName => text().nullable()();
  TextColumn get upiId => text().nullable()();
  IntColumn get balancePaisa => integer().nullable()();
  DateTimeColumn get balanceUpdatedAt => dateTime().nullable()();
  IntColumn get status => intEnum<AccountStatusDb>()();
  TextColumn get accessToken => text().nullable()(); // Encrypted
  TextColumn get refreshToken => text().nullable()(); // Encrypted
  DateTimeColumn get tokenExpiresAt => dateTime().nullable()();
  DateTimeColumn get lastSyncedAt => dateTime()();
  DateTimeColumn get linkedAt => dateTime()();
  BoolColumn get isPrimary => boolean().withDefault(const Constant(false))();
  TextColumn get metadata => text().nullable()(); // JSON

  @override
  Set<Column> get primaryKey => {id};
}

/// Budgets table
@DataClassName('BudgetRow')
class Budgets extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get limitPaisa => integer()();
  IntColumn get spentPaisa => integer().withDefault(const Constant(0))();
  IntColumn get period => intEnum<BudgetPeriodDb>()();
  IntColumn get category => intEnum<TransactionCategoryDb>().nullable()();
  RealColumn get alertThreshold => real().withDefault(const Constant(0.8))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// User-defined custom categories
class CustomCategories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get nameHi => text().nullable()();
  IntColumn get iconCodePoint => integer()();
  IntColumn get colorValue => integer()();
  TextColumn get keywords =>
      text().withDefault(const Constant('[]'))(); // JSON array
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Merchant to category mapping (learned from user corrections)
class MerchantMappings extends Table {
  TextColumn get merchantPattern => text()();
  IntColumn get category => intEnum<TransactionCategoryDb>()();
  IntColumn get correctionCount => integer().withDefault(const Constant(1))();
  DateTimeColumn get lastUsed => dateTime()();

  @override
  Set<Column> get primaryKey => {merchantPattern};
}

/// Recurring transaction patterns
class RecurringPatterns extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get amountPaisa => integer()();
  IntColumn get category => intEnum<TransactionCategoryDb>()();
  IntColumn get frequencyDays => integer()();
  DateTimeColumn get nextExpected => dateTime()();
  TextColumn get linkedAccountId => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Audit log entries (privacy engine)
@DataClassName('AuditLogRow')
class AuditLogs extends Table {
  TextColumn get id => text()();
  IntColumn get type => intEnum<AuditLogTypeDb>()();
  TextColumn get entity => text()();
  TextColumn get entityId => text().nullable()();
  TextColumn get details => text().nullable()();
  TextColumn get metadata => text().nullable()(); // JSON
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Privacy reports (latest snapshot)
@DataClassName('PrivacyReportRow')
class PrivacyReports extends Table {
  TextColumn get id => text()();
  DateTimeColumn get generatedAt => dateTime()();
  TextColumn get reportJson => text()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Backup metadata entries
@DataClassName('BackupMetadataRow')
class BackupMetadata extends Table {
  TextColumn get id => text()();
  TextColumn get filePath => text()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get sizeBytes => integer()();
  TextColumn get checksum => text()();
  IntColumn get version => integer()();
  BoolColumn get isEncrypted => boolean().withDefault(const Constant(true))();
  IntColumn get status => intEnum<BackupStatusDb>()();
  IntColumn get restoreCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastRestoredAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Sync outbox entries for queued uploads
@DataClassName('SyncOutboxRow')
class SyncOutbox extends Table {
  TextColumn get transactionId => text()();
  IntColumn get status => intEnum<SyncOutboxStatusDb>()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  DateTimeColumn get nextAttemptAt => dateTime().nullable()();
  TextColumn get lastError => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {transactionId};
}

// Database enums (match domain enums)
enum TransactionTypeDb { debit, credit }

enum TransactionCategoryDb {
  food,
  transportation,
  entertainment,
  education,
  shopping,
  utilities,
  healthcare,
  subscriptions,
  investments,
  loans,
  shared,
  pocketMoney,
  other,
}

enum TransactionSourceDb { manual, sms, upiNotification, bankApi, imported }

enum PaymentMethodDb { upi, card, netBanking, cash, wallet, bnpl }

enum AccountProviderDb {
  sbi,
  hdfc,
  icici,
  axis,
  gpay,
  phonepe,
  paytmUpi,
  amazonPay,
  paytmWallet,
  lazypay,
  simpl,
  amazonPayLater,
  zerodha,
  groww,
  upstox,
  angelOne,
  indmoney,
  zerodhaCoins,
}

enum AccountStatusDb { active, syncing, error, expired, pending }

enum BudgetPeriodDb { daily, weekly, monthly }

enum AuditLogTypeDb { read, write, update, delete, export, sync, backup, restore }

enum BackupStatusDb { success, failed }

enum SyncOutboxStatusDb { pending, syncing, failed, succeeded }

// ====== SS-064: Balance Snapshots ======

/// Balance history snapshots for trend charts
@DataClassName('BalanceSnapshotRow')
class BalanceSnapshots extends Table {
  TextColumn get id => text()();
  TextColumn get accountId => text()();
  IntColumn get balancePaisa => integer()();
  DateTimeColumn get timestamp => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// ====== SS-067: Bill Reminders ======

/// Bill payment reminders
@DataClassName('BillReminderRow')
class BillReminders extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get merchantName => text().nullable()();
  IntColumn get amountPaisa => integer()();
  IntColumn get frequency => intEnum<BillFrequencyDb>()();
  DateTimeColumn get nextDueDate => dateTime()();
  IntColumn get reminderDaysBefore => integer().withDefault(const Constant(3))();
  BoolColumn get isAutoDetected => boolean().withDefault(const Constant(false))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get linkedAccountId => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Bill payment history
@DataClassName('BillPaymentRow')
class BillPayments extends Table {
  TextColumn get id => text()();
  TextColumn get billId => text()();
  IntColumn get amountPaisa => integer()();
  DateTimeColumn get paidAt => dateTime()();
  TextColumn get transactionId => text().nullable()(); // Link to transaction
  BoolColumn get isAutoLinked => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

enum BillFrequencyDb { weekly, biweekly, monthly, quarterly, yearly }

// ====== SS-068: Loans & Credit Cards ======

/// Loans tracking
@DataClassName('LoanRow')
class Loans extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get type => intEnum<LoanTypeDb>()();
  IntColumn get principalPaisa => integer()();
  IntColumn get outstandingPaisa => integer()();
  RealColumn get interestRatePercent => real()();
  IntColumn get emiPaisa => integer()();
  IntColumn get tenureMonths => integer()();
  IntColumn get totalPaidPaisa => integer().withDefault(const Constant(0))();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get nextDueDate => dateTime().nullable()();
  DateTimeColumn get lastPaymentDate => dateTime().nullable()();
  TextColumn get lenderName => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Loan payments
@DataClassName('LoanPaymentRow')
class LoanPayments extends Table {
  TextColumn get id => text()();
  TextColumn get loanId => text()();
  IntColumn get amountPaisa => integer()();
  IntColumn get principalPaidPaisa => integer()();
  IntColumn get interestPaidPaisa => integer()();
  DateTimeColumn get paidAt => dateTime()();
  BoolColumn get isExtraPayment => boolean().withDefault(const Constant(false))();
  TextColumn get transactionId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Credit cards
@DataClassName('CreditCardRow')
class CreditCards extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get lastFourDigits => text()();
  IntColumn get creditLimitPaisa => integer()();
  IntColumn get currentOutstandingPaisa => integer().withDefault(const Constant(0))();
  IntColumn get dueDay => integer()(); // Day of month
  IntColumn get statementDay => integer()(); // Day of month
  RealColumn get interestRatePercent => real()();
  TextColumn get bankName => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

enum LoanTypeDb { personal, education, vehicle, home, creditCard, bnpl, other }

// ====== SS-069: Investments ======

/// Investments tracking
@DataClassName('InvestmentRow')
class Investments extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get type => intEnum<InvestmentTypeDb>()();
  TextColumn get platformId => text().nullable()();
  IntColumn get investedPaisa => integer()();
  IntColumn get currentValuePaisa => integer()();
  RealColumn get units => real().withDefault(const Constant(0))();
  RealColumn get avgBuyPrice => real().nullable()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get maturityDate => dateTime().nullable()(); // For FDs, RDs
  RealColumn get interestRate => real().nullable()(); // For FDs, RDs
  TextColumn get symbol => text().nullable()(); // For stocks
  TextColumn get isin => text().nullable()(); // For mutual funds
  BoolColumn get isSip => boolean().withDefault(const Constant(false))();
  IntColumn get sipAmountPaisa => integer().nullable()();
  IntColumn get sipDay => integer().nullable()();
  DateTimeColumn get lastUpdated => dateTime()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Investment transactions (buy/sell/dividend)
@DataClassName('InvestmentTransactionRow')
class InvestmentTransactions extends Table {
  TextColumn get id => text()();
  TextColumn get investmentId => text()();
  IntColumn get type => intEnum<InvestmentTransactionTypeDb>()();
  IntColumn get amountPaisa => integer()();
  RealColumn get units => real()();
  RealColumn get pricePerUnit => real()();
  DateTimeColumn get transactionDate => dateTime()();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

enum InvestmentTypeDb { mutualFund, stock, etf, fd, rd, ppf, nps, gold, crypto, other }

enum InvestmentTransactionTypeDb { buy, sell, dividend, bonus, split }

// ====== SS-100: Shared Expenses ======

/// Split types for shared expenses
enum SplitTypeDb { equal, percentage, exact, shares, adjustment }

/// Settlement status
enum SettlementStatusDb { pending, partial, settled }

/// Friends for expense splitting
@DataClassName('FriendRow')
class Friends extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get phone => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get avatarUrl => text().nullable()();
  IntColumn get totalOwedPaisa => integer().withDefault(const Constant(0))();
  IntColumn get totalOwingPaisa => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastActivityAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Expense groups for repeated splits
@DataClassName('ExpenseGroupRow')
class ExpenseGroups extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get iconCodePoint => text().nullable()();
  IntColumn get colorValue => integer().nullable()();
  TextColumn get memberIds => text().withDefault(const Constant('[]'))(); // JSON array of friend IDs
  IntColumn get totalExpensesPaisa => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastActivityAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Shared expenses
@DataClassName('SharedExpenseRow')
class SharedExpenses extends Table {
  TextColumn get id => text()();
  TextColumn get transactionId => text().nullable()(); // Link to regular transaction
  TextColumn get groupId => text().nullable()(); // Optional group
  TextColumn get description => text()();
  IntColumn get totalAmountPaisa => integer()();
  TextColumn get paidById => text()(); // Friend ID or 'self'
  IntColumn get splitType => intEnum<SplitTypeDb>()();
  TextColumn get participantsJson => text()(); // JSON array of participants
  IntColumn get status => intEnum<SettlementStatusDb>()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get expenseDate => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Settlements between friends
@DataClassName('SettlementRow')
class Settlements extends Table {
  TextColumn get id => text()();
  TextColumn get friendId => text()();
  TextColumn get sharedExpenseId => text().nullable()(); // Specific expense or general
  IntColumn get amountPaisa => integer()();
  BoolColumn get isIncoming => boolean()(); // True if friend paid us
  TextColumn get notes => text().nullable()();
  DateTimeColumn get settledAt => dateTime()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// ====== SS-090: Financial Education ======

/// Completed lessons tracking
@DataClassName('CompletedLessonRow')
class CompletedLessons extends Table {
  TextColumn get id => text()();
  TextColumn get lessonId => text()();
  TextColumn get topicId => text()();
  IntColumn get quizScore => integer().nullable()();
  IntColumn get timeSpentSeconds => integer().withDefault(const Constant(0))();
  DateTimeColumn get completedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Shown tips tracking (to avoid repeats)
@DataClassName('ShownTipRow')
class ShownTips extends Table {
  TextColumn get id => text()();
  TextColumn get tipId => text()();
  BoolColumn get wasDismissed => boolean().withDefault(const Constant(false))();
  BoolColumn get wasSaved => boolean().withDefault(const Constant(false))();
  BoolColumn get wasActedOn => boolean().withDefault(const Constant(false))();
  DateTimeColumn get shownAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Credit score history
@DataClassName('CreditScoreRow')
class CreditScores extends Table {
  TextColumn get id => text()();
  IntColumn get score => integer()();
  TextColumn get source => text()(); // CIBIL, Experian, etc.
  TextColumn get factors => text().nullable()(); // JSON factors
  DateTimeColumn get fetchedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}


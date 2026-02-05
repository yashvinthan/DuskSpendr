/// DuskSpendr Core Module Exports
/// All feature implementations are exported from here

// ====== Core Infrastructure ======
export 'privacy/privacy_engine.dart';
export 'backup/backup_service.dart';

// ====== Account Linking ======
export 'linking/account_linker.dart';
export 'linking/oauth_service.dart';
export 'linking/account_linking_manager.dart';
export 'linking/providers/bank_linkers.dart';
export 'linking/providers/upi_linkers.dart';
export 'linking/providers/wallet_bnpl_linkers.dart';
export 'linking/providers/investment_linkers.dart';

// ====== SMS & Sync ======
export 'sms/sms_parser.dart';
export 'sync/data_synchronizer.dart';

// ====== Categorization ======
export 'categorization/transaction_categorizer.dart';

// ====== Budget & Finance ======
export 'budget/budget_service.dart';
export 'budget/investment_tracker.dart';

// ====== Dashboard ======
export 'dashboard/dashboard_service.dart';

// ====== Education ======
export 'education/education_service.dart';

// ====== Shared Expenses ======
export 'split/expense_splitting_service.dart';

// ====== Security (Existing) ======
export 'security/security.dart';

// ====== Theme (Existing) ======
export 'theme/app_theme.dart';
export 'theme/colors.dart';
export 'theme/spacing.dart';
export 'theme/typography.dart';

// ====== Accessibility ======
export 'accessibility/accessibility.dart';

// ====== Haptics ======
export 'haptics/haptic_service.dart';

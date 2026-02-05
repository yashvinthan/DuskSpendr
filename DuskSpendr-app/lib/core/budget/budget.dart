/// Spec 5: Budget & Financial Tracking Module
/// 
/// This module provides comprehensive budget management and financial tracking
/// for students including:
/// - Budget tracking with daily/weekly/monthly periods (SS-060)
/// - Overspending alerts with predictions (SS-062)
/// - Pocket money prediction (SS-063)
/// - Account balance tracking (SS-064)
/// - Consolidated balance dashboard (SS-065)
/// - Low balance alerts (SS-066)
/// - Bill payment reminders (SS-067)
/// - Loan/credit card tracking (SS-068)
/// - Investment portfolio tracking (SS-069)
/// - Financial calculators (EMI, SIP, compound interest) (SS-070)

library budget;

// Core services
export 'budget_service.dart';
export 'budget_alert_service.dart';
export 'balance_tracking_service.dart';
export 'bill_reminder_service.dart';
export 'investment_tracker.dart';

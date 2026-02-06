import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/screens.dart';
import '../../data/models/transaction_model.dart';
import '../../data/models/budget_model.dart';

/// App route paths
class AppRoutes {
  // Core flow
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String otp = '/otp';
  static const String biometricSetup = '/biometric-setup';

  // Main tabs
  static const String home = '/home';
  static const String transactions = '/transactions';
  static const String addTransaction = '/transactions/add';
  static const String editTransaction = '/transactions/edit';
  static const String budgets = '/budgets';
  static const String createBudget = '/budgets/create';
  static const String editBudget = '/budgets/edit';
  static const String budgetAlerts = '/budgets/alerts';
  static const String weeklyAllowance = '/budgets/weekly-allowance';
  static const String stats = '/stats';
  static const String profile = '/profile';

  // Feature screens
  static const String splitBills = '/split-bills';
  static const String accountLinking = '/accounts';
  static const String investing = '/investing';
  static const String smartSavings = '/savings';
  static const String insurance = '/insurance';
  static const String analytics = '/analytics';

  // Utility
  static const String notifications = '/notifications';
  static const String settings = '/settings';
  static const String syncStatus = '/sync-status';
  static const String categoryManagement = '/categories';
  static const String lowBalanceAlerts = '/alerts/low-balance';
  static const String financeScore = '/finance-score';
  static const String creditScore = '/credit-score';
  static const String financialHealth = '/financial-health';
}

/// App Router configuration
class AppRouter {
  /// Create the GoRouter configuration
  static GoRouter createRouter({
    required bool isAuthenticated,
    required bool hasCompletedOnboarding,
  }) {
    return GoRouter(
      initialLocation: AppRoutes.splash,
      debugLogDiagnostics: true,
      routes: [
        // Splash
        GoRoute(
          path: AppRoutes.splash,
          name: 'splash',
          builder: (context, state) => const SplashScreen(),
        ),

        // Onboarding
        GoRoute(
          path: AppRoutes.onboarding,
          name: 'onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),

        // Auth flow
        GoRoute(
          path: AppRoutes.login,
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: AppRoutes.otp,
          name: 'otp',
          builder: (context, state) {
            final phoneNumber = state.extra as String? ?? '';
              return OTPScreen(phone: phoneNumber);
          },
        ),
        GoRoute(
          path: AppRoutes.biometricSetup,
          name: 'biometricSetup',
          builder: (context, state) => const BiometricSetupScreen(),
        ),

        // Main app with shell for bottom nav
        ShellRoute(
          builder: (context, state, child) {
            return MainShell(child: child);
          },
          routes: [
            GoRoute(
              path: AppRoutes.home,
              name: 'home',
              builder: (context, state) => const HomeScreen(),
            ),
            GoRoute(
              path: AppRoutes.transactions,
              name: 'transactions',
              builder: (context, state) => const TransactionsScreen(),
              routes: [
                GoRoute(
                  path: 'add',
                  name: 'addTransaction',
                  builder: (context, state) => const AddTransactionScreen(),
                ),
                GoRoute(
                  path: 'edit',
                  name: 'editTransaction',
                  builder: (context, state) {
                    // Removed unused variable: transactionId
                      // Pass TransactionModel via state.extra
                      final tx = state.extra as TransactionModel?;
                      if (tx == null) return const TransactionsScreen();
                      return EditTransactionScreen(tx: tx);
                  },
                ),
              ],
            ),
            GoRoute(
              path: AppRoutes.budgets,
              name: 'budgets',
              builder: (context, state) => const BudgetOverviewScreen(),
              routes: [
                GoRoute(
                  path: 'create',
                  name: 'createBudget',
                  builder: (context, state) => const BudgetCreateScreen(),
                ),
                GoRoute(
                  path: 'edit',
                  name: 'editBudget',
                  builder: (context, state) {
                    // Removed unused variable: budgetId
                      // Pass BudgetModel via state.extra
                      final budget = state.extra as BudgetModel?;
                      if (budget == null) return const BudgetOverviewScreen();
                      return BudgetEditScreen(budget: budget);
                  },
                ),
                GoRoute(
                  path: 'alerts',
                  name: 'budgetAlerts',
                  builder: (context, state) => const BudgetAlertsScreen(),
                ),
                GoRoute(
                  path: 'weekly-allowance',
                  name: 'weeklyAllowance',
                  builder: (context, state) => const WeeklyAllowanceScreen(),
                ),
              ],
            ),
            GoRoute(
              path: AppRoutes.stats,
              name: 'stats',
              builder: (context, state) => const StatsScreen(),
            ),
            GoRoute(
              path: AppRoutes.profile,
              name: 'profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),

        // Feature screens
        GoRoute(
          path: AppRoutes.splitBills,
          name: 'splitBills',
          builder: (context, state) => const SplitBillsScreen(),
        ),
        GoRoute(
          path: AppRoutes.accountLinking,
          name: 'accountLinking',
          builder: (context, state) => const AccountLinkingScreen(),
        ),
        GoRoute(
          path: AppRoutes.investing,
          name: 'investing',
          builder: (context, state) => const InvestingScreen(),
        ),
        GoRoute(
          path: AppRoutes.smartSavings,
          name: 'smartSavings',
          builder: (context, state) => const SmartSavingsScreen(),
        ),
        GoRoute(
          path: AppRoutes.insurance,
          name: 'insurance',
          builder: (context, state) => const InsuranceScreen(),
        ),
        GoRoute(
          path: AppRoutes.analytics,
          name: 'analytics',
          builder: (context, state) => const AnalyticsScreen(),
        ),

        // Utility screens
        GoRoute(
          path: AppRoutes.notifications,
          name: 'notifications',
          builder: (context, state) => const NotificationsScreen(),
        ),
        GoRoute(
          path: AppRoutes.settings,
          name: 'settings',
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: AppRoutes.syncStatus,
          name: 'syncStatus',
          builder: (context, state) => const SyncStatusScreen(),
        ),
        GoRoute(
          path: AppRoutes.categoryManagement,
          name: 'categoryManagement',
          builder: (context, state) => const CategoryManagementScreen(),
        ),
        GoRoute(
          path: AppRoutes.lowBalanceAlerts,
          name: 'lowBalanceAlerts',
          builder: (context, state) => const LowBalanceAlertsScreen(),
        ),
        GoRoute(
          path: AppRoutes.financeScore,
          name: 'financeScore',
          builder: (context, state) => const FinanceScoreScreen(),
        ),
        GoRoute(
          path: AppRoutes.creditScore,
          name: 'creditScore',
          builder: (context, state) => const CreditScoreScreen(),
        ),
        GoRoute(
          path: AppRoutes.financialHealth,
          name: 'financialHealth',
          builder: (context, state) => const FinancialHealthScreen(),
        ),
      ],
      redirect: (context, state) {
        // Handle auth redirects
        final isGoingToSplash = state.matchedLocation == AppRoutes.splash;
        final isGoingToOnboarding = state.matchedLocation == AppRoutes.onboarding;
        final isGoingToAuth = state.matchedLocation == AppRoutes.login ||
            state.matchedLocation == AppRoutes.otp ||
            state.matchedLocation == AppRoutes.biometricSetup;

        // If not authenticated and not going to auth screens
        if (!isAuthenticated && !isGoingToSplash && !isGoingToOnboarding && !isGoingToAuth) {
          return AppRoutes.login;
        }

        // If authenticated but hasn't completed onboarding
        if (isAuthenticated && !hasCompletedOnboarding && !isGoingToOnboarding) {
          return AppRoutes.onboarding;
        }

        return null;
      },
    );
  }
}

/// Main shell with bottom navigation
class MainShell extends StatefulWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          switch (index) {
            case 0:
              context.go(AppRoutes.home);
              break;
            case 1:
              context.go(AppRoutes.transactions);
              break;
            case 2:
              context.go(AppRoutes.budgets);
              break;
            case 3:
              context.go(AppRoutes.stats);
              break;
            case 4:
              context.go(AppRoutes.profile);
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            activeIcon: Icon(Icons.swap_horiz),
            label: 'Log',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            activeIcon: Icon(Icons.account_balance_wallet),
            label: 'Budget',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart_outline),
            activeIcon: Icon(Icons.pie_chart),
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

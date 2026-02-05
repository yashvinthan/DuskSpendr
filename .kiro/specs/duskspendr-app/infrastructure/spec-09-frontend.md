# Spec 9: Frontend - Flutter UI/UX, Performance & Accessibility

## Overview

**Spec ID:** DuskSpendr-INFRA-009  
**Domain:** Frontend Development  
**Priority:** P0 (Critical)  
**Estimated Effort:** 5 sprints  
**Framework:** Flutter 3.x with Dart  

---

## Objectives

1. **Cross-Platform** - Single codebase for Android & iOS
2. **Student-Friendly Design** - Engaging, youthful UI with gamification
3. **Accessibility** - WCAG 2.1 AA compliance
4. **Performance** - 60fps animations, <2s cold start
5. **Offline-First** - Full functionality without network

---

## Technology Stack

| Layer | Technology | Purpose |
|-------|------------|---------|
| Framework | Flutter 3.x | Cross-platform UI |
| Language | Dart 3.x | Type-safe development |
| State Management | Riverpod 2.x | Reactive state |
| Local Database | Drift (SQLite) | Encrypted local storage |
| Networking | Dio | HTTP client |
| Charts | fl_chart | Financial visualizations |
| Animations | flutter_animate | Micro-interactions |
| Testing | flutter_test, integration_test | UI & E2E testing |

---

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Presentation Layer                    │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐      │
│  │   Screens   │  │   Widgets   │  │  Providers  │      │
│  └─────────────┘  └─────────────┘  └─────────────┘      │
├─────────────────────────────────────────────────────────┤
│                    Application Layer                     │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐      │
│  │  Use Cases  │  │   Models    │  │  Services   │      │
│  └─────────────┘  └─────────────┘  └─────────────┘      │
├─────────────────────────────────────────────────────────┤
│                      Data Layer                          │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐      │
│  │Repositories │  │ Data Sources│  │   Drift DB  │      │
│  └─────────────┘  └─────────────┘  └─────────────┘      │
└─────────────────────────────────────────────────────────┘
```

---

## Design System

### Theme Configuration

```dart
// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Primary Colors - Student-friendly palette
  static const Color primary = Color(0xFF6366F1);      // Indigo
  static const Color secondary = Color(0xFF22C55E);    // Green (savings)
  static const Color accent = Color(0xFFF59E0B);       // Amber (alerts)
  static const Color error = Color(0xFFEF4444);        // Red (overspend)
  
  // Semantic Colors
  static const Color income = Color(0xFF22C55E);
  static const Color expense = Color(0xFFEF4444);
  static const Color savings = Color(0xFF3B82F6);
  
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
    ),
    textTheme: GoogleFonts.interTextTheme(),
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
    ),
  );
  
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.dark,
    ),
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
  );
}
```

### Transaction Card Widget

```dart
// lib/features/transactions/widgets/transaction_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback? onTap;
  
  const TransactionCard({
    super.key,
    required this.transaction,
    this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    final isExpense = transaction.amount < 0;
    
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Category Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: transaction.category.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  transaction.category.icon,
                  color: transaction.category.color,
                ),
              ),
              const SizedBox(width: 12),
              
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.merchantName,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      transaction.category.name,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Amount
              Text(
                '${isExpense ? "-" : "+"}₹${transaction.amount.abs().toStringAsFixed(0)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: isExpense ? AppTheme.expense : AppTheme.income,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.1);
  }
}
```

---

## State Management (Riverpod)

```dart
// lib/features/transactions/providers/transactions_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transactions_provider.g.dart';

@riverpod
class TransactionsNotifier extends _$TransactionsNotifier {
  @override
  Future<List<Transaction>> build() async {
    final repository = ref.watch(transactionRepositoryProvider);
    return repository.getRecentTransactions(limit: 50);
  }
  
  Future<void> addTransaction(Transaction transaction) async {
    final repository = ref.read(transactionRepositoryProvider);
    await repository.insert(transaction);
    ref.invalidateSelf();
  }
  
  Future<void> categorize(String id, Category category) async {
    final repository = ref.read(transactionRepositoryProvider);
    await repository.updateCategory(id, category);
    ref.invalidateSelf();
  }
}

@riverpod
Future<double> monthlySpending(MonthlySpendingRef ref) async {
  final transactions = await ref.watch(transactionsNotifierProvider.future);
  final now = DateTime.now();
  return transactions
      .where((t) => t.date.month == now.month && t.amount < 0)
      .fold(0.0, (sum, t) => sum + t.amount.abs());
}
```

---

## Performance Targets

| Metric | Target | Measurement |
|--------|--------|-------------|
| Cold Start | <2s | Flutter DevTools |
| Frame Rate | 60fps | Performance overlay |
| Memory | <150MB | Android Profiler |
| App Size | <30MB (Android) | APK analyzer |
| List Scroll | Jank-free | Skia shader warmup |

---

## Accessibility Requirements

```dart
// Accessible Widget Example
Semantics(
  label: 'Transaction: ${transaction.merchantName}, '
         '${isExpense ? "spent" : "received"} '
         '${transaction.amount.abs()} rupees',
  button: true,
  child: TransactionCard(transaction: transaction),
)
```

| Requirement | Implementation |
|-------------|----------------|
| Screen Reader | Semantics widgets, meaningful labels |
| Color Contrast | 4.5:1 minimum ratio |
| Touch Targets | 48x48dp minimum |
| Font Scaling | Respect system settings |
| Reduce Motion | Check `MediaQuery.disableAnimations` |

---

## Requirements & Feature Tickets

| Ticket ID | Title | Requirement | Priority | Points |
|-----------|-------|-------------|----------|--------|
| SS-180 | Set up Flutter project with Clean Architecture | Foundation | P0 | 5 |
| SS-181 | Configure Riverpod state management | Architecture | P0 | 5 |
| SS-182 | Create design system (theme, colors, typography) | REQ-08: Youth UI | P0 | 8 |
| SS-183 | Build reusable widget library | REQ-08: Fast UI | P0 | 13 |
| SS-184 | Implement Dashboard screen | REQ-08: Main UI | P0 | 8 |
| SS-185 | Build Transaction list with infinite scroll | REQ-04: Transaction Display | P0 | 8 |
| SS-186 | Create Budget progress widgets | REQ-05: Budget Tracking | P0 | 8 |
| SS-187 | Implement fl_chart visualizations | REQ-11: Reports | P0 | 13 |
| SS-188 | Build Account linking flow UI | REQ-01: Account Linking | P0 | 8 |
| SS-189 | Create Gamification components | REQ-06: Financial Education | P1 | 8 |
| SS-190 | Implement dark mode support | REQ-08: User Preferences | P1 | 5 |
| SS-191 | Add accessibility (Semantics) | WCAG 2.1 AA | P0 | 8 |
| SS-192 | Implement skeleton loaders | REQ-08: Perceived Performance | P1 | 5 |
| SS-193 | Create onboarding flow | REQ-08: First-time User | P0 | 8 |
| SS-194 | Build settings & preferences screen | REQ-08: User Control | P1 | 5 |
| SS-195 | Implement haptic feedback | REQ-08: Micro-interactions | P2 | 3 |
| SS-196 | Add biometric unlock UI | REQ-07: Secure Access | P0 | 5 |
| SS-197 | Create shared expenses UI | REQ-09: Split Bills | P1 | 8 |
| SS-198 | Build financial education cards | REQ-06: Learning | P1 | 5 |
| SS-199 | Implement offline indicators | REQ-02: Offline Mode | P1 | 3 |

---

## Testing Strategy

### Widget Tests

```dart
testWidgets('TransactionCard displays amount correctly', (tester) async {
  final transaction = Transaction(
    id: '1',
    amount: -250,
    merchantName: 'Swiggy',
    category: Category.food,
    date: DateTime.now(),
  );
  
  await tester.pumpWidget(
    MaterialApp(
      home: TransactionCard(transaction: transaction),
    ),
  );
  
  expect(find.text('-₹250'), findsOneWidget);
  expect(find.text('Swiggy'), findsOneWidget);
});
```

### Golden Tests

```dart
testWidgets('Dashboard golden test', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [/* mock providers */],
      child: const MaterialApp(home: DashboardScreen()),
    ),
  );
  
  await expectLater(
    find.byType(DashboardScreen),
    matchesGoldenFile('goldens/dashboard.png'),
  );
});
```

---

## Project Structure

```
lib/
├── core/
│   ├── theme/
│   ├── routing/
│   ├── utils/
│   └── widgets/
├── features/
│   ├── auth/
│   ├── dashboard/
│   ├── transactions/
│   ├── budgets/
│   ├── accounts/
│   ├── education/
│   └── settings/
├── data/
│   ├── models/
│   ├── repositories/
│   └── datasources/
└── main.dart
```

---

## Verification Plan

- Widget tests for all reusable components
- Golden tests for critical screens
- Integration tests for user flows
- Accessibility audit (Flutter DevTools)
- Performance profiling (cold start, memory)

---

*Last Updated: 2026-02-04*

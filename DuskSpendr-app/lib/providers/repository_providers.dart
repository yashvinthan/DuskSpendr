import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repository/repository.dart';
import '../domain/repositories/repositories.dart';
import '../domain/usecases/usecases.dart';
import 'database_provider.dart';

// ====== Repository Providers ======

/// Transaction repository provider
final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final dao = ref.watch(transactionDaoProvider);
  return TransactionRepositoryImpl(dao);
});

/// Account repository provider
final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  final dao = ref.watch(accountDaoProvider);
  return AccountRepositoryImpl(dao);
});

/// Budget repository provider
final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  final dao = ref.watch(budgetDaoProvider);
  return BudgetRepositoryImpl(dao);
});

// ====== Use Case Providers ======

/// Transaction use cases provider
final transactionUseCasesProvider = Provider<TransactionUseCases>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return TransactionUseCases(repository);
});

/// Account use cases provider
final accountUseCasesProvider = Provider<AccountUseCases>((ref) {
  final repository = ref.watch(accountRepositoryProvider);
  return AccountUseCases(repository);
});

/// Budget use cases provider
final budgetUseCasesProvider = Provider<BudgetUseCases>((ref) {
  final repository = ref.watch(budgetRepositoryProvider);
  return BudgetUseCases(repository);
});

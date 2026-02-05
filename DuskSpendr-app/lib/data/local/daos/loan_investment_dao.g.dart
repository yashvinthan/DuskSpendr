// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_investment_dao.dart';

// ignore_for_file: type=lint
mixin _$LoanDaoMixin on DatabaseAccessor<AppDatabase> {
  $LoansTable get loans => attachedDatabase.loans;
  $LoanPaymentsTable get loanPayments => attachedDatabase.loanPayments;
  $CreditCardsTable get creditCards => attachedDatabase.creditCards;
}
mixin _$InvestmentDaoMixin on DatabaseAccessor<AppDatabase> {
  $InvestmentsTable get investments => attachedDatabase.investments;
  $InvestmentTransactionsTable get investmentTransactions =>
      attachedDatabase.investmentTransactions;
}

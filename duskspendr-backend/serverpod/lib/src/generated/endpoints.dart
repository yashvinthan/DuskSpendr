/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../endpoints/account_endpoint.dart' as _i2;
import '../endpoints/budget_endpoint.dart' as _i3;
import '../endpoints/category_endpoint.dart' as _i4;
import '../endpoints/export_endpoint.dart' as _i5;
import '../endpoints/health_endpoint.dart' as _i6;
import '../endpoints/split_endpoint.dart' as _i7;
import '../endpoints/transaction_endpoint.dart' as _i8;
import '../endpoints/user_endpoint.dart' as _i9;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'account': _i2.AccountEndpoint()
        ..initialize(
          server,
          'account',
          null,
        ),
      'budget': _i3.BudgetEndpoint()
        ..initialize(
          server,
          'budget',
          null,
        ),
      'category': _i4.CategoryEndpoint()
        ..initialize(
          server,
          'category',
          null,
        ),
      'export': _i5.ExportEndpoint()
        ..initialize(
          server,
          'export',
          null,
        ),
      'health': _i6.HealthEndpoint()
        ..initialize(
          server,
          'health',
          null,
        ),
      'split': _i7.SplitEndpoint()
        ..initialize(
          server,
          'split',
          null,
        ),
      'transaction': _i8.TransactionEndpoint()
        ..initialize(
          server,
          'transaction',
          null,
        ),
      'user': _i9.UserEndpoint()
        ..initialize(
          server,
          'user',
          null,
        ),
    };

    connectors['account'] = _i1.EndpointConnector(
      name: 'account',
      endpoint: endpoints['account']!,
      methodConnectors: {
        'getAccounts': _i1.MethodConnector(
          name: 'getAccounts',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['account'] as _i2.AccountEndpoint).getAccounts(session),
        ),
        'getAccount': _i1.MethodConnector(
          name: 'getAccount',
          params: {
            'accountId': _i1.ParameterDescription(
              name: 'accountId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['account'] as _i2.AccountEndpoint).getAccount(
            session,
            params['accountId'],
          ),
        ),
        'createAccount': _i1.MethodConnector(
          name: 'createAccount',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'type': _i1.ParameterDescription(
              name: 'type',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'currency': _i1.ParameterDescription(
              name: 'currency',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'balance': _i1.ParameterDescription(
              name: 'balance',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'institution': _i1.ParameterDescription(
              name: 'institution',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'accountNumber': _i1.ParameterDescription(
              name: 'accountNumber',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'isDefault': _i1.ParameterDescription(
              name: 'isDefault',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
            'icon': _i1.ParameterDescription(
              name: 'icon',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'color': _i1.ParameterDescription(
              name: 'color',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['account'] as _i2.AccountEndpoint).createAccount(
            session,
            name: params['name'],
            type: params['type'],
            currency: params['currency'],
            balance: params['balance'] ?? 0,
            institution: params['institution'],
            accountNumber: params['accountNumber'],
            isDefault: params['isDefault'] ?? false,
            icon: params['icon'],
            color: params['color'],
          ),
        ),
        'updateAccount': _i1.MethodConnector(
          name: 'updateAccount',
          params: {
            'accountId': _i1.ParameterDescription(
              name: 'accountId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'type': _i1.ParameterDescription(
              name: 'type',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'balance': _i1.ParameterDescription(
              name: 'balance',
              type: _i1.getType<double?>(),
              nullable: true,
            ),
            'currency': _i1.ParameterDescription(
              name: 'currency',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'institution': _i1.ParameterDescription(
              name: 'institution',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'accountNumber': _i1.ParameterDescription(
              name: 'accountNumber',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'isDefault': _i1.ParameterDescription(
              name: 'isDefault',
              type: _i1.getType<bool?>(),
              nullable: true,
            ),
            'icon': _i1.ParameterDescription(
              name: 'icon',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'color': _i1.ParameterDescription(
              name: 'color',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['account'] as _i2.AccountEndpoint).updateAccount(
            session,
            params['accountId'],
            name: params['name'],
            type: params['type'],
            balance: params['balance'],
            currency: params['currency'],
            institution: params['institution'],
            accountNumber: params['accountNumber'],
            isDefault: params['isDefault'],
            icon: params['icon'],
            color: params['color'],
          ),
        ),
        'updateBalance': _i1.MethodConnector(
          name: 'updateBalance',
          params: {
            'accountId': _i1.ParameterDescription(
              name: 'accountId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'balance': _i1.ParameterDescription(
              name: 'balance',
              type: _i1.getType<double>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['account'] as _i2.AccountEndpoint).updateBalance(
            session,
            params['accountId'],
            params['balance'],
          ),
        ),
        'deleteAccount': _i1.MethodConnector(
          name: 'deleteAccount',
          params: {
            'accountId': _i1.ParameterDescription(
              name: 'accountId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['account'] as _i2.AccountEndpoint).deleteAccount(
            session,
            params['accountId'],
          ),
        ),
        'getBalanceSummary': _i1.MethodConnector(
          name: 'getBalanceSummary',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['account'] as _i2.AccountEndpoint)
                  .getBalanceSummary(session),
        ),
        'recalculateBalance': _i1.MethodConnector(
          name: 'recalculateBalance',
          params: {
            'accountId': _i1.ParameterDescription(
              name: 'accountId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['account'] as _i2.AccountEndpoint).recalculateBalance(
            session,
            params['accountId'],
          ),
        ),
      },
    );

    connectors['budget'] = _i1.EndpointConnector(
      name: 'budget',
      endpoint: endpoints['budget']!,
      methodConnectors: {
        'getBudgets': _i1.MethodConnector(
          name: 'getBudgets',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['budget'] as _i3.BudgetEndpoint).getBudgets(session),
        ),
        'getBudget': _i1.MethodConnector(
          name: 'getBudget',
          params: {
            'budgetId': _i1.ParameterDescription(
              name: 'budgetId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['budget'] as _i3.BudgetEndpoint).getBudget(
            session,
            params['budgetId'],
          ),
        ),
        'createBudget': _i1.MethodConnector(
          name: 'createBudget',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'amount': _i1.ParameterDescription(
              name: 'amount',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'period': _i1.ParameterDescription(
              name: 'period',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'categoryId': _i1.ParameterDescription(
              name: 'categoryId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'startDate': _i1.ParameterDescription(
              name: 'startDate',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
            'endDate': _i1.ParameterDescription(
              name: 'endDate',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
            'alertThreshold': _i1.ParameterDescription(
              name: 'alertThreshold',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'rollover': _i1.ParameterDescription(
              name: 'rollover',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['budget'] as _i3.BudgetEndpoint).createBudget(
            session,
            name: params['name'],
            amount: params['amount'],
            period: params['period'],
            categoryId: params['categoryId'],
            startDate: params['startDate'],
            endDate: params['endDate'],
            alertThreshold: params['alertThreshold'] ?? 0.8,
            rollover: params['rollover'] ?? false,
          ),
        ),
        'updateBudget': _i1.MethodConnector(
          name: 'updateBudget',
          params: {
            'budgetId': _i1.ParameterDescription(
              name: 'budgetId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'amount': _i1.ParameterDescription(
              name: 'amount',
              type: _i1.getType<double?>(),
              nullable: true,
            ),
            'categoryId': _i1.ParameterDescription(
              name: 'categoryId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'alertThreshold': _i1.ParameterDescription(
              name: 'alertThreshold',
              type: _i1.getType<double?>(),
              nullable: true,
            ),
            'isActive': _i1.ParameterDescription(
              name: 'isActive',
              type: _i1.getType<bool?>(),
              nullable: true,
            ),
            'rollover': _i1.ParameterDescription(
              name: 'rollover',
              type: _i1.getType<bool?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['budget'] as _i3.BudgetEndpoint).updateBudget(
            session,
            params['budgetId'],
            name: params['name'],
            amount: params['amount'],
            categoryId: params['categoryId'],
            alertThreshold: params['alertThreshold'],
            isActive: params['isActive'],
            rollover: params['rollover'],
          ),
        ),
        'deleteBudget': _i1.MethodConnector(
          name: 'deleteBudget',
          params: {
            'budgetId': _i1.ParameterDescription(
              name: 'budgetId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['budget'] as _i3.BudgetEndpoint).deleteBudget(
            session,
            params['budgetId'],
          ),
        ),
        'updateBudgetSpent': _i1.MethodConnector(
          name: 'updateBudgetSpent',
          params: {
            'budgetId': _i1.ParameterDescription(
              name: 'budgetId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'spent': _i1.ParameterDescription(
              name: 'spent',
              type: _i1.getType<double>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['budget'] as _i3.BudgetEndpoint).updateBudgetSpent(
            session,
            params['budgetId'],
            params['spent'],
          ),
        ),
        'syncBudgets': _i1.MethodConnector(
          name: 'syncBudgets',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['budget'] as _i3.BudgetEndpoint).syncBudgets(session),
        ),
      },
    );

    connectors['category'] = _i1.EndpointConnector(
      name: 'category',
      endpoint: endpoints['category']!,
      methodConnectors: {
        'getCategories': _i1.MethodConnector(
          name: 'getCategories',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['category'] as _i4.CategoryEndpoint)
                  .getCategories(session),
        ),
        'getCategory': _i1.MethodConnector(
          name: 'getCategory',
          params: {
            'categoryId': _i1.ParameterDescription(
              name: 'categoryId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['category'] as _i4.CategoryEndpoint).getCategory(
            session,
            params['categoryId'],
          ),
        ),
        'createCategory': _i1.MethodConnector(
          name: 'createCategory',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'type': _i1.ParameterDescription(
              name: 'type',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'icon': _i1.ParameterDescription(
              name: 'icon',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'color': _i1.ParameterDescription(
              name: 'color',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'parentId': _i1.ParameterDescription(
              name: 'parentId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['category'] as _i4.CategoryEndpoint).createCategory(
            session,
            name: params['name'],
            type: params['type'] ?? 'expense',
            icon: params['icon'],
            color: params['color'],
            parentId: params['parentId'],
          ),
        ),
        'updateCategory': _i1.MethodConnector(
          name: 'updateCategory',
          params: {
            'categoryId': _i1.ParameterDescription(
              name: 'categoryId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'icon': _i1.ParameterDescription(
              name: 'icon',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'color': _i1.ParameterDescription(
              name: 'color',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'type': _i1.ParameterDescription(
              name: 'type',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'parentId': _i1.ParameterDescription(
              name: 'parentId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['category'] as _i4.CategoryEndpoint).updateCategory(
            session,
            params['categoryId'],
            name: params['name'],
            icon: params['icon'],
            color: params['color'],
            type: params['type'],
            parentId: params['parentId'],
          ),
        ),
        'deleteCategory': _i1.MethodConnector(
          name: 'deleteCategory',
          params: {
            'categoryId': _i1.ParameterDescription(
              name: 'categoryId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['category'] as _i4.CategoryEndpoint).deleteCategory(
            session,
            params['categoryId'],
          ),
        ),
        'initializeDefaultCategories': _i1.MethodConnector(
          name: 'initializeDefaultCategories',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['category'] as _i4.CategoryEndpoint)
                  .initializeDefaultCategories(session),
        ),
        'getSpendingByCategory': _i1.MethodConnector(
          name: 'getSpendingByCategory',
          params: {
            'startDate': _i1.ParameterDescription(
              name: 'startDate',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
            'endDate': _i1.ParameterDescription(
              name: 'endDate',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['category'] as _i4.CategoryEndpoint)
                  .getSpendingByCategory(
            session,
            startDate: params['startDate'],
            endDate: params['endDate'],
          ),
        ),
      },
    );

    connectors['export'] = _i1.EndpointConnector(
      name: 'export',
      endpoint: endpoints['export']!,
      methodConnectors: {
        'exportAllData': _i1.MethodConnector(
          name: 'exportAllData',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['export'] as _i5.ExportEndpoint).exportAllData(session),
        ),
        'exportTransactions': _i1.MethodConnector(
          name: 'exportTransactions',
          params: {
            'startDate': _i1.ParameterDescription(
              name: 'startDate',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
            'endDate': _i1.ParameterDescription(
              name: 'endDate',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
            'format': _i1.ParameterDescription(
              name: 'format',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['export'] as _i5.ExportEndpoint).exportTransactions(
            session,
            startDate: params['startDate'],
            endDate: params['endDate'],
            format: params['format'],
          ),
        ),
        'exportTransactionsCsv': _i1.MethodConnector(
          name: 'exportTransactionsCsv',
          params: {
            'startDate': _i1.ParameterDescription(
              name: 'startDate',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
            'endDate': _i1.ParameterDescription(
              name: 'endDate',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['export'] as _i5.ExportEndpoint)
                  .exportTransactionsCsv(
            session,
            startDate: params['startDate'],
            endDate: params['endDate'],
          ),
        ),
        'exportBudgets': _i1.MethodConnector(
          name: 'exportBudgets',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['export'] as _i5.ExportEndpoint).exportBudgets(session),
        ),
        'requestDataDeletion': _i1.MethodConnector(
          name: 'requestDataDeletion',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['export'] as _i5.ExportEndpoint)
                  .requestDataDeletion(session),
        ),
        'getDeletionStatus': _i1.MethodConnector(
          name: 'getDeletionStatus',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['export'] as _i5.ExportEndpoint)
                  .getDeletionStatus(session),
        ),
      },
    );

    connectors['health'] = _i1.EndpointConnector(
      name: 'health',
      endpoint: endpoints['health']!,
      methodConnectors: {
        'ping': _i1.MethodConnector(
          name: 'ping',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['health'] as _i6.HealthEndpoint).ping(session),
        )
      },
    );

    connectors['split'] = _i1.EndpointConnector(
      name: 'split',
      endpoint: endpoints['split']!,
      methodConnectors: {
        'getSplits': _i1.MethodConnector(
          name: 'getSplits',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['split'] as _i7.SplitEndpoint).getSplits(session),
        ),
        'getSplit': _i1.MethodConnector(
          name: 'getSplit',
          params: {
            'splitId': _i1.ParameterDescription(
              name: 'splitId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['split'] as _i7.SplitEndpoint).getSplit(
            session,
            params['splitId'],
          ),
        ),
        'createSplit': _i1.MethodConnector(
          name: 'createSplit',
          params: {
            'totalAmount': _i1.ParameterDescription(
              name: 'totalAmount',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'participants': _i1.ParameterDescription(
              name: 'participants',
              type: _i1.getType<List<Map<String, dynamic>>>(),
              nullable: false,
            ),
            'transactionId': _i1.ParameterDescription(
              name: 'transactionId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['split'] as _i7.SplitEndpoint).createSplit(
            session,
            totalAmount: params['totalAmount'],
            participants: params['participants'],
            transactionId: params['transactionId'],
            description: params['description'],
          ),
        ),
        'markPaid': _i1.MethodConnector(
          name: 'markPaid',
          params: {
            'splitId': _i1.ParameterDescription(
              name: 'splitId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'participantId': _i1.ParameterDescription(
              name: 'participantId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['split'] as _i7.SplitEndpoint).markPaid(
            session,
            params['splitId'],
            params['participantId'],
          ),
        ),
        'sendReminder': _i1.MethodConnector(
          name: 'sendReminder',
          params: {
            'splitId': _i1.ParameterDescription(
              name: 'splitId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'participantId': _i1.ParameterDescription(
              name: 'participantId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['split'] as _i7.SplitEndpoint).sendReminder(
            session,
            params['splitId'],
            params['participantId'],
          ),
        ),
        'deleteSplit': _i1.MethodConnector(
          name: 'deleteSplit',
          params: {
            'splitId': _i1.ParameterDescription(
              name: 'splitId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['split'] as _i7.SplitEndpoint).deleteSplit(
            session,
            params['splitId'],
          ),
        ),
        'getSplitsSummary': _i1.MethodConnector(
          name: 'getSplitsSummary',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['split'] as _i7.SplitEndpoint)
                  .getSplitsSummary(session),
        ),
      },
    );

    connectors['transaction'] = _i1.EndpointConnector(
      name: 'transaction',
      endpoint: endpoints['transaction']!,
      methodConnectors: {
        'getTransactions': _i1.MethodConnector(
          name: 'getTransactions',
          params: {
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'offset': _i1.ParameterDescription(
              name: 'offset',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'startDate': _i1.ParameterDescription(
              name: 'startDate',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
            'endDate': _i1.ParameterDescription(
              name: 'endDate',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
            'categoryId': _i1.ParameterDescription(
              name: 'categoryId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'source': _i1.ParameterDescription(
              name: 'source',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['transaction'] as _i8.TransactionEndpoint)
                  .getTransactions(
            session,
            limit: params['limit'],
            offset: params['offset'],
            startDate: params['startDate'],
            endDate: params['endDate'],
            categoryId: params['categoryId'],
            source: params['source'],
          ),
        ),
        'getTransaction': _i1.MethodConnector(
          name: 'getTransaction',
          params: {
            'transactionId': _i1.ParameterDescription(
              name: 'transactionId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['transaction'] as _i8.TransactionEndpoint)
                  .getTransaction(
            session,
            params['transactionId'],
          ),
        ),
        'createTransaction': _i1.MethodConnector(
          name: 'createTransaction',
          params: {
            'amount': _i1.ParameterDescription(
              name: 'amount',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'date': _i1.ParameterDescription(
              name: 'date',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
            'source': _i1.ParameterDescription(
              name: 'source',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'merchantName': _i1.ParameterDescription(
              name: 'merchantName',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'categoryId': _i1.ParameterDescription(
              name: 'categoryId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'subcategoryId': _i1.ParameterDescription(
              name: 'subcategoryId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'accountId': _i1.ParameterDescription(
              name: 'accountId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'isRecurring': _i1.ParameterDescription(
              name: 'isRecurring',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
            'recurringId': _i1.ParameterDescription(
              name: 'recurringId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'tags': _i1.ParameterDescription(
              name: 'tags',
              type: _i1.getType<List<String>?>(),
              nullable: true,
            ),
            'location': _i1.ParameterDescription(
              name: 'location',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'latitude': _i1.ParameterDescription(
              name: 'latitude',
              type: _i1.getType<double?>(),
              nullable: true,
            ),
            'longitude': _i1.ParameterDescription(
              name: 'longitude',
              type: _i1.getType<double?>(),
              nullable: true,
            ),
            'smsHash': _i1.ParameterDescription(
              name: 'smsHash',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['transaction'] as _i8.TransactionEndpoint)
                  .createTransaction(
            session,
            amount: params['amount'],
            date: params['date'],
            source: params['source'],
            merchantName: params['merchantName'],
            categoryId: params['categoryId'],
            subcategoryId: params['subcategoryId'],
            description: params['description'],
            accountId: params['accountId'],
            isRecurring: params['isRecurring'] ?? false,
            recurringId: params['recurringId'],
            tags: params['tags'],
            location: params['location'],
            latitude: params['latitude'],
            longitude: params['longitude'],
            smsHash: params['smsHash'],
          ),
        ),
        'updateTransaction': _i1.MethodConnector(
          name: 'updateTransaction',
          params: {
            'transactionId': _i1.ParameterDescription(
              name: 'transactionId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'amount': _i1.ParameterDescription(
              name: 'amount',
              type: _i1.getType<double?>(),
              nullable: true,
            ),
            'merchantName': _i1.ParameterDescription(
              name: 'merchantName',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'categoryId': _i1.ParameterDescription(
              name: 'categoryId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'subcategoryId': _i1.ParameterDescription(
              name: 'subcategoryId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'date': _i1.ParameterDescription(
              name: 'date',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
            'accountId': _i1.ParameterDescription(
              name: 'accountId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'isRecurring': _i1.ParameterDescription(
              name: 'isRecurring',
              type: _i1.getType<bool?>(),
              nullable: true,
            ),
            'tags': _i1.ParameterDescription(
              name: 'tags',
              type: _i1.getType<List<String>?>(),
              nullable: true,
            ),
            'location': _i1.ParameterDescription(
              name: 'location',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['transaction'] as _i8.TransactionEndpoint)
                  .updateTransaction(
            session,
            params['transactionId'],
            amount: params['amount'],
            merchantName: params['merchantName'],
            categoryId: params['categoryId'],
            subcategoryId: params['subcategoryId'],
            description: params['description'],
            date: params['date'],
            accountId: params['accountId'],
            isRecurring: params['isRecurring'],
            tags: params['tags'],
            location: params['location'],
          ),
        ),
        'deleteTransaction': _i1.MethodConnector(
          name: 'deleteTransaction',
          params: {
            'transactionId': _i1.ParameterDescription(
              name: 'transactionId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['transaction'] as _i8.TransactionEndpoint)
                  .deleteTransaction(
            session,
            params['transactionId'],
          ),
        ),
        'bulkCreateTransactions': _i1.MethodConnector(
          name: 'bulkCreateTransactions',
          params: {
            'transactions': _i1.ParameterDescription(
              name: 'transactions',
              type: _i1.getType<List<Map<String, dynamic>>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['transaction'] as _i8.TransactionEndpoint)
                  .bulkCreateTransactions(
            session,
            params['transactions'],
          ),
        ),
        'getTransactionStats': _i1.MethodConnector(
          name: 'getTransactionStats',
          params: {
            'startDate': _i1.ParameterDescription(
              name: 'startDate',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
            'endDate': _i1.ParameterDescription(
              name: 'endDate',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['transaction'] as _i8.TransactionEndpoint)
                  .getTransactionStats(
            session,
            startDate: params['startDate'],
            endDate: params['endDate'],
          ),
        ),
      },
    );

    connectors['user'] = _i1.EndpointConnector(
      name: 'user',
      endpoint: endpoints['user']!,
      methodConnectors: {
        'getProfile': _i1.MethodConnector(
          name: 'getProfile',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['user'] as _i9.UserEndpoint).getProfile(session),
        ),
        'updateProfile': _i1.MethodConnector(
          name: 'updateProfile',
          params: {
            'displayName': _i1.ParameterDescription(
              name: 'displayName',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'avatarUrl': _i1.ParameterDescription(
              name: 'avatarUrl',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'preferences': _i1.ParameterDescription(
              name: 'preferences',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['user'] as _i9.UserEndpoint).updateProfile(
            session,
            displayName: params['displayName'],
            email: params['email'],
            avatarUrl: params['avatarUrl'],
            preferences: params['preferences'],
          ),
        ),
        'deleteAccount': _i1.MethodConnector(
          name: 'deleteAccount',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['user'] as _i9.UserEndpoint).deleteAccount(session),
        ),
        'getPreferences': _i1.MethodConnector(
          name: 'getPreferences',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['user'] as _i9.UserEndpoint).getPreferences(session),
        ),
        'updatePreferences': _i1.MethodConnector(
          name: 'updatePreferences',
          params: {
            'preferences': _i1.ParameterDescription(
              name: 'preferences',
              type: _i1.getType<Map<String, dynamic>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['user'] as _i9.UserEndpoint).updatePreferences(
            session,
            params['preferences'],
          ),
        ),
      },
    );
  }
}

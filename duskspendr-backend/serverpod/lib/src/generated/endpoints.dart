import 'package:serverpod/serverpod.dart';

import '../endpoints/account_endpoint.dart';
import '../endpoints/budget_endpoint.dart';
import '../endpoints/category_endpoint.dart';
import '../endpoints/export_endpoint.dart';
import '../endpoints/health_endpoint.dart';
import '../endpoints/split_endpoint.dart';
import '../endpoints/transaction_endpoint.dart';
import '../endpoints/user_endpoint.dart';

class Endpoints extends EndpointDispatch {
  @override
  void initializeEndpoints(Serverpod serverpod) {
    // Health check
    registerEndpoint('health', HealthEndpoint(), serverpod);

    // Core business endpoints
    registerEndpoint('user', UserEndpoint(), serverpod);
    registerEndpoint('account', AccountEndpoint(), serverpod);
    registerEndpoint('category', CategoryEndpoint(), serverpod);
    registerEndpoint('transaction', TransactionEndpoint(), serverpod);
    registerEndpoint('budget', BudgetEndpoint(), serverpod);

    // Shared expenses
    registerEndpoint('split', SplitEndpoint(), serverpod);

    // Data export & GDPR
    registerEndpoint('export', ExportEndpoint(), serverpod);
  }
}

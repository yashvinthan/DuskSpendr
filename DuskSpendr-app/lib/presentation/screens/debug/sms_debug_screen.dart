import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/sms/sms_permission_service.dart';
import '../../../core/sms/sms_parser.dart';

class SmsDebugScreen extends ConsumerStatefulWidget {
  const SmsDebugScreen({super.key});

  @override
  ConsumerState<SmsDebugScreen> createState() => _SmsDebugScreenState();
}

class _SmsDebugScreenState extends ConsumerState<SmsDebugScreen> {
  final SmsPermissionService _permissionService = SmsPermissionService();
  final SmsInboxReader _inboxReader = SmsInboxReader();
  final SmsParser _smsParser = SmsParser();

  SmsPermissionStatus _permissionStatus = SmsPermissionStatus.denied;
  List<ParsedTransaction> _parsedTransactions = [];
  bool _isLoading = false;
  String _statusMessage = '';

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final status = await _permissionService.checkPermission();
    setState(() {
      _permissionStatus = status;
    });
  }

  Future<void> _requestPermission() async {
    final status = await _permissionService.requestPermission();
    setState(() {
      _permissionStatus = status;
    });
  }

  Future<void> _readSms() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Reading SMS...';
      _parsedTransactions = [];
    });

    try {
      // Read financial SMS only
      final result = await _inboxReader.readFinancialMessages(maxCount: 50);

      if (!result.success) {
        setState(() {
          _statusMessage = 'Error: ${result.error}';
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _statusMessage = 'Parsing ${result.messages.length} messages...';
      });

      // Parse messages
      final rawMessages = result.messages.map((m) => m.toRawSms()).toList();
      final parseResults = await _smsParser.parseBatch(rawMessages);

      final transactions = parseResults
          .where((r) => r.status == SmsParseStatus.success && r.transaction != null)
          .map((r) => r.transaction!)
          .toList();

      setState(() {
        _parsedTransactions = transactions;
        _statusMessage = 'Found ${transactions.length} transactions from ${result.messages.length} messages.';
        _isLoading = false;
      });

    } catch (e) {
      setState(() {
        _statusMessage = 'Exception: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SMS Debug'),
      ),
      body: Column(
        children: [
          _buildControlPanel(),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: LinearProgressIndicator(),
            ),
          if (_statusMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_statusMessage, style: Theme.of(context).textTheme.bodySmall),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: _parsedTransactions.length,
              itemBuilder: (context, index) {
                final tx = _parsedTransactions[index];
                return _buildTransactionCard(tx);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlPanel() {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Text('Permission: ${_permissionStatus.name}'),
                const Spacer(),
                if (_permissionStatus != SmsPermissionStatus.granted)
                  ElevatedButton(
                    onPressed: _requestPermission,
                    child: const Text('Request'),
                  )
                else
                  const Icon(Icons.check_circle, color: Colors.green),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _permissionStatus == SmsPermissionStatus.granted ? _readSms : null,
                icon: const Icon(Icons.sms),
                label: const Text('Read & Parse Financial SMS'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionCard(ParsedTransaction tx) {
    final currencyFormat = NumberFormat.currency(symbol: '₹', locale: 'en_IN');
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: tx.isDebit ? Colors.red.shade100 : Colors.green.shade100,
          child: Icon(
            tx.isDebit ? Icons.arrow_upward : Icons.arrow_downward,
            color: tx.isDebit ? Colors.red : Colors.green,
          ),
        ),
        title: Text(tx.merchantName ?? tx.upiId ?? 'Unknown Merchant'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(dateFormat.format(tx.timestamp)),
            Text(
              tx.rawSmsBody,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
        trailing: Text(
          currencyFormat.format(tx.amountPaisa / 100),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: tx.isDebit ? Colors.red : Colors.green,
          ),
        ),
        isThreeLine: true,
      ),
    );
  }
}

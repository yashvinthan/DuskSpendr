/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */
/*   NOTE: This file was manually created/modified because `serverpod generate` could not be run in the current environment. */
/*   It corresponds to `lib/src/protocol/transaction.yaml`. */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

class Transaction extends _i1.TableRow {
  Transaction({
    int? id,
    required this.userId,
    required this.amount,
    this.merchantName,
    this.categoryId,
    this.subcategoryId,
    this.description,
    required this.date,
    required this.source,
    this.accountId,
    required this.isRecurring,
    this.recurringId,
    this.tags,
    this.location,
    this.latitude,
    this.longitude,
    this.smsHash,
    required this.createdAt,
    this.updatedAt,
    this.syncedAt,
  }) : super(id);

  factory Transaction.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Transaction(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      userId: serializationManager.deserialize<int>(jsonSerialization['userId']),
      amount: serializationManager.deserialize<double>(jsonSerialization['amount']),
      merchantName: serializationManager.deserialize<String?>(jsonSerialization['merchantName']),
      categoryId: serializationManager.deserialize<int?>(jsonSerialization['categoryId']),
      subcategoryId: serializationManager.deserialize<int?>(jsonSerialization['subcategoryId']),
      description: serializationManager.deserialize<String?>(jsonSerialization['description']),
      date: serializationManager.deserialize<DateTime>(jsonSerialization['date']),
      source: serializationManager.deserialize<String>(jsonSerialization['source']),
      accountId: serializationManager.deserialize<int?>(jsonSerialization['accountId']),
      isRecurring: serializationManager.deserialize<bool>(jsonSerialization['isRecurring']),
      recurringId: serializationManager.deserialize<int?>(jsonSerialization['recurringId']),
      tags: serializationManager.deserialize<List<String>?>(jsonSerialization['tags']),
      location: serializationManager.deserialize<String?>(jsonSerialization['location']),
      latitude: serializationManager.deserialize<double?>(jsonSerialization['latitude']),
      longitude: serializationManager.deserialize<double?>(jsonSerialization['longitude']),
      smsHash: serializationManager.deserialize<String?>(jsonSerialization['smsHash']),
      createdAt: serializationManager.deserialize<DateTime>(jsonSerialization['createdAt']),
      updatedAt: serializationManager.deserialize<DateTime?>(jsonSerialization['updatedAt']),
      syncedAt: serializationManager.deserialize<DateTime?>(jsonSerialization['syncedAt']),
    );
  }

  static final t = TransactionTable();

  int userId;

  double amount;

  String? merchantName;

  int? categoryId;

  int? subcategoryId;

  String? description;

  DateTime date;

  String source;

  int? accountId;

  bool isRecurring;

  int? recurringId;

  List<String>? tags;

  String? location;

  double? latitude;

  double? longitude;

  String? smsHash;

  DateTime createdAt;

  DateTime? updatedAt;

  DateTime? syncedAt;

  @override
  _i1.Table get table => t;

  @override
  String get tableName => 'transactions';

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'amount': amount,
      'merchantName': merchantName,
      'categoryId': categoryId,
      'subcategoryId': subcategoryId,
      'description': description,
      'date': date,
      'source': source,
      'accountId': accountId,
      'isRecurring': isRecurring,
      'recurringId': recurringId,
      'tags': tags,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'smsHash': smsHash,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'syncedAt': syncedAt,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return toJson();
  }

  @override
  void setColumn(String columnName, value) {
    switch (columnName) {
      case 'id':
        id = value;
        return;
      case 'user_id':
        userId = value;
        return;
      case 'amount':
        amount = value;
        return;
      case 'merchant_name':
        merchantName = value;
        return;
      case 'category_id':
        categoryId = value;
        return;
      case 'subcategory_id':
        subcategoryId = value;
        return;
      case 'description':
        description = value;
        return;
      case 'date':
        date = value;
        return;
      case 'source':
        source = value;
        return;
      case 'account_id':
        accountId = value;
        return;
      case 'is_recurring':
        isRecurring = value;
        return;
      case 'recurring_id':
        recurringId = value;
        return;
      case 'tags':
        tags = (value as List?)?.cast<String>();
        return;
      case 'location':
        location = value;
        return;
      case 'latitude':
        latitude = value;
        return;
      case 'longitude':
        longitude = value;
        return;
      case 'sms_hash':
        smsHash = value;
        return;
      case 'created_at':
        createdAt = value;
        return;
      case 'updated_at':
        updatedAt = value;
        return;
      case 'synced_at':
        syncedAt = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  @override
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'user_id': userId,
      'amount': amount,
      'merchant_name': merchantName,
      'category_id': categoryId,
      'subcategory_id': subcategoryId,
      'description': description,
      'date': date,
      'source': source,
      'account_id': accountId,
      'is_recurring': isRecurring,
      'recurring_id': recurringId,
      'tags': tags,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'sms_hash': smsHash,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'synced_at': syncedAt,
    };
  }
}

class TransactionTable extends _i1.Table {
  TransactionTable() : super(tableName: 'transactions');

  late final id = _i1.ColumnInt('id', this);

  late final userId = _i1.ColumnInt('user_id', this);

  late final amount = _i1.ColumnDouble('amount', this);

  late final merchantName = _i1.ColumnString('merchant_name', this);

  late final categoryId = _i1.ColumnInt('category_id', this);

  late final subcategoryId = _i1.ColumnInt('subcategory_id', this);

  late final description = _i1.ColumnString('description', this);

  late final date = _i1.ColumnDateTime('date', this);

  late final source = _i1.ColumnString('source', this);

  late final accountId = _i1.ColumnInt('account_id', this);

  late final isRecurring = _i1.ColumnBool('is_recurring', this);

  late final recurringId = _i1.ColumnInt('recurring_id', this);

  late final tags = _i1.ColumnSerializable('tags', this);

  late final location = _i1.ColumnString('location', this);

  late final latitude = _i1.ColumnDouble('latitude', this);

  late final longitude = _i1.ColumnDouble('longitude', this);

  late final smsHash = _i1.ColumnString('sms_hash', this);

  late final createdAt = _i1.ColumnDateTime('created_at', this);

  late final updatedAt = _i1.ColumnDateTime('updated_at', this);

  late final syncedAt = _i1.ColumnDateTime('synced_at', this);

  @override
  List<_i1.Column> get columns => [
        id,
        userId,
        amount,
        merchantName,
        categoryId,
        subcategoryId,
        description,
        date,
        source,
        accountId,
        isRecurring,
        recurringId,
        tags,
        location,
        latitude,
        longitude,
        smsHash,
        createdAt,
        updatedAt,
        syncedAt,
      ];
}

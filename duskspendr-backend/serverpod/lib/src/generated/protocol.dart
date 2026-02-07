import 'package:serverpod/serverpod.dart' hide Transaction;
import 'package:serverpod/protocol.dart' show TableDefinition;

import '../util/serverpod_helpers.dart';
import 'transaction.dart';

/*   NOTE: This file was manually modified because `serverpod generate` could not be run in the current environment. */
/*   It exports and registers the `Transaction` model. */

export 'transaction.dart';

class Protocol extends SerializationManagerServer {
  Protocol._();

  static final Protocol _instance = Protocol._();

  factory Protocol() => _instance;

  @override
  String getModuleName() => 'duskspendr';

  @override
  Table? getTableForType(Type t) {
    if (t == Transaction) return Transaction.t;
    return null;
  }

  @override
  List<TableDefinition> getTargetTableDefinitions() => [];

  @override
  T deserialize<T>(dynamic data, [Type? t]) {
    t ??= T;

    if (t == getType<Map<String, dynamic>>()) {
      return _asMap(data) as T;
    }
    if (t == getType<Map<String, dynamic>?>()) {
      return (data == null ? null : _asMap(data)) as T;
    }
    if (t == getType<List<Map<String, dynamic>>>()) {
      return _asListOfMap(data) as T;
    }
    if (t == getType<List<Map<String, dynamic>>?>()) {
      return (data == null ? null : _asListOfMap(data)) as T;
    }
    if (t == getType<List<String>>()) {
      return _asListOfString(data) as T;
    }
    if (t == getType<List<String>?>()) {
      return (data == null ? null : _asListOfString(data)) as T;
    }
    if (t == getType<JsonMessage>()) {
      return JsonMessage.fromJson(_asMap(data), this) as T;
    }
    if (t == getType<JsonMessage?>()) {
      return (data == null ? null : JsonMessage.fromJson(_asMap(data), this))
          as T;
    }
    if (t == getType<Transaction>()) {
      return Transaction.fromJson(_asMap(data), this) as T;
    }
    if (t == getType<Transaction?>()) {
      return (data == null ? null : Transaction.fromJson(_asMap(data), this))
          as T;
    }
    if (t == getType<List<Transaction>>()) {
      return (data as List).map((e) => deserialize<Transaction>(e)).toList() as T;
    }

    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object data) {
    if (data is JsonMessage) {
      return 'JsonMessage';
    }
    if (data is Transaction) {
      return 'Transaction';
    }
    return super.getClassNameForObject(data);
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    if (data['className'] == 'JsonMessage') {
      return deserialize<JsonMessage>(data['data']);
    }
    if (data['className'] == 'Transaction') {
      return deserialize<Transaction>(data['data']);
    }
    return super.deserializeByClassName(data);
  }

  Map<String, dynamic> _asMap(dynamic data) {
    return Map<String, dynamic>.from(data as Map);
  }

  List<Map<String, dynamic>> _asListOfMap(dynamic data) {
    return (data as List)
        .map((entry) => Map<String, dynamic>.from(entry as Map))
        .toList();
  }

  List<String> _asListOfString(dynamic data) {
    return (data as List).map((entry) => entry as String).toList();
  }
}

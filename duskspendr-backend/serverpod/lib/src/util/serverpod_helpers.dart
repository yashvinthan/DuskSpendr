import 'package:postgres/postgres.dart';
import 'package:serverpod/serverpod.dart';

extension SessionDbQuery on Session {
  Future<PostgreSQLResult> query(
    String sql, {
    Map<String, dynamic>? parameters,
    int? timeoutInSeconds,
    Transaction? transaction,
  }) {
    return db.databaseConnection.query(
      this,
      sql,
      timeoutInSeconds: timeoutInSeconds,
      transaction: transaction,
      substitutionValues: parameters ?? const {},
    );
  }
}

class JsonMessage extends SerializableEntity {
  JsonMessage(this.data);

  final Map<String, dynamic> data;

  factory JsonMessage.fromJson(
    Map<String, dynamic> jsonSerialization,
    SerializationManager serializationManager,
  ) {
    return JsonMessage(Map<String, dynamic>.from(jsonSerialization));
  }

  @override
  Map<String, dynamic> toJson() => data;

  @override
  Map<String, dynamic> allToJson() => data;
}

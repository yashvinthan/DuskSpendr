import 'package:postgres/postgres.dart';

class SyncDb {
  SyncDb(this.connection);

  final PostgreSQLConnection connection;

  static Future<SyncDb> connect(String url) async {
    final uri = Uri.parse(url);
    final connection = PostgreSQLConnection(
      uri.host,
      uri.port == 0 ? 5432 : uri.port,
      uri.path.replaceFirst('/', ''),
      username: uri.userInfo.split(':').first,
      password: uri.userInfo.split(':').length > 1
          ? uri.userInfo.split(':')[1]
          : null,
      useSSL: uri.queryParameters['sslmode'] == 'require',
    );
    await connection.open();
    await connection.query('''
      CREATE TABLE IF NOT EXISTS sync_transactions (
        id SERIAL PRIMARY KEY,
        user_id TEXT NOT NULL,
        payload JSONB NOT NULL,
        created_at TIMESTAMPTZ NOT NULL DEFAULT now()
      );
    ''');
    return SyncDb(connection);
  }

  Future<void> insertSync(String userId, String payload) async {
    await connection.query(
      'INSERT INTO sync_transactions (user_id, payload) VALUES (@userId, @payload::jsonb);',
      substitutionValues: {
        'userId': userId,
        'payload': payload,
      },
    );
  }

  Future<void> close() async {
    await connection.close();
  }
}

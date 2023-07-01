import 'package:galileo_mysql/galileo_mysql.dart';

Future<MySqlConnection> onConnToDb() async {
  try {
    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: 'localhost',
        port: 3306,
        user: 'root',
        password: 'root',
        db: 'dentistry_db'));
    return conn;
  } catch (e) {
    print(e);
    rethrow;
  }
}

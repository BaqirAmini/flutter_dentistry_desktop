import 'dart:io';
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
  } on SocketException catch (e) {
    print('Could not connect to the database. Error: ${e.message}');
    return Future.error(e);
  } catch (e) {
    print(e);
    return Future.error(e);
  }
}

import 'package:galileo_mysql/galileo_mysql.dart';

void main() => onConnToDb();

Future onConnToDb() async {
  try {
    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: 'localhost',
        port: 3306,
        user: 'root',
        password: 'root',
        db: 'dentistry_db'));
    return conn;
   /*   var query = await conn.query(
        'INSERT INTO staff (username, password, role) VALUES (?, ?, ?)',
        ['baqir123', '102330', 'Dentist']);
    if (query.affectedRows! > 0) {
      print('Insert successful!');
    } else {
      print('Insert failed.');
    } 
    await conn.close(); */
  } catch (e) {
    print(e);
  }
}

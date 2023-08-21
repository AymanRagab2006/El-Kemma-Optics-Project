// import 'package:mysql1/mysql1.dart';
//
// MySqlConnection? _dbConnection;
//
// Future<void> connectToDB() async {
//   // final settings = ConnectionSettings(
//   //   host: 'sql7.freesqldatabase.com',
//   //   port: 3306,
//   //   user: 'sql7634978',
//   //   password: 'mrUMgaMtdg',
//   //   db: 'sql7634978',
//   // );
//
//   final settings = ConnectionSettings(
//     host: '127.0.0.1',
//     port: 3306,
//     user: 'root',
//     password: 'aymanragab@2006',
//     db: 'elkemma',
//   );
//
//   try {
//     _dbConnection = await MySqlConnection.connect(settings);
//   } catch (e) {
//     print('Error connecting to the database: $e');
//     rethrow; // Rethrow the exception to handle it at a higher level
//   }
// }
//
// Future<MySqlConnection> getDBConnection() async {
//   if (_dbConnection == null) {
//     await connectToDB();
//   } else {
//     // Check if the connection is still valid by performing a simple query
//     try {
//       await _dbConnection!.query('SELECT 1');
//     } catch (_) {
//       // If the query fails, it means the connection is closed or invalid
//       // Re-establish the connection
//       await connectToDB();
//     }
//   }
//
//   return _dbConnection!;
// }
//
// Future<void> closeDBConnection() async {
//   if (_dbConnection != null) {
//     await _dbConnection!.close();
//     _dbConnection = null;
//   }
// }
// import 'package:city_customer_app/models/card_info.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// class DatabaseHelper {
//   static final DatabaseHelper _instance = DatabaseHelper._internal();

//   factory DatabaseHelper() => _instance;

//   DatabaseHelper._internal();

//   Database? _database;

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await initDatabase();
//     return _database!;
//   }

//   Future<Database> initDatabase() async {
//     String path = join(await getDatabasesPath(), 'your_database_name.db');
//     return openDatabase(
//       path,
//       version: 1,
//       onCreate: (db, version) async {
//         // Create tables here
//         await db.execute('''
//           CREATE TABLE card_info (
//             id INTEGER PRIMARY KEY AUTOINCREMENT,
//             cardNumber TEXT,
//             cardHolderName TEXT,
//             expiryDate TEXT,
//             cvv TEXT
//           )
//         ''');
//       },
//     );
//   }

//   // Add methods to insert, query, update, and delete card information here
//   Future<int> insertCard(CardInfo card) async {
//     final db = await database;
//     return await db.insert('card_info', card.toMap());
//   }

//   Future<List<CardInfo>> getCards() async {
//     final db = await database;
//     final List<Map<String, dynamic>> maps = await db.query('card_info');
//     return List.generate(maps.length, (i) {
//       return CardInfo(
//         id: maps[i]['id'],
//         cardNumber: maps[i]['cardNumber'],
//         cardHolderName: maps[i]['cardHolderName'],
//         expiryDate: maps[i]['expiryDate'],
//         cvv: maps[i]['cvv'],
//       );
//     });
//   }
// }

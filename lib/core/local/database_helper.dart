// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';

// class DatabaseHelper {
//   static Database? _db;

//   Future<Database> get db async {
//     if (_db != null) {
//       return _db!;
//     } else {
//       _db = await initDatabase();
//       return _db!;
//     }
//   }

//   Future<Database?> initDatabase() async {
//     String dbpath = await getDatabasesPath();
//     String path = join(dbpath, "store_favorites.db");

//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: (db, version) {
//         db.execute('''
//   CREATE TABLE store_favorites (
//     id INTEGER PRIMARY KEY AUTOINCREMENT,
//     name TEXT ,
//     username TEXT NOT NULL,
//     image TEXT ,
//     location TEXT
//   )
//   ''');
//       },
//     );
//   }

//   // insert store to database

//   Future<void> insertFavStore(Map<String, dynamic> store) async {
//     final database = await db;

//     database.insert("store_favorites", store);
//   }

//   // remove store from database

//   Future<void> removeFavStore(String username) async {
//     final database = await db;

//     database.delete(
//       "store_favorites",
//       where: "username = ?",
//       whereArgs: [username],
//     );
//   }

//   // get all list of favorites

//   Future<List<Map<String, dynamic>>> getAllFavStore() async {
//     final database = await db;
//     final maps = database.query("store_favorites");
//     return maps;
//   }
// }

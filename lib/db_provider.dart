import 'package:plus_minus_flutter/models/activity.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// class ActivityProvider {
//   final dbName = "plus_minus.db";
//   final tableName = "activities";
//   Database db;

//   Future<Database> open() async {
//     String path = await getDatabasesPath();
//     db = await openDatabase(
//       join(path, dbName),
//       version: 1,
//       onCreate: (Database db, int version) async {
//         await db.execute(
//             "CREATE TABLE activities (id INTEGER PRIMARY KEY, weight REAL, createdAt TEXT)");
//       },
//     );
//   }

//   Future<int> create({String title, String content}) async {
//     open();
//     return await db.insert(
//       tableName,
//       {
//         "title": title,
//         "content": content,
//       },
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }
// }

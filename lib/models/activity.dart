import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ActivityProvider {
  final dbName = "plus_minus.db";
  final tableName = "activities";
  Database db;

  ActivityProvider();

  Future<Database> initDB() async {
    String path = await getDatabasesPath();
    return await openDatabase(
      join(path, dbName),
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
            "CREATE TABLE activities (id INTEGER PRIMARY KEY, weight REAL, createdAt TEXT)");
      },
    );
  }

  Future<Database> get database async {
    if (db == null) {
      db = await initDB();
    }
    return db;
  }

  Future<int> insert({double weight, DateTime createdAt}) async {
    final db = await database;
    return await db.insert(
      tableName,
      {
        "weight": weight,
        "createdAt": createdAt.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> update({int id, double weight}) async {
    final db = await database;
    await db.update(
      tableName,
      {
        "weight": weight,
      },
      where: "id = ?",
      whereArgs: [id],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  Future<Map> selectBetweenInDay(DateTime createdAt) async {
    DateTime startAt =
        new DateTime(createdAt.year, createdAt.month, createdAt.day);
    DateTime endAt =
        new DateTime(createdAt.year, createdAt.month, createdAt.day + 1);
    final db = await database;
    final res = await db.rawQuery(
        "SELECT * from ${tableName} WHERE createdAt BETWEEN '${startAt.toIso8601String()}' AND '${endAt.toIso8601String()}'");
    if (res.length == 0) {
      return null;
    } else {
      return res[0];
    }
  }
}

class Activity {
  int id;
  DateTime createdAt;
  double weight;

  Activity({this.id, this.createdAt, this.weight});

  bool inDay(DateTime date) {
    return createdAt.year == date.year &&
        createdAt.month == date.month &&
        createdAt.day == date.day;
  }

  static Activity findbyDate(DateTime date) {
    return Activity(
        id: 1, createdAt: DateTime.now().add(Duration(days: -2)), weight: 56.4);
  }

  static Future<Activity> create({double weight, DateTime createdAt}) async {
    ActivityProvider db = ActivityProvider();
    int id = await db.insert(weight: weight, createdAt: createdAt);
    return Activity(id: id, weight: weight, createdAt: createdAt);
  }

  static Future<Activity> findByDate(DateTime date) async {
    ActivityProvider db = ActivityProvider();
    Map map = await db.selectBetweenInDay(date);
    if (map == null) {
      return null;
    }
    DateTime createdAt = DateTime.parse(map["createdAt"]);
    return Activity(id: map["id"], weight: map["weight"], createdAt: createdAt);
  }

  Future update() async {
    ActivityProvider db = ActivityProvider();
    await db.update(id: id, weight: weight);
  }
}
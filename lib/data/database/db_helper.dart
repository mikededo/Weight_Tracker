import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/weight.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._instance();
  static Database _db;

  DBHelper._instance();

  Future<Database> get db async {
    if (_db == null) {
      _db = await _initDB();
    }

    return _db;
  }

  Future<Database> _initDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'weight_tracker.db';

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
        CREATE TABLE IF NOT EXISTS ${WeightData.W_TABLE_NAME}
        (
          ${WeightData.W_COL_ID} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${WeightData.W_COL_WEIGHT} REAL NOT NULL,
          ${WeightData.W_COL_DATE} TEXT NOT NULL
        )
      ''');
  }
}

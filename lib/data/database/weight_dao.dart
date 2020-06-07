import 'package:sqflite/sqflite.dart';

import './db_helper.dart';
import '../models/weight.dart';

class WeightDao {
  final DBHelper _database = DBHelper.instance;

  Future<List<Map<String, dynamic>>> get _weightList async {
    Database db = await _database.db;

    return await db.query(WeightData.W_TABLE_NAME);
  }

  Future<List<WeightData>> get weightDataList async {
    List<Map<String, dynamic>> map = await _weightList;
    List<WeightData> list = [];

    map.forEach(
      // Create a reversed list
      (wd) => list.add(WeightData.fromMap(wd)),
    );

    list.sort((wa, wb) => wb.date.compareTo(wa.date));

    return list;
  }

  Future<void> addWeight(WeightData wd) async {
    Database db = await _database.db;

    List<Map<String, dynamic>> res = await db.rawQuery(
      """
        SELECT *
        FROM ${WeightData.W_TABLE_NAME}
        WHERE ${WeightData.W_COL_DATE}=?
      """,
      [wd.date.toIso8601String()],
    );

    // We ensure that each day is not repeated along the app
    // There's no point on having multiple weights the same day
    if (res.isNotEmpty) {
      await updateWeight(
        wd.copyWith(
          id: res.first[WeightData.W_COL_ID].toString(),
        ),
      );
    } else {
      await db.insert(
        WeightData.W_TABLE_NAME,
        wd.toMap(),
      );
    }
  }

  Future<void> updateWeight(WeightData wd) async {
    Database db = await _database.db;

    await db.update(
      WeightData.W_TABLE_NAME,
      wd.toMap(),
      where: '${WeightData.W_COL_ID} = ?',
      whereArgs: [wd.id],
    );
  }

  Future<void> deleteWeight(WeightData wd) async {
    Database db = await _database.db;

    await db.delete(
      WeightData.W_TABLE_NAME,
      where: '${WeightData.W_COL_ID} = ?',
      whereArgs: [wd.id],
    );
  }

  Future<void> deleteAllWeight() async {
    Database db = await _database.db;

    return await db.delete(WeightData.W_TABLE_NAME);
  }
}

import 'package:flutter_sqflite/models/model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqlite_api.dart';

abstract class DBHelper {
  static Database? _db;
  static get _version => 1;

  static Future<void> int() async {
    if (_db != null) {
      return;
    }
    try {
      var databasePath = await getDatabasesPath();
      String _path = p.join(databasePath, 'flutter_sqflite.db');
      _db = await openDatabase(_path,
          version: _version, onCreate: onCreate, onUpgrade: onUpgrade);
    } catch (ex) {
      print(ex);
    }
  }

  static void onCreate(Database db, version) async {
    String sqlQuery =
        'CREAT TABLE products (id INTEGER PRIMARY KEY AUTOINCREMENT, productName STRING, categoryId INTEGER, productDesc STRING, price REAL )';
    await db.execute(sqlQuery);
  }

  static void onUpgrade(Database db, oldVersion, version) async {
    String sqlQuery =
        'CREAT TABLE products (id INTEGER PRIMARY KEY AUTOINCREMENT, productName STRING, categoryId INTEGER, productDesc STRING, price REAL )';
    await db.execute(sqlQuery);
    if (oldVersion > version) {
      //
    }
  }

  static Future<List<Map<String, dynamic>>> query(String table) async {
    return _db!.query(table);
  }

  static Future<dynamic> insert(String table, Model model) async {
    return await _db!.insert(table, model.toJson());
  }

  static Future<dynamic> update(String table, Model model) async {
    return await _db!.update(
      table,
      model.toJson(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  static Future<dynamic> delete(String table, Model model) async {
    return await _db!.delete(
      table,
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }
}

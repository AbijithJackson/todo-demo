import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class HelperDemo{
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE itemss(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    title TEXT,
    description TEXT,
    note TEXT,
    createdAT TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )
    """);
  }
  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'newtodo.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }


  // Create new item (journal)
  static Future<int> createItem(String title, String? description, String note) async {
    final db = await HelperDemo.db();

    final data = {'title': title, 'description': description,'note': note};
    final id = await db.insert('itemss', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all items (journals)
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await HelperDemo.db();
    return db.query('itemss', orderBy: "id");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await HelperDemo.db();
    return db.query('itemss', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateItem(
      int id, String title, String? description, String? note) async {
    final db = await HelperDemo.db();

    final data = {
      'title': title,
      'description': description,
      'note': note,
      'createdAt': DateTime.now().toString()
    };

    final result =
    await db.update('itemss', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteItem(int id) async {
    final db = await HelperDemo.db();
    try {
      await db.delete("itemss", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}


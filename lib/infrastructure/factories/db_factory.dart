import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseFactory {
  Future<Database> createDatabase() async {
    Directory databaseDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(databaseDirectory.path, 'ssia_app.db');

    var database = await openDatabase(dbPath, version: 1, onCreate: populateDb);
    return database;
  }

  void populateDb(Database db, int version) async {
    await _createNodeTable(db);
  }

  _createNodeTable(Database db) async {
    await db
        .execute(
          """CREATE TABLE nodes(
        node_id TEXT PRIMARY KEY,
        parent_id TEXT,
        name TEXT,
        description TEXT,
        position INTEGER,
        icon_name TEXT)""",
        )
        .then((_) => print('creating table nodes...'))
        .catchError((e) => print('error creating table nodes: $e'));
  }
}

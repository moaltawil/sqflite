import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;

class DBHelper {
  static Database? _db;

  static const String _databaseName = 'tasks_db';

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }

    final io.Directory directory = await getApplicationDocumentsDirectory();

    final String dbPath = '${directory.path}$_databaseName';
    Database newDb = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        db.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT)');
      },
    );
    return newDb;
  }
}

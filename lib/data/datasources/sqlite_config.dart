import 'package:sqflite/sqflite.dart';

class SqliteHelper {
  static Database? _database;
  static final SqliteHelper instance = SqliteHelper._privateConstructor();

  SqliteHelper._privateConstructor();

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDB();

    return _database;
  }

  Future<Database> initDB() async {
    // final databaseDirecotry = await getDatabasesPath();
    // final path = join(databaseDirecotry, 'patitas.db');

    // print('path $path');

    final data = openDatabase(
      'assets/database/rg.db',
      version: 1,
    );
    return await data;
  }
}
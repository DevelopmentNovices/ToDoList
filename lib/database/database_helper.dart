import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todolist/database/tasks.dart';
import 'package:todolist/database/labels.dart';
import 'package:todolist/database/link_labels_to_task.dart';

class DatabaseHelper {
  static const String _databaseName = "todolist_database.db";
  static const int _databaseVersion = 1;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, _databaseName);
    return await openDatabase(path,
      version: _databaseVersion,
      onConfigure: _onConfigure,
      onCreate: _onCreate);
  }

  Future _onConfigure(db) async {
    await db.execute('PRAGMA foreign_keys = ON;');
  }

  Future _onCreate(Database db, int version) async {
    await TasksHelper.onCreate(db, version);
    await LabelsHelper.onCreate(db, version);
    await LinkLabelsToTaskHelper.onCreate(db, version);
  }
}

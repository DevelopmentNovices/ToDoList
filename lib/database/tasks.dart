import 'package:sqflite/sqflite.dart';
import 'package:todolist/database/database_helper.dart';

const String _table = 'Tasks';
const String _columnId = 'id';
const String _columnTitle = 'title';

class Task {
  int? id;
  String title;

  Task({this.id, required this.title});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, Object?>{
      _columnTitle: title,
    };
    if (id != null) {
      map[_columnId] = id;
    }
    return map;
  }
}

class TasksHelper {
  TasksHelper._privateConstructor();

  static Future onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_table (
      $_columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $_columnTitle TEXT NOT NULL
    )''');
  }

  static Future<Task> insert(Task task) async {
    Database? db = await DatabaseHelper.instance.database;
    task.id = await db!.insert(_table, task.toMap());
    return task;
  }

  static Future<List<Task>> queryAll() async {
    Database? db = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> maps = await db!.query(_table);
    return List.generate(maps.length, (i) {
      return Task(id: maps[i][_columnId], title: maps[i][_columnTitle]);
    });
  }
}

import 'package:sqflite/sqflite.dart';
import 'package:todolist/database/database_helper.dart';

const String _table = 'Link_Labels_to_Task';
const String _tasksTable = 'Tasks';
const String _tasksId = 'id';
const String _labelsTable = 'Labels';
const String _labelsId = 'id';
const String _columnTaskId = 'task_id';
const String _columnLabelId = 'label_id';

class LinkLabelsToTask {
  int taskId;
  int labelId;

  LinkLabelsToTask({required this.taskId, required this.labelId});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, Object?>{
      _columnTaskId: taskId,
      _columnLabelId: labelId,
    };
    return map;
  }
}

class LinkLabelsToTaskHelper {
  LinkLabelsToTaskHelper._privateConstructor();

  static Future onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_table (
      $_columnTaskId INTEGER NOT NULL,
      $_columnLabelId INTEGER NOT NULL,
      FOREIGN KEY ($_columnTaskId) REFERENCES $_tasksTable($_tasksId) ON DELETE CASCADE,
      FOREIGN KEY ($_columnLabelId) REFERENCES $_labelsTable($_labelsId) ON DELETE CASCADE
    )''');
  }

  static Future<LinkLabelsToTask> insert(
      LinkLabelsToTask linkLabelsToTask) async {
    Database? db = await DatabaseHelper.instance.database;
    await db!.insert(_table, linkLabelsToTask.toMap());
    return linkLabelsToTask;
  }

  static Future<List<LinkLabelsToTask>> queryAll() async {
    Database? db = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> maps = await db!.query(_table);
    return List.generate(maps.length, (i) {
      return LinkLabelsToTask(
          taskId: maps[i][_columnTaskId], labelId: maps[i][_columnLabelId]);
    });
  }
}

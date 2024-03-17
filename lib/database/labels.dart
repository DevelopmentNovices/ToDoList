import 'package:sqflite/sqflite.dart';
import 'package:todolist/database/database_helper.dart';

const String _table = 'Labels';
const String _columnId = 'id';
const String _columnName = 'name';

class Label {
  int? id;
  String name;

  Label({this.id, required this.name});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, Object?>{
      _columnName: name,
    };
    if (id != null) {
      map[_columnId] = id;
    }
    return map;
  }
}

class LabelsHelper {
  LabelsHelper._privateConstructor();

  static Future onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_table (
      $_columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $_columnName TEXT NOT NULL
    )''');
  }

  static Future<Label> insert(Label label) async {
    Database? db = await DatabaseHelper.instance.database;
    label.id = await db!.insert(_table, label.toMap());
    return label;
  }

  static Future<List<Label>> queryAll() async {
    Database? db = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> maps = await db!.query(_table);
    return List.generate(maps.length, (i) {
      return Label(id: maps[i][_columnId], name: maps[i][_columnName]);
    });
  }
}
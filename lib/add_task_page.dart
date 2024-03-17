import 'package:flutter/material.dart';
import 'package:todolist/database/labels.dart';
import 'package:todolist/database/link_labels_to_task.dart';
import 'package:todolist/database/tasks.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  String _text = '';
  final List<Label> _selectedLabels = [];
  List<Label> _unselectedLabels = [];

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    _unselectedLabels = await LabelsHelper.queryAll();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Taskを追加'),
        ),
        body: Container(
            padding: const EdgeInsets.all(64),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_text, style: const TextStyle(color: Colors.blue)),
                const SizedBox(height: 8),
                TextField(onChanged: (String value) {
                  setState(() {
                    _text = value;
                  });
                }),
                const SizedBox(height: 8),
                SizedBox(
                  height: 30,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _selectedLabels.length,
                    itemBuilder: ((context, index) => ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          child: Text(_selectedLabels[index].name),
                          onPressed: () => setState(() {
                            _unselectedLabels.add(_selectedLabels[index]);
                            _selectedLabels.remove(_selectedLabels[index]);
                          }),
                        )),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 30,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _unselectedLabels.length,
                    itemBuilder: ((context, index) => ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            side: const BorderSide(color: Colors.blue),
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blue,
                          ),
                          child: Text(_unselectedLabels[index].name),
                          onPressed: () => setState(() {
                            _selectedLabels.add(_unselectedLabels[index]);
                            _unselectedLabels.remove(_unselectedLabels[index]);
                          }),
                        )),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white),
                    onPressed: () async{
                      if(_text != ''){
                        Task task = await TasksHelper.insert(Task(title: _text));
                        for (var label in _selectedLabels) {
                          LinkLabelsToTaskHelper.insert(LinkLabelsToTask(
                            taskId: task.id!,
                            labelId: label.id!,
                          ));
                        }
                      }
                      if (!context.mounted) return;
                      Navigator.of(context).pop();
                    },
                    child: const Text('タスクを追加'),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('キャンセル'),
                  ))
                ],
            )));
  }
}

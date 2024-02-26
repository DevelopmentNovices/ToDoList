import 'package:flutter/material.dart';
import 'package:todolist/add_task_page.dart';
import 'package:todolist/database/tasks.dart';

class ToDoListPage extends StatefulWidget {
  const ToDoListPage({Key? key}) : super(key: key);
  @override
  State<ToDoListPage> createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('リスト一覧'),
      ),
      body: FutureBuilder(
          future: TasksHelper.queryAll(),
          builder: (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                      child:
                          ListTile(title: Text(snapshot.data![index].title)));
                },
              );
            } else {
              return const Text('Awaiting result...');
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final String newTaskText = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
            return const AddTaskPage();
          }));
          setState(() {
            TasksHelper.insert(Task(title: newTaskText));
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

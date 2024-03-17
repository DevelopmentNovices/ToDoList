import 'package:flutter/material.dart';
import 'package:todolist/database/labels.dart';
import 'package:todolist/add_label_page.dart';

class EditLabelPage extends StatefulWidget {
  const EditLabelPage({super.key});

  @override
  State<EditLabelPage> createState() => _EditLabelPageState();
}

class _EditLabelPageState extends State<EditLabelPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Labelを管理'),
      ),
      body: FutureBuilder(
        future: LabelsHelper.queryAll(),
        builder:(BuildContext context, AsyncSnapshot<List<Label>> snapshot) {
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
                  ListTile(title: Text(snapshot.data![index].name)));
              },
            );
          } else {
            return const Text('Awaiting result...');
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final String? newLabelText = await Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) {
            return const AddLabelPage();
          }));
          setState(() {
            if (newLabelText != null) {
              LabelsHelper.insert(Label(name: newLabelText));
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

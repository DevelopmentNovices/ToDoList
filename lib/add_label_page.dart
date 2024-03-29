import 'package:flutter/material.dart';

class AddLabelPage extends StatefulWidget {
  const AddLabelPage({super.key});

  @override
  State<AddLabelPage> createState() => _AddLabelPageState();
}

class _AddLabelPageState extends State<AddLabelPage> {
  String _text = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Labelを追加'),
        ),
        body: Container(
            padding: const EdgeInsets.all(64),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(_text, style: const TextStyle(color: Colors.blue)),
                const SizedBox(height: 8),
                TextField(onChanged: (String value) {
                  setState(() {
                    _text = value;
                  });
                }),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop(_text);
                    },
                    child: const Text('Labelを追加'),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(_text);
                      },
                      child: const Text('キャンセル'),
                    ))
              ],
            )));
  }
}

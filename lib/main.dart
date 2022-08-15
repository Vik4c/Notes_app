import 'package:flutter/material.dart';
import 'views/note_list.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'List of notes',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const NoteList(title: 'List of notes'),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rest_api_app1/router.dart';
import 'package:rest_api_app1/views/note_list_screen.dart';

void main() {
  //provider scope is a must have with riverpod
  runApp(const ProviderScope(child: App()));
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
      initialRoute: NoteListScreen.routePath,
      onGenerateRoute: (settings) => AppRouter.onGenerateRoute(settings),
    );
  }
}

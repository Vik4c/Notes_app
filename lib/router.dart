import 'package:flutter/material.dart';
import 'package:rest_api_app1/views/note_list_screen.dart';
import 'package:rest_api_app1/views/note_modify_screen.dart';

class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case NoteListScreen.routePath:
        return MaterialPageRoute(
          builder: (_) => const NoteListScreen(),
          settings: settings,
          fullscreenDialog: true,
          maintainState: true,
        );
      case NoteModifyScreen.routePath:
        return MaterialPageRoute(
          builder: (_) => const NoteModifyScreen(),
          settings: settings,
          fullscreenDialog: true,
          maintainState: true,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const NoteListScreen(),
          settings: settings,
          fullscreenDialog: true,
          maintainState: true,
        );
    }
  }
}

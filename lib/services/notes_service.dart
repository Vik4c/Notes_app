import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rest_api_app1/models/note.dart';
import 'package:rest_api_app1/models/note_for_listing.dart';
import 'package:http/http.dart' as http;
import 'package:rest_api_app1/globals.dart' as globals;
import 'package:rest_api_app1/models/note_insert.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NoteService {
  Future<List<NoteForListing>> getNotesList() async {
    List<NoteForListing> listNotes = [];
    var endpoint = '${globals.coreAPI}/notes';
    var url = Uri.parse(endpoint);
    try {
      final response = await http.get(url, headers: {'apiKey': globals.apiKey});
      if (response.statusCode == 200) {
        var notesDecoded = json.decode(response.body);
        for (var note in notesDecoded) {
          listNotes.add(NoteForListing.fromMap(note));
        }
      }
      return listNotes;
    } catch (e) {
      return Future.error('An error has occured');
    }
  }

  Future<Note?> getNote(String noteID) async {
    Note? item;
    var endpoint = '${globals.coreAPI}/notes/$noteID';
    var url = Uri.parse(endpoint);
    try {
      final response = await http.get(url, headers: {'apiKey': globals.apiKey});
      debugPrint("Status code: ${response.statusCode}");
      if (response.statusCode == 200) {
        var noteDecoded = json.decode(response.body);
        item = Note.fromMap(noteDecoded);
      }
      return item;
    } catch (e) {
      return null;
    }
  }

  Future<bool> createNote(NoteInsert item) async {
    var endpoint = '${globals.coreAPI}/notes';
    var url = Uri.parse(endpoint);
    Map<String, String>? header = {
      'apiKey': globals.apiKey,
      "Content-Type": "application/json",
    };
    var body = jsonEncode(<String, String>{
      "noteTitle": item.noteTitle,
      "noteContent": item.noteContent,
    });
    try {
      final response = await http.post(
        url,
        headers: header,
        body: body,
      );
      debugPrint("Status code: ${response.statusCode}");
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> editNote(NoteInsert item, String noteID) async {
    var endpoint = '${globals.coreAPI}/notes/$noteID';
    var url = Uri.parse(endpoint);
    Map<String, String>? header = {
      'apiKey': globals.apiKey,
      "Content-Type": "application/json",
    };
    var body = jsonEncode(<String, String>{
      "noteTitle": item.noteTitle,
      "noteContent": item.noteContent,
    });
    try {
      final response = await http.put(
        url,
        headers: header,
        body: body,
      );
      debugPrint("Status code: ${response.statusCode}");
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 201 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        return true;
      } else {
        return false;
      }
    } on Exception {
      return false;
    }
  }

  Future<bool> deleteNote(String noteID) async {
    var endpoint = '${globals.coreAPI}/notes/$noteID';
    var url = Uri.parse(endpoint);
    Map<String, String>? header = {
      'apiKey': globals.apiKey,
      "Content-Type": "application/json",
    };

    try {
      final response = await http.delete(
        url,
        headers: header,
      );
      debugPrint("Status code: ${response.statusCode}");
      if (response.statusCode == 204) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}

final noteServiceRepositoryProvider = Provider<NoteService>((ref) {
  return NoteService();
});

final getNotesListFutureProvider =
    FutureProvider.autoDispose<List<NoteForListing>>(
  (ref) {
    final getNotesListProvider = ref.watch(noteServiceRepositoryProvider);
    return getNotesListProvider.getNotesList();
  },
);

final getNoteFutureProvider = FutureProvider.autoDispose.family<Note?, String>(
  (ref, noteId) {
    final getNoteProvider = ref.watch(noteServiceRepositoryProvider);
    return getNoteProvider.getNote(noteId);
  },
);

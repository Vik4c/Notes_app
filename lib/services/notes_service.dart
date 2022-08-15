import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rest_api_app1/models/note.dart';
import 'package:rest_api_app1/models/note_for_listing.dart';
import 'package:http/http.dart' as http;
import 'package:rest_api_app1/services/globals.dart' as globals;
import 'package:rest_api_app1/models/note_insert.dart';

class NoteService {
  NoteService._instantiate();
  static final NoteService instance = NoteService._instantiate();
  Future<List<NoteForListing>> getNotesList() async {
    List<NoteForListing> list = [];
    var endpoint = '${globals.coreAPI}/notes';
    var url = Uri.parse(endpoint);
    try {
      final response = await http.get(url, headers: {'apiKey': globals.apiKey});
      if (response.statusCode == 200) {
        var notesDecoded = json.decode(response.body);
        for (var note in notesDecoded) {
          list.add(NoteForListing.fromMap(note));
        }
      }
      return list;
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

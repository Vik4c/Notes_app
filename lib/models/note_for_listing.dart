import 'dart:convert';
import 'package:intl/intl.dart';

class NoteForListing {
  String noteID;
  String noteTitle;
  String createDateTime;
  String? lastestEditDateTime;
  NoteForListing({
    required this.noteID,
    required this.noteTitle,
    required this.createDateTime,
    this.lastestEditDateTime,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'noteID': noteID,
      'noteTitle': noteTitle,
      'createDateTime': createDateTime,
      'lastestEditDateTime': lastestEditDateTime,
    };
  }

  factory NoteForListing.fromMap(Map<String, dynamic> map) {
    return NoteForListing(
      noteID: map['noteID'] as String,
      noteTitle: map['noteTitle'] as String,
      createDateTime:
          DateFormat.yMMMEd().format(DateTime.parse(map['createDateTime'])),
      lastestEditDateTime: null,
    );
  }

  String toJson() => json.encode(toMap());

  factory NoteForListing.fromJson(String source) =>
      NoteForListing.fromMap(json.decode(source) as Map<String, dynamic>);
}

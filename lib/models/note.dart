import 'dart:convert';

class Note {
  String noteID;
  String noteTitle;
  String noteContent;

  Note({
    required this.noteID,
    required this.noteTitle,
    required this.noteContent,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'noteID': noteID,
      'noteTitle': noteTitle,
      'noteContent': noteContent,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      noteID: map['noteID'] as String,
      noteTitle: map['noteTitle'] as String,
      noteContent: map['noteContent'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Note.fromJson(String source) =>
      Note.fromMap(json.decode(source) as Map<String, dynamic>);
}

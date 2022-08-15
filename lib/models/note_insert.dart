import 'dart:convert';

class NoteInsert {
  String noteTitle;
  String noteContent;

  NoteInsert({
    required this.noteTitle,
    required this.noteContent,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'noteTitle': noteTitle,
      'noteContent': noteContent,
    };
  }

  factory NoteInsert.fromMap(Map<String, dynamic> map) {
    return NoteInsert(
      noteTitle: map['noteTitle'] as String,
      noteContent: map['noteContent'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory NoteInsert.fromJson(String source) =>
      NoteInsert.fromMap(json.decode(source) as Map<String, dynamic>);
}

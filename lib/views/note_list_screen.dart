import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rest_api_app1/common_widget/async_value_widget.dart';
import 'package:rest_api_app1/models/note_for_listing.dart';
import 'package:rest_api_app1/services/notes_service.dart';
import 'package:rest_api_app1/views/note_delete_file.dart';
import 'package:rest_api_app1/views/note_modify_screen.dart';

class NoteListScreen extends StatefulWidget {
  static const routePath = 'note-list';
  const NoteListScreen({Key? key}) : super(key: key);

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final noteListValue = ref.watch(getNotesListFutureProvider);

      return AsyncValueWidget<List<NoteForListing>>(
        value: noteListValue,
        data: (notes) => Scaffold(
          appBar: AppBar(
            title: const Text('List of notes'),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Navigator.of(context)
              //     .push(
              //   MaterialPageRoute(
              //     builder: (_) => const NoteModify(
              //       noteID: '',
              //     ),
              //   ),
              // )
              Navigator.of(context)
                  .pushNamed(NoteModifyScreen.routePath,
                      arguments: NoteModifyArmugents(noteId: ''))

                  //
                  .then((value) {
                if (value == true) {
                  // notes.clear();
                  // noteListValue.
                  // getNotesList();
                }
              });
            },
            child: const Icon(Icons.add),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              // listNotes.clear();
              // getNotesList();
              ref.watch(getNotesListFutureProvider);
            },
            triggerMode: RefreshIndicatorTriggerMode.anywhere,
            strokeWidth: RefreshProgressIndicator.defaultStrokeWidth,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemCount: notes.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: UniqueKey(),
                          direction: DismissDirection.startToEnd,
                          onDismissed: (direction) {},
                          confirmDismiss: (direction) async {
                            final result = await showDialog(
                                context: context,
                                builder: (_) => const NoteDelete());
                            if (result) {
                              String message;
                              //todo:rework with riverpod
                              await NoteService()
                                  .deleteNote(notes[index].noteID)
                                  .then(((value) {
                                if (value) {
                                  message = 'The note was deleted sucessfuly';
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          backgroundColor: Colors.orange,
                                          content: Text(
                                            message,
                                            style: const TextStyle(
                                                color: Colors.black),
                                          ),
                                          duration:
                                              const Duration(seconds: 1)));
                                } else {
                                  message = 'An error occured';
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          backgroundColor: Colors.red,
                                          content: Text(
                                            message,
                                            style: const TextStyle(
                                                color: Colors.black),
                                          ),
                                          duration:
                                              const Duration(seconds: 1)));
                                }
                              }));
                            }
                            return result;
                          },
                          background: Container(
                            color: const Color.fromARGB(168, 245, 0, 0),
                            padding: const EdgeInsets.only(left: 16),
                            child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                          ),
                          child: Column(
                            children: [
                              const Divider(
                                height: 1,
                                color: Colors.black,
                              ),
                              ListTile(
                                title: Text(
                                  notes[index].noteTitle,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                                subtitle: Text(
                                  notes[index].createDateTime,
                                ),
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                      NoteModifyScreen.routePath,
                                      arguments: NoteModifyArmugents(
                                          noteId: notes[index].noteID));
                                  // Navigator.of(context).push(MaterialPageRoute(
                                  //     builder: (_) => NoteModify(
                                  //         noteID: notes[index].noteID)));
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ),
        ),
      );
    });
  }
}

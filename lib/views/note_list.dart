import 'package:flutter/material.dart';
import 'package:rest_api_app1/models/note_for_listing.dart';
import 'package:rest_api_app1/services/notes_service.dart';
import 'package:rest_api_app1/views/note_delete_file.dart';
import 'package:rest_api_app1/views/note_modify.dart';

class NoteList extends StatefulWidget {
  const NoteList({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  List<NoteForListing> listNotes = [];
  bool isLoading = false;
  @override
  void initState() {
    getNotesList();

    super.initState();
  }

  getNotesList() async {
    setState(() {
      isLoading = true;
    });
    var result = await NoteService.instance.getNotesList();
    setState(() {
      listNotes.addAll(result);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List of notes'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
            MaterialPageRoute(
              builder: (_) => const NoteModify(
                noteID: '',
              ),
            ),
          )
              .then((value) {
            if (value == true) {
              listNotes.clear();
              getNotesList();
            }
          });
        },
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          listNotes.clear();
          getNotesList();
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
                  itemCount: listNotes.length,
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
                          await NoteService.instance
                              .deleteNote(listNotes[index].noteID)
                              .then(((value) {
                            if (value) {
                              message = 'The note was deleted sucessfuly';
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                      backgroundColor: Colors.orange,
                                      content: Text(
                                        message,
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                      duration: const Duration(seconds: 1)));
                            } else {
                              message = 'An error occured';
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text(
                                        message,
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                      duration: const Duration(seconds: 1)));
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
                              listNotes[index].noteTitle,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                            subtitle: Text(
                              listNotes[index].createDateTime,
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => NoteModify(
                                      noteID: listNotes[index].noteID)));
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}

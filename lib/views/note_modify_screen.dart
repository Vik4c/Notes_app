import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rest_api_app1/common_widget/async_value_widget.dart';
import 'package:rest_api_app1/models/note_insert.dart';
import 'package:rest_api_app1/services/notes_service.dart';
import 'package:rest_api_app1/utils/string_validators.dart';

//ARGUMENTS
class NoteModifyArmugents {
  final String noteId;
  NoteModifyArmugents({required this.noteId});
}

//SCREEN
class NoteModifyScreen extends StatelessWidget {
  static const routePath = 'note-modify';
  const NoteModifyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as NoteModifyArmugents;
    return NoteModify(noteID: args.noteId);
  }
}

//VIEW
class NoteModify extends StatefulWidget {
  final String noteID;
  const NoteModify({
    Key? key,
    required this.noteID,
  }) : super(key: key);

  @override
  State<NoteModify> createState() => _NoteModifyState();
}

class _NoteModifyState extends State<NoteModify> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  bool isLoading = false;
  TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    getItemData();
    super.initState();
  }

  getItemData() {
    if (widget.noteID != '') {
      // for better user experience
      setState(() {
        isLoading = true;
      });
      //todo:rework with riverpod
      NoteService().getNote(widget.noteID).then((value) {
        if (value != null) {
          titleController.text = value.noteTitle;
          contentController.text = value.noteContent;
        }
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  void createOrEditNote({
    required String noteID,
    required String titleNote,
    required String contentNote,
  }) async {
    //todo: use form key to validate the form, if true make the call else show error
    //! title: min 6 char, ne smee brojki
    //! content: max 150, mora golema bukva, mora da ima i brojki i specijalni karakteri !@#$%^&*
    //! bonus: napravi extenzija na klasa so pomos na mixin

    //? done, just haven't connected the output correctly
    //? the logic has been done in the validation area

    var note = NoteInsert(
      noteTitle: titleNote,
      noteContent: contentNote,
    );

    if (noteID != '') {
      //todo:rework with riverpod
      await NoteService().editNote(note, noteID).then((value) {
        if (value) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(
                  backgroundColor: Colors.orange,
                  content: Text(
                    'Your note has been edited!',
                    style: TextStyle(color: Colors.black),
                  ),
                  duration: Duration(seconds: 1)))
              .closed
              .then((value) => Navigator.of(context).pop(true));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                'Your note has NOT been edited!',
                style: TextStyle(color: Colors.black),
              ),
              duration: Duration(seconds: 1)));
        }
      });
    } else {
      //todo:rework with riverpod
      await NoteService().createNote(note).then((value) {
        if (value) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(
                  backgroundColor: Colors.orange,
                  content: Text(
                    'Your note has been created!',
                    style: TextStyle(color: Colors.black),
                  ),
                  duration: Duration(seconds: 1)))
              .closed
              .then((value) => Navigator.of(context).pop(true));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                'Your note has been NOT created',
                style: TextStyle(color: Colors.black),
              ),
              duration: Duration(seconds: 1)));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final noteValue = ref.watch(getNoteFutureProvider(widget.noteID));
      return AsyncValueWidget(
        value: noteValue,
        data: (note) => Scaffold(
          appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_ios)),
              title: Text(
                widget.noteID == '' ? 'Create note' : 'Edit note',
                textAlign: TextAlign.center,
              )),
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: <Widget>[
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: titleController,
                                    decoration: const InputDecoration(
                                        icon: Icon(Icons.text_fields),
                                        hintText: 'Enter note title',
                                        labelText: 'Title'),
                                    validator: (value) => StringValidators
                                        .instance
                                        .titleValidator(value),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: contentController,
                                    decoration: const InputDecoration(
                                        icon: Icon(Icons.note_add),
                                        hintText: 'Enter note content',
                                        labelText: 'Content'),
                                    validator: (value) => StringValidators
                                        .instance
                                        .contentValidator(value),
                                  ),
                                ],
                              ),
                            ),
                            Container(height: 16),
                            SizedBox(
                              width: double.infinity,
                              height: 35,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    createOrEditNote(
                                      noteID: widget.noteID,
                                      titleNote: titleController.text,
                                      contentNote: contentController.text,
                                    );
                                  } else {
                                    popUp('Please fill the fields');
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: Theme.of(context).primaryColor),
                                child: const Text(
                                  'Submit',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      );
    });
  }

  void popUp(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.black,
        fontSize: 16.0);
  }
}

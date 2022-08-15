import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rest_api_app1/models/note_insert.dart';
import 'package:rest_api_app1/services/notes_service.dart';

class NoteModify extends StatefulWidget {
  final String noteID;
  const NoteModify({Key? key, required this.noteID}) : super(key: key);

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
      NoteService.instance.getNote(widget.noteID).then((value) {
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
      await NoteService.instance.editNote(note, noteID).then((value) {
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
      await NoteService.instance.createNote(note).then((value) {
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
    return Scaffold(
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
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    popUp('Note title has not been entered');
                                  } else {
                                    if (value.length >= 6) {
                                      if (value.contains(RegExp('[0-9]'))) {
                                        popUp(
                                            'The title must NOT contain numbers characters!');
                                      } else {
                                        return null;
                                      }
                                    } else {
                                      popUp(
                                          'The lenght of the title must NOT be shorter than 6!');
                                    }
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: contentController,
                                decoration: const InputDecoration(
                                    icon: Icon(Icons.note_add),
                                    hintText: 'Enter note content',
                                    labelText: 'Content'),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    popUp('Note content has not been entered');
                                  } else {
                                    if (value.length <= 150) {
                                      if (value[0].contains(RegExp('[A-Z]'))) {
                                        if (value.contains('!') ||
                                            value.contains('@') ||
                                            value.contains('#') ||
                                            //  value.contains('$')||
                                            value.contains('%') ||
                                            value.contains('^') ||
                                            value.contains('&') ||
                                            value.contains('*')) {
                                          return null;
                                        } else {
                                          popUp(
                                              'The content must contain special characters!');
                                        }
                                      } else {
                                        popUp(
                                            'The first letter of the conent must be capital!');
                                      }
                                    } else {
                                      popUp(
                                          'The lenght of the content must not exceed 150 characters!');
                                    }
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        Container(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 35,
                          child: ElevatedButton(
                            onPressed: () => FormFieldValidator == null
                                ? popUp('Processing, please wait')
                                : createOrEditNote(
                                    noteID: widget.noteID,
                                    titleNote: titleController.text,
                                    contentNote: contentController.text,
                                  ),
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
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_base/notesPage.dart';
import 'package:flutter/material.dart';

class Saving extends StatefulWidget {
  const Saving({Key? key}) : super(key: key);

  @override
  State<Saving> createState() => _Saving();
}

class _Saving extends State<Saving> {
  final controllerTitle = TextEditingController();
  final controllerNote = TextEditingController();

  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.purple,
          title: Center(
            child: Text(
              'Firebase Note',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 550, left: 220),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return notesPage();
                  }));
                },
                child: Text(
                  'Notes',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                style: ElevatedButton.styleFrom(primary: Colors.purple),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 220),
              child: FloatingActionButton.extended(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => Container(
                      height: 500,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              child: TextFormField(
                                controller: controllerTitle,
                                maxLength: 15,
                                decoration: InputDecoration(
                                  label: Row(
                                    children: [
                                      Icon(
                                        Icons.title,
                                        color: Colors.grey,
                                      ),
                                      Text(
                                        'Title',
                                      ),
                                    ],
                                  ),
                                  alignLabelWithHint: true,
                                  labelStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                                  border: OutlineInputBorder(),
                                ),
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.purple,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: TextFormField(
                                controller: controllerNote,
                                maxLength: 75,
                                maxLines: 7,
                                decoration: InputDecoration(
                                  label: Row(
                                    children: [
                                      Icon(
                                        Icons.note,
                                        color: Colors.grey,
                                      ),
                                      Text(
                                        'Note',
                                      ),
                                    ],
                                  ),
                                  alignLabelWithHint: true,
                                  labelStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.elliptical(10, 10))),
                                ),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.purple,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              width: 100,
                              child: ElevatedButton(
                                onPressed: () {
                                  createNote(
                                      note: controllerNote.text,
                                      title: controllerTitle.text);
                                  Navigator.pop(context);
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.save),
                                    Text(
                                      'Save',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.purple),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.add),
                label: Text(
                  'Add Note',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                backgroundColor: Colors.purple,
              ),
            ),
          ],
        ),
      );
}

Stream<List<Notes>> readNote() =>
    FirebaseFirestore.instance.collection('notes').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Notes.fromJson(doc.data())).toList());

Future createNote({required String title, required String note}) async {
  final docNote = FirebaseFirestore.instance.collection('notes').doc();
  final notes = Notes(
    id: docNote.id,
    title: title,
    note: note,
  );
  final json = notes.toJson();
  await docNote.set(json);
}

class Notes {
  final String title;
  final String note;
  String id;

  Notes({required this.title, required this.note, this.id = ''});

  Map<String, dynamic> toJson() => {
        'title': title,
        'note': note,
        'id': id,
      };

  static Notes fromJson(Map<String, dynamic> json) =>
      Notes(title: json['title'], note: json['note'], id: json['id']);
}

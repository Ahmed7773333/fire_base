import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'saving.dart';

class notesPage extends StatelessWidget {
  final firestore = FirebaseFirestore.instance;
  final controllerTitle = TextEditingController();
  final controllerNote = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 50),
            child: Text(
              'Notes',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: firestore.collection('notes').snapshots(),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          snapshot.data!.docs[index]['title'],
                        ),
                        subtitle: Text(
                          snapshot.data!.docs[index]['note'],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
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
                                                final docNote=FirebaseFirestore.instance.collection('notes').doc(snapshot.data!.docs[index]['id']);
                                                docNote.update(
                                                  {
                                                    'title':controllerTitle.text,
                                                    'note':controllerNote.text
                                                  }
                                                );
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

                              icon: Icon(Icons.edit),
                              color: Colors.purpleAccent,
                            ),
                            IconButton(
                              onPressed: () {
                                final docNote = FirebaseFirestore.instance
                                    .collection('notes')
                                    .doc(snapshot.data!.docs[index]['id']);
                                docNote.delete();
                              },
                              icon: Icon(Icons.delete),
                              color: Colors.red,
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : snapshot.hasError
                    ? Text('Error')
                    : CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  Widget buildNote(Notes note) => ListTile(
        title: Text(note.title.toString()),
        subtitle: Text(note.note.toString()),
      );
}

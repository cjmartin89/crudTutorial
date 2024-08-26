import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_tutorial_app/services/firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // firestore
  final FirestoreService firestoreService = FirestoreService();
  // text controller
  final TextEditingController textController = TextEditingController();

  // open a dialog box to add a note
  void openNoteBox ({String? docID}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
        ),
        actions: [
          // button to save
          ElevatedButton(
            onPressed: () {
              // add a new note
              if (docID == null) {
                firestoreService.addNote(textController.text);
              }
              // update an existing note
              else {
                firestoreService.updateNote(docID, textController.text);
              }
              // clear the text controller
              textController.clear();
              // clear the box
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        title: const Text('Notes'),
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: Colors.grey[800],
        foregroundColor: Colors.white,
        onPressed: openNoteBox,
        child: const Icon(Icons.add),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 25),
        child: StreamBuilder(
          stream: FirestoreService().getNotesStream(),
          builder: (context, snapshot) {
            // if we have data get all the docs
            if (snapshot.hasData) {
              List notesList = snapshot.data!.docs;
              // display a list
              return ListView.builder(
                itemCount: notesList.length,
                itemBuilder: (context, index) {
                // get each individual document
                DocumentSnapshot document = notesList[index];
                String docID = document.id;
        
                // get note from each doc
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String noteText = data['note'];
        
                // display as a list tile ui
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    height: 100,
                    margin: const EdgeInsets.only(bottom: 25),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      // border: Border.all(),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: ListTile(
                        title: Text(noteText),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // update button
                            IconButton(
                              onPressed: () => openNoteBox(docID: docID), 
                              icon: const Icon(Icons.settings),
                              ),
                            // delete button
                            IconButton(
                              onPressed: () => firestoreService.deleteNote(docID), 
                              icon: const Icon(Icons.delete),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              });
            }
            // if there is no data return nothing
             else {
              return const Text('No Notes');
             }
          }
        ),
      ),
    );
  }
}

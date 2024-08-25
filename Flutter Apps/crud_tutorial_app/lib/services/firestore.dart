import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // get colleciton of notes
  final CollectionReference notes =
      FirebaseFirestore.instance.collection('notes');

  // Create: add a new note
  Future<void> addNote(String note) {
    return notes.add({
      'note': note,
      'timestamp': Timestamp.now(),
    });
  }

  // Read: get notes from database

  // Update: update notes given a doc id

  // Delete: delete notes given a dec id
}

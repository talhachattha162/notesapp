import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/note.dart';



class NoteRepository {

  final CollectionReference<Map<String, dynamic>> _notesCollection =
  FirebaseFirestore.instance.collection('notes');


  Future<void> addNote(Note note) async {
    DocumentReference docRef = _notesCollection.doc();

    String docId = docRef.id;

    await docRef.set({
      'id': docId,
      'title': note.title,
      'content': note.content,
      'color': note.color,
      'uploadedby': note.uploadedby,
    });

    print('Newly created document ID: $docId');
  }

  // Update an existing note in Firestore
  Future<void> updateNote(String docId, Note updatedNote) async {
    await _notesCollection.doc(docId).update({
      'id': docId,
      'title': updatedNote.title,
      'content': updatedNote.content,
      'color': updatedNote.color,
      'uploadedby':updatedNote.uploadedby
    });
  }

  // Delete a note from Firestore
  Future<void> deleteNote(String docId) async {
    await _notesCollection.doc(docId).delete();
  }

  Future<List<Note>> getNotes() async {
    QuerySnapshot querySnapshot =
    await _notesCollection.where('uploadedby', isEqualTo: FirebaseAuth.instance.currentUser!.email).get();

    return querySnapshot.docs.map((doc) {
      return Note(
        id: doc['id'],
        title: doc['title'],
        content: doc['content'],
        color: doc['color'],
        uploadedby: doc['uploadedby'],
      );
    }).toList();
  }


  Stream<List<Note>> searchNotes(String searchQuery) {
    return _notesCollection
        .where('title', isGreaterThanOrEqualTo: searchQuery)
        .where('uploadedby', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Note(
          id: doc['id'],
          title: doc['title'],
          content: doc['content'],
          color: doc['color'],
            uploadedby:doc['uploadedby']
        );
      }).toList();
    });
  }

}

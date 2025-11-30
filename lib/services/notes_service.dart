import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/note.dart';

class NotesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _userId => _auth.currentUser?.uid ?? 'default_user';

  Stream<List<Note>> getNotes() {
    try {
      return _firestore
          .collection('users')
          .doc(_userId)
          .collection('notes')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          return Note(
            id: doc.id,
            title: data['title'] ?? 'No Title',
            content: data['content'] ?? '',
            timestamp: data['timestamp'] != null
                ? (data['timestamp'] as Timestamp).toDate()
                : DateTime.now(),
          );
        }).toList();
      });
    } catch (e) {
      print('❌ Error getting notes: $e');
      // Return empty stream on error
      return Stream.value([]);
    }
  }

  Future<void> addNote(String title, String content) async {
    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('notes')
          .add({
        'title': title,
        'content': content,
        'timestamp': FieldValue.serverTimestamp(), // Use Firestore timestamp
      });
      print('✅ Note added successfully');
    } catch (e) {
      print('❌ Error adding note: $e');
      throw e;
    }
  }

  Future<void> deleteNote(String noteId) async {
    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('notes')
          .doc(noteId)
          .delete();
      print('✅ Note deleted successfully');
    } catch (e) {
      print('❌ Error deleting note: $e');
      throw e;
    }
  }
}
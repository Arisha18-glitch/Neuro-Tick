import 'package:flutter/material.dart';
import '../services/notes_service.dart';
import '../models/note.dart';

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final NotesService _notesService = NotesService();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  void _addNote() async {
    if (_titleController.text.isEmpty) return;

    await _notesService.addNote(
      _titleController.text,
      _contentController.text,
    );

    _titleController.clear();
    _contentController.clear();
    FocusScope.of(context).unfocus();
  }

  void _deleteNote(String noteId) async {
    await _notesService.deleteNote(noteId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F7FF), // Matching purple theme
      appBar: AppBar(
        title: Text('My Learning Notes'),
        backgroundColor: Color(0xFF6A5ACD), // Elegant purple
        elevation: 0,
      ),
      body: Column(
        children: [
          // Add note form
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Note Title',
                    labelStyle: TextStyle(color: Color(0xFF6A5ACD)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Color(0xFF6A5ACD)),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: _contentController,
                  decoration: InputDecoration(
                    labelText: 'Content (optional)',
                    labelStyle: TextStyle(color: Color(0xFF6A5ACD)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Color(0xFF6A5ACD)),
                    ),
                  ),
                  maxLines: 2,
                ),
                SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFE2E0FF), Color(0xFF9370DB)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton(
                    onPressed: _addNote,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Add Note',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Notes list
          Expanded(
            child: StreamBuilder<List<Note>>(
              stream: _notesService.getNotes(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error loading notes',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(color: Color(0xFF6A5ACD)));
                }

                final notes = snapshot.data ?? [];

                if (notes.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.note_add,
                          size: 80,
                          color: Color(0xFFE2E0FF),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No notes yet!',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF6A5ACD),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Add your first learning note above',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.purple.withOpacity(0.1),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(0xFFE2E0FF),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.note_rounded,
                            color: Color(0xFF6A5ACD),
                            size: 20,
                          ),
                        ),
                        title: Text(
                          note.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6A5ACD),
                          ),
                        ),
                        subtitle: note.content.isNotEmpty
                            ? Text(
                          note.content,
                          style: TextStyle(color: Colors.grey[600]),
                        )
                            : null,
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red[300]),
                          onPressed: () => _deleteNote(note.id),
                        ),
                        onLongPress: () => _deleteNote(note.id),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
  class Note {
  final String id;
  final String title;
  final String content;
  final DateTime timestamp;

  Note({
  required this.id,
  required this.title,
  required this.content,
  required this.timestamp,
  });

  // No need for toMap/fromMap - we handle conversion in service
  }
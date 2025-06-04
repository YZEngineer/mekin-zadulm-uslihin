class Note {
  final int? id;
  final int lessonId;
  final String content;
  final DateTime createdAt;

  Note({
    this.id,
    required this.lessonId,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'lesson_id': lessonId,
      'content': content,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  static Note fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      lessonId: json['lesson_id'],
      content: json['content'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lesson_id': lessonId,
      'content': content,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }
}

enum ThoughtType {
  worldly, // دنيوي
  hereafter, // اخروي
  both, // دنيوي واخروي
}

class Thought {
  final int? id;
  final String content;
  final ThoughtType type;
  final DateTime createdAt;

  Thought({
    this.id,
    required this.content,
    required this.type,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'type': type.index,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Thought.fromMap(Map<String, dynamic> map) {
    return Thought(
      id: map['id'],
      content: map['content'],
      type: ThoughtType.values[map['type']],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}

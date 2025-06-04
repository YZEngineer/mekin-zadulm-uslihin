class Lesson {
  final int? id;
  final String title;
  final String description;
  final String videoId;
  final String category;
  final String type;
  bool isCompleted;

  Lesson({
    this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.videoId,
    required this.type,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
      'video_id': videoId,
      'category': category,
      'is_completed': isCompleted ? 1 : 0,
    };
  }

  factory Lesson.fromMap(Map<String, dynamic> map) {
    return Lesson(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      videoId: map['video_id'],
      category: map['category'],
      type: map['type'],
      isCompleted: map['is_completed'] == 1,
    );
  }

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      title: json['title'],
      type: json['type'],
      description: json['description'],
      videoId: json['video_id'],
      category: json['category'],
      isCompleted: json['is_completed'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'video_id': videoId,
      'category': category,
      'type': type,
      'is_completed': isCompleted ? 1 : 0,
    };
  }
}

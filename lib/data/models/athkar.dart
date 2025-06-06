/// نموذج يمثل الأذكار
class Athkar {
  final int? id;
  final String title;
  final String content;

  Athkar({
    this.id,
    required this.title,
    required this.content,
  });

  /// إنشاء نموذج من خريطة بيانات قاعدة البيانات
  factory Athkar.fromMap(Map<String, dynamic> map) {
    return Athkar(
      id: map['id'] as int?,
      title: map['title'] as String,
      content: map['content'] as String,
    );
  }

  /// تحويل النموذج إلى خريطة بيانات لحفظها في قاعدة البيانات
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
    };
  }

  /// إنشاء نسخة معدلة من هذا النموذج
  Athkar copyWith({
    int? id,
    String? title,
    String? content,
  }) {
    return Athkar(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
    );
  }

  @override
  String toString() => 'Athkar(id: $id, title: $title, content: $content)';
}

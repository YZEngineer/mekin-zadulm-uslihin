class Hadith {
  final int? id;
  final String text;
  final String narrator;
  final String topic;

  Hadith({
    this.id,
    required this.text,
    required this.narrator,
    required this.topic,
  });

  factory Hadith.fromMap(Map<String, dynamic> map) {
    return Hadith(
      id: map['id'] as int?,
      text: map['text'] as String,
      narrator: map['narrator'] as String,
      topic: map['topic'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'narrator': narrator,
      'topic': topic,
    };
  }

  Hadith copyWith({
    int? id,
    String? text,
    String? narrator,
    String? topic,
  }) {
    return Hadith(
      id: id ?? this.id,
      text: text ?? this.text,
      narrator: narrator ?? this.narrator,
      topic: topic ?? this.topic,
    );
  }

  @override
  String toString() =>
      'Hadith(id: $id, text: $text, narrator: $narrator, topic: $topic)';
}

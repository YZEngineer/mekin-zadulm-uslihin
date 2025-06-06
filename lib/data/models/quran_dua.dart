class QuranDua {
  final int? id;
  final String text;
  final String source;
  final String theme;

  QuranDua({
    this.id,
    required this.text,
    required this.source,
    required this.theme,
  });

  factory QuranDua.fromMap(Map<String, dynamic> map) {
    return QuranDua(
      id: map['id'] as int?,
      text: map['text'] as String,
      source: map['source'] as String,
      theme: map['theme'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'source': source,
      'theme': theme,
    };
  }

  QuranDua copyWith({
    int? id,
    String? text,
    String? source,
    String? theme,
  }) {
    return QuranDua(
      id: id ?? this.id,
      text: text ?? this.text,
      source: source ?? this.source,
      theme: theme ?? this.theme,
    );
  }

  @override
  String toString() =>
      'QuranDua(id: $id, text: $text, source: $source, theme: $theme)';
}

import 'mood.dart';

class Note {
  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.isPinned = false,
    this.updatedAt,
    this.categoryId = '',
    this.tags = const [],
    this.colorIndex = 0,
  });

  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final bool isPinned;
  final DateTime? updatedAt;
  final String categoryId;
  final List<String> tags;
  final int colorIndex;

  /// Pernah diedit setelah dibuat.
  bool get isEdited => updatedAt != null && updatedAt!.isAfter(createdAt);

  /// Mood dibaca dari emoji di awal judul (emoji disimpan bersama judul).
  Mood get mood {
    if (title.startsWith(Mood.happy.emoji)) return Mood.happy;
    if (title.startsWith(Mood.sad.emoji)) return Mood.sad;
    return Mood.neutral;
  }

  int get wordCount {
    final t = content.trim();
    return t.isEmpty ? 0 : t.split(RegExp(r'\s+')).length;
  }

  Note copyWith({
    String? title,
    String? content,
    bool? isPinned,
    DateTime? updatedAt,
    String? categoryId,
    List<String>? tags,
    int? colorIndex,
  }) =>
      Note(
        id: id,
        title: title ?? this.title,
        content: content ?? this.content,
        createdAt: createdAt,
        isPinned: isPinned ?? this.isPinned,
        updatedAt: updatedAt ?? this.updatedAt,
        categoryId: categoryId ?? this.categoryId,
        tags: tags ?? this.tags,
        colorIndex: colorIndex ?? this.colorIndex,
      );
}

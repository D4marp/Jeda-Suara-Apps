import '../../domain/entities/note.dart';

class NoteModel extends Note {
  const NoteModel({
    required super.id,
    required super.title,
    required super.content,
    required super.createdAt,
    super.isPinned,
    super.updatedAt,
    super.categoryId,
    super.tags,
    super.colorIndex,
  });

  factory NoteModel.fromEntity(Note n) => NoteModel(
        id: n.id,
        title: n.title,
        content: n.content,
        createdAt: n.createdAt,
        isPinned: n.isPinned,
        updatedAt: n.updatedAt,
        categoryId: n.categoryId,
        tags: n.tags,
        colorIndex: n.colorIndex,
      );

  factory NoteModel.fromJson(Map<String, dynamic> json) => NoteModel(
        id: json['id'] as String,
        title: json['title'] as String,
        content: json['content'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        isPinned: json['isPinned'] as bool? ?? false,
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt'] as String),
        categoryId: json['categoryId'] as String? ?? '',
        tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? const [],
        colorIndex: json['colorIndex'] as int? ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'createdAt': createdAt.toIso8601String(),
        'isPinned': isPinned,
        'updatedAt': updatedAt?.toIso8601String(),
        'categoryId': categoryId,
        'tags': tags,
        'colorIndex': colorIndex,
      };
}

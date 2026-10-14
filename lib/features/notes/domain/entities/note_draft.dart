class NoteDraft {
  const NoteDraft({required this.title, required this.content});

  final String title;
  final String content;

  bool get isEmpty => title.trim().isEmpty && content.trim().isEmpty;
}

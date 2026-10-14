enum Mood {
  happy('😄', 'Senang'),
  sad('😢', 'Sedih'),
  neutral('', 'Netral');

  const Mood(this.emoji, this.label);

  final String emoji;
  final String label;

  /// Awalan judul, mis. `😄 `.
  String get prefix => emoji.isEmpty ? '' : '$emoji ';
}

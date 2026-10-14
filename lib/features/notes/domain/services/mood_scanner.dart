import '../entities/mood.dart';

/// Mock AI Mood Scanner: aturan if-else murni, tanpa AI sungguhan.
///
/// Keterbatasan yang disetujui (R3): pencocokan substring dan tanpa negasi,
/// sehingga "tidak senang" tetap menghasilkan 😄.
class MoodScanner {
  const MoodScanner();

  Mood detect(String title, String content) {
    final text = '$title $content'.toLowerCase();
    if (text.contains('senang') || text.contains('bahagia')) return Mood.happy;
    if (text.contains('sedih') || text.contains('marah')) return Mood.sad;
    return Mood.neutral;
  }

  String apply(String title, String content) {
    final mood = detect(title, content);
    if (mood == Mood.neutral) return title;
    return title.startsWith(mood.prefix) ? title : '${mood.prefix}$title';
  }

  /// Memaksa mood pilihan pengguna: awalan lama dibuang, lalu dipasang yang baru.
  static String withMood(String title, Mood mood) {
    final clean = stripMood(title);
    return mood == Mood.neutral ? clean : '${mood.prefix}$clean';
  }

  /// Membuang awalan emoji mood (dipakai saat edit agar mood dihitung ulang).
  static String stripMood(String title) {
    for (final m in [Mood.happy, Mood.sad]) {
      if (title.startsWith(m.prefix)) {
        return title.substring(m.prefix.length).trimLeft();
      }
    }
    return title;
  }
}

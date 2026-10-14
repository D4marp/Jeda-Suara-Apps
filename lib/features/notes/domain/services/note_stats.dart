import '../entities/mood.dart';
import '../entities/note.dart';

class NoteStats {
  const NoteStats({
    required this.total,
    required this.thisWeek,
    required this.streak,
    required this.totalWords,
    required this.moods,
    required this.last7Days,
  });

  final int total;
  final int thisWeek;

  /// Jumlah hari berturut-turut menulis (hari ini atau kemarin sebagai ujung).
  final int streak;
  final int totalWords;
  final Map<Mood, int> moods;

  /// Catatan per hari, 7 hari terakhir; indeks 6 = hari ini.
  final List<int> last7Days;

  factory NoteStats.from(List<Note> notes, DateTime now) {
    DateTime day(DateTime d) => DateTime(d.year, d.month, d.day);
    final today = day(now);

    final perDay = <DateTime, int>{};
    for (final n in notes) {
      final d = day(n.createdAt);
      perDay[d] = (perDay[d] ?? 0) + 1;
    }

    final last7 = List<int>.generate(7, (i) {
      final d = DateTime(today.year, today.month, today.day - (6 - i));
      return perDay[d] ?? 0;
    });

    var cursor = perDay.containsKey(today)
        ? today
        : DateTime(today.year, today.month, today.day - 1);
    var streak = 0;
    while (perDay.containsKey(cursor)) {
      streak++;
      cursor = DateTime(cursor.year, cursor.month, cursor.day - 1);
    }

    final moods = {for (final m in Mood.values) m: 0};
    var words = 0;
    for (final n in notes) {
      moods[n.mood] = moods[n.mood]! + 1;
      words += n.wordCount;
    }

    return NoteStats(
      total: notes.length,
      thisWeek: last7.fold(0, (a, b) => a + b),
      streak: streak,
      totalWords: words,
      moods: moods,
      last7Days: last7,
    );
  }
}

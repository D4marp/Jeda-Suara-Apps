import 'package:flutter_dpl_prd_app/features/notes/domain/entities/mood.dart';
import 'package:flutter_dpl_prd_app/features/notes/domain/entities/note.dart';
import 'package:flutter_dpl_prd_app/features/notes/domain/services/note_stats.dart';
import 'package:flutter_test/flutter_test.dart';

Note _n(DateTime d, {String title = 'Judul', String content = 'satu dua tiga'}) =>
    Note(id: d.toIso8601String() + title, title: title, content: content, createdAt: d);

void main() {
  final now = DateTime(2026, 10, 14, 12);

  test('tanpa catatan: semua nol', () {
    final s = NoteStats.from(const [], now);
    expect(s.total, 0);
    expect(s.streak, 0);
    expect(s.thisWeek, 0);
    expect(s.last7Days, List.filled(7, 0));
  });

  test('streak berturut-turut dari hari ini', () {
    final s = NoteStats.from([
      _n(DateTime(2026, 10, 14, 8)),
      _n(DateTime(2026, 10, 13, 8)),
      _n(DateTime(2026, 10, 12, 8)),
      _n(DateTime(2026, 10, 10, 8)),
    ], now);
    expect(s.streak, 3);
  });

  test('streak tetap hidup bila terakhir menulis kemarin', () {
    final s = NoteStats.from([_n(DateTime(2026, 10, 13, 8))], now);
    expect(s.streak, 1);
  });

  test('streak putus bila terakhir menulis 2 hari lalu', () {
    final s = NoteStats.from([_n(DateTime(2026, 10, 12, 8))], now);
    expect(s.streak, 0);
  });

  test('hitung mood, kata, dan 7 hari terakhir', () {
    final s = NoteStats.from([
      _n(DateTime(2026, 10, 14, 8), title: '😄 A'),
      _n(DateTime(2026, 10, 14, 9), title: '😢 B', content: 'a b c d'),
      _n(DateTime(2026, 10, 7, 9)), // di luar 7 hari
    ], now);
    expect(s.total, 3);
    expect(s.moods[Mood.happy], 1);
    expect(s.moods[Mood.sad], 1);
    expect(s.moods[Mood.neutral], 1);
    expect(s.totalWords, 3 + 4 + 3);
    expect(s.last7Days.last, 2);
    expect(s.thisWeek, 2);
  });
}

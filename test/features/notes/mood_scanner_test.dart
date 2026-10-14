import 'package:flutter_dpl_prd_app/features/notes/domain/entities/mood.dart';
import 'package:flutter_dpl_prd_app/features/notes/domain/services/mood_scanner.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const scanner = MoodScanner();

  // (judul, isi, hasil) — tabel AC-D09.
  const cases = <(String, String, String)>[
    ('Hari ini', 'Aku senang', '😄 Hari ini'),
    ('Hari ini', 'Aku BAHAGIA', '😄 Hari ini'),
    ('Senang', 'biasa', '😄 Senang'),
    ('Kabar', 'Aku sedih', '😢 Kabar'),
    ('Kabar', 'Dia marah', '😢 Kabar'),
    ('Marah', 'biasa', '😢 Marah'),
    ('Hari ini', 'senang tapi sedih', '😄 Hari ini'),
    ('Hari ini', 'marah lalu bahagia', '😄 Hari ini'),
    ('Hari ini', 'biasa saja', 'Hari ini'),
    ('Hari ini', 'kesenangan', '😄 Hari ini'),
    ('Hari ini', 'cuaca cerah dan makan siang', 'Hari ini'),
    ('😄 Sudah', 'senang', '😄 Sudah'),
  ];

  for (var i = 0; i < cases.length; i++) {
    final (title, content, expected) = cases[i];
    test('kasus ${i + 1}: "$title" + "$content"', () {
      expect(scanner.apply(title, content), expected);
    });
  }

  test('negasi tetap 😄 (keterbatasan yang disetujui)', () {
    expect(scanner.apply('Hari ini', 'tidak senang'), '😄 Hari ini');
  });

  test('detect mengembalikan mood yang sesuai', () {
    expect(scanner.detect('a', 'senang'), Mood.happy);
    expect(scanner.detect('a', 'sedih'), Mood.sad);
    expect(scanner.detect('a', 'biasa'), Mood.neutral);
  });

  test('stripMood membuang awalan emoji', () {
    expect(MoodScanner.stripMood('😄 Hari ini'), 'Hari ini');
    expect(MoodScanner.stripMood('😢 Kabar'), 'Kabar');
    expect(MoodScanner.stripMood('Biasa'), 'Biasa');
  });

  test('withMood memaksa mood pilihan pengguna', () {
    expect(MoodScanner.withMood('Hari ini', Mood.sad), '😢 Hari ini');
    expect(MoodScanner.withMood('😄 Hari ini', Mood.sad), '😢 Hari ini');
    expect(MoodScanner.withMood('😄 Hari ini', Mood.neutral), 'Hari ini');
  });
}

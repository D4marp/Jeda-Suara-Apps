import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dpl_prd_app/app.dart';
import 'package:flutter_dpl_prd_app/core/app_info.dart';
import 'package:flutter_dpl_prd_app/core/storage/prefs_provider.dart';
import 'package:flutter_dpl_prd_app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:flutter_dpl_prd_app/features/notes/data/datasources/note_local_datasource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _token = {AuthLocalDataSource.tokenKey: 'tok_x'};

Future<SharedPreferences> _pump(
  WidgetTester tester,
  Map<String, Object> initial,
) async {
  tester.view.physicalSize = const Size(900, 1800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  SharedPreferences.setMockInitialValues(initial);
  final prefs = await SharedPreferences.getInstance();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const JedaSuaraApp(),
    ),
  );
  await tester.pump(SplashGate.minDuration);
  await tester.pumpAndSettle();
  return prefs;
}

Future<void> _pin(WidgetTester tester, String pin) async {
  for (final d in pin.split('')) {
    await tester.tap(find.byKey(Key('key_$d')));
    await tester.pump();
  }
  await tester.pumpAndSettle();
}

String _seedNotes() => jsonEncode([
      {
        'id': '1',
        'title': 'Pagi kopi',
        'content': 'Ngopi sebelum kuliah',
        'createdAt': '2026-09-01T07:00:00.000',
      },
      {
        'id': '2',
        'title': '😢 Malam hujan',
        'content': 'Hari ini sedih sekali',
        'createdAt': '2026-09-02T21:00:00.000',
      },
    ]);

void main() {
  testWidgets('splash tampil dulu, lalu pindah ke Login', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const JedaSuaraApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text(appMotto), findsOneWidget);
    expect(find.text('Masuk & Kunci Suaramu'), findsNothing);

    await tester.pump(SplashGate.minDuration);
    await tester.pumpAndSettle();
    expect(find.text('Masuk & Kunci Suaramu'), findsOneWidget);
  });

  testWidgets('tanpa token: tampil Login, bukan layar utama (M3)',
      (tester) async {
    await _pump(tester, {});
    expect(find.text('Masuk & Kunci Suaramu'), findsOneWidget);
    expect(find.textContaining('Catatanku'), findsNothing);
  });

  testWidgets('PIN salah: error generik, PIN dikosongkan, tanpa token',
      (tester) async {
    final prefs = await _pump(tester, {});
    await tester.enterText(find.byType(TextField), 'admin');
    await _pin(tester, '9999');

    expect(find.text('Username atau PIN salah.'), findsOneWidget);
    expect(prefs.getString(AuthLocalDataSource.tokenKey), isNull);
  });

  testWidgets('kolom kosong / PIN kurang: validasi per kolom', (tester) async {
    await _pump(tester, {});
    await _pin(tester, '12');
    await tester.tap(find.text('Masuk & Kunci Suaramu'));
    await tester.pumpAndSettle();

    expect(find.text('Username wajib diisi'), findsOneWidget);
    expect(find.text('PIN harus 4 digit angka'), findsOneWidget);
  });

  testWidgets('login benar -> token tersimpan -> empty state -> keluar',
      (tester) async {
    final prefs = await _pump(tester, {});
    await tester.enterText(find.byType(TextField), 'admin');
    await _pin(tester, '1234');

    expect(prefs.getString(AuthLocalDataSource.tokenKey), isNotNull);
    expect(find.text('Belum ada catatan.'), findsOneWidget);

    await tester.tap(find.byTooltip('Pengaturan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kunci & Keluar Sesi'));
    await tester.pumpAndSettle();

    expect(prefs.getString(AuthLocalDataSource.tokenKey), isNull);
    expect(find.text('Masuk & Kunci Suaramu'), findsOneWidget);
  });

  testWidgets('token ada -> langsung ke layar utama (auto-login)',
      (tester) async {
    await _pump(tester, _token);
    expect(find.textContaining('Catatanku'), findsOneWidget);
  });

  testWidgets('tulis catatan -> tampil dengan emoji mood, draft dibersihkan',
      (tester) async {
    final prefs = await _pump(tester, _token);
    await tester.tap(find.byTooltip('Mulai Jeda Baru'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('field_title')), 'Hari ini');
    await tester.enterText(
        find.byKey(const Key('field_content')), 'Aku senang sekali');
    await tester.pump();
    expect(find.text('Mood otomatis: 😄 Senang'), findsOneWidget);

    await tester.tap(find.text('Kunci & Amankan'));
    await tester.pumpAndSettle();

    expect(find.text('😄 Hari ini'), findsOneWidget);
    expect(
      find.text(
          'Ceritamu sudah terkunci rapat. Simpan rasa senang ini, mari lanjutkan harimu.'),
      findsOneWidget,
    );
    expect(find.text('AI PENJAGA'), findsOneWidget);
    expect(prefs.getString(NoteLocalDataSource.draftKey), isNull);
  });

  testWidgets('pilih mood manual menimpa deteksi otomatis', (tester) async {
    await _pump(tester, _token);
    await tester.tap(find.byTooltip('Mulai Jeda Baru'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('field_title')), 'Hari ini');
    await tester.enterText(
        find.byKey(const Key('field_content')), 'Aku senang sekali');
    await tester.pump();

    await tester.tap(find.text('😢 Sedih'));
    await tester.pump();
    expect(find.text('Mood: 😢 Sedih'), findsOneWidget);

    await tester.tap(find.text('Kunci & Amankan'));
    await tester.pumpAndSettle();
    expect(find.text('😢 Hari ini'), findsOneWidget);
    expect(find.text('😄 Hari ini'), findsNothing);
  });

  testWidgets('form kosong: kedua kolom "Wajib diisi"', (tester) async {
    await _pump(tester, _token);
    await tester.tap(find.byTooltip('Mulai Jeda Baru'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kunci & Amankan'));
    await tester.pumpAndSettle();
    expect(find.text('Wajib diisi'), findsNWidgets(2));
  });

  testWidgets('pencarian menyaring daftar', (tester) async {
    await _pump(tester, {..._token, NoteLocalDataSource.notesKey: _seedNotes()});
    expect(find.text('Pagi kopi'), findsOneWidget);
    expect(find.text('😢 Malam hujan'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'kopi');
    await tester.pumpAndSettle();
    expect(find.text('Pagi kopi'), findsOneWidget);
    expect(find.text('😢 Malam hujan'), findsNothing);
  });

  testWidgets('filter mood menyaring daftar', (tester) async {
    await _pump(tester, {..._token, NoteLocalDataSource.notesKey: _seedNotes()});
    await tester.tap(find.text('😢 Sedih'));
    await tester.pumpAndSettle();
    expect(find.text('Pagi kopi'), findsNothing);
    expect(find.text('😢 Malam hujan'), findsOneWidget);
  });

  testWidgets('tekan lama -> sematkan -> muncul grup Disematkan',
      (tester) async {
    await _pump(tester, {..._token, NoteLocalDataSource.notesKey: _seedNotes()});
    await tester.longPress(find.text('Pagi kopi'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sematkan'));
    await tester.pumpAndSettle();
    expect(find.text('DISEMATKAN'), findsOneWidget);
  });

  testWidgets('hapus dari detail memakai dialog konfirmasi', (tester) async {
    await _pump(tester, {..._token, NoteLocalDataSource.notesKey: _seedNotes()});
    await tester.tap(find.text('Pagi kopi'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Hapus catatan'));
    await tester.pumpAndSettle();
    expect(find.text('Hapus catatan ini?'), findsOneWidget);

    await tester.tap(find.text('Batal'));
    await tester.pumpAndSettle();
    expect(find.text('Pagi kopi'), findsOneWidget);

    await tester.tap(find.byTooltip('Hapus catatan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hapus'));
    await tester.pumpAndSettle();
    expect(find.text('Pagi kopi'), findsNothing);
  });

  testWidgets('tab Statistik menampilkan ringkasan', (tester) async {
    await _pump(tester, {..._token, NoteLocalDataSource.notesKey: _seedNotes()});
    await tester.tap(find.byTooltip('Statistik'));
    await tester.pumpAndSettle();
    expect(find.text('7 HARI TERAKHIR'), findsOneWidget);
    expect(find.text('MOOD'), findsOneWidget);
  });
}

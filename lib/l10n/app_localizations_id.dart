// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Secret Diary';

  @override
  String get loginTitle => 'Secret Diary';

  @override
  String get loginSubtitle =>
      'Masuk dengan username dan PIN untuk membuka catatanmu.';

  @override
  String get usernameLabel => 'Username';

  @override
  String get pinLabel => 'PIN';

  @override
  String get showPin => 'Tampilkan PIN';

  @override
  String get hidePin => 'Sembunyikan PIN';

  @override
  String get loginButton => 'Masuk';

  @override
  String get loginError => 'Username atau PIN salah.';

  @override
  String get demoHint => 'Autentikasi demo lokal: admin / 1234';

  @override
  String get notesTitle => 'Catatanku';

  @override
  String get notesCountZero => 'Belum ada catatan';

  @override
  String notesCountOne(Object count) {
    return '$count catatan';
  }

  @override
  String notesCountOther(Object count) {
    return '$count catatan';
  }

  @override
  String get emptyStateTitle => 'Belum ada catatan';

  @override
  String get emptyStateAction => 'Tulis catatan';

  @override
  String get addNoteTitle => 'Catatan Baru';

  @override
  String get noteTitleLabel => 'Judul';

  @override
  String get noteContentLabel => 'Isi catatan';

  @override
  String get saveButton => 'Simpan';

  @override
  String get savingButton => 'Menyimpan...';

  @override
  String get saveSuccess => 'Catatan disimpan';

  @override
  String get saveError => 'Catatan gagal disimpan';

  @override
  String get deleteConfirmationTitle => 'Hapus catatan ini?';

  @override
  String get deleteConfirmationMessage => 'Tindakan ini tidak bisa dibatalkan.';

  @override
  String get cancelButton => 'Batal';

  @override
  String get deleteButton => 'Hapus';

  @override
  String get logoutTooltip => 'Keluar';

  @override
  String get requiredField => 'Wajib diisi';

  @override
  String get pinValidation => 'PIN harus 4 digit angka';

  @override
  String noteTitleMaxLength(Object max) {
    return 'Judul maksimal $max karakter';
  }

  @override
  String noteContentMaxLength(Object max) {
    return 'Isi maksimal $max karakter';
  }

  @override
  String get loading => 'Memuat...';

  @override
  String get errorGeneric => 'Terjadi kesalahan';

  @override
  String get dateFormat => 'd MMM yyyy, HH.mm';

  @override
  String get moodHappy => 'Senang';

  @override
  String get moodSad => 'Sedih';
}

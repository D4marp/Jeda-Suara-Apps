const _bulanPendek = [
  'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
  'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
];
const _bulanPanjang = [
  'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
  'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
];
const _hari = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];

String bulanPendek(int month) => _bulanPendek[month - 1];
String bulanPanjang(int month) => _bulanPanjang[month - 1];
String namaHari(int weekday) => _hari[weekday - 1];

String formatJam(DateTime d) =>
    '${d.hour.toString().padLeft(2, '0')}.${d.minute.toString().padLeft(2, '0')}';

/// Format `13 Okt 2026, 17.33`.
String formatTanggal(DateTime d) =>
    '${d.day} ${bulanPendek(d.month)} ${d.year}, ${formatJam(d)}';

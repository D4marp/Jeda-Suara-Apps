import '../entities/mood.dart';

/// "AI Penjaga": mock, hanya memilih kalimat penenang sesuai mood.
class GuardianAi {
  const GuardianAi();

  String reassure(Mood mood) => switch (mood) {
        Mood.happy =>
          'Ceritamu sudah terkunci rapat. Simpan rasa senang ini, mari lanjutkan harimu.',
        Mood.sad =>
          'Ceritamu sudah terkunci rapat. Tarik napas pelan-pelan, kamu sudah berani menuliskannya.',
        Mood.neutral =>
          'Ceritamu sudah terkunci rapat. Tarik napas, mari lanjutkan harimu.',
      };
}

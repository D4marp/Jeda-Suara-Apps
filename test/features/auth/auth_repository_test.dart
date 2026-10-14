import 'package:flutter_dpl_prd_app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:flutter_dpl_prd_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_dpl_prd_app/features/auth/domain/entities/login_result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late AuthLocalDataSource ds;
  late AuthRepositoryImpl repo;
  late DateTime now;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    ds = AuthLocalDataSource(await SharedPreferences.getInstance());
    now = DateTime(2026, 10, 13, 10);
    repo = AuthRepositoryImpl(ds, now: () => now);
  });

  test('kredensial benar -> token tersimpan', () async {
    final r = await repo.login('admin', '1234');
    expect(r, isA<LoginSuccess>());
    expect(ds.readToken(), isNotNull);
    expect((await repo.getSession())?.token, ds.readToken());
  });

  test('kredensial salah -> LoginInvalid, tanpa token', () async {
    final r = await repo.login('admin', '0000');
    expect(r, isA<LoginInvalid>());
    expect((r as LoginInvalid).attemptsLeft, 4);
    expect(ds.readToken(), isNull);
  });

  test('5 kali salah -> terkunci 30 detik, lalu terbuka', () async {
    for (var i = 0; i < 4; i++) {
      expect(await repo.login('admin', '0000'), isA<LoginInvalid>());
    }
    final locked = await repo.login('admin', '0000');
    expect(locked, isA<LoginLocked>());

    // PIN benar pun ditolak selama terkunci.
    expect(await repo.login('admin', '1234'), isA<LoginLocked>());

    now = now.add(const Duration(seconds: 31));
    expect(await repo.login('admin', '1234'), isA<LoginSuccess>());
  });

  test('ganti PIN: PIN lama salah ditolak, PIN baru berlaku', () async {
    expect(await repo.changePin('9999', '4321'), isFalse);
    expect(await repo.changePin('1234', '4321'), isTrue);
    expect(await repo.login('admin', '1234'), isA<LoginInvalid>());
    expect(await repo.login('admin', '4321'), isA<LoginSuccess>());
  });

  test('logout menghapus token', () async {
    await repo.login('admin', '1234');
    await repo.logout();
    expect(await repo.getSession(), isNull);
  });
}

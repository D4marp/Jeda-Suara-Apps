import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/app_info.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/palette.dart';
import '../../domain/entities/login_result.dart';
import '../providers/auth_notifier.dart';
import '../widgets/pin_keypad.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _username = TextEditingController();
  String _pin = '';
  bool _loading = false;
  String? _usernameError;
  String? _pinError;
  String? _error;
  String? _hint;
  DateTime? _lockedUntil;
  Timer? _ticker;

  bool get _locked => _lockedUntil != null;

  int get _secondsLeft {
    final ms = _lockedUntil!.difference(DateTime.now()).inMilliseconds;
    return (ms / 1000).ceil().clamp(1, 3600);
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _username.dispose();
    super.dispose();
  }

  void _onDigit(String d) {
    if (_loading || _locked || _pin.length >= 4) return;
    setState(() {
      _pin += d;
      _error = null;
      _hint = null;
      _pinError = null;
    });
    if (_pin.length == 4 && _username.text.trim().isNotEmpty) _submit();
  }

  void _onBackspace() {
    if (_loading || _pin.isEmpty) return;
    setState(() => _pin = _pin.substring(0, _pin.length - 1));
  }

  void _startLock(DateTime until) {
    _ticker?.cancel();
    setState(() {
      _lockedUntil = until;
      _pin = '';
      _loading = false;
      _error = null;
      _hint = null;
    });
    _ticker = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (!DateTime.now().isBefore(until)) {
        t.cancel();
        setState(() => _lockedUntil = null);
      } else {
        setState(() {});
      }
    });
  }

  Future<void> _submit() async {
    if (_loading || _locked) return;
    final user = _username.text.trim();
    setState(() {
      _usernameError = user.isEmpty ? 'Username wajib diisi' : null;
      _pinError = _pin.length == 4 ? null : 'PIN harus 4 digit angka';
      _error = null;
      _hint = null;
    });
    if (_usernameError != null || _pinError != null) return;

    setState(() => _loading = true);
    final result =
        await ref.read(authNotifierProvider.notifier).login(user, _pin);
    if (!mounted) return;

    switch (result) {
      case LoginSuccess():
        return; // AuthGate yang berpindah layar
      case LoginInvalid(:final attemptsLeft):
        setState(() {
          _pin = '';
          _loading = false;
          _error = 'Username atau PIN salah.';
          _hint = attemptsLeft <= 2 ? 'Sisa percobaan: $attemptsLeft' : null;
        });
      case LoginLocked(:final until):
        _startLock(until);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final errorColor = (_error != null || _locked) ? p.danger : p.ink;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(28, 8, 28, 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: '${appNameParts[0]}\n${appNameParts[1]}'),
                        TextSpan(text: '.', style: TextStyle(color: p.accent)),
                      ],
                    ),
                    style: AppText.display(p.ink, size: 48),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    appSubheadline,
                    style: TextStyle(color: p.muted, fontSize: 15, height: 1.5),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _username,
                    textInputAction: TextInputAction.done,
                    autocorrect: false,
                    enableSuggestions: false,
                    onChanged: (_) {
                      if (_usernameError != null) {
                        setState(() => _usernameError = null);
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Username',
                      errorText: _usernameError,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Semantics(
                      label: 'PIN terisi ${_pin.length} dari 4 digit',
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (var i = 0; i < 4; i++)
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 120),
                              margin: const EdgeInsets.symmetric(horizontal: 9),
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: i < _pin.length
                                    ? errorColor
                                    : Colors.transparent,
                                border: Border.all(
                                  color: i < _pin.length ? errorColor : p.line,
                                  width: 2,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 28,
                    child: Center(
                      child: Text(
                        _locked
                            ? 'Terlalu banyak percobaan. Coba lagi dalam $_secondsLeft dtk.'
                            : _pinError ??
                                (_error == null
                                    ? ''
                                    : (_hint == null
                                        ? _error!
                                        : '$_error $_hint')),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: p.danger,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: PinKeypad(
                      enabled: !_loading && !_locked,
                      onDigit: _onDigit,
                      onBackspace: _onBackspace,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: (_loading || _locked) ? null : _submit,
                    child: _loading
                        ? SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: p.paper,
                            ),
                          )
                        : const Text('Masuk & Kunci Suaramu'),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      'Akun demo · admin / 1234',
                      style: TextStyle(color: p.muted, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

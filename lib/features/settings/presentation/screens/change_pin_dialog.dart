import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_notifier.dart';

/// Mengembalikan `true` bila PIN berhasil diganti.
class ChangePinDialog extends ConsumerStatefulWidget {
  const ChangePinDialog({super.key});

  @override
  ConsumerState<ChangePinDialog> createState() => _ChangePinDialogState();
}

class _ChangePinDialogState extends ConsumerState<ChangePinDialog> {
  final _formKey = GlobalKey<FormState>();
  final _current = TextEditingController();
  final _next = TextEditingController();
  final _confirm = TextEditingController();
  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    _current.dispose();
    _next.dispose();
    _confirm.dispose();
    super.dispose();
  }

  String? _pinRule(String? v) =>
      (v == null || !RegExp(r'^\d{4}$').hasMatch(v)) ? 'Harus 4 digit angka' : null;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final ok = await ref
        .read(authNotifierProvider.notifier)
        .changePin(_current.text, _next.text);
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop(true);
    } else {
      setState(() {
        _busy = false;
        _error = 'PIN lama salah.';
      });
    }
  }

  Widget _field(String key, String label, TextEditingController c,
      String? Function(String?) validator) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        key: Key(key),
        controller: c,
        obscureText: true,
        keyboardType: TextInputType.number,
        maxLength: 4,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(labelText: label, counterText: ''),
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ganti PIN'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _field('pin_current', 'PIN lama', _current, _pinRule),
              _field('pin_new', 'PIN baru', _next, _pinRule),
              _field(
                'pin_confirm',
                'Ulangi PIN baru',
                _confirm,
                (v) => _pinRule(v) ?? (v != _next.text ? 'PIN tidak sama' : null),
              ),
              if (_error != null)
                Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _busy ? null : () => Navigator.of(context).pop(false),
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: _busy ? null : _submit,
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}

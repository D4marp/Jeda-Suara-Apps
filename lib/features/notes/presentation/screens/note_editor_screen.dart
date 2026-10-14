import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/palette.dart';
import '../../domain/entities/mood.dart';
import '../../domain/entities/note.dart';
import '../../domain/entities/note_draft.dart';
import '../../domain/services/guardian_ai.dart';
import '../../domain/services/mood_scanner.dart';
import '../../domain/usecases/draft_usecases.dart';
import '../providers/notes_notifier.dart';
import '../widgets/mood_filter_bar.dart';

/// Menulis catatan baru, atau mengedit bila [note] diberikan.
class NoteEditorScreen extends ConsumerStatefulWidget {
  const NoteEditorScreen({super.key, this.note});

  final Note? note;

  @override
  ConsumerState<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends ConsumerState<NoteEditorScreen> {
  static const _maxTitle = 80;
  static const _maxContent = 5000;

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _content;
  late final SaveDraft _saveDraft;
  late final ClearDraft _clearDraft;
  late final MoodScanner _scanner;

  Timer? _debounce;
  bool _saving = false;
  bool _saved = false;
  bool _restored = false;

  /// Mood pilihan pengguna; `null` = otomatis (Mock AI Mood Scanner).
  Mood? _manualMood;

  bool get _isEdit => widget.note != null;

  @override
  void initState() {
    super.initState();
    final n = widget.note;
    _title = TextEditingController(
      text: n == null ? '' : MoodScanner.stripMood(n.title),
    );
    _content = TextEditingController(text: n?.content ?? '');
    _saveDraft = ref.read(saveDraftUseCaseProvider);
    _clearDraft = ref.read(clearDraftUseCaseProvider);
    _scanner = ref.read(moodScannerProvider);
    _title.addListener(_onChanged);
    _content.addListener(_onChanged);
    if (!_isEdit) _restoreDraft();
  }

  Future<void> _restoreDraft() async {
    final draft = await ref.read(getDraftUseCaseProvider)();
    if (!mounted || draft == null || draft.isEmpty) return;
    if (_title.text.isNotEmpty || _content.text.isNotEmpty) return;
    _title.text = draft.title;
    _content.text = draft.content;
    setState(() => _restored = true);
  }

  void _onChanged() {
    setState(() {});
    if (_isEdit) return;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), _flushDraft);
  }

  void _flushDraft() {
    if (_saved) return;
    _saveDraft(NoteDraft(title: _title.text, content: _content.text));
  }

  @override
  void dispose() {
    _debounce?.cancel();
    if (!_isEdit && !_saved) _flushDraft();
    _title.dispose();
    _content.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final chosen = _manualMood;
    final guardian = const GuardianAi()
        .reassure(chosen ?? _scanner.detect(_title.text, _content.text));
    final labelColor = context.palette.paper.withValues(alpha: 0.7);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final notifier = ref.read(notesNotifierProvider.notifier);
    try {
      if (_isEdit) {
        await notifier.edit(widget.note!, _title.text, _content.text,
            mood: chosen);
      } else {
        await notifier.add(_title.text, _content.text, mood: chosen);
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      messenger.showSnackBar(
        const SnackBar(content: Text('Catatan gagal disimpan.')),
      );
      return;
    }
    _saved = true;
    _debounce?.cancel();
    if (!_isEdit) await _clearDraft();
    navigator.pop();
    messenger.showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AI PENJAGA',
              style: AppText.overline(labelColor).copyWith(fontSize: 10),
            ),
            const SizedBox(height: 4),
            Text(guardian),
          ],
        ),
      ),
    );
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null;

  InputDecoration _bare(String hint) => InputDecoration(
        hintText: hint,
        filled: false,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        contentPadding: EdgeInsets.zero,
      );

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final mood = _manualMood ?? _scanner.detect(_title.text, _content.text);
    final words = _content.text.trim().isEmpty
        ? 0
        : _content.text.trim().split(RegExp(r'\s+')).length;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Tutup',
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(_isEdit ? 'Edit catatan' : 'Catatan baru'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                  children: [
                    if (_restored)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          'Draft terakhir dipulihkan.',
                          style: TextStyle(color: p.accent, fontSize: 13),
                        ),
                      ),
                    TextFormField(
                      key: const Key('field_title'),
                      controller: _title,
                      autofocus: true,
                      maxLength: _maxTitle,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.sentences,
                      style: AppText.display(p.ink, size: 28),
                      decoration: _bare('Judul'),
                      validator: _required,
                    ),
                    const SizedBox(height: 8),
                    Container(height: 1, color: p.line),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: const Key('field_content'),
                      controller: _content,
                      maxLength: _maxContent,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      minLines: 10,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      style: const TextStyle(fontSize: 16, height: 1.6),
                      decoration: _bare('Tulis ceritamu…'),
                      validator: _required,
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: p.line)),
                ),
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
                child: Column(
                  children: [
                    MoodFilterBar(
                      key: const Key('mood_picker'),
                      allLabel: 'Otomatis',
                      selected: _manualMood,
                      onSelect: (m) => setState(() => _manualMood = m),
                    ),
                    Row(
                      children: [
                        Text(
                          '${_manualMood == null ? 'Mood otomatis' : 'Mood'}: '
                          '${mood == Mood.neutral ? 'netral' : '${mood.emoji} ${mood.label}'}',
                          style: TextStyle(color: p.muted, fontSize: 13),
                        ),
                        const Spacer(),
                        Text(
                          '$words kata',
                          style: TextStyle(color: p.muted, fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: _saving ? null : _save,
                      child: const Text('Kunci & Amankan'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

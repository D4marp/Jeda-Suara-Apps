import 'package:flutter/material.dart';

import '../../notes/presentation/screens/note_editor_screen.dart';
import '../../notes/presentation/screens/notes_tab.dart';
import '../../notes/presentation/screens/stats_tab.dart';
import '../../settings/presentation/screens/settings_tab.dart';
import 'app_dock.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  void _openEditor() => Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const NoteEditorScreen()),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: _index,
          children: [
            NotesTab(onWrite: _openEditor),
            const StatsTab(),
            const SettingsTab(),
          ],
        ),
      ),
      bottomNavigationBar: AppDock(
        index: _index,
        onSelect: (i) => setState(() => _index = i),
        onAdd: _openEditor,
      ),
    );
  }
}

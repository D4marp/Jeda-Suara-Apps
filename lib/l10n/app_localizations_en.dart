// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Secret Diary';

  @override
  String get loginTitle => 'Secret Diary';

  @override
  String get loginSubtitle =>
      'Sign in with username and PIN to access your notes.';

  @override
  String get usernameLabel => 'Username';

  @override
  String get pinLabel => 'PIN';

  @override
  String get showPin => 'Show PIN';

  @override
  String get hidePin => 'Hide PIN';

  @override
  String get loginButton => 'Sign In';

  @override
  String get loginError => 'Invalid username or PIN.';

  @override
  String get demoHint => 'Demo auth: admin / 1234';

  @override
  String get notesTitle => 'My Notes';

  @override
  String get notesCountZero => 'No notes yet';

  @override
  String notesCountOne(Object count) {
    return '$count note';
  }

  @override
  String notesCountOther(Object count) {
    return '$count notes';
  }

  @override
  String get emptyStateTitle => 'No notes yet';

  @override
  String get emptyStateAction => 'Write a note';

  @override
  String get addNoteTitle => 'New Note';

  @override
  String get noteTitleLabel => 'Title';

  @override
  String get noteContentLabel => 'Content';

  @override
  String get saveButton => 'Save';

  @override
  String get savingButton => 'Saving...';

  @override
  String get saveSuccess => 'Note saved';

  @override
  String get saveError => 'Failed to save note';

  @override
  String get deleteConfirmationTitle => 'Delete this note?';

  @override
  String get deleteConfirmationMessage => 'This action cannot be undone.';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get deleteButton => 'Delete';

  @override
  String get logoutTooltip => 'Sign out';

  @override
  String get requiredField => 'This field is required';

  @override
  String get pinValidation => 'PIN must be 4 digits';

  @override
  String noteTitleMaxLength(Object max) {
    return 'Title max $max characters';
  }

  @override
  String noteContentMaxLength(Object max) {
    return 'Content max $max characters';
  }

  @override
  String get loading => 'Loading...';

  @override
  String get errorGeneric => 'Something went wrong';

  @override
  String get dateFormat => 'MMM d, yyyy, HH:mm';

  @override
  String get moodHappy => 'Happy';

  @override
  String get moodSad => 'Sad';
}

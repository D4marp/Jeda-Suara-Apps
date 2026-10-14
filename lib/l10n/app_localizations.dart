import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Secret Diary'**
  String get appTitle;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Secret Diary'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with username and PIN to access your notes.'**
  String get loginSubtitle;

  /// No description provided for @usernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get usernameLabel;

  /// No description provided for @pinLabel.
  ///
  /// In en, this message translates to:
  /// **'PIN'**
  String get pinLabel;

  /// No description provided for @showPin.
  ///
  /// In en, this message translates to:
  /// **'Show PIN'**
  String get showPin;

  /// No description provided for @hidePin.
  ///
  /// In en, this message translates to:
  /// **'Hide PIN'**
  String get hidePin;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get loginButton;

  /// No description provided for @loginError.
  ///
  /// In en, this message translates to:
  /// **'Invalid username or PIN.'**
  String get loginError;

  /// No description provided for @demoHint.
  ///
  /// In en, this message translates to:
  /// **'Demo auth: admin / 1234'**
  String get demoHint;

  /// No description provided for @notesTitle.
  ///
  /// In en, this message translates to:
  /// **'My Notes'**
  String get notesTitle;

  /// No description provided for @notesCountZero.
  ///
  /// In en, this message translates to:
  /// **'No notes yet'**
  String get notesCountZero;

  /// No description provided for @notesCountOne.
  ///
  /// In en, this message translates to:
  /// **'{count} note'**
  String notesCountOne(Object count);

  /// No description provided for @notesCountOther.
  ///
  /// In en, this message translates to:
  /// **'{count} notes'**
  String notesCountOther(Object count);

  /// No description provided for @emptyStateTitle.
  ///
  /// In en, this message translates to:
  /// **'No notes yet'**
  String get emptyStateTitle;

  /// No description provided for @emptyStateAction.
  ///
  /// In en, this message translates to:
  /// **'Write a note'**
  String get emptyStateAction;

  /// No description provided for @addNoteTitle.
  ///
  /// In en, this message translates to:
  /// **'New Note'**
  String get addNoteTitle;

  /// No description provided for @noteTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get noteTitleLabel;

  /// No description provided for @noteContentLabel.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get noteContentLabel;

  /// No description provided for @saveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButton;

  /// No description provided for @savingButton.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get savingButton;

  /// No description provided for @saveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Note saved'**
  String get saveSuccess;

  /// No description provided for @saveError.
  ///
  /// In en, this message translates to:
  /// **'Failed to save note'**
  String get saveError;

  /// No description provided for @deleteConfirmationTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this note?'**
  String get deleteConfirmationTitle;

  /// No description provided for @deleteConfirmationMessage.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get deleteConfirmationMessage;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// No description provided for @deleteButton.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteButton;

  /// No description provided for @logoutTooltip.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get logoutTooltip;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get requiredField;

  /// No description provided for @pinValidation.
  ///
  /// In en, this message translates to:
  /// **'PIN must be 4 digits'**
  String get pinValidation;

  /// No description provided for @noteTitleMaxLength.
  ///
  /// In en, this message translates to:
  /// **'Title max {max} characters'**
  String noteTitleMaxLength(Object max);

  /// No description provided for @noteContentMaxLength.
  ///
  /// In en, this message translates to:
  /// **'Content max {max} characters'**
  String noteContentMaxLength(Object max);

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorGeneric;

  /// No description provided for @dateFormat.
  ///
  /// In en, this message translates to:
  /// **'MMM d, yyyy, HH:mm'**
  String get dateFormat;

  /// No description provided for @moodHappy.
  ///
  /// In en, this message translates to:
  /// **'Happy'**
  String get moodHappy;

  /// No description provided for @moodSad.
  ///
  /// In en, this message translates to:
  /// **'Sad'**
  String get moodSad;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

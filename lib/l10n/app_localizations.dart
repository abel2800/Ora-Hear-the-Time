import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_am.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('am'),
    Locale('en'),
    Locale('es')
  ];

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @settingsHub.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsHub;

  /// No description provided for @tapToHearTime.
  ///
  /// In en, this message translates to:
  /// **'Tap anywhere to hear the time'**
  String get tapToHearTime;

  /// No description provided for @voiceSettings.
  ///
  /// In en, this message translates to:
  /// **'Voice'**
  String get voiceSettings;

  /// No description provided for @voiceVolume.
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get voiceVolume;

  /// No description provided for @voiceSpeed.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get voiceSpeed;

  /// No description provided for @voicePitch.
  ///
  /// In en, this message translates to:
  /// **'Pitch'**
  String get voicePitch;

  /// No description provided for @voiceLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get voiceLanguage;

  /// No description provided for @voiceChoice.
  ///
  /// In en, this message translates to:
  /// **'Voice'**
  String get voiceChoice;

  /// No description provided for @voiceToneMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get voiceToneMale;

  /// No description provided for @voiceToneFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get voiceToneFemale;

  /// No description provided for @voiceToneNeutral.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get voiceToneNeutral;

  /// No description provided for @voiceToneLabel.
  ///
  /// In en, this message translates to:
  /// **'Tone'**
  String get voiceToneLabel;

  /// No description provided for @noVoicesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No voices found for this language on your device'**
  String get noVoicesAvailable;

  /// No description provided for @testVoice.
  ///
  /// In en, this message translates to:
  /// **'Test Voice'**
  String get testVoice;

  /// No description provided for @tapToHearSample.
  ///
  /// In en, this message translates to:
  /// **'Tap to hear a voice sample'**
  String get tapToHearSample;

  /// No description provided for @announcementInterval.
  ///
  /// In en, this message translates to:
  /// **'Announcement Interval'**
  String get announcementInterval;

  /// No description provided for @noRepeat.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get noRepeat;

  /// No description provided for @every15Minutes.
  ///
  /// In en, this message translates to:
  /// **'Every 15 minutes'**
  String get every15Minutes;

  /// No description provided for @every30Minutes.
  ///
  /// In en, this message translates to:
  /// **'Every 30 minutes'**
  String get every30Minutes;

  /// No description provided for @everyHour.
  ///
  /// In en, this message translates to:
  /// **'Every hour'**
  String get everyHour;

  /// No description provided for @quietHours.
  ///
  /// In en, this message translates to:
  /// **'Quiet Hours'**
  String get quietHours;

  /// No description provided for @enableQuietHours.
  ///
  /// In en, this message translates to:
  /// **'Enable Quiet Hours'**
  String get enableQuietHours;

  /// No description provided for @disableAnnouncements.
  ///
  /// In en, this message translates to:
  /// **'Disable announcements during set times'**
  String get disableAnnouncements;

  /// No description provided for @quietStartTime.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get quietStartTime;

  /// No description provided for @quietEndTime.
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get quietEndTime;

  /// No description provided for @blockTouchDuringQuiet.
  ///
  /// In en, this message translates to:
  /// **'Block Touch During Quiet'**
  String get blockTouchDuringQuiet;

  /// No description provided for @alsoDisableTapToSpeak.
  ///
  /// In en, this message translates to:
  /// **'Also disable tap-to-speak during quiet hours'**
  String get alsoDisableTapToSpeak;

  /// No description provided for @touchToSpeak.
  ///
  /// In en, this message translates to:
  /// **'Touch to Speak'**
  String get touchToSpeak;

  /// No description provided for @tapAnywhereToHear.
  ///
  /// In en, this message translates to:
  /// **'Tap anywhere on screen to hear time'**
  String get tapAnywhereToHear;

  /// No description provided for @vibrationFeedback.
  ///
  /// In en, this message translates to:
  /// **'Vibration Feedback'**
  String get vibrationFeedback;

  /// No description provided for @feelVibration.
  ///
  /// In en, this message translates to:
  /// **'Feel a vibration when time is spoken'**
  String get feelVibration;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @usesDarkTheme.
  ///
  /// In en, this message translates to:
  /// **'Use dark theme for the app'**
  String get usesDarkTheme;

  /// No description provided for @dynamicColors.
  ///
  /// In en, this message translates to:
  /// **'Dynamic Colors'**
  String get dynamicColors;

  /// No description provided for @useDynamicColors.
  ///
  /// In en, this message translates to:
  /// **'Use system wallpaper colors on supported devices'**
  String get useDynamicColors;

  /// No description provided for @largeText.
  ///
  /// In en, this message translates to:
  /// **'Large Text'**
  String get largeText;

  /// No description provided for @highContrast.
  ///
  /// In en, this message translates to:
  /// **'High Contrast'**
  String get highContrast;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @madeWithLove.
  ///
  /// In en, this message translates to:
  /// **'Made with love for accessibility'**
  String get madeWithLove;

  /// No description provided for @slow.
  ///
  /// In en, this message translates to:
  /// **'Slow'**
  String get slow;

  /// No description provided for @normal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// No description provided for @fast.
  ///
  /// In en, this message translates to:
  /// **'Fast'**
  String get fast;

  /// No description provided for @quietMode.
  ///
  /// In en, this message translates to:
  /// **'Quiet Mode'**
  String get quietMode;

  /// No description provided for @every.
  ///
  /// In en, this message translates to:
  /// **'Every'**
  String get every;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get minutes;

  /// No description provided for @repeatCount.
  ///
  /// In en, this message translates to:
  /// **'Repeat Count'**
  String get repeatCount;

  /// No description provided for @once.
  ///
  /// In en, this message translates to:
  /// **'Once'**
  String get once;

  /// No description provided for @twice.
  ///
  /// In en, this message translates to:
  /// **'Twice'**
  String get twice;

  /// No description provided for @threeTimes.
  ///
  /// In en, this message translates to:
  /// **'3 times'**
  String get threeTimes;

  /// No description provided for @fourTimes.
  ///
  /// In en, this message translates to:
  /// **'4 times'**
  String get fourTimes;

  /// No description provided for @fiveTimes.
  ///
  /// In en, this message translates to:
  /// **'5 times'**
  String get fiveTimes;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening'**
  String get goodEvening;

  /// No description provided for @goodNight.
  ///
  /// In en, this message translates to:
  /// **'Good Night'**
  String get goodNight;

  /// No description provided for @nextAnnouncement.
  ///
  /// In en, this message translates to:
  /// **'Next announcement'**
  String get nextAnnouncement;

  /// No description provided for @lastAnnouncement.
  ///
  /// In en, this message translates to:
  /// **'Last announcement'**
  String get lastAnnouncement;

  /// No description provided for @nextAnnouncementPreview.
  ///
  /// In en, this message translates to:
  /// **'Next Announcement'**
  String get nextAnnouncementPreview;

  /// No description provided for @statusInformation.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusInformation;

  /// No description provided for @announcementIntervalLabel.
  ///
  /// In en, this message translates to:
  /// **'Interval'**
  String get announcementIntervalLabel;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// No description provided for @announcements.
  ///
  /// In en, this message translates to:
  /// **'Announcements'**
  String get announcements;

  /// No description provided for @accessibility.
  ///
  /// In en, this message translates to:
  /// **'Accessibility'**
  String get accessibility;

  /// No description provided for @openSourceLicenses.
  ///
  /// In en, this message translates to:
  /// **'Open Source Licenses'**
  String get openSourceLicenses;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @accessibilityMission.
  ///
  /// In en, this message translates to:
  /// **'Accessibility Mission'**
  String get accessibilityMission;

  /// No description provided for @whatsNew.
  ///
  /// In en, this message translates to:
  /// **'What\'s New'**
  String get whatsNew;

  /// No description provided for @shareApp.
  ///
  /// In en, this message translates to:
  /// **'Share App'**
  String get shareApp;

  /// No description provided for @greetingAnnouncements.
  ///
  /// In en, this message translates to:
  /// **'Greeting on Launch'**
  String get greetingAnnouncements;

  /// No description provided for @greetingAnnouncementsDesc.
  ///
  /// In en, this message translates to:
  /// **'Speak a greeting when you open the app'**
  String get greetingAnnouncementsDesc;

  /// No description provided for @dateAnnouncement.
  ///
  /// In en, this message translates to:
  /// **'Include Date'**
  String get dateAnnouncement;

  /// No description provided for @dateAnnouncementDesc.
  ///
  /// In en, this message translates to:
  /// **'Also speak today\'s date when tapping'**
  String get dateAnnouncementDesc;

  /// No description provided for @voiceClockAssistant.
  ///
  /// In en, this message translates to:
  /// **'Voice Clock Assistant'**
  String get voiceClockAssistant;

  /// No description provided for @announcementsOff.
  ///
  /// In en, this message translates to:
  /// **'Announcements off'**
  String get announcementsOff;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @categoryVoiceDesc.
  ///
  /// In en, this message translates to:
  /// **'Language, volume, speed, and pitch'**
  String get categoryVoiceDesc;

  /// No description provided for @categoryAnnouncementsDesc.
  ///
  /// In en, this message translates to:
  /// **'Intervals, repeat count, and quiet hours'**
  String get categoryAnnouncementsDesc;

  /// No description provided for @categoryAccessibilityDesc.
  ///
  /// In en, this message translates to:
  /// **'Touch, vibration, and screen reader'**
  String get categoryAccessibilityDesc;

  /// No description provided for @categoryAppearanceDesc.
  ///
  /// In en, this message translates to:
  /// **'Theme, colors, and display'**
  String get categoryAppearanceDesc;

  /// No description provided for @categoryAboutDesc.
  ///
  /// In en, this message translates to:
  /// **'Version, support, and mission'**
  String get categoryAboutDesc;

  /// No description provided for @whatsNewContent.
  ///
  /// In en, this message translates to:
  /// **'• Premium Material 3 redesign\n• Split settings for easier navigation\n• Improved accessibility\n• Smoother animations\n• Better background reliability'**
  String get whatsNewContent;

  /// No description provided for @accessibilityMissionText.
  ///
  /// In en, this message translates to:
  /// **'Ora helps blind and visually impaired users know the time independently — without asking anyone. Everyone deserves to know the time.'**
  String get accessibilityMissionText;

  /// No description provided for @privacyPolicyText.
  ///
  /// In en, this message translates to:
  /// **'Ora does not collect personal data. All settings are stored locally on your device. The app uses text-to-speech and background services only to announce time.'**
  String get privacyPolicyText;

  /// No description provided for @shareMessage.
  ///
  /// In en, this message translates to:
  /// **'Try Ora — a voice clock for accessibility!'**
  String get shareMessage;

  /// No description provided for @notScheduled.
  ///
  /// In en, this message translates to:
  /// **'Not scheduled'**
  String get notScheduled;
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
      <String>['am', 'en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'am':
      return AppLocalizationsAm();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}

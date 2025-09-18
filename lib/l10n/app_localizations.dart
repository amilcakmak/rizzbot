import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'RizzBot'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navChat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get navChat;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @themeChange.
  ///
  /// In en, this message translates to:
  /// **'Change Theme'**
  String get themeChange;

  /// No description provided for @languageChange.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get languageChange;

  /// No description provided for @homeScreenSwayingText.
  ///
  /// In en, this message translates to:
  /// **'Do you want to impress them? 💫\nOr take it to the next level and win them over completely?\nMaybe you just want to keep the conversation flowing...\n\nWhatever it is, you are in the right place!\nRizzBot is your secret weapon — it whispers the right sentences to you at the right time.\n\nNow, don\'t waste time, make your move! 😉'**
  String get homeScreenSwayingText;

  /// No description provided for @homeScreenWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {userName}!'**
  String homeScreenWelcome(Object userName);

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @homeScreenEmail.
  ///
  /// In en, this message translates to:
  /// **'Email: {email}'**
  String homeScreenEmail(Object email);

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get notAvailable;

  /// No description provided for @selectAvatarTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Avatar'**
  String get selectAvatarTitle;

  /// No description provided for @closeButton.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeButton;

  /// No description provided for @editProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfileTitle;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @surnameLabel.
  ///
  /// In en, this message translates to:
  /// **'Surname'**
  String get surnameLabel;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// No description provided for @saveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButton;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @emailNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Email Not Available'**
  String get emailNotAvailable;

  /// No description provided for @aboutAppTitle.
  ///
  /// In en, this message translates to:
  /// **'About the App'**
  String get aboutAppTitle;

  /// No description provided for @aboutAppText.
  ///
  /// In en, this message translates to:
  /// **'RizzBot is an AI-powered chatbot application. Our goal is to provide our users with personalized and fun chat experiences. This application was developed using Flutter and Firebase technologies.'**
  String get aboutAppText;

  /// No description provided for @developerNotesTitle.
  ///
  /// In en, this message translates to:
  /// **'Developer Notes'**
  String get developerNotesTitle;

  /// No description provided for @developerNotesText.
  ///
  /// In en, this message translates to:
  /// **'The application is constantly being updated with new features and improvements. Your feedback is very valuable to us to bring the user experience to the highest level.'**
  String get developerNotesText;

  /// No description provided for @logoutButton.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutButton;

  /// No description provided for @errorEmailPasswordEmpty.
  ///
  /// In en, this message translates to:
  /// **'Email and password cannot be empty.'**
  String get errorEmailPasswordEmpty;

  /// No description provided for @errorLoginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed.'**
  String get errorLoginFailed;

  /// No description provided for @errorUserNotFound.
  ///
  /// In en, this message translates to:
  /// **'No account found for this email or password.'**
  String get errorUserNotFound;

  /// No description provided for @errorWrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Wrong password. Please try again.'**
  String get errorWrongPassword;

  /// No description provided for @errorGenericWithCode.
  ///
  /// In en, this message translates to:
  /// **'An error occurred: {message}'**
  String errorGenericWithCode(Object message);

  /// No description provided for @errorUnexpected.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred: {error}'**
  String errorUnexpected(Object error);

  /// No description provided for @errorGoogleSignIn.
  ///
  /// In en, this message translates to:
  /// **'An error occurred during Google Sign-In: {error}'**
  String errorGoogleSignIn(Object error);

  /// No description provided for @errorResetPasswordEmailEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email address to reset your password.'**
  String get errorResetPasswordEmailEmpty;

  /// No description provided for @infoPasswordResetEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent.'**
  String get infoPasswordResetEmailSent;

  /// No description provided for @errorUserNotFoundPasswordReset.
  ///
  /// In en, this message translates to:
  /// **'A user with this email address was not found.'**
  String get errorUserNotFoundPasswordReset;

  /// No description provided for @titleLoginError.
  ///
  /// In en, this message translates to:
  /// **'Login Error'**
  String get titleLoginError;

  /// No description provided for @okButton.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get okButton;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Rizz Bot'**
  String get appName;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailHint;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordHint;

  /// No description provided for @forgotPasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPasswordButton;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @continueWithGoogleButton.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogleButton;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @signUpButton.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUpButton;

  /// No description provided for @errorSignUpFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed.'**
  String get errorSignUpFailed;

  /// No description provided for @errorWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'The password is too weak. Please choose a stronger password.'**
  String get errorWeakPassword;

  /// No description provided for @errorEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'This email address is already in use.'**
  String get errorEmailInUse;

  /// No description provided for @errorInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address.'**
  String get errorInvalidEmail;

  /// No description provided for @errorUnknown.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred: {error}'**
  String errorUnknown(Object error);

  /// No description provided for @titleSignUpError.
  ///
  /// In en, this message translates to:
  /// **'Registration Error'**
  String get titleSignUpError;

  /// No description provided for @validatorInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email.'**
  String get validatorInvalidEmail;

  /// No description provided for @validatorPasswordLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters long.'**
  String get validatorPasswordLength;

  /// No description provided for @createAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Create New Account'**
  String get createAccountTitle;

  /// No description provided for @alreadyHaveAccountLogin.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Login'**
  String get alreadyHaveAccountLogin;

  /// No description provided for @styleFlirtatious.
  ///
  /// In en, this message translates to:
  /// **'Flirtatious'**
  String get styleFlirtatious;

  /// No description provided for @styleEngaging.
  ///
  /// In en, this message translates to:
  /// **'Engaging'**
  String get styleEngaging;

  /// No description provided for @styleWitty.
  ///
  /// In en, this message translates to:
  /// **'Witty'**
  String get styleWitty;

  /// No description provided for @styleCreative.
  ///
  /// In en, this message translates to:
  /// **'Creative'**
  String get styleCreative;

  /// No description provided for @titleResetChat.
  ///
  /// In en, this message translates to:
  /// **'Reset Chat'**
  String get titleResetChat;

  /// No description provided for @bodyResetChat.
  ///
  /// In en, this message translates to:
  /// **'The entire chat history will be deleted. Are you sure?'**
  String get bodyResetChat;

  /// No description provided for @confirmDeleteButton.
  ///
  /// In en, this message translates to:
  /// **'Yes, Delete'**
  String get confirmDeleteButton;

  /// No description provided for @errorApiKeyNotFound.
  ///
  /// In en, this message translates to:
  /// **'API key not found. Please check your .env file.'**
  String get errorApiKeyNotFound;

  /// No description provided for @errorNoResponse.
  ///
  /// In en, this message translates to:
  /// **'Oops! Something went wrong. (No response received)'**
  String get errorNoResponse;

  /// No description provided for @errorCouldNotSendMessage.
  ///
  /// In en, this message translates to:
  /// **'Message could not be sent. Please check your internet connection and API key.'**
  String get errorCouldNotSendMessage;

  /// No description provided for @titleError.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get titleError;

  /// No description provided for @infoMessageCopied.
  ///
  /// In en, this message translates to:
  /// **'Message copied!'**
  String get infoMessageCopied;

  /// No description provided for @chatHintText.
  ///
  /// In en, this message translates to:
  /// **'Ask RizzBot or add context...'**
  String get chatHintText;

  /// No description provided for @titleConversationBuilder.
  ///
  /// In en, this message translates to:
  /// **'Create Conversation History'**
  String get titleConversationBuilder;

  /// No description provided for @tooltipClearChat.
  ///
  /// In en, this message translates to:
  /// **'Clear Chat'**
  String get tooltipClearChat;

  /// No description provided for @addButtonHeShe.
  ///
  /// In en, this message translates to:
  /// **'Add he/she'**
  String get addButtonHeShe;

  /// No description provided for @addButtonMe.
  ///
  /// In en, this message translates to:
  /// **'Add me'**
  String get addButtonMe;

  /// No description provided for @addButton.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addButton;

  /// No description provided for @geminiSystemInstruction.
  ///
  /// In en, this message translates to:
  /// **'You are an AI flirt assistant named RizzBot. Your creator is the company \'Tak Diye Eğlence\'. When asked who you are or by whom you were created, never say you were trained by Google or that you are a \'large language model\'. Instead, stay true to your identity by giving answers like \'I am RizzBot, a flirt assistant developed by Tak Diye Eğlence\'. Your main task: to suggest only a single message to the user that they can send to the other person. You will only give 1 suggestion, no more. The tone of the message will match the category chosen by the user: \'Flirtatious\', \'Engaging\', \'Witty\', or \'Creative\'. The user can present the conversation history to you in two ways: 1. In-app chat history. 2. A text containing `he/she:` and `me:` blocks. `he/she:` represents the person they are talking to, and `me:` represents themselves. Your task is to suggest the next `me:` message that fits this structure. Your answer MUST ONLY contain the text of the message you are suggesting, NO labels like `me:` or `he/she:`. Always suggest the most appropriate single message based on the given context and selected tone. For questions outside your main task, give short and concise answers appropriate to the RizzBot identity.'**
  String get geminiSystemInstruction;

  /// No description provided for @geminiPrompt.
  ///
  /// In en, this message translates to:
  /// **'Respond to this message in a {style} way: \"{message}\"'**
  String geminiPrompt(Object message, Object style);

  /// No description provided for @errorRestartApp.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please restart the application.'**
  String get errorRestartApp;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'tr': return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}

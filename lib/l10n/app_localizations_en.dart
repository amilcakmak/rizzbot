// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'RizzBot';

  @override
  String get navHome => 'Home';

  @override
  String get navChat => 'Chat';

  @override
  String get navProfile => 'Profile';

  @override
  String get themeChange => 'Change Theme';

  @override
  String get languageChange => 'Change Language';

  @override
  String get homeScreenSwayingText => 'Do you want to impress them? 💫\nOr take it to the next level and win them over completely?\nMaybe you just want to keep the conversation flowing...\n\nWhatever it is, you are in the right place!\nRizzBot is your secret weapon — it whispers the right sentences to you at the right time.\n\nNow, don\'t waste time, make your move! 😉';

  @override
  String homeScreenWelcome(Object userName) {
    return 'Welcome, $userName!';
  }

  @override
  String get user => 'User';

  @override
  String homeScreenEmail(Object email) {
    return 'Email: $email';
  }

  @override
  String get notAvailable => 'N/A';

  @override
  String get selectAvatarTitle => 'Select Avatar';

  @override
  String get closeButton => 'Close';

  @override
  String get editProfileTitle => 'Edit Profile';

  @override
  String get nameLabel => 'Name';

  @override
  String get surnameLabel => 'Surname';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get saveButton => 'Save';

  @override
  String get profileTitle => 'Profile';

  @override
  String get emailNotAvailable => 'Email Not Available';

  @override
  String get aboutAppTitle => 'About the App';

  @override
  String get aboutAppText => 'RizzBot is an AI-powered chatbot application. Our goal is to provide our users with personalized and fun chat experiences. This application was developed using Flutter and Firebase technologies.';

  @override
  String get developerNotesTitle => 'Developer Notes';

  @override
  String get developerNotesText => 'The application is constantly being updated with new features and improvements. Your feedback is very valuable to us to bring the user experience to the highest level.';

  @override
  String get logoutButton => 'Logout';

  @override
  String get errorEmailPasswordEmpty => 'Email and password cannot be empty.';

  @override
  String get errorLoginFailed => 'Login failed.';

  @override
  String get errorUserNotFound => 'No account found for this email or password.';

  @override
  String get errorWrongPassword => 'Wrong password. Please try again.';

  @override
  String errorGenericWithCode(Object message) {
    return 'An error occurred: $message';
  }

  @override
  String errorUnexpected(Object error) {
    return 'An unexpected error occurred: $error';
  }

  @override
  String errorGoogleSignIn(Object error) {
    return 'An error occurred during Google Sign-In: $error';
  }

  @override
  String get errorResetPasswordEmailEmpty => 'Please enter your email address to reset your password.';

  @override
  String get infoPasswordResetEmailSent => 'Password reset email sent.';

  @override
  String get errorUserNotFoundPasswordReset => 'A user with this email address was not found.';

  @override
  String get titleLoginError => 'Login Error';

  @override
  String get okButton => 'OK';

  @override
  String get appName => 'Rizz Bot';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get emailHint => 'Email';

  @override
  String get passwordHint => 'Password';

  @override
  String get forgotPasswordButton => 'Forgot Password?';

  @override
  String get loginButton => 'Login';

  @override
  String get continueWithGoogleButton => 'Continue with Google';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get signUpButton => 'Sign Up';

  @override
  String get errorSignUpFailed => 'Registration failed.';

  @override
  String get errorWeakPassword => 'The password is too weak. Please choose a stronger password.';

  @override
  String get errorEmailInUse => 'This email address is already in use.';

  @override
  String get errorInvalidEmail => 'Invalid email address.';

  @override
  String errorUnknown(Object error) {
    return 'An unknown error occurred: $error';
  }

  @override
  String get titleSignUpError => 'Registration Error';

  @override
  String get validatorInvalidEmail => 'Please enter a valid email.';

  @override
  String get validatorPasswordLength => 'Password must be at least 6 characters long.';

  @override
  String get createAccountTitle => 'Create New Account';

  @override
  String get alreadyHaveAccountLogin => 'Already have an account? Login';

  @override
  String get styleFlirtatious => 'Flirtatious';

  @override
  String get styleEngaging => 'Engaging';

  @override
  String get styleWitty => 'Witty';

  @override
  String get styleCreative => 'Creative';

  @override
  String get titleResetChat => 'Reset Chat';

  @override
  String get bodyResetChat => 'The entire chat history will be deleted. Are you sure?';

  @override
  String get confirmDeleteButton => 'Yes, Delete';

  @override
  String get errorApiKeyNotFound => 'API key not found. Please check your .env file.';

  @override
  String get errorNoResponse => 'Oops! Something went wrong. (No response received)';

  @override
  String get errorCouldNotSendMessage => 'Message could not be sent. Please check your internet connection and API key.';

  @override
  String get titleError => 'Error';

  @override
  String get infoMessageCopied => 'Message copied!';

  @override
  String get chatHintText => 'Ask RizzBot or add context...';

  @override
  String get titleConversationBuilder => 'Create Conversation History';

  @override
  String get tooltipClearChat => 'Clear Chat';

  @override
  String get addButtonHeShe => 'Add he/she';

  @override
  String get addButtonMe => 'Add me';

  @override
  String get addButton => 'Add';

  @override
  String get geminiSystemInstruction => 'You are an AI flirt assistant named RizzBot. Your creator is the company \'Tak Diye Eğlence\'. When asked who you are or by whom you were created, never say you were trained by Google or that you are a \'large language model\'. Instead, stay true to your identity by giving answers like \'I am RizzBot, a flirt assistant developed by Tak Diye Eğlence\'. Your main task: to suggest only a single message to the user that they can send to the other person. You will only give 1 suggestion, no more. The tone of the message will match the category chosen by the user: \'Flirtatious\', \'Engaging\', \'Witty\', or \'Creative\'. The user can present the conversation history to you in two ways: 1. In-app chat history. 2. A text containing `he/she:` and `me:` blocks. `he/she:` represents the person they are talking to, and `me:` represents themselves. Your task is to suggest the next `me:` message that fits this structure. Your answer MUST ONLY contain the text of the message you are suggesting, NO labels like `me:` or `he/she:`. Always suggest the most appropriate single message based on the given context and selected tone. For questions outside your main task, give short and concise answers appropriate to the RizzBot identity.';

  @override
  String geminiPrompt(Object message, Object style) {
    return 'Respond to this message in a $style way: \"$message\"';
  }

  @override
  String get errorRestartApp => 'An error occurred. Please restart the application.';
}

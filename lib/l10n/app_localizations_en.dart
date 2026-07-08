// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get unknown_error => 'An unknown error has occurred';

  @override
  String get data_processing_error =>
      'An error occurred while processing the data.';

  @override
  String get no_internet_access => 'Unable to access the Internet!';

  @override
  String get common_xeducation => 'XEducation';

  @override
  String get reset_password => 'Reset your password';

  @override
  String get reset_password_instruction =>
      'Enter your email address and we\'ll send you a link to reset your password.';

  @override
  String get common_email => 'Email';

  @override
  String get common_email_hint => 'email@example.com';

  @override
  String get common_email_required => 'Email is required';

  @override
  String get common_email_invalid => 'Invalid email';

  @override
  String get send_reset_link => 'Send reset link';

  @override
  String get back_to_login => 'Back to login';

  @override
  String get common_password => 'Password';

  @override
  String get password_hint => '********';

  @override
  String get password_required => 'Password is required';

  @override
  String get password_length => 'Password must be at least 8 characters long';

  @override
  String get password_letters_numbers =>
      'Password must contain both letters and numbers';

  @override
  String get forget_password => 'Forget password';

  @override
  String get login => 'Login';

  @override
  String get common_select_option => 'Select option';

  @override
  String get common_agree => 'Agree';

  @override
  String get welcome_title => 'Welcome to Nusuk Guide';

  @override
  String get welcome_subtitle => 'Your smart companion for Hajj and Umrah';

  @override
  String get start_now => 'Start Now';

  @override
  String get dark_mode => 'Dark Mode';

  @override
  String get language => 'Language';

  @override
  String get sign_in => 'Sign In';

  @override
  String get session_expired =>
      'Your session has expired. Please log in again.';
}

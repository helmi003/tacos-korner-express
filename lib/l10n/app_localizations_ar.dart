// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get unknown_error => 'حدث خطأ غير معروف';

  @override
  String get data_processing_error => 'حدث خطأ أثناء معالجة البيانات.';

  @override
  String get no_internet_access => 'غير قادر على الوصول إلى الإنترنت!';

  @override
  String get common_xeducation => 'إكس إديوكيشن';

  @override
  String get reset_password => 'إعادة تعيين كلمة المرور';

  @override
  String get reset_password_instruction =>
      'أدخل عنوان بريدك الإلكتروني وسنرسل لك رابطًا لإعادة تعيين كلمة المرور.';

  @override
  String get common_email => 'البريد الإلكتروني';

  @override
  String get common_email_hint => 'email@example.com';

  @override
  String get common_email_required => 'البريد الإلكتروني مطلوب';

  @override
  String get common_email_invalid => 'بريد إلكتروني غير صالح';

  @override
  String get send_reset_link => 'إرسال رابط إعادة التعيين';

  @override
  String get back_to_login => 'العودة إلى تسجيل الدخول';

  @override
  String get common_password => 'كلمة المرور';

  @override
  String get password_hint => '********';

  @override
  String get password_required => 'كلمة المرور مطلوبة';

  @override
  String get password_length => 'يجب أن تكون كلمة المرور 8 أحرف على الأقل';

  @override
  String get password_letters_numbers =>
      'يجب أن تحتوي كلمة المرور على أحرف وأرقام';

  @override
  String get forget_password => 'نسيت كلمة المرور';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get common_select_option => 'حدد الخيار';

  @override
  String get common_agree => 'موافق';

  @override
  String get welcome_title => 'مرحباً بك في مرشد النُسُك';

  @override
  String get welcome_subtitle => 'رفيقك الذكي في رحلة الحج والعمرة';

  @override
  String get start_now => 'ابدأ الآن';

  @override
  String get dark_mode => 'الوضع الداكن';

  @override
  String get language => 'اللغة';

  @override
  String get sign_in => 'تسجيل الدخول';

  @override
  String get session_expired => 'انتهت جلستك. يرجى تسجيل الدخول مجدداً.';
}

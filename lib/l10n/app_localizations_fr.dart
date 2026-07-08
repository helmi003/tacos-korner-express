// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get unknown_error => 'Une erreur inconnue s\'est produite';

  @override
  String get data_processing_error =>
      'Une erreur s\'est produite lors du traitement des données.';

  @override
  String get no_internet_access => 'Impossible d\'accéder à Internet !';

  @override
  String get common_xeducation => 'XEducation';

  @override
  String get reset_password => 'Réinitialiser votre mot de passe';

  @override
  String get reset_password_instruction =>
      'Entrez votre adresse e-mail et nous vous enverrons un lien pour réinitialiser votre mot de passe.';

  @override
  String get common_email => 'E-mail';

  @override
  String get common_email_hint => 'email@exemple.com';

  @override
  String get common_email_required => 'L\'e-mail est requis';

  @override
  String get common_email_invalid => 'E-mail invalide';

  @override
  String get send_reset_link => 'Envoyer le lien de réinitialisation';

  @override
  String get back_to_login => 'Retour à la connexion';

  @override
  String get common_password => 'Mot de passe';

  @override
  String get password_hint => '********';

  @override
  String get password_required => 'Le mot de passe est requis';

  @override
  String get password_length =>
      'Le mot de passe doit contenir au moins 8 caractères';

  @override
  String get password_letters_numbers =>
      'Le mot de passe doit contenir des lettres et des chiffres';

  @override
  String get forget_password => 'Mot de passe oublié';

  @override
  String get login => 'Connexion';

  @override
  String get common_select_option => 'Sélectionner une option';

  @override
  String get common_agree => 'Accepter';

  @override
  String get welcome_title => 'Bienvenue dans le Guide Nusuk';

  @override
  String get welcome_subtitle =>
      'Votre compagnon intelligent pour le Hajj et l\'Omra';

  @override
  String get start_now => 'Commencer maintenant';

  @override
  String get dark_mode => 'Mode sombre';

  @override
  String get language => 'Langue';

  @override
  String get sign_in => 'Se connecter';

  @override
  String get session_expired =>
      'Votre session a expiré. Veuillez vous reconnecter.';
}

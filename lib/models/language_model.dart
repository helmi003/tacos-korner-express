import 'package:flutter/material.dart';
import 'package:takos_corner_express/l10n/app_localizations.dart';

class LanguageModel {
  final Locale code;
  final String name;
  final String title;

  LanguageModel(this.code, this.name, this.title);

  factory LanguageModel.fromJson(Map<String, dynamic> json) {
    return LanguageModel(
      json['code'] ?? '',
      json['name'] ?? '',
      json['title'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'code': code, 'name': name, 'title': title};
  }

  static Locale stringToLocale(String code) {
    return Locale(code);
  }

  static String localeToString(Locale locale) {
    return locale.languageCode;
  }

  String localizedTitle(AppLocalizations loc) {
    switch (code.languageCode) {
      case 'en':
        return "English";
      case 'ar':
        return "Arabic";
      case 'fr':
        return "French";
      default:
        return title;
    }
  }
}

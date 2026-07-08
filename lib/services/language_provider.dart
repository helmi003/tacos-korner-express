import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takos_corner_express/data/language_data.dart';
import 'package:takos_corner_express/models/language_model.dart';

class LanguageProvider with ChangeNotifier {
  final url = dotenv.env['API_URL'];
  Locale selectedLanguage = const Locale('fr');
  bool get isArabic => selectedLanguage.languageCode == 'ar';
  bool get isFrench => selectedLanguage.languageCode == 'fr';

  LanguageProvider() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString('defaultLanguage');
    if (code != null) {
      selectedLanguage = LanguageModel.stringToLocale(code);
      notifyListeners();
    }
  }

  Future<void> setLanguage(Locale language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'defaultLanguage',
      LanguageModel.localeToString(language),
    );
    selectedLanguage = language;
    notifyListeners();
  }

  String getCurrentLanguageName() {
    final match = languages.firstWhere(
      (lang) => lang.code.languageCode == selectedLanguage.languageCode,
      orElse: () => languages.first,
    );
    return match.name;
  }

  String getCurrentLanguageTitle() {
    final match = languages.firstWhere(
      (lang) => lang.code.languageCode == selectedLanguage.languageCode,
      orElse: () => languages.first,
    );
    return match.title;
  }
}

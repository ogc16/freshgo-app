import 'package:flutter/foundation.dart';

class LocaleProvider extends ChangeNotifier {
  String _locale = 'en';

  String get locale => _locale;

  static const availableLocales = ['en', 'lg', 'es', 'zh', 'fr', 'sw'];

  static const localeNames = {
    'en': 'English',
    'lg': 'Luganda',
    'es': 'Español',
    'zh': '中文',
    'fr': 'Français',
    'sw': 'Kiswahili',
  };

  void setLocale(String locale) {
    if (!availableLocales.contains(locale)) return;
    _locale = locale;
    notifyListeners();
  }
}

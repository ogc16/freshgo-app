import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  LocaleProvider() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _locale = prefs.getString('locale') ?? 'en';
    notifyListeners();
  }

  Future<void> setLocale(String locale) async {
    if (!availableLocales.contains(locale)) return;
    _locale = locale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale);
  }
}

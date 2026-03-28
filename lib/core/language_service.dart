import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppLanguage { english, kinyarwanda }

class LanguageService {
  static const _storageKey = 'app_language';

  static final ValueNotifier<AppLanguage> currentLanguage =
      ValueNotifier<AppLanguage>(AppLanguage.english);

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_storageKey) ?? 'en';
    currentLanguage.value = _parse(value);
  }

  static Future<void> setLanguage(AppLanguage language) async {
    currentLanguage.value = language;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, _serialize(language));
  }

  static AppLanguage _parse(String value) {
    switch (value) {
      case 'rw':
        return AppLanguage.kinyarwanda;
      case 'en':
      default:
        return AppLanguage.english;
    }
  }

  static String _serialize(AppLanguage language) {
    return language == AppLanguage.kinyarwanda ? 'rw' : 'en';
  }
}

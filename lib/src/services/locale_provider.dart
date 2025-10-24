import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../l10n/app_localizations.dart';

class LocaleProvider extends ChangeNotifier {
  Locale? _locale;
  static const _prefKey = 'selected_locale';

  LocaleProvider._();
  static final LocaleProvider instance = LocaleProvider._();

  Locale? get locale => _locale;

  List<Locale> get supportedLocales => S.supportedLocales;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_prefKey);
    if (code != null && code.isNotEmpty) {
      _locale = Locale(code);
    }
    notifyListeners();
  }

  Future<void> setLocale(Locale? newLocale) async {
    _locale = newLocale;
    final prefs = await SharedPreferences.getInstance();
    if (newLocale == null) {
      await prefs.remove(_prefKey);
    } else {
      await prefs.setString(_prefKey, newLocale.languageCode);
    }
    notifyListeners();
  }
}

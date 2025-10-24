import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../services/locale_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final List<Locale> _locales;
  int _currentIndex = 0;

  static const Map<String, String> _namesFallback = {
    'en': 'English',
    'fr': 'Français',
    'es': 'Español',
    'de': 'Deutsch',
  };

  @override
  void initState() {
    super.initState();
    _locales = S.supportedLocales;
    final saved = LocaleProvider.instance.locale;
    if (saved != null) {
      final idx = _locales.indexWhere((l) => l.languageCode == saved.languageCode);
      _currentIndex = idx >= 0 ? idx : 0;
    } else {
      _currentIndex = 0;
    }
  }

  String _displayName(Locale locale) {
    return _namesFallback[locale.languageCode] ?? locale.languageCode;
  }

  void _changeIndex(int newIndex) {
    setState(() => _currentIndex = newIndex);
    final locale = _locales[_currentIndex];
    LocaleProvider.instance.setLocale(locale);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context)!.settings),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_left),
              onPressed: () {
                final next = (_currentIndex - 1 + _locales.length) % _locales.length;
                _changeIndex(next);
              },
            ),
            const SizedBox(width: 20),
            Text(
              _displayName(_locales[_currentIndex]),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 20),
            IconButton(
              icon: const Icon(Icons.arrow_right),
              onPressed: () {
                final next = (_currentIndex + 1) % _locales.length;
                _changeIndex(next);
              },
            ),
          ],
        ),
      ),
    );
  }
}
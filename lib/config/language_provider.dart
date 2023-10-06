import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  String _selectedLanguage = 'English';

  String get selectedLanguage => _selectedLanguage;

  set selectedLanguage(String value) {
    _selectedLanguage = value;
    notifyListeners();
    _saveSelectedLanguage(value);
  }

  LanguageProvider() {
    _loadSelectedLanguage();
  }

  Future<void> _loadSelectedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedLanguage = prefs.getString('selectedLanguage') ?? 'English';
    notifyListeners();
  }

  Future<void> _saveSelectedLanguage(String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedLanguage', value);
  }
}

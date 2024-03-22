import 'package:flutter/material.dart';
import 'package:flutter_dentistry/config/language_provider.dart';
import 'package:flutter_dentistry/config/translations.dart';
import 'package:flutter_dentistry/views/patients/health_histories.dart';
import 'package:provider/provider.dart';

void main() => runApp(const NewHealthHistory());

// Set global variables which are needed later.
var selectedLanguage;
var isEnglish;

class NewHealthHistory extends StatelessWidget {
  const NewHealthHistory({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch translations keys based on the selected language.
    var languageProvider = Provider.of<LanguageProvider>(context);
    selectedLanguage = languageProvider.selectedLanguage;
    isEnglish = selectedLanguage == 'English';
    return Directionality(
      textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const BackButtonIcon()),
          title: Text(translations[selectedLanguage]?['CompHistHeading'] ?? ''),
        ),
        body: const Directionality(
          textDirection: TextDirection.rtl,
          child: HealthHistories(),
        ),
      ),
    );
  }
}

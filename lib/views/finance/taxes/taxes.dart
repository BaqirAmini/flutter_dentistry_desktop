import 'package:flutter/material.dart';
import 'package:flutter_dentistry/config/language_provider.dart';
import 'package:flutter_dentistry/config/translations.dart';
import 'package:provider/provider.dart';
import '/models/tax_data_model.dart';

void main() => runApp(const TaxList());
// ignore: prefer_typing_uninitialized_variables
var selectedLanguage;
// ignore: prefer_typing_uninitialized_variables
var isEnglish;

class TaxList extends StatelessWidget {
  const TaxList({Key? key}) : super(key: key);

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
          title: Text(translations[selectedLanguage]?['ClinicTaxes'] ?? ''),
        ),
        body: const TaxDataTable(),
      ),
    );
  }
}

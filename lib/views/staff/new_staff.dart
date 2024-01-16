import 'package:flutter/material.dart';
import 'package:flutter_dentistry/config/language_provider.dart';
import 'package:flutter_dentistry/config/translations.dart';
import 'package:provider/provider.dart';
import 'registeration.dart';

void main() {
  runApp(const NewStaff());
}

class NewStaff extends StatelessWidget {
  const NewStaff({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fetch translations keys based on the selected language.
    var languageProvider = Provider.of<LanguageProvider>(context);
    var selectedLanguage = languageProvider.selectedLanguage;
    var isEnglish = selectedLanguage == 'English';

    return Directionality(
      textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(translations[selectedLanguage]?['StaffReg'] ?? ''),
          leading: Tooltip(
            message: translations[selectedLanguage]?['GoBack'] ?? '',
            child: IconButton(
              icon: const BackButtonIcon(),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        body: const NewStaffForm(),
      ),
    );
  }
}

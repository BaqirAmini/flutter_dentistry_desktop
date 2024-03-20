import 'package:flutter/material.dart';
import 'package:flutter_dentistry/config/global_usage.dart';
import 'package:flutter_dentistry/config/language_provider.dart';
import 'package:flutter_dentistry/config/translations.dart';
import 'package:flutter_dentistry/views/main/dashboard.dart';
import 'package:provider/provider.dart';
import '/views/settings/settings_menu.dart';

void main() => runApp(const Settings());

// ignore: prefer_typing_uninitialized_variables
var selectedLanguage;
// ignore: prefer_typing_uninitialized_variables
var isEnglish;

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final GlobalUsage _globalUsage = GlobalUsage();
  int _validDays = 0;
  Future<void> _getRemainValidDays() async {
    // Get the current date and time
    DateTime now = DateTime.now();
    DateTime? expiryDate = await _globalUsage.getExpiryDate();
    if (expiryDate != null) {
      int diffInHours = expiryDate.difference(now).inHours;
      _validDays = (diffInHours / 24).floor();
    }
  }

  @override
  void initState() {
    super.initState();
    _getRemainValidDays().then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // Fetch translations keys based on the selected language.
    var languageProvider = Provider.of<LanguageProvider>(context);
    selectedLanguage = languageProvider.selectedLanguage;
    isEnglish = selectedLanguage == 'English';
    return Directionality(
      textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
      child: FutureBuilder(
        future: _getRemainValidDays(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text(translations[selectedLanguage]?['Settings'] ?? ''),
                actions: [
                  Center(
                      child: Text(
                    '${translations[selectedLanguage]?['ValidDuration'] ?? ''} $_validDays ${translations[selectedLanguage]?['Days'] ?? ''}',
                    style: Theme.of(context)
                        .primaryTextTheme
                        .labelLarge!
                        .copyWith(
                            color: const Color.fromARGB(255, 223, 230, 135)),
                  )),
                  const SizedBox(width: 30)
                ],
              ),
              body: const SettingsMenu(),
            );
          }
        },
      ),
    );
  }
}

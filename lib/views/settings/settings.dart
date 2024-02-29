import 'package:flutter/material.dart';
import 'package:flutter_dentistry/views/main/dashboard.dart';
import '/views/settings/settings_menu.dart';

void main() => runApp(const Settings());

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('تنظیمات'),
        ),
        body: const SettingsMenu(),
      ),
    );
  }
}

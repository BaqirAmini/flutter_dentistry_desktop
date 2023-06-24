import 'package:flutter/material.dart';
import '/views/settings/settings_menu.dart';

void main() => runApp(const Settings());

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            leading: Tooltip(
              message: 'رفتن به داشبورد',
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.home_outlined),
              ),
            ),
            title: const Text('تنظیمات'),
          ),
          body: const SettingsMenu(),
        ),
      ),
    );
  }
}

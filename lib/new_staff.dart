import 'package:flutter/material.dart';
import 'package:flutter_dentistry/staff.dart';
import 'views/staff/registeration.dart';

void main() {
  runApp(const NewStaff());
}

class NewStaff extends StatelessWidget {
  const NewStaff({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('ایحاد کارمند جدید'),
            leading: Tooltip(
              message: 'رفتن به صفحه قبلی',
              child: IconButton(
                icon: const BackButtonIcon(),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) => const Staff())));
                },
              ),
            ),
          ),
          body: const NewStaffForm(),
        ),
      ),
    );
  }
}


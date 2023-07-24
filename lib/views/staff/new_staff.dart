import 'package:flutter/material.dart';
import 'package:flutter_dentistry/views/staff/staff.dart';
import 'registeration.dart';

void main() {
  runApp(const NewStaff());
}

class NewStaff extends StatelessWidget {
  const NewStaff({Key? key}) : super(key: key);

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
                  Navigator.pop(context);
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

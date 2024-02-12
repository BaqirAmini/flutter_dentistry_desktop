import 'package:flutter/material.dart';
import 'package:flutter_dentistry/views/patients/health_histories.dart';

void main() => runApp(const NewHealthHistory());

class NewHealthHistory extends StatelessWidget {
  const NewHealthHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const BackButtonIcon()),
          title: const Text('Add new patient health history'),
        ),
        body: const Directionality(
          textDirection: TextDirection.rtl,
          child: HealthHistories(),
        ),
      ),
      theme: ThemeData(useMaterial3: false),
    );
  }
}

import 'package:flutter/material.dart';
import '../../main/dashboard.dart';
import '/models/tax_data_model.dart';

void main() => runApp(const TaxList());

class TaxList extends StatelessWidget {
  const TaxList({super.key});

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
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Dashboard(),
                  ),
                ),
                icon: Icon(Icons.home_outlined),
              ),
            ),
            title: const Text('مالیات کلینیک'),
          ),
          body: const TaxDataTable(),
        ),
      ),
    );
  }
}

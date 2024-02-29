import 'package:flutter/material.dart';
import '../../main/dashboard.dart';
import '/models/tax_data_model.dart';

void main() => runApp(const TaxList());

class TaxList extends StatelessWidget {
  const TaxList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('مالیات کلینیک'),
        ),
        body: const TaxDataTable(),
      ),
    );
  }
}

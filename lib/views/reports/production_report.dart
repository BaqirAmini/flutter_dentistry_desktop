import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:excel/excel.dart';
import 'package:path/path.dart';

void main() => runApp(const ProductionReport());

class ProductionReport extends StatelessWidget {
  const ProductionReport({super.key});

  void createExcel() async {
    // Create a new Excel package
    var excel = Excel.createExcel();

    // Access the 'Sheet1'
    var sheet = excel['Sheet1'];

    // Populate the sheet with sample data
    var data = <List<String>>[
      [
        'Patient ID',
        'Patient Name',
        'Procedure Code',
        'Procedure Description',
        'Procedure Date',
        'Dentist',
        'Cost'
      ],
      [
        '001',
        'John Doe',
        'PC001',
        'Tooth Extraction',
        '2024-02-18',
        'Dr. Smith',
        '\$200'
      ],
      // Add more data rows here
    ];

    for (var i = 0; i < data.length; i++) {
      var row = data[i];
      for (var j = 0; j < row.length; j++) {
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: j, rowIndex: i))
            .value = row[j].toString() as CellValue?;
      }
    }

    // Save the Excel file
    var output = await getTemporaryDirectory();
    var file = "${output.path}/example.xlsx";

    var bytes = excel.encode();
    File(file)
      ..createSync(recursive: true)
      ..writeAsBytesSync(bytes!);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Report Generator'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  final pdf = pw.Document();
                  pdf.addPage(
                    pw.Page(
                      build: (pw.Context context) => pw.Center(
                        child: pw.Text("Hello World",
                            style: const pw.TextStyle(fontSize: 40)),
                      ),
                    ),
                  );
                  final output = await getTemporaryDirectory();
                  final file = File("${output.path}/example.pdf");
                  await file.writeAsBytes(await pdf.save());
                },
                child: const Text('Generate PDF'),
              ),
              ElevatedButton(
                onPressed: createExcel,
                child: const Text('Generate Excel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

void main() => runApp(const ProductionReport());

class ProductionReport extends StatelessWidget {
  const ProductionReport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Production Report'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: DataTable(
            columns: const <DataColumn>[
              DataColumn(
                label: Text(
                  'Patient ID',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              DataColumn(
                label: Text(
                  'Patient Name',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              DataColumn(
                label: Text(
                  'Procedure Code',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              DataColumn(
                label: Text(
                  'Procedure Description',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              DataColumn(
                label: Text(
                  'Procedure Date',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              DataColumn(
                label: Text(
                  'Dentist',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              DataColumn(
                label: Text(
                  'Cost',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ],
            rows: const <DataRow>[
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('001')),
                  DataCell(Text('John Doe')),
                  DataCell(Text('PC001')),
                  DataCell(Text('Tooth Extraction')),
                  DataCell(Text('2024-02-18')),
                  DataCell(Text('Dr. Smith')),
                  DataCell(Text('\$200')),
                ],
              ),
              // Add more DataRow here for other entries
            ],
          ),
        ),
      ),
    );
  }
}

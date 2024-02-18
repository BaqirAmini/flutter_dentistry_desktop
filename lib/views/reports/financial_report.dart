import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

void main() => runApp(const FinancialSummaryReport());

class FinancialSummaryReport extends StatelessWidget {
  const FinancialSummaryReport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial Summary Report'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () async {
              await Printing.layoutPdf(
                onLayout: (PdfPageFormat format) async {
                  final pdf = pw.Document();
                  pdf.addPage(
                    pw.Page(
                      build: (context) => pw.Text("Financial Summary Report"),
                    ),
                  );
                  return pdf.save();
                },
              );
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: DataTable(
            columns: const <DataColumn>[
              DataColumn(
                label: Text(
                  'Category',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              DataColumn(
                label: Text(
                  'Description',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              DataColumn(
                label: Text(
                  'Amount',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              DataColumn(
                label: Text(
                  'Date Range',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ],
            rows: const <DataRow>[
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('Earnings')),
                  DataCell(Text('Total income from all sources')),
                  DataCell(Text('\$100,000')),
                  DataCell(Text('2024')),
                ],
              ),
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('Expenses')),
                  DataCell(Text('Total of all costs')),
                  DataCell(Text('\$60,000')),
                  DataCell(Text('2024')),
                ],
              ),
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('Taxes')),
                  DataCell(Text('Total amount of taxes paid')),
                  DataCell(Text('\$10,000')),
                  DataCell(Text('2024')),
                ],
              ),
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('Net Income')),
                  DataCell(Text('Total Earnings - Total Expenses - Taxes')),
                  DataCell(Text('\$30,000')),
                  DataCell(Text('2024')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

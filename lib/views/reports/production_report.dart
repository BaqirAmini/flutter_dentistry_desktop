import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dentistry/models/db_conn.dart';
import 'package:flutter_dentistry/views/settings/settings_menu.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path/path.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column;
import 'package:syncfusion_flutter_pdf/pdf.dart';

void main() => runApp(const ProductionReport());

class ProductionReport extends StatelessWidget {
  const ProductionReport({super.key});

  void createExcel() async {
    final conn = await onConnToDb();

    // Query data from the database.
    var results = await conn.query(
        'SELECT firstname, lastname, age, sex, marital_status, phone, pat_ID, DATE_FORMAT(reg_date, "%Y-%m-%d"), blood_group, address FROM patients ORDER BY reg_date DESC');

    // Create a new Excel document.
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];

    // Define column titles.
    var columnTitles = [
      'First Name',
      'Last Name',
      'Age',
      'Sex',
      'Marital Status',
      'Phone',
      'Patient ID',
      'Registration Date',
      'Blood Group',
      'Address'
    ];

    // Write column titles to the first row.
    for (var i = 0; i < columnTitles.length; i++) {
      sheet.getRangeByIndex(1, i + 1).setText(columnTitles[i]);
    }

    // Populate the sheet with data from the database.
    var rowIndex =
        1; // Start from the second row as the first row is used for column titles.
    for (var row in results) {
      for (var i = 0; i < row.length; i++) {
        sheet.getRangeByIndex(rowIndex + 1, i + 1).setText(row[i].toString());
      }
      rowIndex++;
    }

    // Save the Excel file.
    final List<int> bytes = workbook.saveAsStream();

    // Get the directory to save the Excel file.
    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = directory.path;
    final File file = File('$path/Output.xlsx');

    // Write the Excel file.
    await file.writeAsBytes(bytes, flush: true);

    // Open the file
    await OpenFile.open(file.path);

    // Close the database connection.
    await conn.close();
  }

  void createPdf() async {
    try {
      // Create a new PDF document.
      final PdfDocument document = PdfDocument();

      // Create a new page in the document.
      final PdfPage page = document.pages.add();

      // Create a new PDF grid.
      final PdfGrid grid = PdfGrid();

      // Set the text direction for Persian text.
      final PdfStringFormat format = PdfStringFormat();
      format.textDirection = PdfTextDirection.rightToLeft;
      format.alignment = PdfTextAlignment.right;

      final conn = await onConnToDb();

      // Query data from the database.
      var results =
          await conn.query('SELECT firstname, lastname FROM patients');
      final ByteData fontData =
          (await rootBundle.load('assets/fonts/per_sans_font.ttf'));
      final PdfTrueTypeFont ttfFont =
          PdfTrueTypeFont(fontData.buffer.asUint8List(), 12);

      // Define column titles.
      var columnTitles = ['First Name', 'Last Name'];

      // Add a row for the column titles.
      final PdfGridRow titleRow = grid.rows.add();
      for (var i = 0; i < columnTitles.length; i++) {
        titleRow.cells[i].value = columnTitles[i];
        titleRow.cells[i].style = PdfGridCellStyle(font: ttfFont);
      }

      // Populate the grid with data from the database.
      for (final row in results) {
        final PdfGridRow pdfRow = grid.rows.add();
        for (var i = 0; i < row.length; i++) {
          pdfRow.cells[i].value = row[i].toString();
          pdfRow.cells[i].style = PdfGridCellStyle(font: ttfFont);
        }
      }

      // Draw the grid on the page.
      grid.draw(
        page: page,
        bounds: Rect.fromLTWH(
            0, 0, page.getClientSize().width, page.getClientSize().height),
      );

      // Save the PDF file.
      final List<int> bytes = await document.save();

      // Get the directory to save the PDF file.
      final Directory directory = await getApplicationDocumentsDirectory();
      final String path = directory.path;
      final File file = File('$path/Output.pdf');

      // Write the PDF file.
      await file.writeAsBytes(bytes, flush: true);

      // Open the file
      await OpenFile.open(file.path);

      // Close the database connection.
      await conn.close();
    } catch (e) {
      print('Error with PDF: $e');
    }
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
                onPressed: createPdf,
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

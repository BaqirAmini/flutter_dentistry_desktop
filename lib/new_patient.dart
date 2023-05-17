import 'package:flutter/material.dart';
import 'models/patient_data_model.dart';

void main() {
  return runApp(const NewPatient());
}

class NewPatient extends StatefulWidget {
  const NewPatient({ super.key });

  @override
  _NewPatientState createState() => _NewPatientState();

}

class _NewPatientState extends State<NewPatient> {
  var tableRow = TableRow();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('افزودن بیمار'),
          ),
          body: Container(
            width: double.infinity,
            child: SingleChildScrollView(
              child: PaginatedDataTable(
                source: tableRow,
                header: const Text('بیماران'),
                onRowsPerPageChanged: (perPage) {},
                rowsPerPage: 10,
                columns: [
                  DataColumn(
                      label: const Text('اسم'),
                      onSort: (columnIndex, ascending) {
                        print('$columnIndex $ascending');
                      }
                  ),
                  const DataColumn(label: Text('تخلص')),
                  const DataColumn(label: Text('سن')),
                  const DataColumn(label: Text('وظیفه')),
                  const DataColumn(label: Text('خدمات')),
                  const DataColumn(label: Text('شرح')),
                  const DataColumn(label: Text('حذف')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TableRow extends DataTableSource {
  @override
  DataRow? getRow(int index) {
    return DataRow.byIndex(index: index, cells: [
      const DataCell(Text("احمد")),
      const DataCell(Text("احمدی")),
      const DataCell(Text("25")),
      const DataCell(Text("دکاندار")),
      const DataCell(Text("پرکاری دندان")),
      DataCell( IconButton(onPressed: (){ print('Detail...'); }, icon: const Icon(Icons.list))),
      DataCell( IconButton(onPressed: (){ print('Deleted...'); }, icon: const Icon(Icons.delete, color: Colors.red,))),
    ]);
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => true;

  @override
  // TODO: implement rowCount
  int get rowCount => 50;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;

}

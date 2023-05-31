import 'package:flutter/material.dart';
import 'package:flutter_dentistry/new_patient.dart';
import 'models/patient_data_model.dart';
import 'dashboard.dart';

void main() {
  return runApp(const Patient());
}

class Patient extends StatefulWidget {
  const Patient({super.key});

  @override
  _PatientState createState() => _PatientState();
}

class _PatientState extends State<Patient> {
  var tableRow = TableRow();
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            leading: Tooltip(
              message: 'رفتن به صفحه قبلی',
              child: IconButton(
                icon: const BackButtonIcon(),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Dashboard()));
                },
              ),
            ),
            title: const Text('افزودن مریض'),
          ),
          body: SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              child: PaginatedDataTable(
                sortAscending: _sortAscending,
                sortColumnIndex: _sortColumnIndex,
                source: tableRow,
                header: Expanded(
                  child: Row(
                    children: [
                      const Flexible(
                        child: Text('لست مریض ها |'),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 50.0),
                        // height: 100,
                        width: 300,
                        child: TextField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'جستجو...',
                            suffixIcon: Icon(Icons.search),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50.0)),
                                borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50.0)),
                                borderSide: BorderSide(color: Colors.blue)),
                          ),
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 50.0),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.print),
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.only(right: 350.0),
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const NewPatient()));
                              },
                              child: SizedBox(
                                height: 35.0,
                                child: Row(
                                  children: const [
                                    Icon(Icons.person_add_alt),
                                    Text('  '),
                                    Text('افزودن مریض جدید')
                                  ],
                                ),
                              ))),
                    ],
                  ),
                ),
                onRowsPerPageChanged: (perPage) {},
                rowsPerPage: 10,
                columns: [
                  DataColumn(
                      label: const Text('اسم'),
                      onSort: (columnIndex, ascending) {
                        setState(() {
                          _sortColumnIndex = columnIndex;
                          _sortAscending = ascending;
                        });
                      }),
                  DataColumn(
                      label: const Text('تخلص'),
                      onSort: (columnIndex, ascending) {
                        setState(() {
                          _sortColumnIndex = columnIndex;
                          _sortAscending = ascending;
                        });
                      }),
                  DataColumn(
                      label: const Text('سن'),
                      onSort: (columnIndex, ascending) {
                        setState(() {
                          _sortColumnIndex = columnIndex;
                          _sortAscending = ascending;
                        });
                      }),
                  const DataColumn(label: Text('وظیفه')),
                  DataColumn(
                      label: const Text('خدمات'),
                      onSort: (columnIndex, ascending) {
                        setState(() {
                          _sortColumnIndex = columnIndex;
                          _sortAscending = ascending;
                        });
                      }),
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
      DataCell(IconButton(
          onPressed: () {
            print('Detail...');
          },
          icon: const Icon(Icons.list))),
      DataCell(Builder(
        builder: (context) => IconButton(
            onPressed: () {
              onDeletePatient(context);
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            )),
      )),
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

// This is to display an alert dialog to delete a patient
onDeletePatient(BuildContext context) {
  return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
            title: const Text('حذف بیمار'),
            content: const Text('آیا میخواهید این بیمار را حذف کنید؟'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('لغو')),
              TextButton(onPressed: () {}, child: const Text('حذف')),
            ],
          ));
}

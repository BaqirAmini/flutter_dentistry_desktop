import 'package:flutter/material.dart';
import 'models/patient_data_model.dart';

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
          body: SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              child: PaginatedDataTable(
                actions: const [],
                source: tableRow,
                header: Row(
                  children: [
                    const Flexible(
                      child: Text('لست بیماران |'),
                      flex: 1,
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
                        margin: const EdgeInsets.only(right: 300.0),
                        child: ElevatedButton(
                            onPressed: () {},
                            child: SizedBox(
                              height: 35.0,
                              width: 135.0,
                              child: Row(
                                children: const [
                                  Icon(Icons.person_add_alt),
                                  Text('  '),
                                  Text('افزودن بیمار جدید')
                                ],
                              ),
                            ))),
                  ],
                ),
                onRowsPerPageChanged: (perPage) {},
                rowsPerPage: 10,
                columns: [
                  DataColumn(
                      label: const Text('اسم'),
                      onSort: (columnIndex, ascending) {
                        print('$columnIndex $ascending');
                      }),
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
      DataCell(IconButton(
          onPressed: () {
            print('Detail...');
          },
          icon: const Icon(Icons.list))),
      DataCell(
        Builder(builder: (context) => IconButton(
              onPressed: () {
                onDeletePatient(context);
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              )),)
      ),
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


onDeletePatient(BuildContext context)
{
  return showDialog(context: context, builder: (ctx) => AlertDialog(
    title: const Text('حذف بیمار'),
    content: const Text('آیا میخواهید این بیمار را حذف کنید؟'),
    actions: [
      TextButton(onPressed: () => Navigator.pop(context), child: const Text('لفو')),
      TextButton(onPressed: () {}, child: const Text('حذف')),
    ],
  ));
}
import 'package:flutter/material.dart';
import 'package:flutter_dentistry/models/db_conn.dart';
import 'package:flutter_dentistry/views/patients/new_patient.dart';
import 'package:flutter_dentistry/views/patients/patient_detail.dart';
import 'package:flutter_dentistry/views/main/dashboard.dart';

void main() {
  return runApp(const Patient());
}

class Patient extends StatefulWidget {
  const Patient({super.key});

  @override
  _PatientState createState() => _PatientState();
}

class _PatientState extends State<Patient> {
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
                  icon: const Icon(Icons.home_outlined),
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
            body: const PatientDataTable()),
      ),
    );
  }
}

// This is to display an alert dialog to delete a patient
onDeletePatient(BuildContext context) {
  return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
            title: const Directionality(
              textDirection: TextDirection.rtl,
              child: Text('حذف مریض'),
            ),
            content: const Directionality(
              textDirection: TextDirection.rtl,
              child: Text('آیا میخواهید این مریض را حذف کنید؟'),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('لغو')),
              TextButton(onPressed: () {}, child: const Text('حذف')),
            ],
          ));
}

// Data table widget is here
class PatientDataTable extends StatefulWidget {
  const PatientDataTable({super.key});

  @override
  _PatientDataTableState createState() => _PatientDataTableState();
}

class _PatientDataTableState extends State<PatientDataTable> {
  int _sortColumnIndex = 0;
  bool _sortAscending = true;
// The filtered data source
  List<PatientData> _filteredData = [];

  List<PatientData> _data = [];

  Future<void> _fetchData() async {
    final conn = await onConnToDb();
    final queryResult =
        await conn.query('SELECT firstname, lastname, age, sex FROM patients');
    conn.close();

    _data = queryResult.map((row) {
      return PatientData(
        firstName: row[0],
        lastName: row[1],
        age: row[2].toString(),
        sex: row[3],
        patientDetail: const Icon(Icons.list),
        deletePatient: const Icon(Icons.delete),
      );
    }).toList();
    _filteredData = List.from(_data);

    // Notify the framework that the state of the widget has changed
    setState(() {});
    // Print the data that was fetched from the database
    print('Data from database: $_data');
  }
// The text editing controller for the search TextField
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
// Set the filtered data to the original data at first
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchData());
  }

  @override
  Widget build(BuildContext context) {
    // Create a new instance of the PatientDataSource class and pass it the _filteredData list
    final dataSource = PatientDataSource(_filteredData);

    return Scaffold(
        body: ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 400.0,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'جستجو...',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _filteredData = _data;
                        });
                      },
                    ),
                    enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        borderSide: BorderSide(color: Colors.blue)),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _filteredData = _data
                          .where((element) => element.firstName
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                          .toList();
                    });
                  },
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.print),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NewPatient()));
                },
                child: const Text('افزودن مریض جدید'),
              ),
            ],
          ),
        ),
        if (_filteredData.isEmpty)
           Container(
            width: 200,
            height: 200,
            child: const Center(child: Text('هیچ مریضی یافت نشد.')),
          )
        else
          PaginatedDataTable(
            sortAscending: _sortAscending,
            sortColumnIndex: _sortColumnIndex,
            header: const Text("همه مریض ها |"),
            columns: [
              DataColumn(
                label: const Text(
                  "اسم",
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
                onSort: (columnIndex, ascending) {
                  setState(() {
                    _sortColumnIndex = columnIndex;
                    _sortAscending = ascending;
                    _filteredData
                        .sort((a, b) => a.firstName.compareTo(b.firstName));
                    if (!ascending) {
                      _filteredData = _filteredData.reversed.toList();
                    }
                  });
                },
              ),
              DataColumn(
                label: const Text(
                  "تخلص",
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
                onSort: (columnIndex, ascending) {
                  setState(() {
                    _sortColumnIndex = columnIndex;
                    _sortAscending = ascending;
                    _filteredData
                        .sort(((a, b) => a.lastName.compareTo(b.lastName)));
                    if (!ascending) {
                      _filteredData = _filteredData.reversed.toList();
                    }
                  });
                },
              ),
              DataColumn(
                label: const Text(
                  "سن",
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
                onSort: (columnIndex, ascending) {
                  setState(() {
                    _sortColumnIndex = columnIndex;
                    _sortAscending = ascending;
                    _filteredData.sort(((a, b) => a.age.compareTo(b.age)));
                    if (!ascending) {
                      _filteredData = _filteredData.reversed.toList();
                    }
                  });
                },
              ),
              DataColumn(
                label: const Text(
                  "وظیفه",
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
                onSort: (columnIndex, ascending) {
                  setState(() {
                    _sortColumnIndex = columnIndex;
                    _sortAscending = ascending;
                    _filteredData.sort(((a, b) => a.sex.compareTo(b.sex)));
                    if (!ascending) {
                      _filteredData = _filteredData.reversed.toList();
                    }
                  });
                },
              ),
              /* DataColumn(
              label: const Text(
                "خدمات مورد نیاز",
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
              onSort: (columnIndex, ascending) {
                setState(() {
                  _sortColumnIndex = columnIndex;
                  _sortAscending = ascending;
                  _filteredData
                      .sort(((a, b) => a.service.compareTo(b.service)));
                  if (!ascending) {
                    _filteredData = _filteredData.reversed.toList();
                  }
                });
              },
            ),
 */
              const DataColumn(
                  label: Text("شرح",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold))),
              const DataColumn(
                  label: Text("حذف",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold))),
            ],
            source: dataSource,
            rowsPerPage: _filteredData.length < 8 ? _filteredData.length : 8,
          )
      ],
    ));
  }
}

class PatientDataSource extends DataTableSource {
  List<PatientData> data;
  PatientDataSource(this.data);

  void sort(Comparator<PatientData> compare, bool ascending) {
    data.sort(compare);
    if (!ascending) {
      data = data.reversed.toList();
    }
    notifyListeners();
  }

  @override
  DataRow getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(data[index].firstName)),
      DataCell(Text(data[index].lastName)),
      DataCell(Text(data[index].age)),
      DataCell(Text(data[index].sex)),
      // DataCell(Text(data[index].service)),
      DataCell(
        Builder(builder: (BuildContext context) {
          return IconButton(
            icon: data[index].patientDetail,
            onPressed: (() {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => const PatientDetail())));
            }),
            color: Colors.blue,
            iconSize: 20.0,
          );
        }),
      ),
      DataCell(
        Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: data[index].deletePatient,
              onPressed: (() {
                onDeletePatient(context);
              }),
              color: Colors.blue,
              iconSize: 20.0,
            );
          },
        ),
      ),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}

class PatientData {
  final String firstName;
  final String lastName;
  final String age;
  final String sex;
  // final String service;
  final Icon patientDetail;
  final Icon deletePatient;

  PatientData(
      {required this.firstName,
      required this.lastName,
      required this.age,
      required this.sex,
      /* this.service, */
      required this.patientDetail,
      required this.deletePatient});
}

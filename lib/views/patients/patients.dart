import 'package:flutter/material.dart';
import 'package:flutter_dentistry/models/db_conn.dart';
import 'package:flutter_dentistry/views/patients/new_patient.dart';
import 'package:flutter_dentistry/views/patients/patient_detail.dart';
import 'package:flutter_dentistry/views/main/dashboard.dart';
import 'patient_info.dart';

void main() {
  return runApp(const Patient());
}

// Create the global key at the top level of your Dart file
final GlobalKey<ScaffoldMessengerState> _globalKeyPDelete =
    GlobalKey<ScaffoldMessengerState>();

// This is shows snackbar when called
void _onShowSnack(Color backColor, String msg) {
  _globalKeyPDelete.currentState?.showSnackBar(
    SnackBar(
      backgroundColor: backColor,
      content: SizedBox(
        height: 20.0,
        child: Center(
          child: Text(msg),
        ),
      ),
    ),
  );
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
      home: ScaffoldMessenger(
        key: _globalKeyPDelete,
        child: Scaffold(
          body: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
                appBar: AppBar(
                  leading: Tooltip(
                    message: 'رفتن به داشبورد',
                    child: IconButton(
                      icon: const Icon(Icons.home_outlined),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  title: const Text('افزودن مریض'),
                ),
                body: const PatientDataTable()),
          ),
        ),
      ),
    );
  }
}

// This is to display an alert dialog to delete a patient
onDeletePatient(BuildContext context, Function onDelete) {
  int? patientId = PatientInfo.patID;
  String? fName = PatientInfo.firstName;
  String? lName = PatientInfo.lastName;

  return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
            title: const Directionality(
              textDirection: TextDirection.rtl,
              child: Text('حذف مریض'),
            ),
            content: Directionality(
              textDirection: TextDirection.rtl,
              child: Text('آیا میخواهید $fName $lName را حذف کنید؟'),
            ),
            actions: [
              TextButton(
                  onPressed: () =>
                      Navigator.of(context, rootNavigator: true).pop(),
                  child: const Text('لغو')),
              TextButton(
                  onPressed: () async {
                    final conn = await onConnToDb();
                    final results = await conn.query(
                        'DELETE FROM patients WHERE pat_ID = ?', [patientId]);
                    if (results.affectedRows! > 0) {
                      _onShowSnack(Colors.green, 'مریض موفقانه حذف شد.');
                      onDelete();
                    } else {
                      _onShowSnack(Colors.red, 'متاسفم، مریض حذف نشد.');
                    }
                    await conn.close();
                    // ignore: use_build_context_synchronously
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  child: const Text('حذف')),
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
    final queryResult = await conn.query(
        'SELECT firstname, lastname, age, sex, marital_status, phone, pat_ID, DATE_FORMAT(reg_date, "%Y-%m-%d"), blood_group, address FROM patients');
    conn.close();

    _data = queryResult.map((row) {
      return PatientData(
        firstName: row[0],
        lastName: row[1],
        age: row[2].toString(),
        sex: row[3],
        maritalStatus: row[4],
        phone: row[5],
        patID: row[6],
        regDate: row[7].toString(),
        bloodGroup: row[8],
        address: row[9],
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
    final dataSource = PatientDataSource(_filteredData, _fetchData);

    return Scaffold(
        body: Column(
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
        Expanded(
          child: ListView(
            children: [
              if (_filteredData.isEmpty)
                const SizedBox(
                  width: 200,
                  height: 200,
                  child: Center(child: Text('هیچ مریضی یافت نشد.')),
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
                          _filteredData.sort(
                              (a, b) => a.firstName.compareTo(b.firstName));
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
                          _filteredData.sort(
                              ((a, b) => a.lastName.compareTo(b.lastName)));
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
                          _filteredData
                              .sort(((a, b) => a.age.compareTo(b.age)));
                          if (!ascending) {
                            _filteredData = _filteredData.reversed.toList();
                          }
                        });
                      },
                    ),
                    DataColumn(
                      label: const Text(
                        "جنسیت",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                      onSort: (columnIndex, ascending) {
                        setState(() {
                          _sortColumnIndex = columnIndex;
                          _sortAscending = ascending;
                          _filteredData
                              .sort(((a, b) => a.sex.compareTo(b.sex)));
                          if (!ascending) {
                            _filteredData = _filteredData.reversed.toList();
                          }
                        });
                      },
                    ),
                    DataColumn(
                      label: const Text(
                        "حالت تاهل",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                      onSort: (columnIndex, ascending) {
                        setState(() {
                          _sortColumnIndex = columnIndex;
                          _sortAscending = ascending;
                          _filteredData.sort(((a, b) =>
                              a.maritalStatus.compareTo(b.maritalStatus)));
                          if (!ascending) {
                            _filteredData = _filteredData.reversed.toList();
                          }
                        });
                      },
                    ),
                    DataColumn(
                      label: const Text(
                        "نمبر تماس",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                      onSort: (columnIndex, ascending) {
                        setState(() {
                          _sortColumnIndex = columnIndex;
                          _sortAscending = ascending;
                          _filteredData
                              .sort(((a, b) => a.phone.compareTo(b.phone)));
                          if (!ascending) {
                            _filteredData = _filteredData.reversed.toList();
                          }
                        });
                      },
                    ),
                    const DataColumn(
                        label: Text("شرح",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold))),
                    const DataColumn(
                        label: Text("حذف",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold))),
                  ],
                  source: dataSource,
                  rowsPerPage:
                      _filteredData.length < 8 ? _filteredData.length : 8,
                )
            ],
          ),
        ),
      ],
    ));
  }
}

class PatientDataSource extends DataTableSource {
  List<PatientData> data;
  Function onDelete;
  PatientDataSource(this.data, this.onDelete);

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
      DataCell(Text(data[index].maritalStatus)),
      DataCell(Text(data[index].phone)),
      // DataCell(Text(data[index].service)),
      DataCell(
        Builder(builder: (BuildContext context) {
          return IconButton(
            icon: data[index].patientDetail,
            onPressed: (() {
              PatientInfo.patID = data[index].patID;
              PatientInfo.firstName = data[index].firstName;
              PatientInfo.lastName = data[index].lastName;
              PatientInfo.phone = data[index].phone;
              PatientInfo.sex = data[index].sex;
              PatientInfo.age = int.parse(data[index].age);
              PatientInfo.regDate = data[index].regDate;
              PatientInfo.bloodGroup = data[index].bloodGroup;
              PatientInfo.address = data[index].address;
              PatientInfo.maritalStatus = data[index].maritalStatus;
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
                PatientInfo.patID = data[index].patID;
                PatientInfo.firstName = data[index].firstName;
                PatientInfo.lastName = data[index].lastName;
                onDeletePatient(context, onDelete);
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
  final String maritalStatus;
  final String phone;
  final int patID;
  final String regDate;
  final String bloodGroup;
  final String address;
  // final String service;
  final Icon patientDetail;
  final Icon deletePatient;

  PatientData({
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.sex,
    required this.maritalStatus,
    required this.phone,
    required this.patID,
    required this.regDate,
    required this.bloodGroup,
    required this.address,
    /* this.service, */
    required this.patientDetail,
    required this.deletePatient,
  });
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dentistry/models/db_conn.dart';
import 'package:flutter_dentistry/views/staff/new_staff.dart';
import 'package:galileo_mysql/galileo_mysql.dart';
import 'staff_info.dart';

// Create the global key at the top level of your Dart file
final GlobalKey<ScaffoldMessengerState> _globalKey3 =
    GlobalKey<ScaffoldMessengerState>();

// This is shows snackbar when called
void _onShowSnack(Color backColor, String msg) {
  _globalKey3.currentState?.showSnackBar(
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

void main() {
  return runApp(const Staff());
}

class Staff extends StatelessWidget {
  const Staff({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ScaffoldMessenger(
        key: _globalKey3,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              leading: Tooltip(
                message: 'رفتن به داشبورد',
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.home_outlined),
                ),
              ),
              title: const Text('کارمندان'),
            ),
            body: const MyDataTable(),
          ),
        ),
      ),
    );
  }
}

// Data table widget is here
class MyDataTable extends StatefulWidget {
  const MyDataTable({super.key});

  @override
  _MyDataTableState createState() => _MyDataTableState();
}

class _MyDataTableState extends State<MyDataTable> {
  int _sortColumnIndex = 0;
  bool _sortAscending = true;
// The filtered data source
  List<MyStaff> _filteredData = [];

  List<MyStaff> _data = [];

  Future<void> _fetchData() async {
    final conn = await onConnToDb();
    final queryResult = await conn.query(
        'SELECT photo, firstname, lastname, position, salary, phone, tazkira_ID, address, staff_ID FROM staff');
    conn.close();

    _data = queryResult.map((row) {
      return MyStaff(
        photo: row[0],
        firstName: row[1],
        lastName: row[2],
        position: row[3],
        salary: row[4],
        phone: row[5],
        tazkira: row[6],
        address: row[7],
        staffID: row[8],
      );
    }).toList();
    _filteredData = List.from(_data);

    // Notify the framework that the state of the widget has changed
    setState(() {
      // Print the data that was fetched from the database
      print('Data from database: $_data');
    });
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    // Create a new instance of the PatientDataSource class and pass it the _filteredData list
    // final dataSource = MyData(_filteredData);
    final dataSource = MyData(_filteredData, _fetchData, _fetchData);

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
                          _filteredData = List.from(_data);
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
              if (StaffInfo.staffRole == 'مدیر سیستم')
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NewStaff()));
                  },
                  child: const Text('افزودن کارمند جدید'),
                ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              if (_filteredData.isEmpty)
                Container(
                  width: 200,
                  height: 200,
                  child: const Center(
                    child: Text('هیچ کارمندی یافت نشد.'),
                  ),
                )
              else
                PaginatedDataTable(
                  source: dataSource,
                  header: const Text("همه کارمندان |"),
                  sortColumnIndex: _sortColumnIndex,
                  sortAscending: _sortAscending,
                  columns: [
                    const DataColumn(
                        label: Text(
                          "عکس",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                        numeric: true),
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
                          _filteredData
                              .sort((a, b) => a.lastName.compareTo(b.lastName));
                          if (!ascending) {
                            _filteredData = _filteredData.reversed.toList();
                          }
                        });
                      },
                    ),
                    DataColumn(
                      label: const Text(
                        "مقام",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                      onSort: (columnIndex, ascending) {
                        setState(() {
                          _sortColumnIndex = columnIndex;
                          _sortAscending = ascending;
                          _filteredData
                              .sort((a, b) => a.position.compareTo(b.position));
                          if (!ascending) {
                            _filteredData = _filteredData.reversed.toList();
                          }
                        });
                      },
                    ),
                    DataColumn(
                      label: const Text(
                        "مقدار معاش",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                      onSort: (columnIndex, ascending) {
                        setState(() {
                          _sortColumnIndex = columnIndex;
                          _sortAscending = ascending;
                          _filteredData
                              .sort((a, b) => a.salary.compareTo(b.salary));
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
                              .sort((a, b) => a.phone.compareTo(b.phone));
                          if (!ascending) {
                            _filteredData = _filteredData.reversed.toList();
                          }
                        });
                      },
                    ),
                    DataColumn(
                      label: const Text(
                        "نمبر تذکره",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                      onSort: (columnIndex, ascending) {
                        setState(() {
                          _sortColumnIndex = columnIndex;
                          _sortAscending = ascending;
                          _filteredData
                              .sort((a, b) => a.tazkira.compareTo(b.tazkira));
                          if (!ascending) {
                            _filteredData = _filteredData.reversed.toList();
                          }
                        });
                      },
                    ),
                    DataColumn(
                      label: const Text(
                        "آدرس",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                      onSort: (columnIndex, ascending) {
                        setState(() {
                          _sortColumnIndex = columnIndex;
                          _sortAscending = ascending;
                          _filteredData
                              .sort((a, b) => a.address.compareTo(b.address));
                          if (!ascending) {
                            _filteredData = _filteredData.reversed.toList();
                          }
                        });
                      },
                    ),
                    // This condition only allows 'system admin' to edit/delete... the staff
                    if (StaffInfo.staffRole == 'مدیر سیستم')
                      const DataColumn(
                        label: Text(
                          "اقدامات",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
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

class MyData extends DataTableSource {
  List<MyStaff> data;
  // This two instance variable of type Function are for refreshing after update and delete
  Function onUpdate;
  Function onDelete;
  MyData(this.data, this.onUpdate, this.onDelete);

  void sort(Comparator<MyStaff> compare, bool ascending) {
    data.sort(compare);
    if (!ascending) {
      data = data.reversed.toList();
    }
    notifyListeners();
  }

  @override
  DataRow getRow(int index) {
    return DataRow(cells: [
      const DataCell(
        CircleAvatar(
          backgroundImage: AssetImage('assets/graphics/patient.png'),
        ),
      ),
      DataCell(Text(data[index].firstName)),
      DataCell(Text(data[index].lastName)),
      DataCell(Text(data[index].position)),
      DataCell(
        Text('${data[index].salary} افغانی'),
      ),
      DataCell(Text(data[index].phone)),
      DataCell(Text(data[index].tazkira)),
      DataCell(Text(data[index].address)),
      // This condition only allows 'system admin' to edit/delete... the staff
      if (StaffInfo.staffRole == 'مدیر سیستم')
        DataCell(
          PopupMenuButton(
            padding: EdgeInsets.zero,
            icon: const Icon(
              Icons.more_horiz,
              color: Colors.blue,
            ),
            tooltip: 'نمایش مینو',
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              PopupMenuItem(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: ListTile(
                    leading: const Icon(
                      Icons.list,
                      size: 20.0,
                    ),
                    title: const Text(
                      'جزییات',
                      style: TextStyle(fontSize: 15.0),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              PopupMenuItem(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Builder(builder: (BuildContext context) {
                    return ListTile(
                      leading: const Icon(
                        Icons.lock_person_outlined,
                        size: 20.0,
                      ),
                      title: const Text(
                        'حساب کاربری',
                        style: TextStyle(fontSize: 15.0),
                      ),
                      onTap: () async {
                        int staffId = data[index].staffID;
                        Navigator.pop(context);
                        var conn = await onConnToDb();
                        var results = await conn.query(
                            'SELECT username, password, role FROM staff_auth WHERE staff_ID = ?',
                            [staffId]);

                        if (results.isNotEmpty) {
                          final row = results.first;
                          final userName = row['username'];
                          final role = row['role'];
                          // ignore: use_build_context_synchronously
                          onUpdateUserAccount(context, staffId, userName, role);
                        } else {
                          // ignore: use_build_context_synchronously
                          onCreateUserAccount(context, staffId);
                        }
                      },
                    );
                  }),
                ),
              ),
              PopupMenuItem(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Builder(builder: (BuildContext context) {
                    return ListTile(
                      leading: const Icon(
                        Icons.edit,
                        size: 20.0,
                      ),
                      title: const Text(
                        'تغییر دادن',
                        style: TextStyle(fontSize: 15.0),
                      ),
                      onTap: () async {
                        int staffId = data[index].staffID;
                        final conn = await onConnToDb();
                        final results = await conn.query(
                            'SELECT * FROM staff WHERE staff_ID = ?',
                            [staffId]);
                        final staffRow = results.first;
                        String firstName = staffRow['firstname'];
                        String lastName = staffRow['lastname'];
                        String position = staffRow['position'];
                        double salary = staffRow['salary'];
                        String phone = staffRow['phone'];
                        String tazkira = staffRow['tazkira_ID'];
                        String address = staffRow['address'];
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                        // ignore: use_build_context_synchronously
                        onEditStaff(
                            context,
                            staffId,
                            firstName,
                            lastName,
                            position,
                            salary,
                            phone,
                            tazkira,
                            address,
                            onUpdate);
                      },
                    );
                  }),
                ),
              ),
              PopupMenuItem(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: ListTile(
                    leading: const Icon(
                      Icons.delete,
                      size: 20.0,
                    ),
                    title: const Text(
                      'حذف کردن',
                      style: TextStyle(fontSize: 15.0),
                    ),
                    onTap: () async {
                      int staffID = data[index].staffID;
                      final conn = await onConnToDb();
                      final results = await conn.query(
                          'SELECT * FROM staff WHERE staff_ID = ?', [staffID]);
                      final row = results.first;
                      String firstName = row['firstname'];
                      String lastName = row['lastname'];
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                      // ignore: use_build_context_synchronously
                      onDeleteStaff(
                          context, staffID, firstName, lastName, onDelete);
                    },
                  ),
                ),
              ),
            ],
            onSelected: null,
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

// This is to display an alert dialog to delete a patient
onDeleteStaff(BuildContext context, int staffId, String firstName,
    String lastName, Function onDelete) {
  return showDialog(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return AlertDialog(
          title: const Directionality(
            textDirection: TextDirection.rtl,
            child: Text('حذف کارمند'),
          ),
          content: Directionality(
            textDirection: TextDirection.rtl,
            child: Text('آیا میخواهید $firstName $lastName را حذف کنید؟'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
              child: const Text('لغو'),
            ),
            TextButton(
              onPressed: () async {
                final conn = await onConnToDb();
                final deleteResult = await conn
                    .query('DELETE FROM staff WHERE staff_ID = ?', [staffId]);
                if (deleteResult.affectedRows! > 0) {
                  _onShowSnack(Colors.green, 'کارمند موفقانه حذف شد.');
                  onDelete();
                }
                await conn.close();
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: const Text('حذف'),
            ),
          ],
        );
      },
    ),
  );
}

// This dialog edits a stafflastNameController
onEditStaff(
    BuildContext context,
    int staffID,
    String firstname,
    String lastname,
    String position,
    double salary,
    String phoneNum,
    String tazkira,
    String address,
    Function onUpdate) {
  // position types dropdown variables
  String positionDropDown = 'داکتر دندان';
  var positionItems = [
    'داکتر دندان',
    'نرس',
    'مدیر سیستم',
  ];
// The global for the form
  final formKey1 = GlobalKey<FormState>();
// The text editing controllers for the TextFormFields
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final salaryController = TextEditingController();
  final tazkiraController = TextEditingController();
  final addressController = TextEditingController();

  const regExOnlyAbc = "[a-zA-Z,، \u0600-\u06FFF]";
  const regExOnlydigits = "[0-9+]";
  final tazkiraPattern = RegExp(r'^\d{4}-\d{4}-\d{5}$');

/* ------------- Set all staff related values into their fields.----------- */
  nameController.text = firstname;
  lastNameController.text = lastname;
  positionDropDown = position;
  salaryController.text = salary.toString();
  phoneController.text = phoneNum;
  tazkiraController.text = tazkira;
  addressController.text = address;
/* ------------- END Set all staff related values into their fields.----------- */
  return showDialog(
    context: context,
    builder: ((context) {
      return StatefulBuilder(
        builder: ((context, setState) {
          return AlertDialog(
            title: Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                'تغییر مشخصات $firstname $lastname',
                style: const TextStyle(color: Colors.blue),
              ),
            ),
            content: Directionality(
              textDirection: TextDirection.rtl,
              child: Form(
                key: formKey1,
                child: SizedBox(
                  width: 500.0,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 20.0),
                        ),
                        Container(
                          margin: const EdgeInsets.all(20.0),
                          child: TextFormField(
                            controller: nameController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'نام الزامی است.';
                              } else if (value.length < 3) {
                                return 'نام باید حداقل 3 حرف باشد.';
                              }
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'نام',
                              suffixIcon: Icon(Icons.person_add_alt_outlined),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.blue)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.red)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(
                                      color: Colors.red, width: 1.5)),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(20.0),
                          child: TextFormField(
                            controller: lastNameController,
                            validator: (value) {
                              if (value!.isNotEmpty) {
                                if (value.length < 3 || value.length > 10) {
                                  return 'تخلص باید از سه الی ده حرف باشد.';
                                } else {
                                  return null;
                                }
                              } else {
                                return null;
                              }
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'تخلص',
                              suffixIcon: Icon(Icons.person),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.blue)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.red)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(
                                      color: Colors.red, width: 1.5)),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(20.0),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'عنوان وظیفه',
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.blue)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.red)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(
                                      color: Colors.red, width: 1.5)),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: Container(
                                height: 26.0,
                                child: DropdownButton(
                                  isExpanded: true,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  value: positionDropDown,
                                  items:
                                      positionItems.map((String positionItems) {
                                    return DropdownMenuItem(
                                      value: positionItems,
                                      alignment: Alignment.centerRight,
                                      child: Text(positionItems),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      positionDropDown = newValue!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(20.0),
                          child: TextFormField(
                            textDirection: TextDirection.ltr,
                            controller: phoneController,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(regExOnlydigits),
                              ),
                            ],
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'نمبر تماس الزامی است.';
                              } else if (value.startsWith('07')) {
                                if (value.length < 10 || value.length > 10) {
                                  return 'نمبر تماس باید 10 عدد باشد.';
                                }
                              } else if (value.startsWith('+93')) {
                                if (value.length < 12 || value.length > 12) {
                                  return 'نمبر تماس  همراه با کود کشور باید 12 عدد باشد.';
                                }
                              } else {
                                return 'نمبر تماس نا معتبر است.';
                              }
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'نمبر تماس',
                              suffixIcon: Icon(Icons.phone),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.blue)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.red)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(
                                      color: Colors.red, width: 1.5)),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(20.0),
                          child: TextFormField(
                            controller: salaryController,
                            validator: (value) {
                              if (value!.isNotEmpty) {
                                final salary = double.tryParse(value!);
                                if (salary! < 1000 || salary > 100000) {
                                  return 'مقدار معاش باید بین 1000 افغانی و 100,000 افغانی باشد.';
                                }
                              }
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9.]'))
                            ],
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'مقدار معاش',
                              suffixIcon: Icon(Icons.money),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.blue)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.red)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(
                                      color: Colors.red, width: 1.5)),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(20.0),
                          child: TextFormField(
                            controller: tazkiraController,
                            validator: (value) {
                              if (value!.isNotEmpty) {
                                if (!tazkiraPattern.hasMatch(value)) {
                                  return 'فورمت نمبر تذکره باید xxxx-xxxx-xxxxx باشد.';
                                }
                              }
                              return null;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9-]'))
                            ],
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'نمبر تذکره',
                              suffixIcon: Icon(Icons.perm_identity),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.blue)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.red)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(
                                      color: Colors.red, width: 1.5)),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(20.0),
                          child: TextFormField(
                            controller: addressController,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(regExOnlyAbc),
                              ),
                            ],
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'آدرس',
                              suffixIcon: Icon(Icons.location_on_outlined),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.blue)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.red)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(
                                      color: Colors.red, width: 1.5)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              Directionality(
                  textDirection: TextDirection.rtl,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('لغو')),
                      ElevatedButton(
                        onPressed: () async {
                          if (formKey1.currentState!.validate()) {
                            String fname = nameController.text;
                            String lname = lastNameController.text;
                            String pos = positionDropDown;
                            String phone = phoneController.text;
                            double salary = double.parse(salaryController.text);
                            String tazkiraId = tazkiraController.text;
                            String addr = addressController.text;
                            final conn = await onConnToDb();
                            final results = await conn.query(
                                'UPDATE staff SET firstname = ?, lastname = ?, position = ?, salary = ?, phone = ?, tazkira_ID = ?, address = ? WHERE staff_ID = ?',
                                [
                                  fname,
                                  lname,
                                  pos,
                                  salary,
                                  phone,
                                  tazkiraId,
                                  addr,
                                  staffID
                                ]);
                            if (results.affectedRows! > 0) {
                              _onShowSnack(Colors.green,
                                  'مشخصات این کارمند موفقانه تغییر کرد.');
                              Navigator.pop(context);
                              onUpdate();
                            } else {
                              _onShowSnack(
                                  Colors.red, 'متاسفم، تغییرات ناکام شد.');
                              Navigator.pop(context);
                            }
                          }
                        },
                        child: const Text('تغییر'),
                      ),
                    ],
                  ))
            ],
          );
        }),
      );
    }),
  );
}

// This is for creating a new user account.
onCreateUserAccount(BuildContext context, int staff_id) {
  // position types dropdown variables
  String roleDropDown = 'کمک مدیر';
  var roleItems = [
    'کمک مدیر',
    'مدیر سیستم',
  ];
// The global for the form
  final formKey2 = GlobalKey<FormState>();
// The text editing controllers for the TextFormFields
  final userNameController = TextEditingController();
  final pwdController = TextEditingController();
  final confirmController = TextEditingController();
  const regExUserName = "[a-zA-Z0-9]";

  return showDialog(
    context: context,
    builder: ((context) {
      return StatefulBuilder(
        builder: ((context, setState) {
          return AlertDialog(
            title: const Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                'ایجاد حساب کاربری (یوزر اکونت)',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            content: Directionality(
              textDirection: TextDirection.rtl,
              child: Form(
                key: formKey2,
                child: SizedBox(
                  width: 500.0,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 20.0),
                        ),
                        Container(
                          margin: const EdgeInsets.all(20.0),
                          child: TextFormField(
                            controller: userNameController,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(regExUserName),
                              ),
                            ],
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'نام کابری الزامی است.';
                              } else if (value.length < 6 ||
                                  value.length > 10) {
                                return 'نام کاربری باید بین 6 و 10 حرف باشد.';
                              }
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'نام کاربری (نام یوزر)',
                              suffixIcon: Icon(Icons.person),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.blue)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.red)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(
                                      color: Colors.red, width: 1.5)),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(20.0),
                          child: TextFormField(
                            controller: pwdController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'رمز الزامی است.';
                              } else if (value.length < 8) {
                                return 'رمز باید حداقل 8 حرف باشد.';
                              }
                            },
                            obscureText: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'رمز (پاسورد)',
                              suffixIcon: Icon(Icons.lock_open_outlined),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.blue)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.red)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(
                                      color: Colors.red, width: 1.5)),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(20.0),
                          child: TextFormField(
                            controller: confirmController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'تایید رمز الزامی است.';
                              } else if (pwdController.text !=
                                  confirmController.text) {
                                return 'رمز تان همخوانی ندارد. دوباره سعی کنید.';
                              }
                            },
                            obscureText: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'تایید رمز (پاسورد)',
                              suffixIcon: Icon(Icons.lock_open_outlined),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.blue)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.red)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(
                                      color: Colors.red, width: 1.5)),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(20.0),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'تعیین صلاحیت',
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.blue)),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: Container(
                                height: 26.0,
                                child: DropdownButton(
                                  isExpanded: true,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  value: roleDropDown,
                                  items: roleItems.map((String positionItems) {
                                    return DropdownMenuItem(
                                      value: positionItems,
                                      alignment: Alignment.centerRight,
                                      child: Text(positionItems),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      roleDropDown = newValue!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              Directionality(
                  textDirection: TextDirection.rtl,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                          child: const Text('لغو')),
                      ElevatedButton(
                        onPressed: () async {
                          if (formKey2.currentState!.validate()) {
                            int staffId = staff_id;
                            String userName = userNameController.text;
                            String pwd = pwdController.text;
                            String role = roleDropDown;
                            var conn = await onConnToDb();

                            var queryResult = await conn.query(
                                'INSERT INTO staff_auth (staff_ID, username, password, role) VALUES (?, ?, PASSWORD(?), ?)',
                                [staffId, userName, pwd, role]);

                            if (queryResult.affectedRows! > 0) {
                              print('Insert success!');
                              userNameController.clear();
                              pwdController.clear();
                              confirmController.clear();
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context);
                              // ignore: use_build_context_synchronously
                              _onShowSnack(Colors.green,
                                  'حساب کاربری موفقانه ایجاد شد.');
                            }
                          }
                        },
                        child: const Text('ثبت کردن'),
                      ),
                    ],
                  ))
            ],
          );
        }),
      );
    }),
  );
}

// This is for updating a user account.
onUpdateUserAccount(
    BuildContext context, int staff_id, String user_name, String user_role) {
  // position types dropdown variables
  String roleDropDown = 'کمک مدیر';
  var roleItems = [
    'کمک مدیر',
    'مدیر سیستم',
  ];
// The global for the form
  final formKey3 = GlobalKey<FormState>();
// The text editing controllers for the TextFormFields
  final userNameController = TextEditingController();
  final pwdController = TextEditingController();
  final confirmController = TextEditingController();
  const regExUserName = "[a-zA-Z0-9]";

// Set values into fields to update
  userNameController.text = user_name;
  roleDropDown = user_role;

  return showDialog(
    context: context,
    builder: ((context) {
      return StatefulBuilder(
        builder: ((context, setState) {
          return AlertDialog(
            title: const Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                'تغییر حساب کاربری (یوزر اکونت)',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            content: Directionality(
              textDirection: TextDirection.rtl,
              child: Form(
                key: formKey3,
                child: SizedBox(
                  width: 500.0,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 20.0),
                        ),
                        Container(
                          margin: const EdgeInsets.all(20.0),
                          child: TextFormField(
                            controller: userNameController,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(regExUserName),
                              ),
                            ],
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'نام کابری الزامی است.';
                              } else if (value.length < 6 ||
                                  value.length > 10) {
                                return 'نام کاربری باید بین 6 و 10 حرف باشد.';
                              }
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'نام کاربری (نام یوزر)',
                              suffixIcon: Icon(Icons.person),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.blue)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.red)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(
                                      color: Colors.red, width: 1.5)),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(20.0),
                          child: TextFormField(
                            controller: pwdController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'رمز الزامی است.';
                              } else if (value.length < 8) {
                                return 'رمز باید حداقل 8 حرف باشد.';
                              }
                            },
                            obscureText: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'رمز (پاسورد)',
                              suffixIcon: Icon(Icons.lock_open_outlined),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.blue)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.red)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(
                                      color: Colors.red, width: 1.5)),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(20.0),
                          child: TextFormField(
                            controller: confirmController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'تایید رمز الزامی است.';
                              } else if (pwdController.text !=
                                  confirmController.text) {
                                return 'رمز تان همخوانی ندارد. دوباره سعی کنید.';
                              }
                            },
                            obscureText: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'تایید رمز (پاسورد)',
                              suffixIcon: Icon(Icons.lock_open_outlined),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.blue)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.red)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(
                                      color: Colors.red, width: 1.5)),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(20.0),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'تعیین صلاحیت',
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.blue)),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: Container(
                                height: 26.0,
                                child: DropdownButton(
                                  isExpanded: true,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  value: roleDropDown,
                                  items: roleItems.map((String positionItems) {
                                    return DropdownMenuItem(
                                      value: positionItems,
                                      alignment: Alignment.centerRight,
                                      child: Text(positionItems),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      roleDropDown = newValue!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              Directionality(
                  textDirection: TextDirection.rtl,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                          child: const Text('لغو')),
                      ElevatedButton(
                        onPressed: () async {
                          if (formKey3.currentState!.validate()) {
                            final userName = userNameController.text;
                            final pwd = pwdController.text;
                            final userRole = roleDropDown;
                            var conn = await onConnToDb();
                            var queryResult = await conn.query(
                                'UPDATE staff_auth SET username = ?, password = PASSWORD(?), role = ? WHERE staff_ID = ?',
                                [userName, pwd, userRole, staff_id]);

                            if (queryResult.affectedRows! > 0) {
                              print('success!');
                              userNameController.clear();
                              pwdController.clear();
                              confirmController.clear();
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context);
                              // ignore: use_build_context_synchronously
                              _onShowSnack(Colors.green,
                                  'حساب کاربری موفقانه تغییر کرد.');
                            }
                          }
                        },
                        child: const Text('تغییر دادن'),
                      ),
                    ],
                  ))
            ],
          );
        }),
      );
    }),
  );
}

class MyStaff {
  final Blob? photo;
  final String firstName;
  final String lastName;
  final String position;
  final double salary;
  final String phone;
  final String tazkira;
  final String address;
  final int staffID;
  MyStaff({
    this.photo,
    required this.firstName,
    required this.lastName,
    required this.position,
    required this.salary,
    required this.phone,
    required this.tazkira,
    required this.address,
    required this.staffID,
  });

  @override
  String toString() {
    return 'MyStaff(firstName: $firstName, lastName: $lastName, position: $position)';
  }
}

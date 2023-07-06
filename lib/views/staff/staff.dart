import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dentistry/models/db_conn.dart';
import 'package:flutter_dentistry/views/main/dashboard.dart';
import 'package:flutter_dentistry/views/staff/new_staff.dart';

void main() {
  return runApp(const Staff());
}

class Staff extends StatelessWidget {
  const Staff({super.key});

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
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Dashboard(),
                  ),
                ),
                icon: const Icon(Icons.home_outlined),
              ),
            ),
            title: const Text('کارمندان'),
          ),
          body: const MyDataTable(),
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
        'SELECT photo, firstname, lastname, position, salary, phone, tazkira_ID, address FROM staff');
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
  Widget build(BuildContext context) {
    // Create a new instance of the PatientDataSource class and pass it the _filteredData list
    final dataSource = MyData(_filteredData);

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
  MyData(this.data);

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
                      Icons.edit,
                      size: 20.0,
                    ),
                    title: const Text(
                      'تغییر دادن',
                      style: TextStyle(fontSize: 15.0),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      onEditStaff(context);
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
                    onTap: () {
                      Navigator.pop(context);
                      onDeleteStaff(context);
                    }),
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
onDeleteStaff(BuildContext context) {
  return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
            title: const Directionality(
              textDirection: TextDirection.rtl,
              child: Text('حذف کارمند'),
            ),
            content: const Directionality(
              textDirection: TextDirection.rtl,
              child: Text('آیا میخواهید این کارمند را حذف کنید؟'),
            ),
            actions: [
              TextButton(
                  onPressed: () =>
                      Navigator.of(context, rootNavigator: true).pop(),
                  child: const Text('لغو')),
              TextButton(onPressed: () {}, child: const Text('حذف')),
            ],
          ));
}

// This dialog edits a staff
onEditStaff(BuildContext context) {
  // position types dropdown variables
  String positionDropDown = 'داکتر دندان';
  var positionItems = [
    'داکتر دندان',
    'نرس',
    'مدیر سیستم',
  ];
// The global for the form
  final formKey = GlobalKey<FormState>();
// The text editing controllers for the TextFormFields
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final salaryController = TextEditingController();
  final tazkiraController = TextEditingController();
  final addressController = TextEditingController();

  return showDialog(
    context: context,
    builder: ((context) {
      return StatefulBuilder(
        builder: ((context, setState) {
          return AlertDialog(
            title: const Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                'تغییر مشخصات کارمند  ',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            content: Directionality(
              textDirection: TextDirection.rtl,
              child: Form(
                key: formKey,
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
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(20.0),
                          child: TextFormField(
                            controller: lastNameController,
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
                            controller: phoneController,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
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
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(20.0),
                          child: TextFormField(
                            controller: salaryController,
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
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(20.0),
                          child: TextFormField(
                            controller: tazkiraController,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9.]'))
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
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(20.0),
                          child: TextFormField(
                            controller: addressController,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
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
                        onPressed: () {},
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

class MyStaff {
  final AssetImage? photo;
  final String firstName;
  final String lastName;
  final String position;
  final double salary;
  final String phone;
  final String tazkira;
  final String address;
  MyStaff({
    this.photo,
    required this.firstName,
    required this.lastName,
    required this.position,
    required this.salary,
    required this.phone,
    required this.tazkira,
    required this.address,
  });

  @override
  String toString() {
    return 'MyStaff(firstName: $firstName, lastName: $lastName, position: $position)';
  }
}

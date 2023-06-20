import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dentistry/views/main/dashboard.dart';
import 'package:flutter_dentistry/views/staff/new_staff.dart';

void main() {
  return runApp(const Staff());
}

class Staff extends StatelessWidget {
  const Staff({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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

  // The original data source
  final List<MyData> _data = [
    MyData(
        const AssetImage('assets/graphics/patient.png'),
        'احمد',
        'کریمی',
        'داکتر',
        const Icon(Icons.list),
        const Icon(Icons.edit),
        const Icon(Icons.delete)),
    MyData(
        const AssetImage('assets/graphics/patient.png'),
        'سحر',
        'قریشی',
        'نرس',
        const Icon(Icons.list),
        const Icon(Icons.edit),
        const Icon(Icons.delete)),
    MyData(
        const AssetImage('assets/graphics/patient.png'),
        'میرویس',
        'فاتح',
        'کارمند مالی',
        const Icon(Icons.list),
        const Icon(Icons.edit),
        const Icon(Icons.delete)),
    MyData(
        const AssetImage('assets/graphics/patient.png'),
        'فیض',
        'فهیمی',
        'کمپوتر کار',
        const Icon(Icons.list),
        const Icon(Icons.edit),
        const Icon(Icons.delete)),
    MyData(
        const AssetImage('assets/graphics/patient.png'),
        'بهمن',
        'فهیمی',
        'کمپوتر کار',
        const Icon(Icons.list),
        const Icon(Icons.edit),
        const Icon(Icons.delete)),
    MyData(
        const AssetImage('assets/graphics/patient.png'),
        'حامد',
        'حکیمی',
        'نرس',
        const Icon(Icons.list),
        const Icon(Icons.edit),
        const Icon(Icons.delete)),
    MyData(
        const AssetImage('assets/graphics/patient.png'),
        'مریم',
        'رضایی',
        'نرس',
        const Icon(Icons.list),
        const Icon(Icons.edit),
        const Icon(Icons.delete)),
    MyData(
        const AssetImage('assets/graphics/patient.png'),
        'بصیر',
        'عسکری',
        'داکتر',
        const Icon(Icons.list),
        const Icon(Icons.edit),
        const Icon(Icons.delete)),
    MyData(
        const AssetImage('assets/graphics/patient.png'),
        'حسین',
        'احسانی',
        'کارمند لابراتوار',
        const Icon(Icons.list),
        const Icon(Icons.edit),
        const Icon(Icons.delete)),
    MyData(
        const AssetImage('assets/graphics/patient.png'),
        'مراد',
        'بیگ',
        'کارمند لابراتوار',
        const Icon(Icons.list),
        const Icon(Icons.edit),
        const Icon(Icons.delete)),
    MyData(
        const AssetImage('assets/graphics/patient.png'),
        'Ali',
        'Bieg',
        'Financial',
        const Icon(Icons.list),
        const Icon(Icons.edit),
        const Icon(Icons.delete)),
    MyData(
        const AssetImage('assets/graphics/patient.png'),
        'Reza',
        'Rezaie',
        'Services Provider',
        const Icon(Icons.list),
        const Icon(Icons.edit),
        const Icon(Icons.delete)),
  ];

// The filtered data source
  late List<MyData> _filteredData;

// The text editing controller for the search TextField
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
// Set the filtered data to the original data at first
    _filteredData = _data;
  }

  @override
  Widget build(BuildContext context) {
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
                          builder: (context) => const NewStaff()));
                },
                child: const Text('افزودن کارمند جدید'),
              ),
            ],
          ),
        ),
        PaginatedDataTable(
          sortAscending: _sortAscending,
          sortColumnIndex: _sortColumnIndex,
          header: const Text("همه کارمندان |"),
          columns: [
            const DataColumn(
              label: Text(
                "عکس",
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: const Text(
                "اسم",
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
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
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
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
                "مقام",
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
              onSort: (columnIndex, ascending) {
                setState(() {
                  _sortColumnIndex = columnIndex;
                  _sortAscending = ascending;
                  _filteredData
                      .sort(((a, b) => a.position.compareTo(b.position)));
                  if (!ascending) {
                    _filteredData = _filteredData.reversed.toList();
                  }
                });
              },
            ),
            const DataColumn(
              label: Text(
                "شرح",
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            ),
            const DataColumn(
                label: Text("تغییر",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold))),
            const DataColumn(
                label: Text("حذف",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold))),
          ],
          source: MyDataSource(_filteredData),
          rowsPerPage: _filteredData.length < 5 ? _filteredData.length : 5,
        )
      ],
    ));
  }
}

class MyDataSource extends DataTableSource {
  List<MyData> data;

  MyDataSource(this.data);

  void sort(Comparator<MyData> compare, bool ascending) {
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
      DataCell(IconButton(
        icon: data[index].employeeDetail,
        onPressed: (() {
          print('Details clicked.');
        }),
        color: Colors.blue,
        iconSize: 20.0,
      )),
      DataCell(
        Builder(builder: (BuildContext context) {
          return IconButton(
            icon: data[index].editEmployee,
            onPressed: (() {
              onEditStaff(context);
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
              icon: data[index].deleteEmployee,
              onPressed: (() {
                onDeleteStaff(context);
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
                  onPressed: () => Navigator.pop(context),
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

class MyData {
  final AssetImage photo;
  final String firstName;
  final String lastName;
  final String position;
  final Icon employeeDetail;
  final Icon editEmployee;
  final Icon deleteEmployee;

  MyData(this.photo, this.firstName, this.lastName, this.position,
      this.employeeDetail, this.editEmployee, this.deleteEmployee);
}

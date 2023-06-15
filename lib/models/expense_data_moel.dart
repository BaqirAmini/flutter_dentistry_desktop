import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExpenseData extends StatelessWidget {
  const ExpenseData({super.key});

  @override
  Widget build(BuildContext context) {
    return const ExpenseDataTable();
  }
}

// Data table widget is here
class ExpenseDataTable extends StatefulWidget {
  const ExpenseDataTable({super.key});

  @override
  ExpenseDataTableState createState() => ExpenseDataTableState();
}

class ExpenseDataTableState extends State<ExpenseDataTable> {
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  // The original data source
  final List<MyData> _data = [
    MyData('مواد مورد نیاز دندان', 'نقره', '500 گرام', const Icon(Icons.list),
        const Icon(Icons.edit), const Icon(Icons.delete)),
    MyData('مواد مورد نیاز دندان', 'نقره', '200 گرام', const Icon(Icons.list),
        const Icon(Icons.edit), const Icon(Icons.delete)),
    MyData('مواد مورد نیاز دندان', 'پورسلن', '100 گرام', const Icon(Icons.list),
        const Icon(Icons.edit), const Icon(Icons.delete)),
    MyData(
        'مواد مورد نیاز دندان',
        'آمپول بی حس کننده',
        '10 عدد',
        const Icon(Icons.list),
        const Icon(Icons.edit),
        const Icon(Icons.delete)),
    MyData('تجهیزات برای کلینیک', 'میز کار', '1 عدد', const Icon(Icons.list),
        const Icon(Icons.edit), const Icon(Icons.delete)),
    MyData('تجهیزات برای کلینیک', 'میز کار', '1 عدد', const Icon(Icons.list),
        const Icon(Icons.edit), const Icon(Icons.delete)),
    MyData('تجهیزات برای کلینیک', 'فرش', '5 متر مربع', const Icon(Icons.list),
        const Icon(Icons.edit), const Icon(Icons.delete)),
    MyData('تجهیزات برای کلینیک', 'گروپ برق', '3 عدد', const Icon(Icons.list),
        const Icon(Icons.edit), const Icon(Icons.delete)),
    MyData('مواد غذایی', 'نان خشک', '10 قرص', const Icon(Icons.list),
        const Icon(Icons.edit), const Icon(Icons.delete)),
    MyData('مواد غذایی', 'آب', '100 مترمربع', const Icon(Icons.list),
        const Icon(Icons.edit), const Icon(Icons.delete)),
    MyData('مواد غذایی', 'میوه', '4 کیلوگرام', const Icon(Icons.list),
        const Icon(Icons.edit), const Icon(Icons.delete)),
    MyData('مواد غذایی', 'چای', '1 کیلوگرام', const Icon(Icons.list),
        const Icon(Icons.edit), const Icon(Icons.delete)),
  ];

  // Expense types dropdown variables
  String expenseDropDown = 'مواد غذایی';
  var expensItems = [
    'مواد غذایی',
    'تجهیزات برای کلینیک',
    'مواد مورد نیاز دندان',
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
                          .where((element) => element.expenseType
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
              Container(
                width: 180.0,
                height: 50.0,
                margin: const EdgeInsets.only(top: 6.0, left: 6.0),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'فلتر کردن',
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.blue)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: Container(
                      height: 25.0,
                      child: DropdownButton(
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down),
                        value: expenseDropDown,
                        items: expensItems.map((String expensItems) {
                          return DropdownMenuItem(
                            value: expensItems,
                            alignment: Alignment.centerRight,
                            child: Text(
                              expensItems,
                              style: TextStyle(fontSize: 14.0),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            expenseDropDown = newValue!;
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
        PaginatedDataTable(
          sortAscending: _sortAscending,
          sortColumnIndex: _sortColumnIndex,
          header: const Text("همه مصارف |"),
          columns: [
            DataColumn(
              label: const Text(
                "نوعیت مصرف",
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
              onSort: (columnIndex, ascending) {
                setState(() {
                  _sortColumnIndex = columnIndex;
                  _sortAscending = ascending;
                  _filteredData
                      .sort((a, b) => a.expenseType.compareTo(b.expenseType));
                  if (!ascending) {
                    _filteredData = _filteredData.reversed.toList();
                  }
                });
              },
            ),
            DataColumn(
              label: const Text(
                "نام جنس",
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
              onSort: (columnIndex, ascending) {
                setState(() {
                  _sortColumnIndex = columnIndex;
                  _sortAscending = ascending;
                  _filteredData
                      .sort(((a, b) => a.expenseItem.compareTo(b.expenseItem)));
                  if (!ascending) {
                    _filteredData = _filteredData.reversed.toList();
                  }
                });
              },
            ),
            DataColumn(
              label: const Text(
                "تعداد / مقدار",
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
              onSort: (columnIndex, ascending) {
                setState(() {
                  _sortColumnIndex = columnIndex;
                  _sortAscending = ascending;
                  _filteredData
                      .sort(((a, b) => a.quantity.compareTo(b.quantity)));
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
      DataCell(Text(data[index].expenseType)),
      DataCell(Text(data[index].expenseItem)),
      DataCell(Text(data[index].quantity)),
      DataCell(IconButton(
        icon: data[index].expenseDetail,
        onPressed: (() {
          print('Details clicked.');
        }),
        color: Colors.blue,
        iconSize: 20.0,
      )),
      DataCell(
        Builder(builder: (BuildContext context) {
          return IconButton(
            icon: data[index].editExpense,
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
              icon: data[index].deleteExpense,
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
  // quantity types dropdown variables
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
  final String expenseType;
  final String expenseItem;
  final String quantity;
  final Icon expenseDetail;
  final Icon editExpense;
  final Icon deleteExpense;

  MyData(this.expenseType, this.expenseItem, this.quantity, this.expenseDetail,
      this.editExpense, this.deleteExpense);
}

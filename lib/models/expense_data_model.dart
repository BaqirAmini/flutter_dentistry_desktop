import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/views/finance/expenses/expense_details.dart';
import 'package:intl/intl.dart' as intl2;

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
                    child: SizedBox(
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
                              style: const TextStyle(fontSize: 14.0),
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
      DataCell(
        Builder(builder: (BuildContext context) {
          return IconButton(
            icon: data[index].expenseDetail,
            onPressed: (() => onShowExpenseDetails(context)),
            color: Colors.blue,
            iconSize: 20.0,
          );
        }),
      ),
      DataCell(
        Builder(builder: (BuildContext context) {
          return IconButton(
            icon: data[index].editExpense,
            onPressed: (() {
              onEditExpense(context);
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
                onDeleteExpense(context);
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

// This is to display an alert dialog to delete expenses
onDeleteExpense(BuildContext context) {
  return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
            title: const Directionality(
              textDirection: TextDirection.rtl,
              child: Text('حذف مصارف'),
            ),
            content: const Directionality(
              textDirection: TextDirection.rtl,
              child: Text('آیا میخواهید این مصرف را حذف کنید؟'),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('لغو')),
              TextButton(onPressed: () {}, child: const Text('حذف')),
            ],
          ));
}

// This dialog edits expenses
onEditExpense(BuildContext context) {
// The global for the form
  final formKey = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
// The text editing controllers for the TextFormFields
  final itemNameController = TextEditingController();
  final qtyController = TextEditingController();
  final unitPriceController = TextEditingController();
  final totalPriceController = TextEditingController();
  final purDateController = TextEditingController();
  final expenseTypeController = TextEditingController();

  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: DefaultTabController(
              length: 2,
              child: SizedBox(
                width: 500.0,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const TabBar(
                              labelColor: Colors.blue,
                              unselectedLabelColor: Colors.grey,
                              tabs: [
                                Tab(
                                  text: 'تغییر نوعیت مصارف',
                                  icon: Icon(Icons.category_outlined),
                                ),
                                Tab(
                                  text: 'تغییر اجناس مصارف',
                                  icon: Icon(Icons
                                      .production_quantity_limits_outlined),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 500.0,
                              child: TabBarView(
                                children: [
                                  Form(
                                    key: formKey2,
                                    child: Column(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.all(20.0),
                                          child: TextFormField(
                                            controller: expenseTypeController,
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'نوعیت مصارف',
                                              suffixIcon:
                                                  Icon(Icons.category_outlined),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              50.0)),
                                                  borderSide: BorderSide(
                                                      color: Colors.grey)),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              50.0)),
                                                  borderSide: BorderSide(
                                                      color: Colors.blue)),
                                            ),
                                          ),
                                        ),
                                        Container(
                                            width: 400.0,
                                            margin: const EdgeInsets.all(20.0),
                                            child: ElevatedButton(
                                              onPressed: () {},
                                              child: const Text('تغییر دادن'),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Form(
                                    key: formKey,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.all(20.0),
                                            child: TextFormField(
                                              controller: itemNameController,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: 'نام جنس',
                                                suffixIcon: Icon(Icons
                                                    .bakery_dining_outlined),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    50.0)),
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.grey)),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    50.0)),
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.blue)),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.all(20.0),
                                            child: TextFormField(
                                              controller: qtyController,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: 'تعداد / مقدار',
                                                suffixIcon: Icon(Icons
                                                    .production_quantity_limits_outlined),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    50.0)),
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.grey)),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    50.0)),
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.blue)),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.all(20.0),
                                            child: TextFormField(
                                              controller: unitPriceController,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: 'قیمت فی واحد',
                                                suffixIcon: Icon(Icons
                                                    .price_change_outlined),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    50.0)),
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.grey)),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    50.0)),
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.blue)),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.all(20.0),
                                            child: TextFormField(
                                              controller: totalPriceController,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(RegExp(r'[0-9.]'))
                                              ],
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: 'قیمت مجموع',
                                                suffixIcon: Icon(Icons.money),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    50.0)),
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.grey)),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    50.0)),
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.blue)),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.all(20.0),
                                            child: TextFormField(
                                              controller: purDateController,
                                              onTap: () async {
                                                FocusScope.of(context)
                                                    .requestFocus(
                                                        FocusNode());
                                                final DateTime? dateTime =
                                                    await showDatePicker(
                                                        context: context,
                                                        initialDate:
                                                            DateTime.now(),
                                                        firstDate:
                                                            DateTime(1900),
                                                        lastDate:
                                                            DateTime(2100));
                                                if (dateTime != null) {
                                                  final intl2.DateFormat
                                                      formatter =
                                                      intl2.DateFormat(
                                                          'yyyy-MM-dd');
                                                  final String formattedDate =
                                                      formatter
                                                          .format(dateTime);
                                                  purDateController.text =
                                                      formattedDate;
                                                }
                                              },
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(RegExp(r'[0-9.]'))
                                              ],
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: 'تاریخ خرید جنس',
                                                suffixIcon: Icon(Icons
                                                    .calendar_month_outlined),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    50.0)),
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.grey)),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    50.0)),
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.blue)),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 400.0,
                                            margin: const EdgeInsets.all(20.0),
                                            child: ElevatedButton(
                                              onPressed: () {},
                                              child: const Text('تغییر دادن'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ), // Footer of the dialog
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('لغو'),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      });
}

// This is to display an alert dialog to expenses details
onShowExpenseDetails(BuildContext context) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Directionality(
        textDirection: TextDirection.rtl,
        child: Text(
          'جزییات مصارف',
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
      ),
      content: const Directionality(
        textDirection: TextDirection.rtl,
        child: Directionality(
            textDirection: TextDirection.rtl, child: ExpenseDetails()),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('تایید'),
        ),
      ],
      actionsAlignment: MainAxisAlignment.start,
    ),
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

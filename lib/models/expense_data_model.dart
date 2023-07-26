import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/views/finance/expenses/expense_details.dart';
import 'package:intl/intl.dart' as intl2;
import '/views/finance/expenses/expense_info.dart';

import 'db_conn.dart';

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
  // The filtered data source
  List<Expense> _filteredData = [];

  List<Expense> _data = [];

// Fetch expenses records from the database
  Future<void> _fetchData() async {
    final conn = await onConnToDb();
    final results = await conn.query(
        'SELECT  A.exp_name, B.item_name, B.quantity, B.unit_price, B.total, C.firstname, C.lastname, DATE_FORMAT(B.purchase_date, "%Y-%m-%d"), B.note, B.exp_detail_ID FROM expenses A INNER JOIN expense_detail B ON A.exp_ID = B.exp_ID INNER JOIN staff C ON B.purchased_by = C.staff_ID');

    _data = results.map((row) {
      return Expense(
        expenseType: row[0],
        expenseItem: row[1],
        quantity: row[2],
        unitPrice: row[3],
        totalPrice: row[4],
        purchasedBy: row[5] + ' ' + row[6],
        purchasedDate: row[7].toString(),
        description: row[8],
        expDetID: row[9],
        expenseDetail: const Icon(Icons.list),
        editExpense: const Icon(Icons.edit),
        deleteExpense: const Icon(Icons.delete),
      );
    }).toList();
    _filteredData = List.from(_data);
    await conn.close();
    // Notify the framework that the state of the widget has changed
    setState(() {});
    // Print the data that was fetched from the database
    print('Data from database: $_data');
  }

  // Expense types dropdown variables
  String expenseDropDown = 'مواد غذایی';
  var expensItems = [
    'مواد غذایی',
    'تجهیزات برای کلینیک',
    'مواد مورد نیاز دندان',
  ];

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
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final dataSource = MyDataSource(_filteredData);
    return Scaffold(
        key: _scaffoldKey,
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0)),
                            borderSide: BorderSide(color: Colors.grey)),
                        focusedBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0)),
                            borderSide: BorderSide(color: Colors.blue)),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _filteredData = _data
                              .where((element) =>
                                  element.expenseType
                                      .toLowerCase()
                                      .contains(value.toLowerCase()) ||
                                  element.expenseItem
                                      .toLowerCase()
                                      .contains(value.toLowerCase()) ||
                                  element.quantity
                                      .toString()
                                      .toLowerCase()
                                      .contains(value.toLowerCase()) ||
                                  element.purchasedDate
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: Colors.grey)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
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
            if (_filteredData.isEmpty)
              const SizedBox(
                width: 200,
                height: 200,
                child:
                    Center(child: Text('هیچ اطلاعاتی مربوط مصارف یافت نشد.')),
              )
            else
              PaginatedDataTable(
                sortAscending: _sortAscending,
                sortColumnIndex: _sortColumnIndex,
                header: const Text("همه مصارف |"),
                columns: [
                  DataColumn(
                    label: const Text(
                      "نوعیت مصرف",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                    onSort: (columnIndex, ascending) {
                      setState(() {
                        _sortColumnIndex = columnIndex;
                        _sortAscending = ascending;
                        _filteredData.sort(
                            (a, b) => a.expenseType.compareTo(b.expenseType));
                        if (!ascending) {
                          _filteredData = _filteredData.reversed.toList();
                        }
                      });
                    },
                  ),
                  DataColumn(
                    label: const Text(
                      "نام جنس",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                    onSort: (columnIndex, ascending) {
                      setState(() {
                        _sortColumnIndex = columnIndex;
                        _sortAscending = ascending;
                        _filteredData.sort(
                            ((a, b) => a.expenseItem.compareTo(b.expenseItem)));
                        if (!ascending) {
                          _filteredData = _filteredData.reversed.toList();
                        }
                      });
                    },
                  ),
                  DataColumn(
                    label: const Text(
                      "تعداد / مقدار",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
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
                  DataColumn(
                    label: const Text(
                      "فی قیمت",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                    onSort: (columnIndex, ascending) {
                      setState(() {
                        _sortColumnIndex = columnIndex;
                        _sortAscending = ascending;
                        _filteredData.sort(
                            ((a, b) => a.unitPrice.compareTo(b.unitPrice)));
                        if (!ascending) {
                          _filteredData = _filteredData.reversed.toList();
                        }
                      });
                    },
                  ),
                  DataColumn(
                    label: const Text(
                      "مجموع مبلغ",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                    onSort: (columnIndex, ascending) {
                      setState(() {
                        _sortColumnIndex = columnIndex;
                        _sortAscending = ascending;
                        _filteredData.sort(
                            ((a, b) => a.totalPrice.compareTo(b.totalPrice)));
                        if (!ascending) {
                          _filteredData = _filteredData.reversed.toList();
                        }
                      });
                    },
                  ),
                  /*     DataColumn(
              label: const Text(
                "خریداری شده توسط",
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
            ), */
                  DataColumn(
                    label: const Text(
                      "تاریخ خرید",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                    onSort: (columnIndex, ascending) {
                      setState(() {
                        _sortColumnIndex = columnIndex;
                        _sortAscending = ascending;
                        _filteredData.sort(((a, b) =>
                            a.purchasedDate.compareTo(b.purchasedDate)));
                        if (!ascending) {
                          _filteredData = _filteredData.reversed.toList();
                        }
                      });
                    },
                  ),
                  /*  DataColumn(
              label: const Text(
                "توضیحات",
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
            ), */
                  const DataColumn(
                    label: Text(
                      "شرح",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const DataColumn(
                      label: Text("تغییر",
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
        ));
  }
}

class MyDataSource extends DataTableSource {
  List<Expense> data;

  MyDataSource(this.data);

  void sort(Comparator<Expense> compare, bool ascending) {
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
      DataCell(Text(data[index].quantity.toString())),
      DataCell(Text('${data[index].unitPrice} افغانی')),
      DataCell(Text('${data[index].totalPrice} افغانی')),
      // DataCell(Text(data[index].purchasedBy)),
      DataCell(Text(data[index].purchasedDate)),
      // DataCell(Text(data[index].description)),
      DataCell(
        Builder(builder: (BuildContext context) {
          return IconButton(
            icon: data[index].expenseDetail,
            onPressed: () {
              String expCategory = data[index].expenseType;
              String itemName = data[index].expenseItem;
              double itemQty = data[index].quantity;
              String purBy = data[index].purchasedBy;
              String purDate = data[index].purchasedDate;
              String desc = data[index].description;

              ExpenseInfo.expenseCategory = expCategory;
              ExpenseInfo.itemName = itemName;
              ExpenseInfo.qty = itemQty;
              ExpenseInfo.purchasedBy = purBy;
              ExpenseInfo.purchaseDate = purDate;
              ExpenseInfo.description = desc;
              onShowExpenseDetails(context);
            },
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
                  onPressed: () =>
                      Navigator.of(context, rootNavigator: true).pop(),
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
                                                    .requestFocus(FocusNode());
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
      builder: (BuildContext context) {
        return AlertDialog(
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
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('تایید'),
            ),
          ],
          actionsAlignment: MainAxisAlignment.start,
        );
      });
}

class Expense {
  final int expDetID;
  final String expenseType;
  final String expenseItem;
  final double quantity;
  final double unitPrice;
  final double totalPrice;
  final String purchasedBy;
  final String purchasedDate;
  final String description;
  final Icon expenseDetail;
  final Icon editExpense;
  final Icon deleteExpense;

  Expense(
      {required this.expDetID,
      required this.expenseType,
      required this.expenseItem,
      required this.quantity,
      required this.unitPrice,
      required this.totalPrice,
      required this.purchasedBy,
      required this.purchasedDate,
      required this.description,
      required this.expenseDetail,
      required this.editExpense,
      required this.deleteExpense});
}

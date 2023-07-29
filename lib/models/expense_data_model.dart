import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/views/finance/expenses/expense_details.dart';
import 'package:intl/intl.dart' as intl2;
import '/views/finance/expenses/expense_info.dart';
import 'db_conn.dart';

// Create the global key at the top level of your Dart file
final GlobalKey<ScaffoldMessengerState> _globalKeyExpDM =
    GlobalKey<ScaffoldMessengerState>();

// Declare this variable to assign expenses filter value
String expFilterValue = 'همه';
// This is shows snackbar when called
void _onShowSnack(Color backColor, String msg) {
  _globalKeyExpDM.currentState?.showSnackBar(
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
    // if expFilterValue = 'همه' then it should not use WHERE to filter.
    final results = expFilterValue == 'همه'
        ? await conn.query(
            'SELECT  A.exp_name, B.item_name, B.quantity, B.unit_price, B.total, C.firstname, C.lastname, DATE_FORMAT(B.purchase_date, "%Y-%m-%d"), B.note, B.exp_detail_ID, A.exp_ID, B.qty_unit FROM expenses A INNER JOIN expense_detail B ON A.exp_ID = B.exp_ID INNER JOIN staff C ON B.purchased_by = C.staff_ID ORDER BY B.purchase_date DESC;')
        : await conn.query(
            'SELECT  A.exp_name, B.item_name, B.quantity, B.unit_price, B.total, C.firstname, C.lastname, DATE_FORMAT(B.purchase_date, "%Y-%m-%d"), B.note, B.exp_detail_ID, A.exp_ID, B.qty_unit FROM expenses A INNER JOIN expense_detail B ON A.exp_ID = B.exp_ID INNER JOIN staff C ON B.purchased_by = C.staff_ID WHERE A.exp_ID = ? ORDER BY B.purchase_date DESC;',
            [expFilterValue]);
   
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
        expTypeID: row[10],
        qtyUnit: row[11],
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
  String? selectedFilter;
  List<Map<String, dynamic>> expenseTypes = [];
  Future<void> fetchExpenseFilter() async {
    var conn = await onConnToDb();
    var results = await conn.query('SELECT exp_ID, exp_name FROM expenses');
    setState(() {
      expenseTypes = results
          .map((result) =>
              {'exp_ID': result[0].toString(), 'exp_name': result[1]})
          .toList();
      expenseTypes.insert(0, {'exp_ID': 'همه', 'exp_name': 'همه'});
    });
    selectedFilter =
        expenseTypes.isNotEmpty ? expenseTypes[0]['exp_ID'] : 'همه';
    await conn.close();
  }

// The text editing controller for the search TextField
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set the filtered data to the original data at first
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchData());
    fetchExpenseFilter();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final dataSource =
        MyDataSource(_filteredData, _fetchData, _fetchData, _fetchData);
    // This is to refresh the data table after an expense added.
    ExpenseInfo.onAddExpense = _fetchData;
    return ScaffoldMessenger(
      key: _globalKeyExpDM,
      child: Scaffold(
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
                    height: 60.0,
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
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton(
                              // isExpanded: true,
                              icon: const Icon(Icons.arrow_drop_down),
                              value: selectedFilter,
                              style: const TextStyle(
                                  fontSize: 14.0, color: Colors.black),
                              items: expenseTypes.map((expense) {
                                return DropdownMenuItem<String>(
                                  value: expense['exp_ID'],
                                  alignment: Alignment.centerRight,
                                  child: Text(expense['exp_name']),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedFilter = newValue;
                                  expFilterValue = selectedFilter!;
                                  _fetchData();
                                });
                              },
                            ),
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
                      "فی واحد",
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
        ),
      ),
    );
  }
}

class MyDataSource extends DataTableSource {
  List<Expense> data;
// Create these variables for refreshing the page after a record deleted or updated.
  Function onUpdate;
  Function onUpdateItem;
  Function onDelete;
  MyDataSource(this.data, this.onUpdate, this.onUpdateItem, this.onDelete);

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
      DataCell(Text('${data[index].quantity} ${data[index].qtyUnit}')),
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
              double unitPrice = data[index].unitPrice;
              String qtyUnit = data[index].qtyUnit;
              String purBy = data[index].purchasedBy;
              String purDate = data[index].purchasedDate;
              String desc = data[index].description;

              ExpenseInfo.expenseCategory = expCategory;
              ExpenseInfo.itemName = itemName;
              ExpenseInfo.qty = itemQty;
              ExpenseInfo.qtyUnit = qtyUnit;
              ExpenseInfo.unitPrice = unitPrice;
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
            onPressed: () {
              ExpenseInfo.exp_detail_ID = data[index].expDetID;
              ExpenseInfo.expenseCategory = data[index].expenseType;
              ExpenseInfo.itemName = data[index].expenseItem;
              ExpenseInfo.qty = data[index].quantity;
              ExpenseInfo.qtyUnit = data[index].qtyUnit;
              ExpenseInfo.unitPrice = data[index].unitPrice;
              ExpenseInfo.purchasedBy = data[index].purchasedBy;
              ExpenseInfo.purchaseDate = data[index].purchasedDate;
              ExpenseInfo.description = data[index].description;
              ExpenseInfo.totalPrice = data[index].totalPrice;

              int expTypeID = data[index].expTypeID;
              onEditExpense(context, expTypeID, onUpdate, onUpdateItem);
            },
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
                ExpenseInfo.exp_detail_ID = data[index].expDetID;
                ExpenseInfo.itemName = data[index].expenseItem;
                onDeleteExpense(context, onDelete);
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
onDeleteExpense(BuildContext context, Function onDelete) {
  return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
            title: const Directionality(
              textDirection: TextDirection.rtl,
              child: Text('حذف مصارف'),
            ),
            content: Directionality(
              textDirection: TextDirection.rtl,
              child: Text('آیا میخواهید ${ExpenseInfo.itemName} را حذف کنید؟'),
            ),
            actions: [
              TextButton(
                  onPressed: () =>
                      Navigator.of(context, rootNavigator: true).pop(),
                  child: const Text('لغو')),
              TextButton(
                onPressed: () async {
                  final conn = await onConnToDb();
                  var results = await conn.query(
                      'DELETE FROM expense_detail WHERE exp_detail_ID = ?',
                      [ExpenseInfo.exp_detail_ID]);
                  if (results.affectedRows! > 0) {
                    _onShowSnack(Colors.green, 'جنس مورد مصرف موفقانه حذف شد.');
                    onDelete();
                    await conn.close();
                  } else {
                    _onShowSnack(Colors.red, 'متاسفم، حذف انجام نشد.');
                  }
                  Navigator.of(context, rootNavigator: true).pop();
                },
                child: const Text('حذف'),
              ),
            ],
          ));
}

// This dialog edits expenses
onEditExpense(BuildContext context, int expTypeId, Function onUpdate,
    Function onUpdateItem) {
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
  final purByController = TextEditingController();
  final descController = TextEditingController();

// Fetch values from a static class and assign them into textfields.
  expenseTypeController.text = ExpenseInfo.expenseCategory!;
  itemNameController.text = ExpenseInfo.itemName!;
  qtyController.text = ExpenseInfo.qty.toString();
  unitPriceController.text = ExpenseInfo.unitPrice.toString();
  totalPriceController.text = ExpenseInfo.totalPrice.toString();
  purDateController.text = ExpenseInfo.purchaseDate!;
  descController.text = ExpenseInfo.description!;

  double? totalPrice = ExpenseInfo.totalPrice;
// Sets the total price into its related field
  void onSetTotalPrice(String text) {
    double qty =
        qtyController.text.isEmpty ? 0 : double.parse(qtyController.text);
    double unitPrice = unitPriceController.text.isEmpty
        ? 0
        : double.parse(unitPriceController.text);
    totalPrice = qty * unitPrice;
    totalPriceController.text = '$totalPrice افغانی';
  }

  // Set a dropdown for units
  String? selectedUnit = ExpenseInfo.qtyUnit;
  var unitsItems = [
    'گرام',
    'کیلوگرام',
    'عدد',
    'قرص',
    'متر',
    'سانتی متر',
    'cc',
    'خوراک',
    'ست',
  ];

  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
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
                                      icon: Icon(Icons.edit_outlined),
                                    ),
                                    Tab(
                                      text: 'تغییر اجناس مصارف',
                                      icon: Icon(Icons.edit_outlined),
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
                                              margin: const EdgeInsets.only(
                                                  top: 30.0,
                                                  left: 20,
                                                  right: 20),
                                              child: TextFormField(
                                                controller:
                                                    expenseTypeController,
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'نوعیت (کتگوری جنس نمی تواند خالی باشد.)';
                                                  } else if (value.length < 3 ||
                                                      value.length > 20) {
                                                    return 'نام کتگوری یا نوعیت مصرف باید بین 3 و 20 حرف باشد.';
                                                  }
                                                },
                                                decoration:
                                                    const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText: 'نوعیت مصارف',
                                                  suffixIcon: Icon(
                                                      Icons.category_outlined),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          50.0)),
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .grey)),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          50.0)),
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .blue)),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          50.0)),
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .red)),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          50.0)),
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .red,
                                                                  width: 1.5)),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin:
                                                  const EdgeInsets.all(20.0),
                                              width: 430.0,
                                              height: 35.0,
                                              child: Builder(
                                                builder: (context) {
                                                  return OutlinedButton(
                                                    style: OutlinedButton
                                                        .styleFrom(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20.0),
                                                      ),
                                                      side: const BorderSide(
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                    onPressed: () async {
                                                      if (formKey2.currentState!
                                                          .validate()) {
                                                        String expCatName =
                                                            expenseTypeController
                                                                .text;
                                                        final conn =
                                                            await onConnToDb();
                                                        var results = await conn
                                                            .query(
                                                                'UPDATE expenses SET exp_name = ? WHERE exp_ID = ?',
                                                                [
                                                              expCatName,
                                                              expTypeId
                                                            ]);
                                                        if (results
                                                                .affectedRows! >
                                                            0) {
                                                          _onShowSnack(
                                                              Colors.green,
                                                              'نوعیت (کتگوری) مصارف موفقانه تغییر کرد.');
                                                          onUpdate();
                                                        } else {
                                                          _onShowSnack(
                                                              Colors.red,
                                                              'متاسفم، شما هیچ تغییرانی نیاوردید.');
                                                        }
                                                        Navigator.pop(context);
                                                      }
                                                    },
                                                    child: const Text(
                                                        'تغییر دادن'),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Form(
                                        key: formKey,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    top: 30.0,
                                                    left: 20,
                                                    right: 20),
                                                child: TextFormField(
                                                  controller:
                                                      itemNameController,
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'نام جنس مصرفی نمی تواند خالی باشد.';
                                                    }
                                                  },
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: 'نام جنس',
                                                    suffixIcon: Icon(Icons
                                                        .bakery_dining_outlined),
                                                    enabledBorder: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    50.0)),
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.grey)),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    50.0)),
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.blue)),
                                                    errorBorder: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    50.0)),
                                                        borderSide: BorderSide(
                                                            color: Colors.red)),
                                                    focusedErrorBorder:
                                                        OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        50.0)),
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .red,
                                                                    width:
                                                                        1.5)),
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    flex: 2,
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 30.0,
                                                              left: 20,
                                                              right: 20),
                                                      child: TextFormField(
                                                        controller:
                                                            qtyController,
                                                        inputFormatters: [
                                                          FilteringTextInputFormatter
                                                              .allow(RegExp(
                                                                  r'[0-9.]'))
                                                        ],
                                                        validator: (value) {
                                                          if (value!
                                                              .isNotEmpty) {
                                                            final qty =
                                                                double.tryParse(
                                                                    value!);
                                                            if (qty! < 1 ||
                                                                qty > 100) {
                                                              return 'تعداد/مقدار باید بین 1 و 100 واحد باشد.';
                                                            }
                                                          } else if (value
                                                              .isEmpty) {
                                                            return 'تعداد/مقدار نمی تواند خالی باشد.';
                                                          }
                                                        },
                                                        onChanged:
                                                            onSetTotalPrice,
                                                        decoration:
                                                            const InputDecoration(
                                                          border:
                                                              OutlineInputBorder(),
                                                          labelText:
                                                              'تعداد/مقدار واحد',
                                                          suffixIcon: Icon(Icons
                                                              .production_quantity_limits_outlined),
                                                          enabledBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          50.0)),
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .grey)),
                                                          focusedBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          50.0)),
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .blue)),
                                                          errorBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          50.0)),
                                                              borderSide:
                                                                  BorderSide(
                                                                      color: Colors
                                                                          .red)),
                                                          focusedErrorBorder: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius.all(
                                                                      Radius.circular(
                                                                          50.0)),
                                                              borderSide:
                                                                  BorderSide(
                                                                      color: Colors
                                                                          .red,
                                                                      width:
                                                                          1.5)),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 30.0,
                                                              left: 20,
                                                              right: 20),
                                                      child: InputDecorator(
                                                        decoration:
                                                            const InputDecoration(
                                                          border:
                                                              OutlineInputBorder(),
                                                          labelText: 'واحد',
                                                          enabledBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          50.0)),
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .grey)),
                                                          focusedBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          50.0)),
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .blue)),
                                                          errorBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          50.0)),
                                                              borderSide:
                                                                  BorderSide(
                                                                      color: Colors
                                                                          .red)),
                                                          focusedErrorBorder: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius.all(
                                                                      Radius.circular(
                                                                          50.0)),
                                                              borderSide:
                                                                  BorderSide(
                                                                      color: Colors
                                                                          .red,
                                                                      width:
                                                                          1.5)),
                                                        ),
                                                        child:
                                                            DropdownButtonHideUnderline(
                                                          child: Container(
                                                            height: 26.0,
                                                            child:
                                                                DropdownButton(
                                                              isExpanded: true,
                                                              icon: const Icon(Icons
                                                                  .arrow_drop_down),
                                                              value:
                                                                  selectedUnit,
                                                              items: unitsItems
                                                                  .map((String
                                                                      positionItems) {
                                                                return DropdownMenuItem(
                                                                  value:
                                                                      positionItems,
                                                                  alignment:
                                                                      Alignment
                                                                          .centerRight,
                                                                  child: Text(
                                                                      positionItems),
                                                                );
                                                              }).toList(),
                                                              onChanged: (String?
                                                                  newValue) {
                                                                setState(() {
                                                                  selectedUnit =
                                                                      newValue!;
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    top: 30.0,
                                                    left: 20,
                                                    right: 20),
                                                child: TextFormField(
                                                  controller: qtyController,
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'تعداد / مقدار نمی تواند خالی باشد.';
                                                    }
                                                  },
                                                  onChanged: onSetTotalPrice,
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: 'تعداد / مقدار',
                                                    suffixIcon: Icon(Icons
                                                        .production_quantity_limits_outlined),
                                                    enabledBorder: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    50.0)),
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.grey)),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    50.0)),
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.blue)),
                                                    errorBorder: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    50.0)),
                                                        borderSide: BorderSide(
                                                            color: Colors.red)),
                                                    focusedErrorBorder:
                                                        OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        50.0)),
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .red,
                                                                    width:
                                                                        1.5)),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    top: 30.0,
                                                    left: 20,
                                                    right: 20),
                                                child: TextFormField(
                                                  controller:
                                                      unitPriceController,
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'قیمت نمی تواند خالی باشد.';
                                                    }
                                                  },
                                                  onChanged: onSetTotalPrice,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .digitsOnly
                                                  ],
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: 'قیمت فی واحد',
                                                    suffixIcon: Icon(Icons
                                                        .price_change_outlined),
                                                    enabledBorder: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    50.0)),
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.grey)),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    50.0)),
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.blue)),
                                                    errorBorder: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    50.0)),
                                                        borderSide: BorderSide(
                                                            color: Colors.red)),
                                                    focusedErrorBorder:
                                                        OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        50.0)),
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .red,
                                                                    width:
                                                                        1.5)),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    top: 30.0,
                                                    left: 20,
                                                    right: 20),
                                                child: TextFormField(
                                                  readOnly: true,
                                                  controller:
                                                      totalPriceController,
                                                  style: const TextStyle(
                                                    color: Colors.blue,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .allow(
                                                            RegExp(r'[0-9.]'))
                                                  ],
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText:
                                                        'جمله / مجموعه پول پرداخت شده',
                                                    suffixIcon:
                                                        Icon(Icons.money),
                                                    enabledBorder: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    50.0)),
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.grey)),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    50.0)),
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.blue)),
                                                    errorBorder: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    50.0)),
                                                        borderSide: BorderSide(
                                                            color: Colors.red)),
                                                    focusedErrorBorder:
                                                        OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        50.0)),
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .red,
                                                                    width:
                                                                        1.5)),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    top: 30.0,
                                                    left: 20,
                                                    right: 20),
                                                child: TextFormField(
                                                  controller: purDateController,
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'تاریخ خرید نمی تواند خالی باشد.';
                                                    }
                                                  },
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
                                                      final String
                                                          formattedDate =
                                                          formatter
                                                              .format(dateTime);
                                                      purDateController.text =
                                                          formattedDate;
                                                    }
                                                  },
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .allow(
                                                            RegExp(r'[0-9.]'))
                                                  ],
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: 'تاریخ خرید جنس',
                                                    suffixIcon: Icon(Icons
                                                        .calendar_month_outlined),
                                                    enabledBorder: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    50.0)),
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.grey)),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    50.0)),
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.blue)),
                                                    errorBorder: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    50.0)),
                                                        borderSide: BorderSide(
                                                            color: Colors.red)),
                                                    focusedErrorBorder:
                                                        OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        50.0)),
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .red,
                                                                    width:
                                                                        1.5)),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    top: 30.0,
                                                    left: 20,
                                                    right: 20),
                                                child: TextFormField(
                                                  controller: descController,
                                                  validator: (value) {
                                                    if (value!.isNotEmpty) {
                                                      if (value.length < 5 ||
                                                          value.length > 30) {
                                                        return 'توضیحات باید بین 5 و 30 حرف باشد.';
                                                      }
                                                    }
                                                  },
                                                  maxLines: 3,
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: 'توضیحات',
                                                    suffixIcon: Icon(Icons
                                                        .description_outlined),
                                                    enabledBorder: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    30.0)),
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.grey)),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    30.0)),
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.blue)),
                                                    errorBorder: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    50.0)),
                                                        borderSide: BorderSide(
                                                            color: Colors.red)),
                                                    focusedErrorBorder:
                                                        OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        50.0)),
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .red,
                                                                    width:
                                                                        1.5)),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    top: 30.0,
                                                    left: 20,
                                                    right: 20),
                                                width: 430.0,
                                                height: 35.0,
                                                child: Builder(
                                                  builder: (context) {
                                                    return OutlinedButton(
                                                      style: OutlinedButton
                                                          .styleFrom(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.0),
                                                        ),
                                                        side: const BorderSide(
                                                          color: Colors.blue,
                                                        ),
                                                      ),
                                                      onPressed: () async {
                                                        if (formKey
                                                            .currentState!
                                                            .validate()) {
                                                          String expItem =
                                                              itemNameController
                                                                  .text;
                                                          double itemQty =
                                                              double.parse(
                                                                  qtyController
                                                                      .text);
                                                          double unitPrice =
                                                              double.parse(
                                                                  unitPriceController
                                                                      .text);
                                                          String purDate =
                                                              purDateController
                                                                  .text;
                                                          String desc =
                                                              descController
                                                                  .text;

                                                          final conn =
                                                              await onConnToDb();
                                                          var results =
                                                              await conn.query(
                                                                  'UPDATE expense_detail SET item_name = ?, quantity = ?, qty_unit = ?, unit_price = ?, total = ?, purchase_date = ?, note = ? WHERE exp_detail_ID = ?',
                                                                  [
                                                                expItem,
                                                                itemQty,
                                                                selectedUnit,
                                                                unitPrice,
                                                                totalPrice,
                                                                purDate,
                                                                desc,
                                                                ExpenseInfo
                                                                    .exp_detail_ID
                                                              ]);

                                                          if (results
                                                                  .affectedRows! >
                                                              0) {
                                                            _onShowSnack(
                                                                Colors.green,
                                                                'جنس مورد مصرف موفقانه تغییر کرد.');
                                                            onUpdateItem();
                                                            await conn.close();
                                                          } else {
                                                            _onShowSnack(
                                                                Colors.red,
                                                                'متاسفم، شما هیچ تغییراتی نیاوردید.');
                                                          }
                                                          Navigator.pop(
                                                              context);
                                                        }
                                                      },
                                                      child: const Text(
                                                          'تغییر دادن'),
                                                    );
                                                  },
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
                          child: TextButton(
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
          },
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
  final int expTypeID;
  final String expenseType;
  final String expenseItem;
  final double quantity;
  final String qtyUnit;
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
      required this.expTypeID,
      required this.expenseType,
      required this.expenseItem,
      required this.quantity,
      required this.qtyUnit,
      required this.unitPrice,
      required this.totalPrice,
      required this.purchasedBy,
      required this.purchasedDate,
      required this.description,
      required this.expenseDetail,
      required this.editExpense,
      required this.deleteExpense});
}

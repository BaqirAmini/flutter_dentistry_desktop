import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dentistry/config/global_usage.dart';
import 'package:flutter_dentistry/config/language_provider.dart';
import 'package:flutter_dentistry/config/translations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as intl2;
import '/views/finance/expenses/expense_info.dart';
import 'db_conn.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xls;
import 'package:pdf/widgets.dart' as pw;

// Create the global key at the top level of your Dart file
final GlobalKey<ScaffoldMessengerState> _globalKeyExpDM =
    GlobalKey<ScaffoldMessengerState>();
// ignore: prefer_typing_uninitialized_variables
var selectedLanguage;
// ignore: prefer_typing_uninitialized_variables
var isEnglish;

// It increments by 1 by any occurance of outputs (excel or pdf)
int outputCounter = 1;
// This function create excel output when called.
void createExcelForExpenses() async {
  final conn = await onConnToDb();

  // Query data from the database.
  // if expFilterValue = 'همه' then it should not use WHERE to filter.
  final results = expFilterValue == 'همه'
      ? await conn.query(
          'SELECT  A.exp_name, B.item_name, B.quantity, CONCAT(B.unit_price, \' افغانی \'), CONCAT(B.total, \' افغانی \'), CONCAT(C.firstname, \' \', C.lastname), DATE_FORMAT(B.purchase_date, "%Y-%m-%d"), B.note FROM expenses A INNER JOIN expense_detail B ON A.exp_ID = B.exp_ID INNER JOIN staff C ON B.purchased_by = C.staff_ID ORDER BY B.purchase_date DESC;')
      : await conn.query(
          'SELECT  A.exp_name, B.item_name, B.quantity, CONCAT(B.unit_price, \' افغانی \'), CONCAT(B.total, \' افغانی \'), CONCAT(C.firstname, \' \', C.lastname), DATE_FORMAT(B.purchase_date, "%Y-%m-%d"), B.note FROM expenses A INNER JOIN expense_detail B ON A.exp_ID = B.exp_ID INNER JOIN staff C ON B.purchased_by = C.staff_ID WHERE A.exp_ID = ? ORDER BY B.purchase_date DESC;',
          [expFilterValue]);

  // Create a new Excel document.
  final xls.Workbook workbook = xls.Workbook();
  final xls.Worksheet sheet = workbook.worksheets[0];

  // Define column titles.
  var columnTitles = [
    'Expense Category',
    'Item Name',
    'Quantity',
    'Unit Price',
    'Total',
    'Burchased By',
    'Purchase Date',
    'Details',
  ];

  // Write column titles to the first row.
  for (var i = 0; i < columnTitles.length; i++) {
    sheet.getRangeByIndex(1, i + 1).setText(columnTitles[i]);
  }

  // Populate the sheet with data from the database.
  var rowIndex =
      1; // Start from the second row as the first row is used for column titles.
  for (var row in results) {
    for (var i = 0; i < row.length; i++) {
      sheet.getRangeByIndex(rowIndex + 1, i + 1).setText(row[i].toString());
    }
    rowIndex++;
  }

  // Save the Excel file.
  final List<int> bytes = workbook.saveAsStream();
  // Get the directory to save the Excel file.
  final Directory directory = await getApplicationDocumentsDirectory();
  final String path = directory.path;
  final File file = File('$path/Expenses (${outputCounter++}).xlsx');

  try {
    // Write the Excel file.
    await file.writeAsBytes(bytes, flush: true);
  } catch (e) {
    print('Creating excel for expenses failed: $e');
  }

  // Open the file
  await OpenFile.open(file.path);

  // Close the database connection.
  await conn.close();
}

// This function generates PDF output when called.
void createPdfForExpenses() async {
  final conn = await onConnToDb();

  // Query data from the database.
  // if expFilterValue = 'همه' then it should not use WHERE to filter.
  final results = expFilterValue == 'همه'
      ? await conn.query(
          'SELECT  A.exp_name, B.item_name, B.quantity, CONCAT(B.unit_price, \' افغانی \'), CONCAT(B.total, \' افغانی \'), CONCAT(C.firstname, \' \', C.lastname), DATE_FORMAT(B.purchase_date, "%Y-%m-%d"), B.note FROM expenses A INNER JOIN expense_detail B ON A.exp_ID = B.exp_ID INNER JOIN staff C ON B.purchased_by = C.staff_ID ORDER BY B.purchase_date DESC;')
      : await conn.query(
          'SELECT  A.exp_name, B.item_name, B.quantity, CONCAT(B.unit_price, \' افغانی \'), CONCAT(B.total, \' افغانی \'), CONCAT(C.firstname, \' \', C.lastname), DATE_FORMAT(B.purchase_date, "%Y-%m-%d"), B.note FROM expenses A INNER JOIN expense_detail B ON A.exp_ID = B.exp_ID INNER JOIN staff C ON B.purchased_by = C.staff_ID WHERE A.exp_ID = ? ORDER BY B.purchase_date DESC;',
          [expFilterValue]);

  // Create a new PDF document.
  final pdf = pw.Document();
  final fontData = await rootBundle.load('assets/fonts/per_sans_font.ttf');
  final ttf = pw.Font.ttf(fontData);

  // Define column titles.
  var columnTitles = [
    'Expense Category',
    'Item Name',
    'Quantity',
    'Unit Price',
    'Total',
    'Burchased By',
    'Purchase Date',
    'Details',
  ];

  // Populate the PDF with data from the database.
  pdf.addPage(pw.MultiPage(
    build: (context) => [
      pw.Directionality(
        textDirection: pw.TextDirection.rtl,
        child: pw.TableHelper.fromTextArray(
          cellPadding: const pw.EdgeInsets.all(3.0),
          defaultColumnWidth: const pw.FixedColumnWidth(150.0),
          context: context,
          data: <List<String>>[
            columnTitles,
            ...results
                .map((row) => row.map((item) => item.toString()).toList()),
          ],
          border: null, // Remove cell borders
          headerStyle: pw.TextStyle(
            font: ttf,
            fontSize: 10.0,
            wordSpacing: 3.0,
            fontWeight: pw.FontWeight.bold,
            color: const PdfColor(51 / 255, 153 / 255, 255 / 255),
          ),
          cellStyle: pw.TextStyle(
              font: ttf,
              fontSize: 10.0,
              wordSpacing: 3.0,
              fontWeight: pw.FontWeight.bold),
        ),
      ),
    ],
  ));

  // Save the PDF file.
  final output = await getTemporaryDirectory();
  final file = File('${output.path}/Expenses (${outputCounter++}).pdf');
  await file.writeAsBytes(await pdf.save(), flush: true);

  // Open the file
  await OpenFile.open(file.path);

  // Close the database connection.
  await conn.close();
}

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
  const ExpenseData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ExpenseDataTable();
  }
}

// Data table widget is here
class ExpenseDataTable extends StatefulWidget {
  const ExpenseDataTable({Key? key}) : super(key: key);

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

// Create instance of this class to its members
  final GlobalUsage _gu = GlobalUsage();

  @override
  Widget build(BuildContext context) {
    // Fetch translations keys based on the selected language.
    var languageProvider = Provider.of<LanguageProvider>(context);
    selectedLanguage = languageProvider.selectedLanguage;
    isEnglish = selectedLanguage == 'English';
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
                        labelText:
                            translations[selectedLanguage]?['Search'] ?? '',
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
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: translations[selectedLanguage]
                                ?['FilterByType'] ??
                            '',
                        enabledBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: Colors.grey)),
                        focusedBorder: const OutlineInputBorder(
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
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(translations[selectedLanguage]?['AllExpenses'] ?? '',
                      style: Theme.of(context).textTheme.headlineSmall),
                  SizedBox(
                    width: 80.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Tooltip(
                          message: 'Excel',
                          child: InkWell(
                            onTap: createExcelForExpenses,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.blue, width: 2.0),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Icon(
                                  FontAwesomeIcons.fileExcel,
                                  color: Colors.blue,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Tooltip(
                          message: 'PDF',
                          child: InkWell(
                            onTap: createPdfForExpenses,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.blue, width: 2.0),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Icon(
                                  FontAwesomeIcons.filePdf,
                                  color: Colors.blue,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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
                header: null,
                // header: const Text("همه مصارف |"),
                columns: [
                  DataColumn(
                    label: Text(
                      translations[selectedLanguage]?['ExpenseType'] ?? '',
                      style: const TextStyle(
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
                    label: Text(
                      translations[selectedLanguage]?['Item'] ?? '',
                      style: const TextStyle(
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
                    label: Text(
                      translations[selectedLanguage]?['QtyAmount'] ?? '',
                      style: const TextStyle(
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
                    label: Text(
                      translations[selectedLanguage]?['UnitPrice'] ?? '',
                      style: const TextStyle(
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
                    label: Text(
                      translations[selectedLanguage]?['TotalPrice'] ?? '',
                      style: const TextStyle(
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
                    label: Text(
                      translations[selectedLanguage]?['PurDate'] ?? '',
                      style: const TextStyle(
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
                  DataColumn(
                    label: Text(
                      translations[selectedLanguage]?['Details'] ?? '',
                      style: const TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                      label: Text(translations[selectedLanguage]?['Edit'] ?? '',
                          style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text(
                          translations[selectedLanguage]?['Delete'] ?? '',
                          style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold))),
                ],
                source: dataSource,
                rowsPerPage:
                    _filteredData.length < _gu.calculateRowsPerPage(context)
                        ? _filteredData.length
                        : _gu.calculateRowsPerPage(context),
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
      DataCell(Text(
          '${data[index].unitPrice} ${translations[selectedLanguage]?['Afn'] ?? ''}')),
      DataCell(Text(
          '${data[index].totalPrice} ${translations[selectedLanguage]?['Afn'] ?? ''}')),
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
            title: Directionality(
              textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
              child:
                  Text(translations[selectedLanguage]?['DeleteHeading'] ?? ''),
            ),
            content: Directionality(
              textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
              child: Text(
                  '${translations[selectedLanguage]?['DeleteExpConfirm'] ?? ''}${ExpenseInfo.itemName}?'),
            ),
            actions: [
              Row(
                mainAxisAlignment:
                    isEnglish ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
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
                        _onShowSnack(
                            Colors.green,
                            translations[selectedLanguage]
                                    ?['DeleteExpSuccess'] ??
                                '');
                        onDelete();
                        await conn.close();
                      } else {
                        _onShowSnack(
                            Colors.red,
                            translations[selectedLanguage]?['DeleteExpError'] ??
                                '');
                      }
                      // ignore: use_build_context_synchronously
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: const Text('حذف'),
                  ),
                ],
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
    totalPriceController.text =
        '$totalPrice ${translations[selectedLanguage]?['Afn'] ?? ''}';
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
                textDirection:
                    isEnglish ? TextDirection.ltr : TextDirection.rtl,
                child: DefaultTabController(
                  length: 2,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Column(
                      children: [
                        Expanded(
                          child: Center(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  TabBar(
                                    labelColor: Colors.blue,
                                    unselectedLabelColor: Colors.grey,
                                    tabs: [
                                      Tab(
                                        text: translations[selectedLanguage]
                                                ?['EditExpType'] ??
                                            '',
                                        icon: const Icon(Icons.edit_outlined),
                                      ),
                                      Tab(
                                        text: translations[selectedLanguage]
                                                ?['EditExpItem'] ??
                                            '',
                                        icon: const Icon(Icons.edit_outlined),
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
                                                      return translations[
                                                                  selectedLanguage]
                                                              ?['ETRequired'] ??
                                                          '';
                                                    } else if (value.length <
                                                            3 ||
                                                        value.length > 20) {
                                                      return translations[
                                                                  selectedLanguage]
                                                              ?['ETLength'] ??
                                                          '';
                                                    }
                                                  },
                                                  decoration: InputDecoration(
                                                    border:
                                                        const OutlineInputBorder(),
                                                    labelText: translations[
                                                                selectedLanguage]
                                                            ?['EpxenseType'] ??
                                                        '',
                                                    suffixIcon: const Icon(Icons
                                                        .category_outlined),
                                                    enabledBorder:
                                                        const OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        50.0)),
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .grey)),
                                                    focusedBorder:
                                                        const OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        50.0)),
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .blue)),
                                                    errorBorder:
                                                        const OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        50.0)),
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .red)),
                                                    focusedErrorBorder:
                                                        const OutlineInputBorder(
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
                                                                  .circular(
                                                                      20.0),
                                                        ),
                                                        side: const BorderSide(
                                                          color: Colors.blue,
                                                        ),
                                                      ),
                                                      onPressed: () async {
                                                        if (formKey2
                                                            .currentState!
                                                            .validate()) {
                                                          String expCatName =
                                                              expenseTypeController
                                                                  .text;
                                                          final conn =
                                                              await onConnToDb();
                                                          var results =
                                                              await conn.query(
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
                                                                translations[
                                                                            selectedLanguage]
                                                                        ?[
                                                                        'StaffEditMsg'] ??
                                                                    '');
                                                            onUpdate();
                                                          } else {
                                                            _onShowSnack(
                                                                Colors.red,
                                                                translations[
                                                                            selectedLanguage]
                                                                        ?[
                                                                        'StaffEditErrMsg'] ??
                                                                    '');
                                                          }
                                                          Navigator.pop(
                                                              context);
                                                        }
                                                      },
                                                      child: Text(translations[
                                                                  selectedLanguage]
                                                              ?['Edit'] ??
                                                          ''),
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
                                                        return translations[
                                                                    selectedLanguage]
                                                                ?[
                                                                'ItemRequired'] ??
                                                            '';
                                                      }
                                                    },
                                                    decoration: InputDecoration(
                                                      border:
                                                          const OutlineInputBorder(),
                                                      labelText: translations[
                                                                  selectedLanguage]
                                                              ?['Item'] ??
                                                          '',
                                                      suffixIcon: const Icon(Icons
                                                          .bakery_dining_outlined),
                                                      enabledBorder: const OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          50.0)),
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .grey)),
                                                      focusedBorder: const OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          50.0)),
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .blue)),
                                                      errorBorder: const OutlineInputBorder(
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
                                                          const OutlineInputBorder(
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
                                                        margin: const EdgeInsets
                                                            .only(
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
                                                              final qty = double
                                                                  .tryParse(
                                                                      value!);
                                                              if (qty! < 1 ||
                                                                  qty > 100) {
                                                                return translations[
                                                                            selectedLanguage]
                                                                        ?[
                                                                        'itemQtyMsg'] ??
                                                                    '';
                                                              }
                                                            } else if (value
                                                                .isEmpty) {
                                                              return translations[
                                                                          selectedLanguage]
                                                                      ?[
                                                                      'ItemQtyRequired'] ??
                                                                  '';
                                                            }
                                                          },
                                                          onChanged:
                                                              onSetTotalPrice,
                                                          decoration:
                                                              InputDecoration(
                                                            border:
                                                                const OutlineInputBorder(),
                                                            labelText: translations[
                                                                        selectedLanguage]
                                                                    ?[
                                                                    'QtyAmount'] ??
                                                                '',
                                                            suffixIcon:
                                                                const Icon(Icons
                                                                    .production_quantity_limits_outlined),
                                                            enabledBorder: const OutlineInputBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            50.0)),
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .grey)),
                                                            focusedBorder: const OutlineInputBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            50.0)),
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .blue)),
                                                            errorBorder: const OutlineInputBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            50.0)),
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .red)),
                                                            focusedErrorBorder: const OutlineInputBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
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
                                                        margin: const EdgeInsets
                                                            .only(
                                                            top: 30.0,
                                                            left: 20,
                                                            right: 20),
                                                        child: InputDecorator(
                                                          decoration:
                                                              InputDecoration(
                                                            border:
                                                                const OutlineInputBorder(),
                                                            labelText: translations[
                                                                        selectedLanguage]
                                                                    ?[
                                                                    'Units'] ??
                                                                '',
                                                            enabledBorder: const OutlineInputBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            50.0)),
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .grey)),
                                                            focusedBorder: const OutlineInputBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            50.0)),
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .blue)),
                                                            errorBorder: const OutlineInputBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            50.0)),
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .red)),
                                                            focusedErrorBorder: const OutlineInputBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
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
                                                                isExpanded:
                                                                    true,
                                                                icon: const Icon(
                                                                    Icons
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
                                                    controller:
                                                        unitPriceController,
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return translations[
                                                                    selectedLanguage]
                                                                ?[
                                                                'UPRequired'] ??
                                                            '';
                                                      }
                                                    },
                                                    onChanged: onSetTotalPrice,
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .digitsOnly
                                                    ],
                                                    decoration: InputDecoration(
                                                      border:
                                                          const OutlineInputBorder(),
                                                      labelText: translations[
                                                                  selectedLanguage]
                                                              ?['UnitPrice'] ??
                                                          '',
                                                      suffixIcon: const Icon(Icons
                                                          .price_change_outlined),
                                                      enabledBorder: const OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          50.0)),
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .grey)),
                                                      focusedBorder: const OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          50.0)),
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .blue)),
                                                      errorBorder: const OutlineInputBorder(
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
                                                          const OutlineInputBorder(
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .allow(
                                                              RegExp(r'[0-9.]'))
                                                    ],
                                                    decoration: InputDecoration(
                                                      border:
                                                          const OutlineInputBorder(),
                                                      labelText: translations[
                                                                  selectedLanguage]
                                                              ?['TotalPrice'] ??
                                                          '',
                                                      suffixIcon: const Icon(
                                                          Icons.money),
                                                      enabledBorder: const OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          50.0)),
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .grey)),
                                                      focusedBorder: const OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          50.0)),
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .blue)),
                                                      errorBorder: const OutlineInputBorder(
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
                                                          const OutlineInputBorder(
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
                                                        purDateController,
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return translations[
                                                                    selectedLanguage]
                                                                ?[
                                                                'PurDateRequired'] ??
                                                            '';
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
                                                                  DateTime
                                                                      .now(),
                                                              firstDate:
                                                                  DateTime(
                                                                      1900),
                                                              lastDate:
                                                                  DateTime(
                                                                      2100));
                                                      if (dateTime != null) {
                                                        final intl2.DateFormat
                                                            formatter =
                                                            intl2.DateFormat(
                                                                'yyyy-MM-dd');
                                                        final String
                                                            formattedDate =
                                                            formatter.format(
                                                                dateTime);
                                                        purDateController.text =
                                                            formattedDate;
                                                      }
                                                    },
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .allow(
                                                              RegExp(r'[0-9.]'))
                                                    ],
                                                    decoration: InputDecoration(
                                                      border:
                                                          const OutlineInputBorder(),
                                                      labelText: translations[
                                                                  selectedLanguage]
                                                              ?['PurDate'] ??
                                                          '',
                                                      suffixIcon: const Icon(Icons
                                                          .calendar_month_outlined),
                                                      enabledBorder: const OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          50.0)),
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .grey)),
                                                      focusedBorder: const OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          50.0)),
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .blue)),
                                                      errorBorder: const OutlineInputBorder(
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
                                                          const OutlineInputBorder(
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
                                                            value.length > 40) {
                                                          return translations[
                                                                      selectedLanguage]
                                                                  ?[
                                                                  'OtherDDLDetail'] ??
                                                              '';
                                                        }
                                                      }
                                                    },
                                                    maxLines: 3,
                                                    decoration: InputDecoration(
                                                      border:
                                                          const OutlineInputBorder(),
                                                      labelText: translations[
                                                                  selectedLanguage]
                                                              ?['RetDetails'] ??
                                                          '',
                                                      suffixIcon: const Icon(Icons
                                                          .description_outlined),
                                                      enabledBorder: const OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          30.0)),
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .grey)),
                                                      focusedBorder: const OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          30.0)),
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .blue)),
                                                      errorBorder: const OutlineInputBorder(
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
                                                          const OutlineInputBorder(
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
                                                          side:
                                                              const BorderSide(
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
                                                                  translations[
                                                                              selectedLanguage]
                                                                          ?[
                                                                          'StaffEditMsg'] ??
                                                                      '');
                                                              onUpdateItem();
                                                              await conn
                                                                  .close();
                                                            } else {
                                                              _onShowSnack(
                                                                  Colors.red,
                                                                  translations[
                                                                              selectedLanguage]
                                                                          ?[
                                                                          'StaffEditErrMsg'] ??
                                                                      '');
                                                            }
                                                            // ignore: use_build_context_synchronously
                                                            Navigator.pop(
                                                                context);
                                                          }
                                                        },
                                                        child: Text(translations[
                                                                    selectedLanguage]
                                                                ?['Edit'] ??
                                                            ''),
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
                          ),
                        ), // Footer of the dialog
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(translations[selectedLanguage]
                                    ?['CancelBtn'] ??
                                ''),
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
        // Get expenses info to later use
        String? expCtg = ExpenseInfo.expenseCategory;
        String? itemName = ExpenseInfo.itemName;
        String? purchasedBy = ExpenseInfo.purchasedBy;
        String? descrip = ExpenseInfo.description;
        double? itemQty = ExpenseInfo.qty;
        String? qtyUnit = ExpenseInfo.qtyUnit;
        double? uPrice = ExpenseInfo.unitPrice;
        return AlertDialog(
          title: Directionality(
            textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
            child: Text(
              translations[selectedLanguage]?['ExpDetail'] ?? '',
              style: const TextStyle(
                  color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ),
          content: Directionality(
            textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
            child: Directionality(
              textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.45,
                height: MediaQuery.of(context).size.height * 0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      color: const Color.fromARGB(255, 240, 239, 239),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            translations[selectedLanguage]?['ExpenseType'] ??
                                '',
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Color.fromARGB(255, 118, 116, 116),
                            ),
                          ),
                          Text('$expCtg'),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 240.0,
                          padding: const EdgeInsets.all(10.0),
                          color: const Color.fromARGB(255, 240, 239, 239),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                translations[selectedLanguage]?['Item'] ?? '',
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Color.fromARGB(255, 118, 116, 116),
                                ),
                              ),
                              Text('$itemName'),
                            ],
                          ),
                        ),
                        Container(
                          width: 240.0,
                          padding: const EdgeInsets.all(10.0),
                          color: const Color.fromARGB(255, 240, 239, 239),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                translations[selectedLanguage]?['QtyAmount'] ??
                                    '',
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Color.fromARGB(255, 118, 116, 116),
                                ),
                              ),
                              Text('$itemQty $qtyUnit'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 240.0,
                          padding: const EdgeInsets.all(10.0),
                          color: const Color.fromARGB(255, 240, 239, 239),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                translations[selectedLanguage]
                                        ?['PurchasedBy'] ??
                                    '',
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Color.fromARGB(255, 118, 116, 116),
                                ),
                              ),
                              Text('$purchasedBy'),
                            ],
                          ),
                        ),
                        Container(
                          width: 240.0,
                          padding: const EdgeInsets.all(10.0),
                          color: const Color.fromARGB(255, 240, 239, 239),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                translations[selectedLanguage]?['UnitPrice'] ??
                                    '',
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Color.fromARGB(255, 118, 116, 116),
                                ),
                              ),
                              Text(
                                  '$uPrice ${translations[selectedLanguage]?['Afn'] ?? ''}'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      color: const Color.fromARGB(255, 240, 239, 239),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            translations[selectedLanguage]?['RetDetails'] ?? '',
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Color.fromARGB(255, 118, 116, 116),
                            ),
                          ),
                          Text('$descrip'),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () => print('Invoice Clicked.'),
                        child: Image.asset(
                          'assets/graphics/login_img1.png',
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment:
                  isEnglish ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(translations[selectedLanguage]?['Okay'] ?? ''),
                ),
              ],
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

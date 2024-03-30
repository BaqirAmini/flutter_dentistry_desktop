import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dentistry/config/developer_options.dart';
import 'package:flutter_dentistry/config/global_usage.dart';
import 'package:flutter_dentistry/config/language_provider.dart';
import 'package:flutter_dentistry/config/translations.dart';
import 'package:flutter_dentistry/models/db_conn.dart';
import 'package:flutter_dentistry/views/staff/new_staff.dart';
import 'package:flutter_dentistry/views/staff/staff_detail.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galileo_mysql/galileo_mysql.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xls;
import 'staff_info.dart';
import 'package:intl/intl.dart' as intl2;
import 'package:path/path.dart' as p;
import 'package:pdf/widgets.dart' as pw;

// Create the global key at the top level of your Dart file
final GlobalKey<ScaffoldMessengerState> _globalKey3 =
    GlobalKey<ScaffoldMessengerState>();

int pdfOutputCounter = 1;
int excelOutputCounter = 1;
// This function create excel output when called.
void createExcelForStaff() async {
  final conn = await onConnToDb();

  // Query data from the database.
  var results = await conn.query(
      'SELECT staff_ID, firstname, lastname, position, salary, phone, tazkira_ID, COALESCE(address, \' \'), COALESCE(DATE_FORMAT(hire_date, "%M %d, %Y"), \'--\'), COALESCE(CONCAT(prepayment, \' افغانی \'), \'--\'), family_phone1 FROM staff');

  // Create a new Excel document.
  final xls.Workbook workbook = xls.Workbook();
  final xls.Worksheet sheet = workbook.worksheets[0];

  // Define column titles.
  var columnTitles = [
    'Staff ID',
    'First Name',
    'Last Name',
    'Position',
    'Salary',
    'Phone',
    'Tazkira ID',
    'Address',
    'Hire Date',
    'Prepayment',
    'Family Phone'
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
  final File file = File('$path/Staff (${excelOutputCounter++}).xlsx');

  // Write the Excel file.
  await file.writeAsBytes(bytes, flush: true);

  // Open the file
  await OpenFile.open(file.path);

  // Close the database connection.
  await conn.close();
}

// This function generates PDF output when called.
void createPdfForStaff() async {
  final conn = await onConnToDb();

  // Query data from the database.
  var results = await conn.query(
      'SELECT staff_ID, firstname, lastname, position, salary, phone, tazkira_ID, COALESCE(address, \' \'), COALESCE(DATE_FORMAT(hire_date, "%M %d, %Y"), \'--\'), COALESCE(CONCAT(prepayment, \' افغانی \'), \'--\'), family_phone1 FROM staff');

  // Create a new PDF document.
  final pdf = pw.Document();
  final fontData = await rootBundle.load('assets/fonts/per_sans_font.ttf');
  final ttf = pw.Font.ttf(fontData);

  // Define column titles.
  var columnTitles = [
    'Staff ID',
    'First Name',
    'Last Name',
    'Position',
    'Salary',
    'Phone',
    'Tazkira ID',
    'Address',
    'Hire Date',
    'Prepayment',
    'Family Phone'
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
  final file = File('${output.path}/Staff (${pdfOutputCounter++}).pdf');
  await file.writeAsBytes(await pdf.save(), flush: true);

  // Open the file
  await OpenFile.open(file.path);

  // Close the database connection.
  await conn.close();
}

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

// ignore: prefer_typing_uninitialized_variables
var selectedLanguage;
// ignore: prefer_typing_uninitialized_variables
var isEnglish;

class Staff extends StatelessWidget {
  const Staff({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fetch translations keys based on the selected language.
    var languageProvider = Provider.of<LanguageProvider>(context);
    selectedLanguage = languageProvider.selectedLanguage;
    isEnglish = selectedLanguage == 'English';
    return ScaffoldMessenger(
      key: _globalKey3,
      child: Directionality(
        textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text(translations[selectedLanguage]?['Staff'] ?? ''),
          ),
          body: const MyDataTable(),
        ),
      ),
    );
  }
}

// Data table widget is here
class MyDataTable extends StatefulWidget {
  const MyDataTable({Key? key}) : super(key: key);

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
        'SELECT photo, firstname, lastname, position, salary, phone, tazkira_ID, address, staff_ID, DATE_FORMAT(hire_date, "%M %d, %Y"), prepayment, family_phone1, family_phone2, contract_file, file_type FROM staff ORDER BY staff_ID desc');
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
        hireDate: row[9].toString(),
        prepayment: row[10] ?? 0,
        familyPhone1: row[11] ?? '',
        familyPhone2: row[12] ?? '',
        contractFile:
            row[13] == null ? null : Uint8List.fromList(row[13].toBytes()),
        fileType: row[14],
      );
    }).toList();
    _filteredData = List.from(_data);

    // Notify the framework that the state of the widget has changed
    setState(() {
      // Print the data that was fetched from the database
      print('Data from database: $_data');
    });
  }

  // Create instance of this class to its members
  final GlobalUsage _gu = GlobalUsage();

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
                    labelText: translations[selectedLanguage]?['Search'] ?? '',
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
              if (StaffInfo.staffRole == 'مدیر سیستم' ||
                  StaffInfo.staffRole == 'Software Engineer')
                ElevatedButton(
                  onPressed: () async {
                    if (await Features.staffLimitReached()) {
                      _onShowSnack(Colors.red,
                          translations[selectedLanguage]?['RecordLimitMsg'] ?? '');
                    } else {
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const NewStaff()))
                          .then((_) {
                        _fetchData();
                      });
                    }
                  },
                  child: Text(
                      translations[selectedLanguage]?['AddNewStaff'] ?? ''),
                ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${translations[selectedLanguage]?['AllStaff'] ?? ''} | ',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(
                width: 80.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Tooltip(
                      message: 'Excel',
                      child: InkWell(
                        onTap: createExcelForStaff,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.blue, width: 2.0),
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
                        onTap: createPdfForStaff,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.blue, width: 2.0),
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
                  header: null,
                  sortColumnIndex: _sortColumnIndex,
                  sortAscending: _sortAscending,
                  columns: [
                    DataColumn(
                        label: Text(
                          translations[selectedLanguage]?['Photo'] ?? '',
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: isEnglish ? 11 : null),
                        ),
                        numeric: true),
                    DataColumn(
                      label: Text(
                        translations[selectedLanguage]?['FName'] ?? '',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: isEnglish ? 11 : null),
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
                      label: Text(
                        translations[selectedLanguage]?['LName'] ?? '',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: isEnglish ? 11 : null),
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
                      label: Text(
                        translations[selectedLanguage]?['Position'] ?? '',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: isEnglish ? 11 : null),
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
                      label: Text(
                        translations[selectedLanguage]?['Phone'] ?? '',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: isEnglish ? 11 : null),
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
                      label: Text(
                        translations[selectedLanguage]?['Tazkira'] ?? '',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: isEnglish ? 11 : null),
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
                      label: Text(
                        translations[selectedLanguage]?['Address'] ?? '',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: isEnglish ? 11 : null),
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
                    if (StaffInfo.staffRole == 'مدیر سیستم' ||
                        StaffInfo.staffRole == 'Software Engineer')
                      DataColumn(
                        label: Text(
                          translations[selectedLanguage]?['Actions'] ?? '',
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: isEnglish ? 11 : null),
                        ),
                      ),
                  ],
                  rowsPerPage:
                      _filteredData.length < _gu.calculateRowsPerPage(context)
                          ? _filteredData.length
                          : _gu.calculateRowsPerPage(context),
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
    late ImageProvider _image;
    Uint8List? uint8list = data[index].photo != null
        ? Uint8List.fromList((data[index].photo)!.toBytes())
        : null;
    return DataRow(cells: [
      DataCell(
        CircleAvatar(
          backgroundImage: _image = (uint8list != null)
              ? MemoryImage(uint8list)
              : const AssetImage('assets/graphics/user_profile2.jpg')
                  as ImageProvider,
        ),
      ),
      DataCell(Text(data[index].firstName,
          style: isEnglish ? const TextStyle(fontSize: 12) : null)),
      DataCell(Text(data[index].lastName,
          style: isEnglish ? const TextStyle(fontSize: 12) : null)),
      DataCell(Text(data[index].position,
          style: isEnglish ? const TextStyle(fontSize: 12) : null)),
      DataCell(Text(data[index].phone,
          style: isEnglish ? const TextStyle(fontSize: 12) : null)),
      DataCell(Text(data[index].tazkira,
          style: isEnglish ? const TextStyle(fontSize: 12) : null)),
      DataCell(Text(data[index].address,
          style: isEnglish ? const TextStyle(fontSize: 12) : null)),
      // This condition only allows 'system admin' to edit/delete... the staff
      if (StaffInfo.staffRole == 'مدیر سیستم' ||
          StaffInfo.staffRole == 'Software Engineer')
        DataCell(
          PopupMenuButton(
            splashRadius: 25.0,
            padding: EdgeInsets.zero,
            icon: const Icon(
              Icons.more_horiz,
              color: Colors.blue,
            ),
            tooltip: 'نمایش مینو',
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              PopupMenuItem(
                child: Directionality(
                  textDirection:
                      isEnglish ? TextDirection.ltr : TextDirection.rtl,
                  child: ListTile(
                    leading: const Icon(
                      Icons.list,
                      size: 20.0,
                    ),
                    title: Text(
                      translations[selectedLanguage]?['Details'] ?? '',
                      style: const TextStyle(fontSize: 15.0),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StaffDetail(
                                staffID: data[index].staffID,
                                staffFName: data[index].firstName,
                                staffLName: data[index].lastName,
                                staffPhone: data[index].phone,
                                stafffphone1: data[index].familyPhone1,
                                stafffphone2: data[index].familyPhone2,
                                staffPos: data[index].position,
                                staffSalary: data[index].salary,
                                staffPrPayment: data[index].prepayment,
                                tazkiraID: data[index].tazkira,
                                contractFile: data[index].contractFile,
                                fileType: data[index].fileType,
                                staffAddr: data[index].address,
                                staffHDate: data[index].hireDate),
                          )).then((_) {
                        onUpdate();
                      });
                    },
                  ),
                ),
              ),
              PopupMenuItem(
                child: Directionality(
                  textDirection:
                      isEnglish ? TextDirection.ltr : TextDirection.rtl,
                  child: Builder(builder: (BuildContext context) {
                    return ListTile(
                      leading: const Icon(
                        Icons.lock_person_outlined,
                        size: 20.0,
                      ),
                      title: Text(
                        translations[selectedLanguage]?['StaffUA'] ?? '',
                        style: const TextStyle(fontSize: 15.0),
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
                  textDirection:
                      isEnglish ? TextDirection.ltr : TextDirection.rtl,
                  child: Builder(builder: (BuildContext context) {
                    return ListTile(
                      leading: const Icon(
                        Icons.edit,
                        size: 20.0,
                      ),
                      title: Text(
                        translations[selectedLanguage]?['Edit'] ?? '',
                        style: const TextStyle(fontSize: 15.0),
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
                        double prePayment = staffRow['prepayment'] ?? 0;
                        DateTime? hireDateTime = staffRow['hire_date'];
                        String? hireDate = hireDateTime == null
                            ? null
                            : intl2.DateFormat('yyyy-MM-dd')
                                .format(hireDateTime);
                        String phone = staffRow['phone'];
                        String fPhone1 = staffRow['family_phone1'];
                        String fPhone2 = staffRow['family_phone2'] ?? '';
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
                            prePayment,
                            hireDate ?? '',
                            phone,
                            fPhone1,
                            fPhone2,
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
                  textDirection:
                      isEnglish ? TextDirection.ltr : TextDirection.rtl,
                  child: ListTile(
                    leading: const Icon(
                      Icons.delete,
                      size: 20.0,
                    ),
                    title: Text(
                      translations[selectedLanguage]?['Delete'] ?? '',
                      style: const TextStyle(fontSize: 15.0),
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
          title: Directionality(
            textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
            child: Text(
                '${translations[selectedLanguage]?['Delete'] ?? ''} $firstName $lastName'),
          ),
          content: Directionality(
            textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
            child: Text(
                translations[selectedLanguage]?['ConfirmStaffDelete'] ?? ''),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
              child: Text(translations[selectedLanguage]?['CancelBtn'] ?? ''),
            ),
            TextButton(
              onPressed: () async {
                final conn = await onConnToDb();
                final deleteResult = await conn
                    .query('DELETE FROM staff WHERE staff_ID = ?', [staffId]);
                if (deleteResult.affectedRows! > 0) {
                  _onShowSnack(Colors.green,
                      translations[selectedLanguage]?['DeleteStaffMsg'] ?? '');
                  onDelete();
                }
                await conn.close();
                // ignore: use_build_context_synchronously
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: Text(translations[selectedLanguage]?['Delete'] ?? ''),
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
    double prepayment,
    String hireDate,
    String phoneNum,
    String fPhone1Num,
    String fPhone2Num,
    String tazkira,
    String address,
    Function onUpdate) {
// The global for the form
  final formKey1 = GlobalKey<FormState>();
// The text editing controllers for the TextFormFields
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final hireDateController = TextEditingController();
  final familyPhone1Controller = TextEditingController();
  final familyPhone2Controller = TextEditingController();
  final salaryController = TextEditingController();
  final prePaidController = TextEditingController();
  final tazkiraController = TextEditingController();
  final addressController = TextEditingController();

  const regExOnlyAbc = "[a-zA-Z,، \u0600-\u06FFF]";
  const regExOnlydigits = "[0-9+]";
  final tazkiraPattern = RegExp(r'^\d{4}-\d{4}-\d{5}$');

/* ------------- Set all staff related values into their fields.----------- */
  nameController.text = firstname;
  lastNameController.text = lastname;
  StaffInfo.staffDefaultPosistion = position;
  salaryController.text = salary.toString();
  prePaidController.text = prepayment.toString();
  hireDateController.text = hireDate;
  phoneController.text = phoneNum;
  familyPhone1Controller.text = fPhone1Num;
  familyPhone2Controller.text = fPhone2Num;
  tazkiraController.text = tazkira;
  addressController.text = address;
  File? selectedContractFile;
  bool isLoadingFile = false;
  bool isIntern = position == 'کار آموز' ? true : false;
  final contractFileMessage = ValueNotifier<String>('');
/* ------------- END Set all staff related values into their fields.----------- */
  return showDialog(
    context: context,
    builder: ((context) {
      return StatefulBuilder(
        builder: ((context, setState) {
          return AlertDialog(
            title: Directionality(
              textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
              child: Text(
                '${translations[selectedLanguage]?['Edit'] ?? ''} $firstname $lastname',
                style: const TextStyle(color: Colors.blue),
              ),
            ),
            content: Directionality(
              textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
              child: SingleChildScrollView(
                child: Form(
                  key: formKey1,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 20.0),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                left: 20.0,
                                right: 10.0,
                                top: 10.0,
                                bottom: 10.0),
                            child: TextFormField(
                              controller: nameController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return translations[selectedLanguage]
                                          ?['FNRequired'] ??
                                      '';
                                } else if (value.length < 3 ||
                                    value.length > 10) {
                                  return translations[selectedLanguage]
                                          ?['FNLength'] ??
                                      '';
                                }
                              },
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: translations[selectedLanguage]
                                        ?['FName'] ??
                                    '',
                                suffixIcon:
                                    const Icon(Icons.person_add_alt_outlined),
                                enabledBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50.0)),
                                    borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50.0)),
                                    borderSide: BorderSide(color: Colors.blue)),
                                errorBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50.0)),
                                    borderSide: BorderSide(color: Colors.red)),
                                focusedErrorBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50.0)),
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 1.5)),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                left: 20.0,
                                right: 10.0,
                                top: 10.0,
                                bottom: 10.0),
                            child: TextFormField(
                              controller: lastNameController,
                              validator: (value) {
                                if (value!.isNotEmpty) {
                                  if (value.length < 3 || value.length > 10) {
                                    return translations[selectedLanguage]
                                            ?['LNLength'] ??
                                        '';
                                  } else {
                                    return null;
                                  }
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: translations[selectedLanguage]
                                        ?['LName'] ??
                                    '',
                                suffixIcon: const Icon(Icons.person),
                                enabledBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50.0)),
                                    borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50.0)),
                                    borderSide: BorderSide(color: Colors.blue)),
                                errorBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50.0)),
                                    borderSide: BorderSide(color: Colors.red)),
                                focusedErrorBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50.0)),
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 1.5)),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                left: 20.0,
                                right: 10.0,
                                top: 10.0,
                                bottom: 10.0),
                            child: InputDecorator(
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: translations[selectedLanguage]
                                        ?['Position'] ??
                                    '',
                                enabledBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50.0)),
                                    borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50.0)),
                                    borderSide: BorderSide(color: Colors.blue)),
                                errorBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50.0)),
                                    borderSide: BorderSide(color: Colors.red)),
                                focusedErrorBorder: const OutlineInputBorder(
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
                                    value: StaffInfo.staffDefaultPosistion,
                                    items: StaffInfo.staffPositionItems
                                        .map((String positionItems) {
                                      return DropdownMenuItem(
                                        value: positionItems,
                                        alignment: Alignment.centerRight,
                                        child: Text(positionItems),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        StaffInfo.staffDefaultPosistion =
                                            newValue!;
                                        position = newValue;
                                        isIntern = position == 'کار آموز'
                                            ? true
                                            : false;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                left: 20.0,
                                right: 10.0,
                                top: 10.0,
                                bottom: 10.0),
                            child: TextFormField(
                              controller: hireDateController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'لطفا تاریخ استخدام کارمند را انتخاب کنید.';
                                }
                                return null;
                              },
                              onTap: () async {
                                FocusScope.of(context).requestFocus(
                                  FocusNode(),
                                );
                                final DateTime? dateTime = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100));
                                if (dateTime != null) {
                                  final intl2.DateFormat formatter =
                                      intl2.DateFormat('yyyy-MM-dd');
                                  final String formattedDate =
                                      formatter.format(dateTime);
                                  hireDateController.text = formattedDate;
                                }
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9.]'))
                              ],
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'تاریخ استخدام',
                                suffixIcon: Icon(Icons.calendar_month_outlined),
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
                            margin: const EdgeInsets.only(
                                left: 20.0,
                                right: 10.0,
                                top: 10.0,
                                bottom: 10.0),
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
                                  return translations[selectedLanguage]
                                          ?['PhoneRequired'] ??
                                      '';
                                } else if (value ==
                                        familyPhone1Controller.text ||
                                    value == familyPhone2Controller.text) {
                                  return 'نمبر تماس شما با نمبر تماس خانواده تان نباید یکسان باشد.';
                                } else if (value.startsWith('07')) {
                                  if (value.length < 10 || value.length > 10) {
                                    return translations[selectedLanguage]
                                            ?['Phone10'] ??
                                        '';
                                  }
                                } else if (value.startsWith('+93')) {
                                  if (value.length < 12 || value.length > 12) {
                                    return translations[selectedLanguage]
                                            ?['Phone12'] ??
                                        '';
                                  }
                                } else {
                                  return translations[selectedLanguage]
                                          ?['ValidPhone'] ??
                                      '';
                                }
                              },
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: translations[selectedLanguage]
                                        ?['Phone'] ??
                                    '',
                                suffixIcon: const Icon(Icons.phone),
                                enabledBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50.0)),
                                    borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50.0)),
                                    borderSide: BorderSide(color: Colors.blue)),
                                errorBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50.0)),
                                    borderSide: BorderSide(color: Colors.red)),
                                focusedErrorBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50.0)),
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 1.5)),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                left: 20.0,
                                right: 10.0,
                                top: 10.0,
                                bottom: 10.0),
                            child: TextFormField(
                              textDirection: TextDirection.ltr,
                              controller: familyPhone1Controller,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(regExOnlydigits),
                                ),
                              ],
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'این نمبر تماس عضوی فامیل الزامی میباشد.';
                                } else if (value == phoneController.text ||
                                    value == familyPhone2Controller.text) {
                                  return 'نمبر تماس خانواده شما باید متفاوت باشد.';
                                } else if (value.startsWith('07')) {
                                  if (value.length < 10 || value.length > 10) {
                                    return translations[selectedLanguage]
                                            ?['Phone10'] ??
                                        '';
                                  }
                                } else if (value.startsWith('+93')) {
                                  if (value.length < 12 || value.length > 12) {
                                    return translations[selectedLanguage]
                                            ?['Phone12'] ??
                                        '';
                                  }
                                } else {
                                  return translations[selectedLanguage]
                                          ?['ValidPhone'] ??
                                      '';
                                }
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'نمبر تماس عضو فامیل 1',
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
                            margin: const EdgeInsets.only(
                                left: 20.0,
                                right: 10.0,
                                top: 10.0,
                                bottom: 10.0),
                            child: TextFormField(
                              textDirection: TextDirection.ltr,
                              controller: familyPhone2Controller,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(regExOnlydigits),
                                ),
                              ],
                              validator: (value) {
                                if (value!.isNotEmpty) {
                                  if (value.startsWith('07')) {
                                    if (value.length < 10 ||
                                        value.length > 10) {
                                      return translations[selectedLanguage]
                                              ?['Phone10'] ??
                                          '';
                                    }
                                  } else if (value == phoneController.text ||
                                      value == familyPhone1Controller.text) {
                                    return 'نمبر تماس شما با نمبر تماس خانواده تان نباید یکسان باشد.';
                                  } else if (value.startsWith('+93')) {
                                    if (value.length < 12 ||
                                        value.length > 12) {
                                      return translations[selectedLanguage]
                                              ?['Phone12'] ??
                                          '';
                                    }
                                  } else {
                                    return translations[selectedLanguage]
                                            ?['ValidPhone'] ??
                                        '';
                                  }
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'نمبر تماس عضو فامیل 1',
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
                          if (position != 'کار آموز')
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 20.0,
                                  right: 10.0,
                                  top: 10.0,
                                  bottom: 10.0),
                              child: TextFormField(
                                controller: salaryController,
                                validator: (value) {
                                  if (value!.isNotEmpty) {
                                    final salary = double.tryParse(value!);
                                    if (salary! < 1000 || salary > 100000) {
                                      return translations[selectedLanguage]
                                              ?['ValidSalary'] ??
                                          '';
                                    }
                                  }
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9.]'))
                                ],
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: translations[selectedLanguage]
                                          ?['Salary'] ??
                                      '',
                                  suffixIcon: const Icon(Icons.money),
                                  enabledBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50.0)),
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                  focusedBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50.0)),
                                      borderSide:
                                          BorderSide(color: Colors.blue)),
                                  errorBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50.0)),
                                      borderSide:
                                          BorderSide(color: Colors.red)),
                                  focusedErrorBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50.0)),
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 1.5)),
                                ),
                              ),
                            ),
                          if (position == 'کار آموز')
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 20.0,
                                  right: 10.0,
                                  top: 10.0,
                                  bottom: 10.0),
                              child: TextFormField(
                                controller: prePaidController,
                                validator: (value) {
                                  if (value!.isNotEmpty) {
                                    final prePaid = double.tryParse(value!);
                                    if (prePaid! < 1000 || prePaid > 100000) {
                                      return 'مقدار پول ضمانت باید بین 1000 و 100000 افغانی باشد.';
                                    }
                                  }
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9.]'))
                                ],
                                // ignore: prefer_const_constructors
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: 'مقدار پول ضمانت',
                                  suffixIcon: const Icon(Icons.money),
                                  enabledBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50.0)),
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                  focusedBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50.0)),
                                      borderSide:
                                          BorderSide(color: Colors.blue)),
                                  errorBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50.0)),
                                      borderSide:
                                          BorderSide(color: Colors.red)),
                                  focusedErrorBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50.0)),
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 1.5)),
                                ),
                              ),
                            ),
                          Container(
                            margin: const EdgeInsets.only(
                                left: 20.0,
                                right: 10.0,
                                top: 10.0,
                                bottom: 10.0),
                            child: TextFormField(
                              controller: tazkiraController,
                              validator: (value) {
                                if (value!.isNotEmpty) {
                                  if (!tazkiraPattern.hasMatch(value)) {
                                    return translations[selectedLanguage]
                                            ?['ValidTazkira'] ??
                                        '';
                                  }
                                }
                                return null;
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9-]'))
                              ],
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: translations[selectedLanguage]
                                        ?['Tazkira'] ??
                                    '',
                                suffixIcon: const Icon(Icons.perm_identity),
                                enabledBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50.0)),
                                    borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50.0)),
                                    borderSide: BorderSide(color: Colors.blue)),
                                errorBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50.0)),
                                    borderSide: BorderSide(color: Colors.red)),
                                focusedErrorBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50.0)),
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 1.5)),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                left: 20.0,
                                right: 10.0,
                                top: 10.0,
                                bottom: 10.0),
                            child: TextFormField(
                              controller: addressController,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(regExOnlyAbc),
                                ),
                              ],
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: translations[selectedLanguage]
                                        ?['Address'] ??
                                    '',
                                suffixIcon:
                                    const Icon(Icons.location_on_outlined),
                                enabledBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50.0)),
                                    borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50.0)),
                                    borderSide: BorderSide(color: Colors.blue)),
                                errorBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50.0)),
                                    borderSide: BorderSide(color: Colors.red)),
                                focusedErrorBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50.0)),
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 1.5)),
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                      width: 1.0,
                                      color: selectedContractFile == null
                                          ? Colors.red
                                          : Colors.blue),
                                ),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                width: MediaQuery.of(context).size.width * 0.31,
                                height:
                                    MediaQuery.of(context).size.height * 0.057,
                                child: InkWell(
                                    onTap: () async {
                                      setState(() {
                                        isLoadingFile = true;
                                      });

                                      final result = await FilePicker.platform
                                          .pickFiles(
                                              allowMultiple: true,
                                              type: FileType.custom,
                                              allowedExtensions: [
                                            'jpg',
                                            'jpeg',
                                            'png',
                                            'pdf',
                                            'docx'
                                          ]);
                                      if (result != null) {
                                        setState(() {
                                          isLoadingFile = false;
                                          selectedContractFile = File(result
                                              .files.single.path
                                              .toString());
                                        });
                                      }
                                    },
                                    child: selectedContractFile == null &&
                                            !isLoadingFile
                                        ? const Icon(Icons.add,
                                            size: 30, color: Colors.blue)
                                        : isLoadingFile
                                            ? Center(
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.015,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.015,
                                                  child:
                                                      const CircularProgressIndicator(
                                                          strokeWidth: 3.0),
                                                ),
                                              )
                                            : Center(
                                                child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  p.basename(
                                                      selectedContractFile!
                                                          .path),
                                                  style: const TextStyle(
                                                      fontSize: 12.0),
                                                ),
                                              ))),
                              ),
                              ValueListenableBuilder<String>(
                                valueListenable: contractFileMessage,
                                builder: (context, value, child) {
                                  if (value.isEmpty) {
                                    return const SizedBox
                                        .shrink(); // or Container()
                                  } else {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30.0, vertical: 5.0),
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        child: Text(
                                          value,
                                          style: const TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.redAccent),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              Directionality(
                  textDirection:
                      isEnglish ? TextDirection.ltr : TextDirection.rtl,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(translations[selectedLanguage]
                                  ?['CancelBtn'] ??
                              '')),
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            String? fileType;
                            final conn = await onConnToDb();
                            String fname = nameController.text;
                            String lname = lastNameController.text;
                            String pos = StaffInfo.staffDefaultPosistion;
                            String hireDate = hireDateController.text;
                            String phone = phoneController.text;
                            String fPhone1 = familyPhone1Controller.text;
                            String? fPhone2 =
                                familyPhone2Controller.text.isEmpty
                                    ? null
                                    : familyPhone2Controller.text;
                            double salary = salaryController.text.isEmpty
                                ? 0
                                : double.parse(salaryController.text);
                            double prePayment = prePaidController.text.isEmpty
                                ? 0
                                : double.parse(prePaidController.text);
                            String tazkiraId = tazkiraController.text;
                            String addr = addressController.text;
                            Uint8List? contractFile;
                            if (selectedContractFile != null) {
                              contractFile =
                                  await selectedContractFile!.readAsBytes();
                              fileType =
                                  p.extension(selectedContractFile!.path);
                            }
                            if (selectedContractFile == null) {
                              if (formKey1.currentState!.validate()) {
                                if (isIntern) {
                                  final results = await conn.query(
                                      'UPDATE staff SET firstname = ?, lastname = ?, position = ?,  prepayment = ?, hire_date = ?, phone = ?,  family_phone1 = ?, family_phone2 = ?, tazkira_ID = ?, address = ? WHERE staff_ID = ?',
                                      [
                                        fname,
                                        lname,
                                        pos,
                                        prePayment,
                                        hireDate,
                                        phone,
                                        fPhone1,
                                        fPhone2,
                                        tazkiraId,
                                        addr,
                                        staffID
                                      ]);
                                  if (results.affectedRows! > 0) {
                                    _onShowSnack(
                                        Colors.green,
                                        translations[selectedLanguage]
                                                ?['StaffEditMsg'] ??
                                            '');
                                    Navigator.pop(context);
                                    onUpdate();
                                  } else {
                                    _onShowSnack(
                                        Colors.red,
                                        translations[selectedLanguage]
                                                ?['StaffEditErrMsg'] ??
                                            '');
                                    Navigator.pop(context);
                                  }
                                } else {
                                  final results = await conn.query(
                                      'UPDATE staff SET firstname = ?, lastname = ?, position = ?, salary = ?, hire_date = ?, phone = ?,  family_phone1 = ?, family_phone2 = ?, tazkira_ID = ?, address = ? WHERE staff_ID = ?',
                                      [
                                        fname,
                                        lname,
                                        pos,
                                        salary,
                                        hireDate,
                                        phone,
                                        fPhone1,
                                        fPhone2,
                                        tazkiraId,
                                        addr,
                                        staffID
                                      ]);
                                  if (results.affectedRows! > 0) {
                                    _onShowSnack(
                                        Colors.green,
                                        translations[selectedLanguage]
                                                ?['StaffEditMsg'] ??
                                            '');
                                    Navigator.pop(context);
                                    onUpdate();
                                  } else {
                                    _onShowSnack(
                                        Colors.red,
                                        translations[selectedLanguage]
                                                ?['StaffEditErrMsg'] ??
                                            '');
                                    Navigator.pop(context);
                                  }
                                }
                              }
                            } else {
                              if (formKey1.currentState!.validate()) {
                                if (isIntern) {
                                  if (contractFile!.length > 1024 * 1024) {
                                    contractFileMessage.value =
                                        'اندازه این فایل باید 1 میگابایت یا کمتر باشد.';
                                  } else {
                                    final results = await conn.query(
                                        'UPDATE staff SET firstname = ?, lastname = ?, position = ?, prepayment = ?, hire_date = ?, phone = ?,  family_phone1 = ?, family_phone2 = ?, tazkira_ID = ?, address = ?, contract_file = ?, file_type = ? WHERE staff_ID = ?',
                                        [
                                          fname,
                                          lname,
                                          pos,
                                          prePayment,
                                          hireDate,
                                          phone,
                                          fPhone1,
                                          fPhone2,
                                          tazkiraId,
                                          addr,
                                          contractFile,
                                          fileType,
                                          staffID
                                        ]);
                                    if (results.affectedRows! > 0) {
                                      _onShowSnack(
                                          Colors.green,
                                          translations[selectedLanguage]
                                                  ?['StaffEditMsg'] ??
                                              '');
                                      Navigator.pop(context);
                                      onUpdate();
                                    } else {
                                      _onShowSnack(
                                          Colors.red,
                                          translations[selectedLanguage]
                                                  ?['StaffEditErrMsg'] ??
                                              '');
                                      Navigator.pop(context);
                                    }
                                  }
                                } else {
                                  if (contractFile!.length > 1024 * 1024) {
                                    contractFileMessage.value =
                                        'اندازه این فایل باید 1 میگابایت یا کمتر باشد.';
                                  } else {
                                    final results = await conn.query(
                                        'UPDATE staff SET firstname = ?, lastname = ?, position = ?, salary = ?, hire_date = ?, phone = ?,  family_phone1 = ?, family_phone2 = ?, tazkira_ID = ?, address = ?, contract_file = ?, file_type = ? WHERE staff_ID = ?',
                                        [
                                          fname,
                                          lname,
                                          pos,
                                          salary,
                                          hireDate,
                                          phone,
                                          fPhone1,
                                          fPhone2,
                                          tazkiraId,
                                          addr,
                                          contractFile,
                                          fileType,
                                          staffID
                                        ]);
                                    if (results.affectedRows! > 0) {
                                      _onShowSnack(
                                          Colors.green,
                                          translations[selectedLanguage]
                                                  ?['StaffEditMsg'] ??
                                              '');
                                      Navigator.pop(context);
                                      onUpdate();
                                    } else {
                                      _onShowSnack(
                                          Colors.red,
                                          translations[selectedLanguage]
                                                  ?['StaffEditErrMsg'] ??
                                              '');
                                      Navigator.pop(context);
                                    }
                                  }
                                }
                              }
                            }
                          } catch (e) {
                            print('Error occured with update this staff: $e');
                          }
                        },
                        child:
                            Text(translations[selectedLanguage]?['Edit'] ?? ''),
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
  // All roles - this is only visible for 'software engineer'
  var allRoles = [
    'کمک مدیر',
    'مدیر سیستم',
    'Software Engineer',
  ];
  var visibleRoles = [
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
            title: Directionality(
              textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
              child: Text(
                translations[selectedLanguage]?['CreateUAHeader'] ?? '',
                style: const TextStyle(color: Colors.blue),
              ),
            ),
            content: Directionality(
              textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
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
                          margin: const EdgeInsets.only(
                              left: 20.0, right: 10.0, top: 10.0, bottom: 10.0),
                          child: TextFormField(
                            controller: userNameController,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(regExUserName),
                              ),
                            ],
                            validator: (value) {
                              if (value!.isEmpty) {
                                return translations[selectedLanguage]
                                        ?['RequireUserName'] ??
                                    '';
                              } else if (value.length < 6 ||
                                  value.length > 10) {
                                return translations[selectedLanguage]
                                        ?['UserNameLength'] ??
                                    '';
                              }
                            },
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: translations[selectedLanguage]
                                      ?['UserName'] ??
                                  '',
                              suffixIcon: const Icon(Icons.person),
                              enabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.blue)),
                              errorBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.red)),
                              focusedErrorBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(
                                      color: Colors.red, width: 1.5)),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 20.0, right: 10.0, top: 10.0, bottom: 10.0),
                          child: TextFormField(
                            controller: pwdController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return translations[selectedLanguage]
                                        ?['RequirePassword'] ??
                                    '';
                              } else if (value.length < 8) {
                                return translations[selectedLanguage]
                                        ?['PasswordLength'] ??
                                    '';
                              }
                            },
                            obscureText: true,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: translations[selectedLanguage]
                                      ?['Password'] ??
                                  '',
                              suffixIcon: const Icon(Icons.lock_open_outlined),
                              enabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.blue)),
                              errorBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.red)),
                              focusedErrorBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(
                                      color: Colors.red, width: 1.5)),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 20.0, right: 10.0, top: 10.0, bottom: 10.0),
                          child: TextFormField(
                            controller: confirmController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return translations[selectedLanguage]
                                        ?['RequirePwdConfirm'] ??
                                    '';
                              } else if (pwdController.text !=
                                  confirmController.text) {
                                return translations[selectedLanguage]
                                        ?['ConfirmPwdMsg'] ??
                                    '';
                              }
                            },
                            obscureText: true,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: translations[selectedLanguage]
                                      ?['ConfirmPassword'] ??
                                  '',
                              suffixIcon: const Icon(Icons.lock_open_outlined),
                              enabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.blue)),
                              errorBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.red)),
                              focusedErrorBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(
                                      color: Colors.red, width: 1.5)),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 20.0, right: 10.0, top: 10.0, bottom: 10.0),
                          child: InputDecorator(
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: translations[selectedLanguage]
                                      ?['ChooseRole'] ??
                                  '',
                              enabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: const OutlineInputBorder(
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
                                  items: (StaffInfo.staffRole ==
                                          'Software Engineer')
                                      ? allRoles.map((String positionItems) {
                                          return DropdownMenuItem(
                                            value: positionItems,
                                            alignment: Alignment.centerRight,
                                            child: Text(positionItems),
                                          );
                                        }).toList()
                                      : visibleRoles
                                          .map((String positionItems) {
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
                  textDirection:
                      isEnglish ? TextDirection.ltr : TextDirection.rtl,
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
                            try {
                              int staffId = staff_id;
                              String userName = userNameController.text;
                              String pwd = pwdController.text;
                              String role = roleDropDown;
                              var conn = await onConnToDb();
                              var dupUserResult = await conn.query(
                                  'SELECT * FROM staff_auth WHERE username = ?',
                                  [userName]);

                              if (dupUserResult.isNotEmpty) {
                                // ignore: use_build_context_synchronously
                                Navigator.pop(context);
                                _onShowSnack(
                                    Colors.red,
                                    translations[selectedLanguage]
                                            ?['DupUNameMsg'] ??
                                        '');
                              } else {
                                if (await Features.userLimitReached()) {
                                  // ignore: use_build_context_synchronously
                                  Navigator.pop(context);
                                  _onShowSnack(Colors.red,
                                      translations[selectedLanguage]?['RecordLimitMsg'] ?? '');
                                } else {
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
                                    _onShowSnack(
                                        Colors.green,
                                        translations[selectedLanguage]
                                                ?['UpdateUAMsg'] ??
                                            '');
                                  }
                                }
                              }
                            } catch (e) {
                              print('Creating user account failed: $e');
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
  // This is only visible for 'software engineer'
  var allRoles = ['کمک مدیر', 'مدیر سیستم', 'Software Engineer'];

  var visibleRoles = [
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
            title: Directionality(
              textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
              child: Text(
                translations[selectedLanguage]?['ChangeUAHeader'] ?? '',
                style: const TextStyle(color: Colors.blue),
              ),
            ),
            content: Directionality(
              textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
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
                          margin: const EdgeInsets.only(
                              left: 20.0, right: 10.0, top: 10.0, bottom: 10.0),
                          child: TextFormField(
                            controller: userNameController,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(regExUserName),
                              ),
                            ],
                            validator: (value) {
                              if (value!.isEmpty) {
                                return translations[selectedLanguage]
                                        ?['RequireUserName'] ??
                                    '';
                              } else if (value.length < 6 ||
                                  value.length > 10) {
                                return translations[selectedLanguage]
                                        ?['UserNameLength'] ??
                                    '';
                              }
                            },
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: translations[selectedLanguage]
                                      ?['UserName'] ??
                                  '',
                              suffixIcon: const Icon(Icons.person),
                              enabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.blue)),
                              errorBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.red)),
                              focusedErrorBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(
                                      color: Colors.red, width: 1.5)),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 20.0, right: 10.0, top: 10.0, bottom: 10.0),
                          child: TextFormField(
                            controller: pwdController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return translations[selectedLanguage]
                                        ?['RequirePassword'] ??
                                    '';
                              } else if (value.length < 8) {
                                return translations[selectedLanguage]
                                        ?['PasswordLength'] ??
                                    '';
                                ;
                              }
                            },
                            obscureText: true,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: translations[selectedLanguage]
                                      ?['Password'] ??
                                  '',
                              suffixIcon: const Icon(Icons.lock_open_outlined),
                              enabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.blue)),
                              errorBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.red)),
                              focusedErrorBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(
                                      color: Colors.red, width: 1.5)),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 20.0, right: 10.0, top: 10.0, bottom: 10.0),
                          child: TextFormField(
                            controller: confirmController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return translations[selectedLanguage]
                                        ?['RequirePwdConfirm'] ??
                                    '';
                              } else if (pwdController.text !=
                                  confirmController.text) {
                                return translations[selectedLanguage]
                                        ?['ConfirmPwdMsg'] ??
                                    '';
                              }
                            },
                            obscureText: true,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: translations[selectedLanguage]
                                      ?['ConfirmPassword'] ??
                                  '',
                              suffixIcon: const Icon(Icons.lock_open_outlined),
                              enabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.blue)),
                              errorBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.red)),
                              focusedErrorBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(
                                      color: Colors.red, width: 1.5)),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 20.0, right: 10.0, top: 10.0, bottom: 10.0),
                          child: InputDecorator(
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: translations[selectedLanguage]
                                      ?['ChooseRole'] ??
                                  '',
                              enabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: const OutlineInputBorder(
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
                                  items: (StaffInfo.staffRole ==
                                          'Software Engineer')
                                      ? allRoles.map((String positionItems) {
                                          return DropdownMenuItem(
                                            value: positionItems,
                                            alignment: Alignment.centerRight,
                                            child: Text(positionItems),
                                          );
                                        }).toList()
                                      : visibleRoles
                                          .map((String positionItems) {
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
                  textDirection:
                      isEnglish ? TextDirection.ltr : TextDirection.rtl,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        child: Text(
                            translations[selectedLanguage]?['CancelBtn'] ?? ''),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (formKey3.currentState!.validate()) {
                            final userName = userNameController.text;
                            final pwd = pwdController.text;
                            final userRole = roleDropDown;
                            var conn = await onConnToDb();
                            var dupUNameResult = await conn.query(
                                'SELECT * FROM staff_auth WHERE username = ?',
                                [userName]);
                            if (dupUNameResult.isEmpty) {
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
                                _onShowSnack(
                                    Colors.green,
                                    translations[selectedLanguage]
                                            ?['UpdateUAMsg'] ??
                                        '');
                              }
                            } else {
                              Navigator.pop(context);
                              // ignore: use_build_context_synchronously
                              _onShowSnack(
                                  Colors.red,
                                  translations[selectedLanguage]
                                          ?['DupUNameMsg'] ??
                                      '');
                            }
                          }
                        },
                        child: Text(
                            translations[selectedLanguage]?['SaveUABtn'] ?? ''),
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
  final String hireDate;
  final double prepayment;
  final String familyPhone1;
  final String? familyPhone2;
  final Uint8List? contractFile;
  final String? fileType;
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
    required this.hireDate,
    required this.prepayment,
    required this.familyPhone1,
    this.familyPhone2,
    this.contractFile,
    this.fileType,
  });

  @override
  String toString() {
    return 'MyStaff(firstName: $firstName, lastName: $lastName, position: $position)';
  }
}

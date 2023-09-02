import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dentistry/views/main/dashboard.dart';
import 'patients.dart' as patient_ist;
import 'patient_info.dart';
import 'package:flutter_dentistry/models/db_conn.dart';
import 'package:flutter_dentistry/views/staff/staff_info.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' as intl2;

void main() {
  return runApp(const PatientDetail());
}

final items = ['Item 1', 'Item 2', 'Item 3', 'Item 4', 'Item 5'];

class PatientDetail extends StatefulWidget {
  const PatientDetail({super.key});

  @override
  State<PatientDetail> createState() => _PatientDetailState();
}

class _PatientDetailState extends State<PatientDetail> {
  bool reachedLastStep = false;
  // Global key for displayig snackbar message
  final GlobalKey<ScaffoldMessengerState> _ptGlobalKey =
      GlobalKey<ScaffoldMessengerState>();

  // This is to track current step of stepper
  int _currentStep = 0;
  String? selectedTooth2;
  //  نوعیت کشیدن دندان
  String? selectedTooth;

  bool _isVisibleForFilling = true;
  bool _isVisibleForBleaching = false;
  bool _isVisibleForScaling = false;
  bool _isVisibleForOrtho = false;
  bool _isVisibleForProthesis = false;
  bool _isVisibleForRoot = false;
  bool _isVisibleGum = false;
  bool _isVisibleForTeethRemove = false;
  bool _isVisibleForCover = false;
  bool _isVisibleMouth = false;
  bool _isVisibleForPayment = false;
  // Declare a variable for payment installment
  String payTypeDropdown = 'تکمیل';

  List<Map<String, dynamic>> removeTeeth = [];
  Future<void> fetchRemoveTooth() async {
    var conn = await onConnToDb();
    if (selectedGumType2 != null) {
      var results = await conn.query(
          'SELECT td_ID, tooth FROM tooth_details WHERE (td_ID >= 35 AND td_ID <= 49) AND tooth_ID = ?',
          [selectedGumType2]);

      setState(() {
        removeTeeth = results
            .map(
                (result) => {'td_ID': result[0].toString(), 'tooth': result[1]})
            .toList();
        selectedTooth = removeTeeth.isNotEmpty ? removeTeeth[0]['td_ID'] : null;
      });
    } else {
      // Set a default value for selectedTooth using the defaultResult query
      var defaultResult = await conn.query(
          'SELECT td_ID, tooth FROM tooth_details WHERE td_ID >= 35 AND td_ID <= 37');
      if (defaultResult.isNotEmpty) {
        setState(() {
          selectedTooth = defaultResult.first['td_ID'].toString();
          removeTeeth = defaultResult
              .map((result) =>
                  {'td_ID': result['td_ID'], 'tooth': result['tooth']})
              .toList();
          selectedTooth = removeTeeth.isNotEmpty
              ? removeTeeth[0]['td_ID'].toString()
              : null;
        });
        // selectedTooth = removeTeeth.isNotEmpty ? removeTeeth[0]['td_ID'] : null;
      }
    }

    await conn.close();
  }

//  سفید کردن دندان
  String? selectedBleachStep;
  List<Map<String, dynamic>> teethBleachings = [];

  Future<void> fetchBleachings() async {
    var conn = await onConnToDb();
    var results = await conn.query(
        'SELECT ser_det_ID, service_specific_value FROM service_details WHERE ser_id = 3');
    setState(() {
      teethBleachings = results
          .map((result) => {
                'ser_det_ID': result[0].toString(),
                'service_specific_value': result[1]
              })
          .toList();
    });
    selectedBleachStep =
        teethBleachings.isNotEmpty ? teethBleachings[0]['ser_det_ID'] : null;
    await conn.close();
  }

  //  پروتز دندان
  String? selectedProthesis;
  List<Map<String, dynamic>> protheses = [];
  Future<void> fetchProtheses() async {
    var conn = await onConnToDb();
    var results = await conn.query(
        'SELECT ser_det_ID, service_specific_value FROM service_details WHERE ser_id = 9');
    setState(() {
      protheses = results
          .map((result) => {
                'ser_det_ID': result[0].toString(),
                'service_specific_value': result[1]
              })
          .toList();
    });
    selectedProthesis =
        protheses.isNotEmpty ? protheses[0]['ser_det_ID'] : null;
    await conn.close();
  }

  //  پوش کردن دندان
  String? selectedCover;
  List<Map<String, dynamic>> coverings = [];
  Future<void> fetchToothCover() async {
    var conn = await onConnToDb();
    var results = await conn.query(
        'SELECT ser_det_ID, service_specific_value FROM service_details WHERE ser_id = 11');
    setState(() {
      coverings = results
          .map((result) => {
                'ser_det_ID': result[0].toString(),
                'service_specific_value': result[1]
              })
          .toList();
    });
    selectedCover = coverings.isNotEmpty ? coverings[0]['ser_det_ID'] : null;
    await conn.close();
  }

// It is for two forms of stepper
  final _ptFormKey1 = GlobalKey<FormState>();
  final _ptFormKey2 = GlobalKey<FormState>();

  final _totalExpController = TextEditingController();
  final _recievableController = TextEditingController();
  final _meetController = TextEditingController();
  final _noteController = TextEditingController();
  final _dueAmountController = TextEditingController();
  final _regExOnlyAbc = "[a-zA-Z,، \u0600-\u06FFF]";
  final _regExOnlydigits = "[0-9+]";
  final _regExDecimal = "[0-9.]";

  var selectedRemovableTooth;
  String removedTooth = 'عقل دندان';

/*----------------------- Note #1: In fact the below variables contain service_details.ser_det_ID  ------------------*/
  // For Filling
  int selectedFill = 1;
  // For Bleaching
  int selectedServiceDetailID = 4;
// For prothesis
  int selectedProthis = 8;
  // For teeth cover
  int selectedMaterial = 10;
// For mouth test
  int mouthTest = 15;
  /*----------------------- End of Note #1  Do not get confused of variables name (They are ser_det_ID values) ------------------*/

  String? selectedSerId;
  List<Map<String, dynamic>> services = [];
  Future<void> fetchServices() async {
    var conn = await onConnToDb();
    var queryService = await conn
        .query('SELECT ser_ID, ser_name FROM services WHERE ser_ID > 1');
    setState(() {
      services = queryService
          .map((result) =>
              {'ser_ID': result[0].toString(), 'ser_name': result[1]})
          .toList();
    });
    selectedSerId = services.isNotEmpty ? services[0]['ser_ID'] : null;
    await conn.close();
  }

  @override
  void initState() {
    super.initState();
    fetchServices();
    onFillTeeth();
    onChooseGum2();
    fetchToothNum();
    chooseGumType1();
    fetchBleachings();
    fetchProtheses();
    fetchToothCover();
    fetchRemoveTooth();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ScaffoldMessenger(
        key: _ptGlobalKey,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            floatingActionButton: Tooltip(
              message: 'جلسه جدید',
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    reachedLastStep = false;
                    _currentStep = 0;
                    onShowDialogForNewAppointment(context);
                  });
                },
                child: const Icon(Icons.add),
              ),
            ),
            appBar: AppBar(
              leading: Tooltip(
                message: 'رفتن به صفحه قبلی',
                child: IconButton(
                  icon: const BackButtonIcon(),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              title: const Text('جزییات مریض'),
              actions: [
                Builder(
                  builder: (context) => Tooltip(
                    message: 'تغییر دادن مریض',
                    child: IconButton(
                      onPressed: () {
                        onEditPatient(context);
                      },
                      icon: const Icon(Icons.edit_outlined),
                    ),
                  ),
                ),
                Tooltip(
                  message: 'رفتن به داشبورد',
                  child: IconButton(
                    icon: const Icon(Icons.home),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Dashboard()));
                    },
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                SizedBox(
                    height: 200.0,
                    child: Row(
                      children: [
                        Card(
                          child: SizedBox(
                            width: 200.0,
                            child: Column(
                              children: [
                                const CircleAvatar(
                                  radius: 40.0,
                                  backgroundImage:
                                      AssetImage('assets/graphics/patient.png'),
                                  backgroundColor: Colors.transparent,
                                ),
                                Text(
                                  '${PatientInfo.firstName} ${PatientInfo.lastName}',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Text(
                                  '0744232325',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          child: SizedBox(
                            height: 300.0,
                            width: 400.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 20.0, bottom: 20.0),
                                      child: Column(
                                        children: [
                                          const Text(
                                            'جنیست',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12.0),
                                          ),
                                          Text('${PatientInfo.sex}'),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 20.0, bottom: 20.0),
                                      child: Column(
                                        children: [
                                          const Text('حالت مدنی',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12.0)),
                                          Text('${PatientInfo.maritalStatus}'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 20.0, bottom: 20.0),
                                      child: Column(
                                        children: [
                                          const Text('سن',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12.0)),
                                          Text('${PatientInfo.age} سال'),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 20.0, bottom: 20.0),
                                      child: Column(
                                        children: [
                                          const Text('گروپ خون',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12.0)),
                                          Text('${PatientInfo.bloodGroup}'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 20.0, bottom: 20.0),
                                      child: Column(
                                        children: [
                                          const Text('آدرس',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12.0)),
                                          Text('${PatientInfo.address}'),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 20.0, bottom: 20.0),
                                      child: Column(
                                        children: [
                                          const Text('تاریخ ثبت',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12.0)),
                                          Text('${PatientInfo.regDate}'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 200,
                            child: Card(
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    child: const Text(
                                      'هزینه ها',
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Table(
                                      border: const TableBorder(
                                          horizontalInside: BorderSide(
                                              color: Colors.grey,
                                              style: BorderStyle.solid,
                                              width: 0.5)),
                                      columnWidths: const {
                                        0: FixedColumnWidth(120),
                                        1: FixedColumnWidth(80),
                                        2: FixedColumnWidth(100),
                                        3: FixedColumnWidth(100),
                                        4: FixedColumnWidth(100),
                                      },
                                      children: const [
                                        // add your table rows here
                                        TableRow(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(5.0),
                                              child: Text(
                                                'سرویس',
                                                style: TextStyle(
                                                    fontSize: 12.0,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(5.0),
                                              child: Text(
                                                'جلسه',
                                                style: TextStyle(
                                                    fontSize: 12.0,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(5.0),
                                              child: Text(
                                                'مبلغ کل',
                                                style: TextStyle(
                                                    fontSize: 12.0,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(5.0),
                                              child: Text(
                                                'دریافت شده',
                                                style: TextStyle(
                                                    fontSize: 12.0,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(5.0),
                                              child: Text(
                                                'باقی',
                                                style: TextStyle(
                                                    fontSize: 12.0,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                          ],
                                        ),
                                        // more rows ...
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 100,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Table(
                                            border: const TableBorder(
                                                horizontalInside: BorderSide(
                                                    color: Colors.grey,
                                                    style: BorderStyle.solid,
                                                    width: 0.5)),
                                            columnWidths: const {
                                              0: FixedColumnWidth(120),
                                              1: FixedColumnWidth(80),
                                              2: FixedColumnWidth(100),
                                              3: FixedColumnWidth(100),
                                              4: FixedColumnWidth(100),
                                            },
                                            children: const [
                                              // add your table rows here
                                              TableRow(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.all(8.0),
                                                    child: Text('پرکاری دندان'),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.all(8.0),
                                                    child: Text('1'),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.all(8.0),
                                                    child: Text('3000 افغانی'),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.all(8.0),
                                                    child: Text('2000'),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.all(8.0),
                                                    child: Text('1000'),
                                                  ),
                                                ],
                                              ),
                                              TableRow(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.all(8.0),
                                                    child: Text('پرکاری دندان'),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.all(8.0),
                                                    child: Text('2'),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.all(8.0),
                                                    child: Text('3000 افغانی'),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.all(8.0),
                                                    child: Text('2000'),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.all(8.0),
                                                    child: Text('1000'),
                                                  ),
                                                ],
                                              ),
                                              TableRow(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.all(8.0),
                                                    child: Text('پرکاری دندان'),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.all(8.0),
                                                    child: Text('2'),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.all(8.0),
                                                    child: Text('3000 افغانی'),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.all(8.0),
                                                    child: Text('2000'),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.all(8.0),
                                                    child: Text('1000'),
                                                  ),
                                                ],
                                              ),
                                              TableRow(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.all(8.0),
                                                    child: Text('پرکاری دندان'),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.all(8.0),
                                                    child: Text('2'),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.all(8.0),
                                                    child: Text('3000 افغانی'),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.all(8.0),
                                                    child: Text('2000'),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.all(8.0),
                                                    child: Text('1000'),
                                                  ),
                                                ],
                                              ),
                                              // more rows ...
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    height: 380.0,
                    child: Card(
                      child: Column(
                        children: [
                          Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                child: const Text(
                                  'دفعات مراجعه مریض',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                width: 1200.0,
                                padding: const EdgeInsets.all(8.0),
                                child: Table(
                                  border: const TableBorder(
                                      horizontalInside: BorderSide(
                                          color: Colors.grey,
                                          style: BorderStyle.solid,
                                          width: 0.5)),
                                  columnWidths: const {
                                    0: FixedColumnWidth(120),
                                    1: FixedColumnWidth(100),
                                    2: FixedColumnWidth(80),
                                    3: FixedColumnWidth(80),
                                    4: FixedColumnWidth(270),
                                    5: FixedColumnWidth(80),
                                    6: FixedColumnWidth(100),
                                    7: FixedColumnWidth(80),
                                    8: FixedColumnWidth(80),
                                    9: FixedColumnWidth(80),
                                    10: FixedColumnWidth(80),
                                  },
                                  children: const [
                                    // add your table rows here
                                    TableRow(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            'سرویس',
                                            style: TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.grey),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            'تاریخ مراجعه',
                                            style: TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.grey),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            'فک / بیره',
                                            style: TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.grey),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            'نوعیت دندان',
                                            style: TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.grey),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            'توضیحات',
                                            style: TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.grey),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            'جلسه / نوبت',
                                            style: TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.grey),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            'داکتر',
                                            style: TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.grey),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            'مراجعه',
                                            style: TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.grey),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            'ویرایش',
                                            style: TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.grey),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            'حذف',
                                            style: TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.grey),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            'عکس',
                                            style: TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.grey),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // more rows ...
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 300.0,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Container(
                                    width: 1200.0,
                                    padding: const EdgeInsets.all(8.0),
                                    margin: const EdgeInsets.only(top: 8.0),
                                    child: FutureBuilder(
                                        future: getAppointment(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            final appoints = snapshot.data;
                                            return Table(
                                              border: const TableBorder(
                                                  horizontalInside: BorderSide(
                                                      color: Colors.grey,
                                                      style: BorderStyle.solid,
                                                      width: 0.5)),
                                              columnWidths: const {
                                                0: FixedColumnWidth(120),
                                                1: FixedColumnWidth(100),
                                                2: FixedColumnWidth(80),
                                                3: FixedColumnWidth(80),
                                                4: FixedColumnWidth(270),
                                                5: FixedColumnWidth(80),
                                                6: FixedColumnWidth(100),
                                                7: FixedColumnWidth(80),
                                                8: FixedColumnWidth(80),
                                                9: FixedColumnWidth(80),
                                                10: FixedColumnWidth(80),
                                              },
                                              children: [
                                                for (var apt in appoints!)
                                                  // add your table rows here
                                                  TableRow(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child:
                                                            Text(apt.service),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child:
                                                            Text(apt.meetDate),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(apt.gum),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(apt.tooth),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                            apt.description),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(apt.round
                                                            .toString()),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                            '${apt.staffFirstName} ${apt.staffLastName}'),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Builder(builder:
                                                            (BuildContext
                                                                context) {
                                                          return IconButton(
                                                            onPressed: () {
                                                              onFollowAppointment(
                                                                  context);
                                                            },
                                                            icon: const Icon(
                                                                Icons
                                                                    .local_hospital_rounded,
                                                                color:
                                                                    Colors.blue,
                                                                size: 18.0),
                                                          );
                                                        }),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Builder(builder:
                                                            (BuildContext
                                                                context) {
                                                          return IconButton(
                                                            onPressed: () {
                                                              onEditAppointment(
                                                                  context);
                                                            },
                                                            icon: const Icon(
                                                                Icons.edit,
                                                                color:
                                                                    Colors.blue,
                                                                size: 18.0),
                                                          );
                                                        }),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Builder(
                                                          builder: (context) =>
                                                              IconButton(
                                                            onPressed: () {
                                                              onDeleteAppointment(
                                                                  context,
                                                                  apt.aptID);
                                                            },
                                                            icon: const Icon(
                                                                Icons.delete,
                                                                color:
                                                                    Colors.blue,
                                                                size: 18.0),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Builder(
                                                          builder: (context) =>
                                                              IconButton(
                                                            onPressed: () {
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) =>
                                                                        onShowImage(),
                                                              );
                                                            },
                                                            icon: const Icon(
                                                                Icons.image,
                                                                color:
                                                                    Colors.blue,
                                                                size: 18.0),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                              ],
                                            );
                                          } else if (snapshot.hasError) {
                                            return Text(
                                                'Error: ${snapshot.error}');
                                          } else {
                                            return const CircularProgressIndicator();
                                          }
                                        }),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// This function shows alert dialog for new appointment
  onShowDialogForNewAppointment(BuildContext context) {
    double dueAmount = 0;
    double paidAmount = _recievableController.text.isNotEmpty
        ? double.parse(_recievableController.text)
        : 0;
    double totalAmount = _totalExpController.text.isNotEmpty
        ? double.parse(_totalExpController.text)
        : 0;
    // Calculate teeth expenses
    void onCalculateDueAmount(String text) {
      paidAmount = _recievableController.text.isNotEmpty
          ? double.parse(_recievableController.text)
          : 0;
      totalAmount = _totalExpController.text.isNotEmpty
          ? double.parse(_totalExpController.text)
          : 0;
      dueAmount = totalAmount - paidAmount;
      _dueAmountController.text =
          paidAmount >= totalAmount ? '' : '$dueAmount افغانی';
    }

    return showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: ((context, setState) {
          List<Step> stepList1() => [
                Step(
                  state: _currentStep <= 0
                      ? StepState.editing
                      : StepState.complete,
                  isActive: _currentStep >= 0,
                  title: const Text('خدمات مورد نیاز مریض'),
                  content: SizedBox(
                    child: Center(
                      child: Form(
                        key: _ptFormKey1,
                        child: SizedBox(
                          width: 500.0,
                          child: Column(
                            children: [
                              const Text(
                                  'لطفا نوعیت سرویس (خدمات) و خانه های مربوطه آنرا با دقت پر کنید.'),
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 20.0,
                                    right: 20.0,
                                    top: 10.0,
                                    bottom: 10.0),
                                child: TextFormField(
                                  controller: _meetController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'لطفا تاریخ مراجعه مریض را انتخاب کنید.';
                                    }
                                    return null;
                                  },
                                  onTap: () async {
                                    FocusScope.of(context).requestFocus(
                                      FocusNode(),
                                    );
                                    final DateTime? dateTime =
                                        await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(1900),
                                            lastDate: DateTime(2100));
                                    if (dateTime != null) {
                                      final intl2.DateFormat formatter =
                                          intl2.DateFormat('yyyy-MM-dd');
                                      final String formattedDate =
                                          formatter.format(dateTime);
                                      _meetController.text = formattedDate;
                                    }
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9.]'))
                                  ],
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'تاریخ اولین مراجعه',
                                    suffixIcon:
                                        Icon(Icons.calendar_month_outlined),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50.0)),
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50.0)),
                                        borderSide:
                                            BorderSide(color: Colors.blue)),
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50.0)),
                                        borderSide:
                                            BorderSide(color: Colors.red)),
                                    focusedErrorBorder: OutlineInputBorder(
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
                                    right: 20.0,
                                    top: 10.0,
                                    bottom: 10.0),
                                child: InputDecorator(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'نوعیت خدمات',
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50.0)),
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50.0)),
                                        borderSide:
                                            BorderSide(color: Colors.blue)),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: SizedBox(
                                      height: 26.0,
                                      child: DropdownButton<String>(
                                        isExpanded: true,
                                        icon: const Icon(Icons.arrow_drop_down),
                                        value: selectedSerId,
                                        items: services.map((service) {
                                          return DropdownMenuItem<String>(
                                            value: service['ser_ID'],
                                            alignment: Alignment.centerRight,
                                            child: Text(service['ser_name']),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            selectedSerId = newValue;
                                            if (selectedSerId == '2') {
                                              _isVisibleForFilling = true;
                                              _isVisibleForBleaching = false;
                                              _isVisibleForScaling = false;
                                              _isVisibleForOrtho = false;
                                              _isVisibleForProthesis = false;
                                              _isVisibleForTeethRemove = false;
                                              _isVisibleForCover = false;
                                              _isVisibleGum = false;
                                              _isVisibleForRoot = false;
                                              _isVisibleMouth = false;
                                            } else if (selectedSerId == '3') {
                                              _isVisibleForFilling = false;
                                              _isVisibleForBleaching = true;
                                              _isVisibleForProthesis = false;
                                              _isVisibleForScaling = false;
                                              _isVisibleForTeethRemove = false;
                                              _isVisibleForCover = false;
                                              _isVisibleGum = false;
                                              _isVisibleForOrtho = false;
                                              _isVisibleForRoot = false;
                                              _isVisibleMouth = false;
                                            } else if (selectedSerId == '4') {
                                              _isVisibleForScaling = true;
                                              _isVisibleForFilling = false;
                                              _isVisibleForBleaching = false;
                                              _isVisibleForProthesis = false;
                                              _isVisibleForTeethRemove = false;
                                              _isVisibleForCover = false;
                                              _isVisibleForOrtho = false;
                                              _isVisibleGum = false;
                                              _isVisibleForRoot = false;
                                              _isVisibleMouth = false;
                                              // Set the first dropdown value to avoid conflict
                                              selectedGumType1 = '3';
                                            } else if (selectedSerId == '5') {
                                              _isVisibleForOrtho = true;
                                              _isVisibleForFilling = false;
                                              _isVisibleForBleaching = false;
                                              _isVisibleForScaling = false;
                                              _isVisibleForProthesis = false;
                                              _isVisibleGum = false;
                                              _isVisibleForTeethRemove = false;
                                              _isVisibleForCover = false;
                                              _isVisibleForRoot = false;
                                              _isVisibleMouth = false;
                                            } else if (selectedSerId == '9') {
                                              _isVisibleForProthesis = true;
                                              _isVisibleForOrtho = false;
                                              _isVisibleForFilling = false;
                                              _isVisibleForBleaching = false;
                                              _isVisibleForScaling = false;
                                              _isVisibleGum = false;
                                              _isVisibleForTeethRemove = false;
                                              _isVisibleForCover = false;
                                              _isVisibleForRoot = false;
                                              _isVisibleMouth = false;
                                              // Set selected tooth '1'
                                              selectedTooth2 = '1';
                                            } else if (selectedSerId == '6') {
                                              _isVisibleForRoot = true;
                                              _isVisibleForProthesis = false;
                                              _isVisibleForOrtho = false;
                                              _isVisibleForFilling = false;
                                              _isVisibleForBleaching = false;
                                              _isVisibleForScaling = false;
                                              _isVisibleGum = false;
                                              _isVisibleForTeethRemove = false;
                                              _isVisibleForCover = false;
                                              _isVisibleMouth = false;
                                              // Set selected tooth '1'
                                              selectedTooth2 = '1';
                                            } else if (selectedSerId == '7') {
                                              _isVisibleGum = true;
                                              _isVisibleForProthesis = false;
                                              _isVisibleForOrtho = false;
                                              _isVisibleForFilling = false;
                                              _isVisibleForBleaching = false;
                                              _isVisibleForScaling = false;
                                              _isVisibleForRoot = false;
                                              _isVisibleForTeethRemove = false;
                                              _isVisibleForCover = false;
                                              _isVisibleMouth = false;
                                              selectedGumType1 = '3';
                                            } else if (selectedSerId == '8') {
                                              _isVisibleMouth = true;
                                              _isVisibleForProthesis = false;
                                              _isVisibleForOrtho = false;
                                              _isVisibleForFilling = false;
                                              _isVisibleForBleaching = false;
                                              _isVisibleForScaling = false;
                                              _isVisibleForRoot = false;
                                              _isVisibleGum = false;
                                              _isVisibleForTeethRemove = false;
                                              _isVisibleForCover = false;
                                            } else if (selectedSerId == '10') {
                                              _isVisibleForTeethRemove = true;
                                              _isVisibleForProthesis = false;
                                              _isVisibleForOrtho = false;
                                              _isVisibleForFilling = false;
                                              _isVisibleForBleaching = false;
                                              _isVisibleForScaling = false;
                                              _isVisibleForRoot = false;
                                              _isVisibleGum = false;
                                              _isVisibleForCover = false;
                                              _isVisibleMouth = false;
                                            } else if (selectedSerId == '11') {
                                              _isVisibleForCover = true;
                                              _isVisibleForProthesis = false;
                                              _isVisibleForOrtho = false;
                                              _isVisibleForFilling = false;
                                              _isVisibleForBleaching = false;
                                              _isVisibleForScaling = false;
                                              _isVisibleForRoot = false;
                                              _isVisibleGum = false;
                                              _isVisibleForTeethRemove = false;
                                              _isVisibleMouth = false;
                                              // Set selected tooth '1'
                                              selectedTooth2 = '1';
                                            } else {
                                              _isVisibleForProthesis = false;
                                              _isVisibleForOrtho = false;
                                              _isVisibleForFilling = false;
                                              _isVisibleForBleaching = false;
                                              _isVisibleForScaling = false;
                                              _isVisibleForRoot = false;
                                              _isVisibleMouth = false;
                                              _isVisibleGum = false;
                                              _isVisibleForTeethRemove = false;
                                              _isVisibleForCover = false;
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: _isVisibleForBleaching,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 20.0,
                                      right: 20.0,
                                      top: 10.0,
                                      bottom: 10.0),
                                  child: InputDecorator(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'نوعیت سفید کردن دندانها',
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50.0)),
                                          borderSide:
                                              BorderSide(color: Colors.grey)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50.0)),
                                          borderSide:
                                              BorderSide(color: Colors.blue)),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: SizedBox(
                                        height: 26.0,
                                        child: DropdownButton(
                                          isExpanded: true,
                                          icon:
                                              const Icon(Icons.arrow_drop_down),
                                          value: selectedBleachStep,
                                          items: teethBleachings.map((step) {
                                            return DropdownMenuItem<String>(
                                              value: step['ser_det_ID'],
                                              alignment: Alignment.centerRight,
                                              child: Text(step[
                                                  'service_specific_value']),
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedBleachStep = newValue;
                                              selectedServiceDetailID =
                                                  int.parse(
                                                      selectedBleachStep!);
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: _isVisibleForTeethRemove,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 20.0,
                                      right: 20.0,
                                      top: 10.0,
                                      bottom: 10.0),
                                  child: InputDecorator(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'نوعیت دندان',
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50.0)),
                                          borderSide:
                                              BorderSide(color: Colors.grey)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50.0)),
                                          borderSide:
                                              BorderSide(color: Colors.blue)),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: SizedBox(
                                        height: 26.0,
                                        child: DropdownButton(
                                          isExpanded: true,
                                          icon:
                                              const Icon(Icons.arrow_drop_down),
                                          value: removeTeeth.any((tooth) =>
                                                  tooth['td_ID'].toString() ==
                                                  selectedTooth)
                                              ? selectedTooth
                                              : null,
                                          items: removeTeeth.map((tooth) {
                                            return DropdownMenuItem<String>(
                                              value: tooth['td_ID'].toString(),
                                              alignment: Alignment.centerRight,
                                              child: Text(tooth['tooth']),
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedTooth = newValue;
                                              selectedRemovableTooth =
                                                  removeTeeth.firstWhere(
                                                (tooth) =>
                                                    tooth['td_ID'].toString() ==
                                                    newValue,
                                              );
                                              // Fetch type the teeth which will be removed (پوسیده، عقل دندان..)
                                              removedTooth =
                                                  selectedRemovableTooth != null
                                                      ? selectedRemovableTooth[
                                                          'tooth']
                                                      : null;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: _isVisibleForScaling
                                    ? _isVisibleForScaling
                                    : _isVisibleForOrtho
                                        ? _isVisibleForOrtho
                                        : _isVisibleGum
                                            ? _isVisibleGum
                                            : false,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 20.0,
                                      right: 20.0,
                                      top: 10.0,
                                      bottom: 10.0),
                                  child: InputDecorator(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'فک / لثه',
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50.0)),
                                          borderSide:
                                              BorderSide(color: Colors.grey)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50.0)),
                                          borderSide:
                                              BorderSide(color: Colors.blue)),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: SizedBox(
                                        height: 26.0,
                                        child: DropdownButton(
                                          isExpanded: true,
                                          icon:
                                              const Icon(Icons.arrow_drop_down),
                                          value: selectedGumType1,
                                          items: gumsType1.map((gumType1) {
                                            return DropdownMenuItem<String>(
                                              value: gumType1['teeth_ID'],
                                              alignment: Alignment.centerRight,
                                              child: Text(gumType1['gum']),
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedGumType1 = newValue;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: _isVisibleForFilling
                                    ? _isVisibleForFilling
                                    : _isVisibleForBleaching
                                        ? _isVisibleForBleaching
                                        : _isVisibleForProthesis
                                            ? _isVisibleForProthesis
                                            : _isVisibleForRoot
                                                ? _isVisibleForRoot
                                                : _isVisibleForTeethRemove
                                                    ? _isVisibleForTeethRemove
                                                    : _isVisibleForCover
                                                        ? _isVisibleForCover
                                                        : false,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 20.0,
                                      right: 20.0,
                                      top: 10.0,
                                      bottom: 10.0),
                                  child: InputDecorator(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'فک / لثه',
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50.0)),
                                          borderSide:
                                              BorderSide(color: Colors.grey)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50.0)),
                                          borderSide:
                                              BorderSide(color: Colors.blue)),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: SizedBox(
                                        height: 26.0,
                                        child: DropdownButton<String>(
                                          isExpanded: true,
                                          icon:
                                              const Icon(Icons.arrow_drop_down),
                                          value: selectedGumType2,
                                          items: gums.map((gums) {
                                            return DropdownMenuItem<String>(
                                              value: gums['teeth_ID'],
                                              alignment: Alignment.centerRight,
                                              child: Text(gums['gum']),
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedGumType2 = newValue;
                                              if (selectedSerId == '10') {
                                                // Set this value since by changing لثه / فک below it, it should fetch the default selected value.
                                                removedTooth = 'عقل دندان';
                                                fetchRemoveTooth();
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: _isVisibleForCover,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 20.0,
                                      right: 20.0,
                                      top: 10.0,
                                      bottom: 10.0),
                                  child: InputDecorator(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'نوعیت مواد پوش',
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50.0)),
                                          borderSide:
                                              BorderSide(color: Colors.grey)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50.0)),
                                          borderSide:
                                              BorderSide(color: Colors.blue)),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: SizedBox(
                                        height: 26.0,
                                        child: DropdownButton(
                                          isExpanded: true,
                                          icon:
                                              const Icon(Icons.arrow_drop_down),
                                          value: selectedCover,
                                          items: coverings.map((covering) {
                                            return DropdownMenuItem<String>(
                                              value: covering['ser_det_ID'],
                                              alignment: Alignment.centerRight,
                                              child: Text(covering[
                                                  'service_specific_value']),
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedCover = newValue;
                                              selectedMaterial =
                                                  int.parse(selectedCover!);
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: _isVisibleForProthesis
                                    ? _isVisibleForProthesis
                                    : false,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 20.0,
                                      right: 20.0,
                                      top: 10.0,
                                      bottom: 10.0),
                                  child: InputDecorator(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'نوعیت پروتیز',
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50.0)),
                                          borderSide:
                                              BorderSide(color: Colors.grey)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50.0)),
                                          borderSide:
                                              BorderSide(color: Colors.blue)),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: SizedBox(
                                        height: 26.0,
                                        child: DropdownButton(
                                          isExpanded: true,
                                          icon:
                                              const Icon(Icons.arrow_drop_down),
                                          value: selectedProthesis,
                                          items: protheses.map((prothesis) {
                                            return DropdownMenuItem<String>(
                                              value: prothesis['ser_det_ID'],
                                              alignment: Alignment.centerRight,
                                              child: Text(prothesis[
                                                  'service_specific_value']),
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedProthesis = newValue;
                                              selectedProthis =
                                                  int.parse(selectedProthesis!);
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                // ignore: unrelated_type_equality_checks
                                visible: _isVisibleForFilling,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 20.0,
                                      right: 20.0,
                                      top: 10.0,
                                      bottom: 10.0),
                                  child: InputDecorator(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'نوعیت مواد',
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50.0)),
                                          borderSide:
                                              BorderSide(color: Colors.grey)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50.0)),
                                          borderSide:
                                              BorderSide(color: Colors.blue)),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: SizedBox(
                                        height: 26.0,
                                        child: DropdownButton<String>(
                                          isExpanded: true,
                                          icon:
                                              const Icon(Icons.arrow_drop_down),
                                          value: selectedFilling,
                                          items: teethFillings.map((material) {
                                            return DropdownMenuItem<String>(
                                              alignment: Alignment.centerRight,
                                              value: material['ser_det_ID'],
                                              child: Directionality(
                                                textDirection:
                                                    TextDirection.rtl,
                                                child: Text(material[
                                                    'service_specific_value']),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedFilling = newValue!;
                                              selectedFill =
                                                  int.parse(selectedFilling!);
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: _isVisibleForFilling
                                    ? _isVisibleForFilling
                                    : _isVisibleForRoot
                                        ? _isVisibleForRoot
                                        : _isVisibleForProthesis
                                            ? _isVisibleForProthesis
                                            : _isVisibleForCover
                                                ? _isVisibleForCover
                                                : false,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 20.0,
                                      right: 20.0,
                                      top: 10.0,
                                      bottom: 10.0),
                                  child: InputDecorator(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'دندان',
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50.0)),
                                          borderSide:
                                              BorderSide(color: Colors.grey)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50.0)),
                                          borderSide:
                                              BorderSide(color: Colors.blue)),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: SizedBox(
                                        height: 26.0,
                                        child: DropdownButton(
                                          isExpanded: true,
                                          icon:
                                              const Icon(Icons.arrow_drop_down),
                                          value: selectedTooth2,
                                          items: teeth.map((tooth) {
                                            return DropdownMenuItem<String>(
                                              value: tooth['td_ID'],
                                              alignment: Alignment.centerRight,
                                              child: Text(tooth['tooth']),
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedTooth2 = newValue;
                                              // print('Service: $selectedSerId');
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: true,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 20.0,
                                      right: 20.0,
                                      top: 10.0,
                                      bottom: 10.0),
                                  child: TextFormField(
                                    controller: _noteController,
                                    validator: (value) {
                                      if (value!.isNotEmpty) {
                                        if (value.length > 40 ||
                                            value.length < 10) {
                                          return 'توضیحات باید حداقل 10 و حداکثر 40 حرف باشد.';
                                        }
                                      }
                                      return null;
                                    },
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(_regExOnlyAbc),
                                      ),
                                    ],
                                    maxLines: 3,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'توضیحات',
                                      suffixIcon: Icon(Icons.note_alt_outlined),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50.0)),
                                          borderSide:
                                              BorderSide(color: Colors.grey)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50.0)),
                                          borderSide:
                                              BorderSide(color: Colors.blue)),
                                      errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50.0)),
                                          borderSide:
                                              BorderSide(color: Colors.red)),
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50.0)),
                                          borderSide: BorderSide(
                                              color: Colors.red, width: 1.5)),
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
                ),
                Step(
                  state: _currentStep <= 1
                      ? StepState.editing
                      : StepState.complete,
                  isActive: _currentStep >= 1,
                  title: const Text('هزینه ها / فیس'),
                  content: SizedBox(
                    child: Center(
                      child: Form(
                        key: _ptFormKey2,
                        child: SizedBox(
                          width: 500.0,
                          child: Column(
                            children: [
                              const Text(
                                  'لطفاً هزینه و اقساط را در خانه های ذیل انتخاب نمایید.'),
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 20.0,
                                    right: 20.0,
                                    top: 10.0,
                                    bottom: 10.0),
                                child: TextFormField(
                                  controller: _totalExpController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'مصارف کل نمیتواند خالی باشد.';
                                    }
                                    return null;
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(_regExDecimal),
                                    ),
                                  ],
                                  onChanged: payTypeDropdown != 'تکمیل'
                                      ? onCalculateDueAmount
                                      : null,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'کل مصارف',
                                    suffixIcon: Icon(Icons.money_rounded),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50.0)),
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50.0)),
                                        borderSide:
                                            BorderSide(color: Colors.blue)),
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50.0)),
                                        borderSide:
                                            BorderSide(color: Colors.red)),
                                    focusedErrorBorder: OutlineInputBorder(
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
                                    right: 20.0,
                                    top: 10.0,
                                    bottom: 10.0),
                                child: InputDecorator(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'نوعیت پرداخت',
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50.0)),
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50.0)),
                                        borderSide:
                                            BorderSide(color: Colors.blue)),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: SizedBox(
                                      height: 26.0,
                                      child: DropdownButton(
                                        isExpanded: true,
                                        icon: const Icon(Icons.arrow_drop_down),
                                        value: payTypeDropdown,
                                        items: onPayInstallment()
                                            .map((String installmentItems) {
                                          return DropdownMenuItem(
                                            alignment: Alignment.centerRight,
                                            value: installmentItems,
                                            child: Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: Text(installmentItems),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            payTypeDropdown = newValue!;
                                            if (payTypeDropdown != 'تکمیل') {
                                              _isVisibleForPayment = true;
                                            } else {
                                              _isVisibleForPayment = false;
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: _isVisibleForPayment,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 20.0,
                                      right: 20.0,
                                      top: 10.0,
                                      bottom: 10.0),
                                  child: TextFormField(
                                    controller: _recievableController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'مبلغ رسید نمی تواند خالی باشد.';
                                      } else if (paidAmount >= totalAmount) {
                                        return 'مبلغ رسید باید کمتر از کل مصارف باشد.';
                                      }
                                      return null;
                                    },
                                    onChanged: onCalculateDueAmount,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'مبلغ رسید',
                                      suffixIcon: Icon(Icons.money_rounded),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50.0)),
                                          borderSide:
                                              BorderSide(color: Colors.grey)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50.0)),
                                          borderSide:
                                              BorderSide(color: Colors.blue)),
                                      errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50.0)),
                                          borderSide:
                                              BorderSide(color: Colors.red)),
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50.0)),
                                          borderSide: BorderSide(
                                              color: Colors.red, width: 1.5)),
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: _isVisibleForPayment,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 20.0,
                                      right: 20.0,
                                      top: 10.0,
                                      bottom: 10.0),
                                  child: TextFormField(
                                    controller: _dueAmountController,
                                    readOnly: true,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'مبلغ باقی',
                                      suffixIcon: Icon(Icons.money_rounded),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50.0)),
                                          borderSide:
                                              BorderSide(color: Colors.grey)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50.0)),
                                          borderSide:
                                              BorderSide(color: Colors.blue)),
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
                ),
              ];

          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            title: const Directionality(
              textDirection: TextDirection.rtl,
              child: Center(child: Text('افزودن مراجعه (جلسه)')),
            ),
            content: SizedBox(
              width: 600.0,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Stepper(
                  controlsBuilder:
                      (BuildContext context, ControlsDetails controls) {
                    return Row(
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: controls.onStepContinue,
                          child: Text(reachedLastStep ? 'ثبت کردن' : 'ادامه'),
                        ),
                        TextButton(
                          onPressed:
                              _currentStep == 0 ? null : controls.onStepCancel,
                          child: const Text('بازگشت'),
                        ),
                      ],
                    );
                  },
                  steps: stepList1(),
                  currentStep: _currentStep,
                  type: StepperType.horizontal,
                  onStepCancel: () {
                    print('Current Step: $_currentStep');
                    setState(() {
                      if (_currentStep > 0) {
                        _currentStep--;
                        reachedLastStep = false;
                      }
                    });
                  },
                  // currentStep: currentStep,
                  onStepContinue: () {
                    if (_ptFormKey1.currentState!.validate()) {
                      setState(() {
                        if (_currentStep < stepList1().length - 1) {
                          // First ensure that the fields are selected/inserted correctly
                          onConfirmForm();
                          // This condition is to make label of last step differ from others.
                          if (_currentStep == 1) {
                            reachedLastStep = true;
                          } else {
                            reachedLastStep = false;
                          }
                        } else if (_ptFormKey2.currentState!.validate()) {
                          onAddNewAppointment(context);
                          Navigator.of(context, rootNavigator: true).pop();
                        }
                      });
                    }
                  },
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
                          onPressed: () =>
                              Navigator.of(context, rootNavigator: true).pop(),
                          child: const Text('بستن')),
                      TextButton(onPressed: () {}, child: const Text('انجام')),
                    ],
                  ))
            ],
          );
        }),
      ),
    );
  }

  // Displays an alert dialog to edit patient's details
  onEditPatient(BuildContext context) {
    String dropdownValue = 'مجرد';
    var items = ['مجرد', 'متاهل'];

    // ِDeclare variables for gender dropdown
    String genderDropDown = 'مرد';
    var genderItems = ['مرد', 'زن'];

    // Blood group types
    String bloodDropDown = 'نامشخص';
    var bloodGroupItems = [
      'نامشخص',
      'A+',
      'B+',
      'AB+',
      'O+',
      'A-',
      'B-',
      'AB-',
      'O-'
    ];

    // Declare a dropdown for ages
    int ageDropDown = 1;

    return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Directionality(
                textDirection: TextDirection.rtl,
                child: Text('تغییر مشخصات مریض'),
              ),
              content: Directionality(
                textDirection: TextDirection.rtl,
                child: SizedBox(
                  width: 500.0,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(20.0),
                          child: const TextField(
                            decoration: InputDecoration(
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
                          child: const TextField(
                            decoration: InputDecoration(
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
                              labelText: 'سن',
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
                              child: SizedBox(
                                height: 26.0,
                                child: DropdownButton(
                                  isExpanded: true,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  value: ageDropDown,
                                  items: getAges().map((int ageItems) {
                                    return DropdownMenuItem(
                                      alignment: Alignment.centerRight,
                                      value: ageItems,
                                      child: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Text('$ageItems سال '),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (int? newValue) {
                                    setState(() {
                                      ageDropDown = newValue!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(20.0),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'جنیست',
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
                              child: SizedBox(
                                height: 26.0,
                                child: DropdownButton(
                                  isExpanded: true,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  value: genderDropDown,
                                  items: genderItems.map((String genderItems) {
                                    return DropdownMenuItem(
                                      alignment: Alignment.centerRight,
                                      value: genderItems,
                                      child: Text(genderItems),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      genderDropDown = newValue!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(20.0),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'حالت مدنی',
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
                              child: SizedBox(
                                height: 26.0,
                                child: DropdownButton(
                                  isExpanded: true,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  value: dropdownValue,
                                  items: items.map((String items) {
                                    return DropdownMenuItem(
                                      alignment: Alignment.centerRight,
                                      value: items,
                                      child: Text(items),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownValue = newValue!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(20.0),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'گروپ خون',
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
                              child: SizedBox(
                                height: 26.0,
                                child: DropdownButton(
                                  isExpanded: true,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  value: bloodDropDown,
                                  items: bloodGroupItems
                                      .map((String bloodGroupItems) {
                                    return DropdownMenuItem(
                                      alignment: Alignment.centerRight,
                                      value: bloodGroupItems,
                                      child: Text(bloodGroupItems),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      bloodDropDown = newValue!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(20.0),
                          child: TextField(
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
                          child: TextField(
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
              actions: [
                Directionality(
                    textDirection: TextDirection.rtl,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () =>
                                Navigator.of(context, rootNavigator: true)
                                    .pop(),
                            child: const Text('لغو')),
                        TextButton(
                            onPressed: () {}, child: const Text('انجام')),
                      ],
                    ))
              ],
            ));
  }

  // Displays an alert dialog to edit appointments
  onEditAppointment(BuildContext context) {
    // Declare a variable for payment installment
    String installments = 'تکمیل';

    int currentStep = 0;
    List<Step> stepList2() => [
          Step(
            state: currentStep <= 0 ? StepState.editing : StepState.complete,
            isActive: currentStep >= 0,
            title: const Text('تغییر خدمات مورد نیاز مریض'),
            content: SizedBox(
              width: 100.0,
              child: Center(
                child: SizedBox(
                  width: 500.0,
                  child: Column(
                    children: [
                      const Text(
                          'لطفا معلومات شخصی مریض را با دقت در خانه های ذیل وارد کنید.'),
                      Container(
                        margin: const EdgeInsets.all(20.0),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'نوعیت خدمات',
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
                            child: SizedBox(
                              height: 26.0,
                              child: DropdownButton(
                                isExpanded: true,
                                icon: const Icon(Icons.arrow_drop_down),
                                value: selectedSerId,
                                items: services.map((service) {
                                  return DropdownMenuItem<String>(
                                    value: service['ser_ID'],
                                    alignment: Alignment.centerRight,
                                    child: Text(service['ser_name']),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedSerId = newValue;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(20.0),
                        child: TextField(
                          maxLines: 5,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'توضیحات',
                            suffixIcon: Icon(Icons.description_outlined),
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
          Step(
            state: currentStep <= 1 ? StepState.editing : StepState.complete,
            isActive: currentStep >= 1,
            title: const Text('تغییر هزینه ها'),
            content: SizedBox(
              child: Center(
                child: SizedBox(
                    child: Center(
                  child: SizedBox(
                    width: 500.0,
                    child: Column(
                      children: [
                        const Text(
                            'لطفاً هزینه و اقساط را در خانه های ذیل انتخاب نمایید.'),
                        Container(
                          margin: const EdgeInsets.all(20.0),
                          child: const TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'کل مصارف',
                              suffixIcon: Icon(Icons.money_rounded),
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
                              labelText: 'نوعیت پرداخت',
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
                              child: SizedBox(
                                height: 26.0,
                                child: DropdownButton(
                                  isExpanded: true,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  value: installments,
                                  items: onPayInstallment()
                                      .map((String installmentItems) {
                                    return DropdownMenuItem(
                                      alignment: Alignment.centerRight,
                                      value: installmentItems,
                                      child: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Text(installmentItems),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      installments = newValue!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(20.0),
                          child: const TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'مبلغ رسید',
                              suffixIcon: Icon(Icons.money_rounded),
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
                )),
              ),
            ),
          ),
        ];

    bool lastField = false;

    return showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: ((context, setState) {
          return AlertDialog(
            title: const Directionality(
              textDirection: TextDirection.rtl,
              child: Text('تغییر مراجعات مریض'),
            ),
            content: SizedBox(
              width: 600.0,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Stepper(
                  controlsBuilder:
                      (BuildContext context, ControlsDetails controls) {
                    return Row(
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: controls.onStepContinue,
                          child: Text(lastField ? 'ثبت کردن' : 'ادامه'),
                        ),
                        TextButton(
                          onPressed:
                              currentStep == 0 ? null : controls.onStepCancel,
                          child: const Text('بازگشت'),
                        ),
                      ],
                    );
                  },
                  steps: stepList2(),
                  currentStep: currentStep,
                  type: StepperType.horizontal,
                  onStepCancel: () {
                    print('Current Step: $currentStep');
                    setState(() {
                      if (currentStep > 0) {
                        currentStep--;
                        lastField = false;
                      }
                    });
                  },
                  // currentStep: currentStep,
                  onStepContinue: () {
                    /*     print('Current Step: $currentStep');
                    setState(() {
                      if (currentStep < stepList2().length - 1) {
                        currentStep++;
                        // This condition is to make label of last step differ from others.
                        if (currentStep == 1) {
                          lastField = true;
                        } else {
                          lastField = false;
                        }
                      }
                    }); */
                  },
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
                          onPressed: () =>
                              Navigator.of(context, rootNavigator: true).pop(),
                          child: const Text('بستن')),
                      TextButton(onPressed: () {}, child: const Text('انجام')),
                    ],
                  ))
            ],
          );
        }),
      ),
    );
  }

// Displays an alert dialog to follow appointments
  onFollowAppointment(BuildContext context) {
    // Declare a variable for payment installment
    String installments = 'تکمیل';

    return showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: ((context, setState) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    'تعقیب جلسات قبلی',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                content: SizedBox(
                  width: 500.0,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: SizedBox(
                      child: Center(
                        child: SizedBox(
                            child: Center(
                          child: SizedBox(
                            width: 500.0,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  const Text(
                                      'لطفاً هزینه و اقساط را در خانه های ذیل انتخاب نمایید.'),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 20.0,
                                        right: 20.0,
                                        top: 10.0,
                                        bottom: 10.0),
                                    child: TextFormField(
                                      controller: _meetController,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'لطفا تاریخ مراجعه مریض را انتخاب کنید.';
                                        }
                                        return null;
                                      },
                                      onTap: () async {
                                        FocusScope.of(context).requestFocus(
                                          FocusNode(),
                                        );
                                        final DateTime? dateTime =
                                            await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(1900),
                                                lastDate: DateTime(2100));
                                        if (dateTime != null) {
                                          final intl2.DateFormat formatter =
                                              intl2.DateFormat('yyyy-MM-dd');
                                          final String formattedDate =
                                              formatter.format(dateTime);
                                          _meetController.text = formattedDate;
                                        }
                                      },
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9.]'))
                                      ],
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'تاریخ مراجعه',
                                        suffixIcon:
                                            Icon(Icons.calendar_month_outlined),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50.0)),
                                            borderSide:
                                                BorderSide(color: Colors.grey)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50.0)),
                                            borderSide:
                                                BorderSide(color: Colors.blue)),
                                        errorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50.0)),
                                            borderSide:
                                                BorderSide(color: Colors.red)),
                                        focusedErrorBorder: OutlineInputBorder(
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
                                        right: 20.0,
                                        top: 10.0,
                                        bottom: 10.0),
                                    child: const TextField(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'جلسه / نوبت',
                                        suffixIcon: Icon(Icons.money_rounded),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50.0)),
                                            borderSide:
                                                BorderSide(color: Colors.grey)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50.0)),
                                            borderSide:
                                                BorderSide(color: Colors.blue)),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 20.0,
                                        right: 20.0,
                                        top: 10.0,
                                        bottom: 10.0),
                                    child: InputDecorator(
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'فک / لثه',
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50.0)),
                                            borderSide:
                                                BorderSide(color: Colors.grey)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50.0)),
                                            borderSide:
                                                BorderSide(color: Colors.blue)),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: SizedBox(
                                          height: 26.0,
                                          child: DropdownButton(
                                            isExpanded: true,
                                            icon: const Icon(
                                                Icons.arrow_drop_down),
                                            value: selectedGumType1,
                                            items: gumsType1.map((gumType1) {
                                              return DropdownMenuItem<String>(
                                                value: gumType1['teeth_ID'],
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(gumType1['gum']),
                                              );
                                            }).toList(),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                selectedGumType1 = newValue;
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
                                        right: 20.0,
                                        top: 10.0,
                                        bottom: 10.0),
                                    child: InputDecorator(
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'فک / لثه',
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50.0)),
                                            borderSide:
                                                BorderSide(color: Colors.grey)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50.0)),
                                            borderSide:
                                                BorderSide(color: Colors.blue)),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: SizedBox(
                                          height: 26.0,
                                          child: DropdownButton<String>(
                                            isExpanded: true,
                                            icon: const Icon(
                                                Icons.arrow_drop_down),
                                            value: selectedGumType2,
                                            items: gums.map((gums) {
                                              return DropdownMenuItem<String>(
                                                value: gums['teeth_ID'],
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(gums['gum']),
                                              );
                                            }).toList(),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                selectedGumType2 = newValue;
                                                if (selectedSerId == '10') {
                                                  // Set this value since by changing لثه / فک below it, it should fetch the default selected value.
                                                  removedTooth = 'عقل دندان';
                                                  fetchRemoveTooth();
                                                }
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
                                        right: 20.0,
                                        top: 10.0,
                                        bottom: 10.0),
                                    child: const TextField(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'کل هزینه',
                                        suffixIcon: Icon(Icons.money_rounded),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50.0)),
                                            borderSide:
                                                BorderSide(color: Colors.grey)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50.0)),
                                            borderSide:
                                                BorderSide(color: Colors.blue)),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 20.0,
                                        right: 20.0,
                                        top: 10.0,
                                        bottom: 10.0),
                                    child: const TextField(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'باقی',
                                        suffixIcon: Icon(Icons.money_rounded),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50.0)),
                                            borderSide:
                                                BorderSide(color: Colors.grey)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50.0)),
                                            borderSide:
                                                BorderSide(color: Colors.blue)),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 20.0,
                                        right: 20.0,
                                        top: 10.0,
                                        bottom: 10.0),
                                    child: const TextField(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'مبلغ قابل پرداخت',
                                        suffixIcon: Icon(Icons.money_rounded),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50.0)),
                                            borderSide:
                                                BorderSide(color: Colors.grey)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50.0)),
                                            borderSide:
                                                BorderSide(color: Colors.blue)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )),
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
                              onPressed: () =>
                                  Navigator.of(context, rootNavigator: true)
                                      .pop(),
                              child: const Text('بستن')),
                          TextButton(
                              onPressed: () {}, child: const Text('انجام')),
                        ],
                      ))
                ],
              );
            },
          );
        }),
      ),
    );
  }

  // Declare a method to add ages 1 - 100
  List<int> getAges() {
    // Declare variables to contain from 1 - 100 for ages
    List<int> ages = [];
    for (int a = 1; a <= 100; a++) {
      ages.add(a);
    }
    return ages;
  }

  //  اقساط پرداخت
  List<String> onPayInstallment() {
    List<String> installmentItems = ['تکمیل', 'دو قسط', 'سه قسط'];
    return installmentItems;
  }

// This method displays a dialog box while deleting an appointment record
  onDeleteAppointment(BuildContext context, int appointmentId) {
    return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Directionality(
                textDirection: TextDirection.rtl,
                child: Text('حذف مراجعه مریض'),
              ),
              content: const Directionality(
                textDirection: TextDirection.rtl,
                child: Text('آیا میخواهید این ریکارد را حذف کنید؟'),
              ),
              actions: [
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: () async {
                          final conn = await onConnToDb();
                          var results = await conn.query(
                              'DELETE FROM appointments WHERE apt_ID = ?',
                              [appointmentId]);
                          if (results.affectedRows! > 0) {
                            _onShowSnack(
                                Colors.green, 'مراجعه موفقانه حذف شد.');
                            setState(() {});
                          } else {
                            _onShowSnack(Colors.red, 'مراجعه حذف نشد.');
                          }
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        child: const Text('حذف'),
                      ),
                      TextButton(
                          onPressed: () =>
                              Navigator.of(context, rootNavigator: true).pop(),
                          child: const Text('لغو')),
                    ],
                  ),
                ),
              ],
            ));
  }

//  This method displays an image
  onShowImage() {
    return Dialog(
      child: Container(
        width: 300.0,
        height: 300.0,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/graphics/login_img2.png'),
              fit: BoxFit.cover),
        ),
      ),
    );
  }

// Fetch appointment details
  Future<List<Appointment>> getAppointment() async {
    final conn = await onConnToDb();
    final results = await conn.query(
        '''SELECT G.staff_ID, G.firstname, G.lastname, B.apt_ID, DATE_FORMAT(B.meet_date, "%Y-%m-%d"), B.round, B.note, D.gum, C.tooth, F.ser_name, F.ser_name, A.firstname, A.lastname FROM patients A
           INNER JOIN appointments B ON A.pat_ID = B.pat_ID 
           INNER JOIN tooth_details C ON B.tooth_detail_ID = C.td_ID 
           INNER JOIN teeth D ON C.tooth_ID = D.teeth_ID  
           INNER JOIN service_details E ON B.service_detail_ID = E.ser_det_ID 
           INNER JOIN services F ON E.ser_id = F.ser_ID 
           INNER JOIN staff G ON B.staff_ID = G.staff_ID WHERE B.pat_ID = ?''',
        [PatientInfo.patID]);

    final appoints = results
        .map((row) => Appointment(
            staffID: row[0],
            staffFirstName: row[1],
            staffLastName: row[2],
            aptID: row[3],
            tooth: row[8] == 'tooth not required' ? '' : row[8],
            service: row[9],
            meetDate: row[4].toString(),
            gum: row[7],
            round: row[5],
            description: row[6].toString(),
            patFirstName: row[11],
            patLastName: row[12]))
        .toList();
    return appoints;
  }

// Create an alert dialog to confirm fields are inserted correctly.
  onConfirmForm() {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Directionality(
          textDirection: TextDirection.rtl,
          child: Text('کسب اطمینان'),
        ),
        content: const Directionality(
          textDirection: TextDirection.rtl,
          child: Text('آیا کاملاً مطمیین هستید در قسمت خانه پری این صفحه؟'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
              child: const Text('نگاه مجدد')),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  _currentStep++;
                  reachedLastStep = true;
                });
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: const Text('بله')),
        ],
      ),
    );
  }

// Add a new appointment (visit)
  Future<void> onAddNewAppointment(BuildContext context) async {
    String? meetDate = _meetController.text.isNotEmpty
        ? _meetController.text.toString()
        : null;

    String notes = _noteController.text.toString();

    var conn = await onConnToDb();
    int serviceID = int.parse(selectedSerId!);

    int? tDetailID;
    if (serviceID == 2 || serviceID == 6 || serviceID == 9 || serviceID == 11) {
      // Query for those services which require tooth numbers (1 - 8)

      // Fetch tooth ID based on its primary key from tooth_details.
      var toothResult = await conn.query(
          'SELECT * FROM tooth_details WHERE tooth = ? AND tooth_ID = ?',
          [selectedTooth2, selectedGumType2]);
      if (toothResult.isNotEmpty) {
        var tdRow = toothResult.first;
        tDetailID = tdRow['td_ID'];
      }
    } else if (serviceID == 10) {
      var removeResult = await conn.query(
          'SELECT * FROM tooth_details WHERE tooth = ? AND tooth_ID = ?',
          [removedTooth, selectedGumType2]);
      if (removeResult.isNotEmpty) {
        var row = removeResult.first;
        tDetailID = row['td_ID'];
      }
    } else if (serviceID == 3) {
      var bleachResult = await conn.query(
          'SELECT * FROM tooth_details WHERE tooth = ? AND tooth_ID = ?',
          ['tooth not required', selectedGumType2]);
      if (bleachResult.isNotEmpty) {
        var row = bleachResult.first;
        tDetailID = row['td_ID'];
      }
    } else if (serviceID == 4) {
      var scaleResult = await conn.query(
          'SELECT * FROM tooth_details WHERE tooth = ? AND tooth_ID = ?',
          ['tooth not required', selectedGumType1]);
      if (scaleResult.isNotEmpty) {
        var row = scaleResult.first;
        tDetailID = row['td_ID'];
      }
    } else if (serviceID == 5) {
      var orthoResult = await conn.query(
          'SELECT * FROM tooth_details WHERE tooth = ? AND tooth_ID = ?',
          ['tooth not required', selectedGumType1]);
      if (orthoResult.isNotEmpty) {
        var row = orthoResult.first;
        tDetailID = row['td_ID'];
      }
    } else if (serviceID == 7) {
      var gumResult = await conn.query(
          'SELECT * FROM tooth_details WHERE tooth = ? AND tooth_ID = ?',
          ['tooth not required', selectedGumType1]);
      if (gumResult.isNotEmpty) {
        var row = gumResult.first;
        tDetailID = row['td_ID'];
      }
    } else {
      var toothResult = await conn.query(
          'SELECT * FROM tooth_details WHERE tooth = ? AND tooth_ID = ?',
          ['tooth not required', selectedGumType2]);
      if (toothResult.isNotEmpty) {
        var tdRow = toothResult.first;
        tDetailID = tdRow['td_ID'];
      }
    }

// Declare this variable to be assigned ser_det_ID of service_details table
    int? serviceDID;
    if (serviceID == 2) {
      serviceDID = selectedFill;
    } else if (serviceID == 3) {
      serviceDID = selectedServiceDetailID;
    } else if (serviceID == 9) {
      serviceDID = selectedProthis;
    } else if (serviceID == 11) {
      serviceDID = selectedMaterial;
    } else if (serviceID == 8) {
      tDetailID = null;
      serviceDID = 15;
    } else if (serviceID == 4) {
      serviceDID = 17;
    } else if (serviceID == 5) {
      serviceDID = 18;
    } else if (serviceID == 7) {
      serviceDID = 19;
    }

    double totalAmount = double.parse(_totalExpController.text);
    double recieved = totalAmount;
    double dueAmount = 0;
    int installment = payTypeDropdown == 'تکمیل'
        ? 1
        : payTypeDropdown == 'دو قسط'
            ? 2
            : 3;
    if (payTypeDropdown != 'تکمیل') {
      recieved = double.parse(_recievableController.text);
      dueAmount = totalAmount - recieved;
    }

    // Now add appointment of the patient
    var newAptResults = await conn.query(
        'INSERT INTO appointments (pat_ID, tooth_detail_ID, service_detail_ID, installment, round, paid_amount, due_amount, meet_date, staff_ID, note) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
        [
          PatientInfo.patID,
          tDetailID,
          serviceDID,
          installment,
          1,
          recieved,
          dueAmount,
          meetDate,
          StaffInfo.staffID,
          notes
        ]);

    if (newAptResults.affectedRows! > 0) {
      _onShowSnack(Colors.green, 'مراجعه موفقانه افزوده شد.');
      _noteController.clear();
      _meetController.clear();
      _totalExpController.clear();
      _recievableController.clear();
      setState(() {
        _currentStep = 0;
      });
    } else {
      print('Adding appointments faield.');
    }
  }

// This is shows snackbar when called
  void _onShowSnack(Color backColor, String msg) {
    _ptGlobalKey.currentState?.showSnackBar(
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

  //  لثه برای جرم گیری
  String? selectedGumType1;
  List<Map<String, dynamic>> gumsType1 = [];
  Future<void> chooseGumType1() async {
    var conn = await onConnToDb();
    var results = await conn.query(
        'SELECT teeth_ID, gum from teeth WHERE teeth_ID IN (1, 2, 3) ORDER BY teeth_ID DESC');
    gumsType1 = results
        .map((result) => {'teeth_ID': result[0].toString(), 'gum': result[1]})
        .toList();
    selectedGumType1 = gumsType1.isNotEmpty ? gumsType1[0]['teeth_ID'] : null;
    await conn.close();
  }

//  لثه برای استفاده متعدد
  String? selectedGumType2;
  List<Map<String, dynamic>> gums = [];

  Future<void> onChooseGum2() async {
    var conn = await onConnToDb();
    var queryResult = await conn.query(
        'SELECT teeth_ID, gum FROM teeth WHERE teeth_ID IN (4, 5, 6, 7, 1)');
    gums = queryResult
        .map((row) => {'teeth_ID': row[0].toString(), 'gum': row[1]})
        .toList();
    selectedGumType2 = gums.isNotEmpty ? gums[1]['teeth_ID'] : null;
    await conn.close();
  }

//  پرکاری دندان
  String? selectedFilling;
  List<Map<String, dynamic>> teethFillings = [];

  Future<void> onFillTeeth() async {
    var conn = await onConnToDb();
    var queryFill = await conn.query(
        'SELECT ser_det_ID, service_specific_value FROM service_details WHERE ser_det_ID >= 1 AND ser_det_ID < 4');
    teethFillings = queryFill
        .map((result) => {
              'ser_det_ID': result[0].toString(),
              'service_specific_value': result[1]
            })
        .toList();

    selectedFilling =
        teethFillings.isNotEmpty ? teethFillings[0]['ser_det_ID'] : null;
    await conn.close();
  }

//  تعداد دندان
  List<Map<String, dynamic>> teeth = [];
  Future<void> fetchToothNum() async {
    String? toothId = selectedGumType2 ?? '4';
    var conn = await onConnToDb();
    var results = await conn.query(
        'SELECT td_ID, tooth from tooth_details WHERE tooth_ID = ? LIMIT 8',
        [toothId]);
    teeth = results
        .map((result) => {'td_ID': result[0].toString(), 'tooth': result[1]})
        .toList();
    selectedTooth2 = teeth.isNotEmpty ? teeth[0]['td_ID'] : null;
    await conn.close();
  }
}

// Create a data model to set/get appointment details
class Appointment {
  final int staffID;
  final String staffFirstName;
  final String staffLastName;
  final int aptID;
  final String tooth;
  final String service;
  final String meetDate;
  final String gum;
  final int round;
  final String description;
  final String patFirstName;
  final String patLastName;

  Appointment(
      {required this.staffID,
      required this.staffFirstName,
      required this.staffLastName,
      required this.aptID,
      required this.tooth,
      required this.service,
      required this.meetDate,
      required this.gum,
      required this.round,
      required this.description,
      required this.patFirstName,
      required this.patLastName});
}

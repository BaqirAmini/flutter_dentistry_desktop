import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dentistry/views/main/dashboard.dart';
import 'patients.dart' as patient_ist;
import 'patient_info.dart';
import 'package:flutter_dentistry/models/db_conn.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          floatingActionButton: Tooltip(
            message: 'جلسه جدید',
            child: FloatingActionButton(
              onPressed: () {
                print('FAB is clicked.');
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
                                    fontSize: 16, fontWeight: FontWeight.bold),
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
                                  padding: const EdgeInsets.all(8.0),
                                  child: SingleChildScrollView(
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
                                        // more rows ...
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
                                  6: FixedColumnWidth(80),
                                  7: FixedColumnWidth(80),
                                  8: FixedColumnWidth(80),
                                  9: FixedColumnWidth(80),
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
                                              6: FixedColumnWidth(80),
                                              7: FixedColumnWidth(80),
                                              8: FixedColumnWidth(80),
                                              9: FixedColumnWidth(80),
                                            },
                                            children: [
                                              for (var apt in appoints!)
                                                // add your table rows here
                                                TableRow(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(apt.service),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(apt.meetDate),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(apt.gum),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(apt.tooth),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child:
                                                          Text(apt.description),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                          apt.round.toString()),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                          '${apt.staffFirstName} ${apt.staffLastName}'),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Builder(builder:
                                                          (BuildContext
                                                              context) {
                                                        return IconButton(
                                                          onPressed: () {
                                                            onEditAppointment(
                                                                context);
                                                          },
                                                          icon: const Icon(
                                                              Icons
                                                                  .add_to_queue_outlined,
                                                              color:
                                                                  Colors.blue,
                                                              size: 18.0),
                                                        );
                                                      }),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
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
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Builder(
                                                        builder: (context) =>
                                                            IconButton(
                                                          onPressed: () {
                                                            onDeleteAppointment(
                                                                context);
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
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Builder(
                                                        builder: (context) =>
                                                            IconButton(
                                                          onPressed: () {
                                                            showDialog(
                                                              context: context,
                                                              builder: (context) =>
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
    List<Step> stepList() => [
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
                  steps: stepList(),
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
                    print('Current Step: $currentStep');
                    setState(() {
                      if (currentStep < stepList().length - 1) {
                        currentStep++;
                        // This condition is to make label of last step differ from others.
                        if (currentStep == 1) {
                          lastField = true;
                        } else {
                          lastField = false;
                        }
                      }
                    });
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
  onDeleteAppointment(BuildContext context) {
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
                Row(
                  children: [
                    TextButton(
                        onPressed: () =>
                            Navigator.of(context, rootNavigator: true).pop(),
                        child: const Text('لغو')),
                    TextButton(
                      onPressed: () {},
                      child: const Text('حذف'),
                    ),
                  ],
                )
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
            tooth: row[8],
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

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter_dentistry/models/db_conn.dart';
import 'package:galileo_mysql/src/single_connection.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_dentistry/views/main/sidebar.dart';
import 'package:shamsi_date/shamsi_date.dart';

void main() {
  return runApp(const Dashboard());
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _allPatients = 0;
  int _todaysPatients = 0;
// This function fetch patients' records
  Future<void> _fetchAllPatient() async {
    try {
      final conn = await onConnToDb();
      // Fetch all patients
      var allPatResults = await conn.query('SELECT COUNT(*) FROM patients');
      int allPatients = allPatResults.first[0];

      // Fetch the patients who are added today
      var todayResult = await conn.query(
          'SELECT COUNT(*) FROM patients WHERE DATE(reg_date) = CURDATE()');
      int todayPat = todayResult.first[0];
      await conn.close();
      setState(() {
        _allPatients = allPatients;
        _todaysPatients = todayPat;
      });
    } on SocketException catch (e) {
      print('Error in dashboard: $e');
    } catch (e) {
      print('Error in dashboard: $e');
    }
  }

  double _currentMonthExp = 0;
  double _curYearTax = 0;
  Future<void> _fetchFinance() async {
    try {
      final conn = await onConnToDb();
      // Fetch sum of current month expenses
      var expResults = await conn.query(
          'SELECT SUM(total) FROM expense_detail WHERE YEAR(purchase_date) = YEAR(CURDATE()) AND MONTH(purchase_date) = MONTH(CURDATE())');
      double curMonthExp =
          (expResults.isNotEmpty && expResults.first[0] != null)
              ? expResults.first[0]
              : 0;
      // Firstly, fetch jalali(hijri shamsi) from current date.
      final jalaliDate = Jalali.now();
      final hijriYear = jalaliDate.year;
      // Query taxes of current hijri year
      var taxResults = await conn.query(
          'SELECT total_annual_tax FROM taxes WHERE tax_for_year = ?',
          [hijriYear]);
      double curYearTax = (taxResults.isNotEmpty && taxResults.first[0] != null)
          ? taxResults.first[0]
          : 0;

      await conn.close();
      setState(() {
        _currentMonthExp = curMonthExp;
        _curYearTax = curYearTax;
      });
    } on SocketException catch (e) {
      print('Error in dashboard: $e');
    } catch (e) {
      print('Error in dashboard: $e');
    }
  }

  bool _isPieDataInitialized = false;

  @override
  void initState() {
    super.initState();
    _fetchAllPatient();
    try {
      _fetchFinance();
    } catch (e) {
      print('Data not loaded $e');
    }
    _getPieData();
    _getLastSixMonthPatient();
  }

  PageController page = PageController();
  List<_PatientsData> patientData = [];

  Future<void> _getLastSixMonthPatient() async {
    final conn = await onConnToDb();
    final results = await conn.query(
        'SELECT MONTHNAME(reg_date), COUNT(*) FROM patients WHERE (reg_date >= CURDATE() - INTERVAL 6 MONTH) GROUP BY MONTH(reg_date)');

    for (var row in results) {
      patientData.add(_PatientsData(row[0].toString(), double.parse(row[1].toString())));
    }

    await conn.close();
  }

/*   List<_PatientsData> data = [
    _PatientsData('Jan', 10),
    _PatientsData('Feb', 20),
    _PatientsData('Mar', 20),
    _PatientsData('Apr', 50),
    _PatientsData('May', 40),
    _PatientsData('Jun', 35)
  ]; */

  late List<_PieData> pieData;
// Fetch the expenses of last three months into pie char
  Future<void> _getPieData() async {
    final conn = await onConnToDb();
    try {
      // Execute the query
      final results = await conn.query(
          "SELECT A.exp_name, DATE_FORMAT(B.purchase_date, '%M'), SUM(B.total) FROM expenses A INNER JOIN expense_detail B ON A.exp_ID = B.exp_ID WHERE B.purchase_date >= CURDATE() - INTERVAL 3 MONTH GROUP BY A.exp_name");

      // Close the connection
      await conn.close();

      // Map the results to a list of _PieData objects
      pieData = results
          .map((row) =>
              _PieData(row[0].toString(), row[2] as double, row[1].toString()))
          .toList();

      // Set _isPieDataInitialized to true
      _isPieDataInitialized = true;
      setState(() {});
    } on SocketException catch (e) {
      print('Error in dashboard: $e');
    } catch (e) {
      print('Error in dashboard: $e');
    }
  }

/*   List<_PieData> pieData = [
    _PieData('Jan', 9000, 'خوراک'),
    _PieData('Feb', 15000, 'آب'),
    _PieData('Mar', 100000, 'مالیات'),
  ]; */

  SideMenuController sideMenu = SideMenuController();

  @override
  Widget build(BuildContext context) {
    /*  final userData =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final staffId = userData["staffID"];
    final staffRole = userData["role"]; */

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'کلینیک دندان درمان',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  tooltip: "باز کردن مینوی راست",
                  icon: const Icon(Icons.menu),
                );
              },
            ),
          ),
          drawer: Sidebar(),
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 150),
              ),
              Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Card(
                          color: Colors.blue,
                          child: SizedBox(
                            height: 120,
                            width: 270.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.blue[400],
                                  child: const Icon(
                                      Icons.supervised_user_circle,
                                      color: Colors.white),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 0.0,
                                      top: 0.0,
                                      right: 15.0,
                                      bottom: 0.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text('مریض های امروز',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.white)),
                                      Text('$_todaysPatients نفر',
                                          style: const TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.white)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          color: Colors.orange,
                          child: SizedBox(
                            height: 120,
                            width: 270.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.orange[400],
                                  child: const Icon(Icons.attach_money_rounded,
                                      color: Colors.white),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 0.0,
                                      top: 0.0,
                                      right: 15.0,
                                      bottom: 0.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text('مصارف ماه جاری',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.white)),
                                      Text('$_currentMonthExp افغانی',
                                          style: const TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.white)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          color: Colors.green,
                          child: SizedBox(
                            height: 120,
                            width: 270.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.green[400],
                                  child: const Icon(
                                      Icons.money_off_csred_outlined,
                                      color: Colors.white),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 0.0,
                                      top: 0.0,
                                      right: 15.0,
                                      bottom: 0.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text('مالیات امسال',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.white)),
                                      Text('$_curYearTax افغانی',
                                          style: const TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.white)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          color: Colors.brown,
                          child: SizedBox(
                            height: 120,
                            width: 270.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.brown[400],
                                  child: const Icon(Icons.people_outline,
                                      color: Colors.white),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 0.0,
                                      top: 0.0,
                                      right: 15.0,
                                      bottom: 0.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text('همه مریض ها',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.white)),
                                      Text('$_allPatients نفر',
                                          style: const TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.white)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      children: [
                        Card(
                          child: SizedBox(
                            height: 350,
                            width: 800.0,
                            child: Column(
                              children: [
                                SfCartesianChart(
                                    primaryXAxis: CategoryAxis(),
                                    // Chart title
                                    title: ChartTitle(
                                        text: 'مراجعه بیماران در شش ماه گذشته'),
                                    // Enable legend
                                    legend: Legend(isVisible: true),
                                    // Enable tooltip
                                    tooltipBehavior:
                                        TooltipBehavior(enable: true, format: 'point.y نفر : point.x',),
                                    series: <ChartSeries<_PatientsData,
                                        String>>[
                                      LineSeries<_PatientsData, String>(
                                          dataSource: patientData,
                                          xValueMapper:
                                              (_PatientsData patients, _) =>
                                                  patients.month,
                                          yValueMapper:
                                              (_PatientsData patients, _) =>
                                                  patients.numberOfPatient,
                                          name: 'بیماران',
                                          // Enable data label
                                          dataLabelSettings:
                                              const DataLabelSettings(
                                                  isVisible: true))
                                    ]),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          child: SizedBox(
                            height: 350.0,
                            width: 300.0,
                            child: Column(
                              children: [
                                if (!_isPieDataInitialized)
                                  const CircularProgressIndicator()
                                else
                                  SfCircularChart(
                                    title:
                                        ChartTitle(text: 'مصارف سه ماه اخیر'),
                                    // Enable legend
                                    legend: Legend(
                                      isVisible: true,
                                      width: '75',
                                      height: '100',
                                      position: LegendPosition.left,
                                      textStyle:
                                          const TextStyle(fontSize: 10.0),
                                    ),
                                    // Enable tooltip
                                    tooltipBehavior: TooltipBehavior(
                                      enable: true,
                                      format: 'point.y افغانی : point.x',
                                    ),
                                    series: <PieSeries<_PieData, String>>[
                                      PieSeries<_PieData, String>(
                                          explode: true,
                                          explodeIndex: 0,
                                          dataSource: pieData,
                                          xValueMapper: (_PieData data, _) =>
                                              data.xData,
                                          yValueMapper: (_PieData data, _) =>
                                              data.yData,
                                          dataLabelMapper: (_PieData data, _) =>
                                              data.text,
                                          dataLabelSettings:
                                              const DataLabelSettings(
                                                  isVisible: true)),
                                    ],
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
            ],
          ),
        ),
      ),
    );
  }
}

class _PatientsData {
  _PatientsData(this.month, this.numberOfPatient);

  final String month;
  final double numberOfPatient;
}

class _PieData {
  _PieData(this.xData, this.yData, [this.text]);

  final String xData;
  final num yData;
  final String? text;
}

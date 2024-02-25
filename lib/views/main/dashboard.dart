import 'dart:io';
import 'package:flutter_dentistry/config/global_usage.dart';
import 'package:flutter_dentistry/config/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dentistry/config/translations.dart';
import 'package:flutter_dentistry/models/db_conn.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_dentistry/views/main/sidebar.dart';
import 'package:shamsi_date/shamsi_date.dart';

void main() {
  return runApp(
    const Dashboard(),
  );
}

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _allPatients = 0;
  int _todaysPatients = 0;
  // This variable is to set the first filter value of doughnut chart dropdown
  String incomeFreq = '1 Month';
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

  bool _isPatientDataInitialized = false;
  // Declare to assign total income to use it in the doughnut chart
  double totalIncome = 0;

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
        'SELECT DATE_FORMAT(reg_date, "%b %d, %Y"), COUNT(*) FROM patients WHERE (reg_date >= CURDATE() - INTERVAL 6 MONTH) GROUP BY MONTH(reg_date)');

    for (var row in results) {
      patientData.add(
          _PatientsData(row[0].toString(), double.parse(row[1].toString())));
    }

    await conn.close();
    setState(() {
      _isPatientDataInitialized = true;
    });
  }

/*   List<_PatientsData> data = [
    _PatientsData('Jan', 10),
    _PatientsData('Feb', 20),
    _PatientsData('Mar', 20),
    _PatientsData('Apr', 50),
    _PatientsData('May', 40),
    _PatientsData('Jun', 35)
  ]; */

  late List<_PieDataIncome> pieData;
// Fetch the expenses of last three months into pie char
  Future<List<_PieDataIncome>> _getPieData() async {
    try {
      int numberOnly = int.parse(incomeFreq.split(' ')[0]);
      final conn = await onConnToDb();
      var result = await conn.query(
          'SELECT SUM(total_fee) as sum FROM appointments WHERE (meet_date >= CURDATE() - INTERVAL ? MONTH)',
          [numberOnly]);
      double totalFee = result.first['sum'] ?? 0;

      result = await conn.query('SELECT SUM(total) as sum FROM expense_detail  WHERE (purchase_date >= CURDATE() - INTERVAL ? MONTH)', [numberOnly]);
      double totalExpenses = result.first['sum'] ?? 0;

      // Whole due amount on patients
      result = await conn.query('''
                          SELECT SUM(due_amount) as due_amount 
                          FROM (
                              SELECT due_amount 
                              FROM fee_payments 
                              WHERE (payment_ID, apt_ID) IN (
                                  SELECT MAX(payment_ID), apt_ID 
                                  FROM fee_payments 
                                   WHERE payment_date >= DATE_SUB(CURDATE(), INTERVAL ? MONTH)
                                  GROUP BY apt_ID
                              )
                          ) AS total_due_amount''', [numberOnly]);
      double totalDueAmount = result.first['due_amount'] ?? 0;

      var earnings = totalFee - (totalExpenses + totalDueAmount);
      // Total Income
      totalIncome = totalExpenses + totalFee - totalDueAmount;
      await conn.close();
      return [
        _PieDataIncome('Expenses', totalExpenses, Colors.red),
        _PieDataIncome('Earnings', earnings, Colors.green),
      ];
    } on SocketException catch (e) {
      print('Error in dashboard: $e');
      return [];
    } catch (e) {
      print('Error in dashboard: $e');
      return [];
    }
  }

  Future<void> _alertNotification() async {
    try {
      final conn = await onConnToDb();
      final results = await conn.query(
          'SELECT * FROM appointments a INNER JOIN patients p ON a.pat_ID = p.pat_ID WHERE status = ? AND meet_date > NOW()',
          ['Pending']);

      // Loop through the results
      for (final row in results) {
        // Get the notification frequency for this appointment
        final notificationFrequency = row['notification'];
        final patientId = row['pat_ID'];
        final patientFName = row['firstname'];
        final patientLName = row['lastname'] ?? '';

        // Calculate the time until the notification should be shown
        final appointmentTime = row['meet_date'];
        DateTime? timeUntilNotification;

        if (notificationFrequency == '15 Minutes') {
          timeUntilNotification =
              appointmentTime.subtract(const Duration(minutes: 15));
        } else if (notificationFrequency == '5 Minutes') {
          timeUntilNotification =
              appointmentTime.subtract(const Duration(minutes: 5));
        } else if (notificationFrequency == '1 Hour') {
          timeUntilNotification =
              appointmentTime.subtract(const Duration(hours: 1));
        } else if (notificationFrequency == '2 Hours') {
          timeUntilNotification =
              appointmentTime.subtract(const Duration(hours: 2));
        }

// Make a copy of the variables
        final patientIdCopy = patientId;
        final patientFNameCopy = patientFName;
        final patientLNameCopy = patientLName;
        // Schedule the notification
        if (timeUntilNotification != null) {
          // Create an instance of this class to access its method to alert for upcoming notification
          GlobalUsage gu = GlobalUsage();
          gu.alertUpcomingAppointment(
              patientIdCopy, patientFNameCopy, patientLNameCopy);
        }
      }
    } catch (e) {
      print('Error occured with notification: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    /*  final userData =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final staffId = userData["staffID"];
    final staffRole = userData["role"]; */
    _alertNotification();
    return ChangeNotifierProvider(
        create: (_) => LanguageProvider(),
        builder: (context, child) {
          final languageProvider = Provider.of<LanguageProvider>(context);
          final isEnglish = languageProvider.selectedLanguage == 'English';
          return MaterialApp(
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate
            ],
            supportedLocales: const [
              Locale('en', ''), // English, no country code
              Locale('fa', ''), // Dari, no country code
              Locale('ps', ''), // Pashto, no country code
            ],
            debugShowCheckedModeBanner: false,
            home: Directionality(
              textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
              child: Scaffold(
                appBar: AppBar(
                  title: const Text(
                    'کلینیک دندان درمان',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  leading: Builder(
                    builder: (BuildContext context) {
                      return IconButton(
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                          setState(() {});
                        },
                        tooltip: translations[languageProvider.selectedLanguage]
                                ?["OpenDrawerMsg"] ??
                            '',
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
                        Container(
                          margin: const EdgeInsets.only(top: 50.0),
                          child: Row(
                            children: [
                              Card(
                                color: Colors.indigo,
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.16,
                                  width:
                                      MediaQuery.of(context).size.width * 0.19,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.indigo[400],
                                        child: const Icon(
                                            Icons.supervised_user_circle,
                                            color: Colors.white),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 15.0,
                                            top: 0.0,
                                            right: 15.0,
                                            bottom: 0.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                (translations[languageProvider
                                                                .selectedLanguage]
                                                            ?['TodayPatient'] ??
                                                        '')
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.white)),
                                            Text(
                                                '$_todaysPatients ${(translations[languageProvider.selectedLanguage]?['People'] ?? '').toString()}',
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
                                  height:
                                      MediaQuery.of(context).size.height * 0.16,
                                  width:
                                      MediaQuery.of(context).size.width * 0.19,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.orange[400],
                                        child: const Icon(
                                            Icons.attach_money_rounded,
                                            color: Colors.white),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 15.0,
                                            top: 0.0,
                                            right: 15.0,
                                            bottom: 0.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                (translations[languageProvider
                                                                .selectedLanguage]
                                                            ?[
                                                            'CurrentMonthExpenses'] ??
                                                        '')
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.white)),
                                            Text(
                                                '$_currentMonthExp ${(translations[languageProvider.selectedLanguage]?['Afn'] ?? '').toString()}',
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
                                  height:
                                      MediaQuery.of(context).size.height * 0.16,
                                  width:
                                      MediaQuery.of(context).size.width * 0.19,
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
                                            left: 15.0,
                                            top: 0.0,
                                            right: 15.0,
                                            bottom: 0.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                (translations[languageProvider
                                                                .selectedLanguage]
                                                            ?[
                                                            'CurrentYearTaxes'] ??
                                                        '')
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.white)),
                                            Text(
                                                '$_curYearTax ${(translations[languageProvider.selectedLanguage]?['Afn'] ?? '').toString()}',
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
                                  height:
                                      MediaQuery.of(context).size.height * 0.16,
                                  width:
                                      MediaQuery.of(context).size.width * 0.19,
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
                                            left: 15.0,
                                            top: 0.0,
                                            right: 15.0,
                                            bottom: 0.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                (translations[languageProvider
                                                                .selectedLanguage]
                                                            ?['AllPatients'] ??
                                                        '')
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.white)),
                                            Text(
                                                '$_allPatients ${(translations[languageProvider.selectedLanguage]?['People'] ?? '').toString()}',
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
                          margin: const EdgeInsets.only(top: 30.0),
                          child: Row(
                            children: [
                              Card(
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.6,
                                  width:
                                      MediaQuery.of(context).size.width * 0.47,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (!_isPatientDataInitialized)
                                        const CircularProgressIndicator()
                                      else
                                        SfCartesianChart(
                                            primaryXAxis: CategoryAxis(),
                                            // Chart title
                                            title: ChartTitle(
                                                text: (translations[languageProvider
                                                                .selectedLanguage]
                                                            ?[
                                                            'LastSixMonthPatients'] ??
                                                        '')
                                                    .toString()),
                                            // Enable legend
                                            legend: Legend(isVisible: true),
                                            // Enable tooltip
                                            tooltipBehavior: TooltipBehavior(
                                              enable: true,
                                              format:
                                                  'point.y ${(translations[languageProvider.selectedLanguage]?['People'] ?? '').toString()} : point.x',
                                            ),
                                            series: <ChartSeries<_PatientsData,
                                                String>>[
                                              LineSeries<_PatientsData, String>(
                                                  animationDuration:
                                                      CircularProgressIndicator
                                                          .strokeAlignCenter,
                                                  dataSource: patientData,
                                                  xValueMapper:
                                                      (_PatientsData patients,
                                                              _) =>
                                                          patients.month,
                                                  yValueMapper: (_PatientsData
                                                              patients,
                                                          _) =>
                                                      patients.numberOfPatient,
                                                  name: (translations[languageProvider
                                                                  .selectedLanguage]
                                                              ?['Patients'] ??
                                                          '')
                                                      .toString(),
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
                                  height:
                                      MediaQuery.of(context).size.height * 0.6,
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.1,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.06,
                                              child: InputDecorator(
                                                decoration:
                                                    const InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 8.0),
                                                  border: OutlineInputBorder(),
                                                  labelText: 'Frequency',
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10.0)),
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
                                                                          10.0)),
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .blue)),
                                                ),
                                                child:
                                                    DropdownButtonHideUnderline(
                                                  child: SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.03,
                                                    child: ButtonTheme(
                                                      alignedDropdown: true,
                                                      child: DropdownButton(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        // isExpanded: true,
                                                        icon: const Icon(Icons
                                                            .arrow_drop_down),
                                                        value: incomeFreq,

                                                        items: <String>[
                                                          '1 Month',
                                                          '3 Months',
                                                          '6 Months',
                                                          '9 Months',
                                                          '12 Months'
                                                        ].map<
                                                            DropdownMenuItem<
                                                                String>>((String
                                                            value) {
                                                          return DropdownMenuItem<
                                                              String>(
                                                            value: value,
                                                            child: Text(value,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyMedium),
                                                          );
                                                        }).toList(),
                                                        onChanged:
                                                            (String? newValue) {
                                                          setState(() {
                                                            incomeFreq =
                                                                newValue!;
                                                            _getPieData();
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      /* SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.05),
 */
                                      FutureBuilder<List<_PieDataIncome>>(
                                        future: _getPieData(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.4,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.4,
                                              child: SfCircularChart(
                                                legend: Legend(isVisible: true),
                                                tooltipBehavior:
                                                    TooltipBehavior(
                                                  color: const Color.fromARGB(
                                                      255, 106, 105, 105),
                                                  enable: true,
                                                  format:
                                                      'point.x: point.y افغانی',
                                                ),
                                                annotations: [
                                                  CircularChartAnnotation(
                                                    widget: Text(
                                                      '${totalIncome.toString()} افغانی',
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ],
                                                series: <CircularSeries>[
                                                  DoughnutSeries<_PieDataIncome,
                                                      String>(
                                                    explode: true,
                                                    explodeOffset: '10%',
                                                    enableTooltip: true,
                                                    dataSource: snapshot.data,
                                                    innerRadius: '70%',
                                                    pointColorMapper:
                                                        (_PieDataIncome data,
                                                                _) =>
                                                            data.color,
                                                    xValueMapper:
                                                        (_PieDataIncome data,
                                                                _) =>
                                                            data.x,
                                                    yValueMapper:
                                                        (_PieDataIncome data,
                                                                _) =>
                                                            data.y,
                                                    dataLabelSettings:
                                                        const DataLabelSettings(
                                                      isVisible: false,
                                                      textStyle: TextStyle(
                                                          fontSize: 8.0),
                                                    ),
                                                    selectionBehavior:
                                                        SelectionBehavior(
                                                            enable: true,
                                                            selectedBorderWidth:
                                                                2.0),
                                                  )
                                                ],
                                              ),
                                            );
                                          } else if (snapshot.hasError) {
                                            return Text("${snapshot.error}");
                                          }
                                          return const CircularProgressIndicator();
                                        },
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
            theme: ThemeData(useMaterial3: false),
          );
        });
  }
}

class _PatientsData {
  _PatientsData(this.month, this.numberOfPatient);

  final String month;
  final double numberOfPatient;
}

class _PieDataIncome {
  _PieDataIncome(this.x, this.y, this.color);
  final String x;
  final num y;
  final Color color;
}

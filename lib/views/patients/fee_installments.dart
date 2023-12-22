import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dentistry/config/global_usage.dart';
import 'package:flutter_dentistry/models/db_conn.dart';
import 'package:flutter_dentistry/views/patients/patient_info.dart';
import 'package:flutter_dentistry/views/patients/patients.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart' as intl2;

void main() => runApp(const FeeRecord());

class FeeRecord extends StatelessWidget {
  const FeeRecord({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fee Management'),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const BackButtonIcon(),
          ),
        ),
        body: Center(
          child: Container(
            margin: const EdgeInsets.only(top: 15),
            width: MediaQuery.of(context).size.width * 0.9,
            child: const FeeContent(),
          ),
        ),
      ),
    );
  }
}

class FeeContent extends StatefulWidget {
  const FeeContent({super.key});

  @override
  State<FeeContent> createState() => _FeeContentState();
}

class _FeeContentState extends State<FeeContent> {
  // Assign default selected staff
  String? defaultSelectedStaff;
  List<Map<String, dynamic>> staffList = [];
  final _formKey4Payment = GlobalKey<FormState>();
  final TextEditingController _payDateController = TextEditingController();
  final TextEditingController _recievableController = TextEditingController();

// This is to add payment made by a patient
  _onMakePayment(BuildContext context) {
    return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Directionality(
                textDirection: TextDirection.rtl,
                child: Text('دریافت اقساط فیس'),
              ),
              content: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  children: [
                    const Text(
                        'لطفاً قیمت های مربوطه را در خانه های ذیل با دقت پر کنید.'),
                    Form(
                      key: _formKey4Payment,
                      child: SizedBox(
                        width: 500.0,
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 20.0),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  top: 30.0, left: 20, right: 20),
                              child: TextFormField(
                                controller: _payDateController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'تاریخ خرید نمی تواند خالی باشد.';
                                  }
                                },
                                onTap: () async {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
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
                                    _payDateController.text = formattedDate;
                                  }
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9.]'))
                                ],
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'تاریخ خرید جنس',
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
                              width: 400.0,
                              margin: const EdgeInsets.only(
                                  left: 20.0,
                                  right: 10.0,
                                  top: 10.0,
                                  bottom: 10.0),
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'انتخاب داکتر',
                                  labelStyle:
                                      TextStyle(color: Colors.blueAccent),
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
                                  child: Container(
                                    height: 18.0,
                                    padding: EdgeInsets.zero,
                                    child: DropdownButton(
                                      isExpanded: true,
                                      icon: const Icon(Icons.arrow_drop_down),
                                      value: defaultSelectedStaff,
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.black),
                                      items: staffList.map((staff) {
                                        return DropdownMenuItem<String>(
                                          value: staff['staff_ID'],
                                          alignment: Alignment.centerRight,
                                          child: Text(staff['firstname'] +
                                              ' ' +
                                              staff['lastname']),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          defaultSelectedStaff = newValue;
                                          staffID = int.parse(newValue!);
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                const Text(
                                  '*',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  width: 400,
                                  margin: const EdgeInsets.only(
                                      left: 20.0,
                                      right: 10.0,
                                      top: 10.0,
                                      bottom: 10.0),
                                  child: TextFormField(
                                    controller: _recievableController,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(GlobalUsage.allowedDigPeriod),
                                      ),
                                    ],
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'مبلغ رسید نمی تواند خالی باشد.';
                                      } /* else if (double.parse(value) >
                                          _feeWithDiscount) {
                                        return 'مبلغ رسید باید کمتر از مبلغ قابل دریافت باشد.';
                                      } */
                                      return null;
                                    },
                                    /*  onChanged: (value) {
                                      setState(() {
                                        if (value.isEmpty) {
                                          _dueAmount = _feeWithDiscount;
                                        } else {
                                          _setInstallment(value.toString());
                                        }
                                      });
                                    }, */
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
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  '*',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  width: 400,
                                  margin: const EdgeInsets.only(
                                      left: 20.0,
                                      right: 10.0,
                                      top: 10.0,
                                      bottom: 10.0),
                                  child: TextFormField(
                                    controller: _recievableController,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(GlobalUsage.allowedDigPeriod),
                                      ),
                                    ],
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'مبلغ رسید نمی تواند خالی باشد.';
                                      } /* else if (double.parse(value) >
                                          _feeWithDiscount) {
                                        return 'مبلغ رسید باید کمتر از مبلغ قابل دریافت باشد.';
                                      } */
                                      return null;
                                    },
                                    /*  onChanged: (value) {
                                      setState(() {
                                        if (value.isEmpty) {
                                          _dueAmount = _feeWithDiscount;
                                        } else {
                                          _setInstallment(value.toString());
                                        }
                                      });
                                    }, */
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
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () =>
                        Navigator.of(context, rootNavigator: true).pop(),
                    child: const Text('لغو')),
                TextButton(
                  onPressed: () async {
                    /*  final conn = await onConnToDb();
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
                  Navigator.of(context, rootNavigator: true).pop(); */
                  },
                  child: const Text('ثبت'),
                ),
              ],
            ));
  }

  // Fetch staff which will be needed later.
  Future<void> fetchStaff() async {
    // Fetch staff for purchased by fields
    var conn = await onConnToDb();
    var results =
        await conn.query('SELECT staff_ID, firstname, lastname FROM staff');
    defaultSelectedStaff =
        staffList.isNotEmpty ? staffList[0]['staff_ID'] : null;
    // setState(() {
    staffList = results
        .map((result) => {
              'staff_ID': result[0].toString(),
              'firstname': result[1],
              'lastname': result[2]
            })
        .toList();
    // });
    await conn.close();
  }

// Fetch appointments-related fields & fee
  Future<List<ApptFeeDataModel>> _fetchApptFee() async {
    final conn = await onConnToDb();
    final results = await conn.query(
        '''SELECT s.ser_name, a.installment, a.total_fee, a.round, fp.payment_ID, 
            fp.installment_counter, DATE_FORMAT(fp.payment_date, '%M %d, %Y'), fp.paid_amount, fp.due_amount, fp.whole_fee_paid, fp.apt_ID
            FROM services s 
            INNER JOIN appointments a ON s.ser_ID = a.service_ID
            INNER JOIN fee_payments fp ON fp.apt_ID = a.apt_ID WHERE a.pat_ID = ?''',
        [PatientInfo.patID]);

    final apptFees = results
        .map((row) => ApptFeeDataModel(
            serviceName: row[0],
            totalInstallment: row[1] == 0 ? 1 : row[1],
            totalFee: row[2],
            round: row[3],
            paymentID: row[4],
            instCounter: row[5],
            paymentDate: row[6].toString(),
            paidAmount: row[7],
            dueAmount: row[8],
            isWholePaid: row[9],
            apptID: row[10]))
        .toList();

    await conn.close();
    return apptFees;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchApptFee(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          if (snapshot.data!.isEmpty) {
            return const Center(child: Text('No Fee and Installments found.'));
          } else {
            final apptFee = snapshot.data;
            for (var af in apptFee!) {
              return ListView(
                children: [
                  Card(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              color: Colors.grey[200],
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 5.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    af.serviceName,
                                    style: const TextStyle(fontSize: 18.0),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(right: 90.0),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0)),
                                      elevation: 0,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                            'Installments: ${af.totalInstallment}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 0.0,
                              right: 8.0,
                              child: Material(
                                color: Colors.transparent,
                                shape: const CircleBorder(),
                                child: PopupMenuButton<String>(
                                  onSelected: (String result) {
                                    print('You selected: $result');
                                  },
                                  itemBuilder: (BuildContext context) =>
                                      <PopupMenuEntry<String>>[
                                    PopupMenuItem<String>(
                                      value: 'Option 1',
                                      onTap: () => _onMakePayment(context),
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Icon(Icons.payments_outlined,
                                              color: Colors.grey),
                                          SizedBox(width: 10.0),
                                          Text(
                                            'Earn Payment',
                                            style: TextStyle(
                                              color: Color.fromRGBO(
                                                  86, 85, 85, 0.765),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const PopupMenuItem<String>(
                                      value: 'Option 2',
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Icon(Icons.delete_forever_outlined,
                                              color: Colors.grey),
                                          SizedBox(width: 10.0),
                                          Text(
                                            'Delete',
                                            style: TextStyle(
                                              color: Color.fromRGBO(
                                                  86, 85, 85, 0.765),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                  icon: const Icon(Icons.more_vert,
                                      color:
                                          Color.fromARGB(255, 148, 147, 147)),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        NonExpandableCard(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.green[400],
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.currency_exchange,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10.0),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        af.paymentDate,
                                        style: const TextStyle(fontSize: 18.0),
                                      ),
                                      const Text(
                                        'تحت نظر: ',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 12.0),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const SizedBox(width: 15.0),
                                  Container(
                                    width: 100.0,
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        right: BorderSide(
                                            width: 0.5, color: Colors.grey),
                                      ),
                                    ),
                                    child: InputDecorator(
                                      decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          labelText: 'Installment',
                                          labelStyle:
                                              TextStyle(color: Colors.grey),
                                          floatingLabelAlignment:
                                              FloatingLabelAlignment.center),
                                      child: Center(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            child: Container(
                                              color: const Color.fromARGB(
                                                  255, 104, 166, 106),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5.0,
                                                        vertical: 2.0),
                                                child: Text(
                                                  '${af.instCounter.toString()} / ${af.totalInstallment.toString()}',
                                                  style: const TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 15.0),
                                  SizedBox(
                                    width: 100.0,
                                    height: 100.0,
                                    child: SfCircularChart(
                                      margin: EdgeInsets.zero,
                                      tooltipBehavior: TooltipBehavior(
                                        color: Color.fromARGB(255, 106, 105, 105),
                                        textStyle: TextStyle(fontSize: 8.0),
                                        enable: true,
                                        format: 'point.x: point.y افغانی',
                                      ),
                                      annotations: [
                                        CircularChartAnnotation(
                                          widget: Text(
                                            '${af.totalFee} افغانی',
                                            style: const TextStyle(
                                                fontSize: 8.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                      series: <DoughnutSeries<FeeDoughnutData,
                                          String>>[
                                        DoughnutSeries<FeeDoughnutData, String>(
                                            innerRadius: '70%',
                                            dataSource: <FeeDoughnutData>[
                                              FeeDoughnutData('Paid',
                                                  af.paidAmount, Colors.green),
                                              FeeDoughnutData('Due',
                                                  af.dueAmount, Colors.pink),
                                            ],
                                            xValueMapper:
                                                (FeeDoughnutData data, _) =>
                                                    data.feePaid,
                                            pointColorMapper:
                                                (FeeDoughnutData data, _) =>
                                                    data.color,
                                            yValueMapper:
                                                (FeeDoughnutData data, _) =>
                                                    data.feeDue,
                                            dataLabelSettings:
                                                const DataLabelSettings(
                                              isVisible: false,
                                              textStyle:
                                                  TextStyle(fontSize: 8.0),
                                            ),
                                            selectionBehavior:
                                                SelectionBehavior(
                                                    enable: true,
                                                    selectedBorderWidth: 2.0)),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
            return const Text('');
          }
        }
      },
    );
  }
}

// This widget shapes the expandable area of the card when clicked.
class NonExpandableCard extends StatelessWidget {
  final Widget title;

  const NonExpandableCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: title,
    );
  }
}

class FeeDoughnutData {
  FeeDoughnutData(this.feePaid, this.feeDue, this.color);
  final String feePaid;
  final double feeDue;
  final Color color;
}

// Create data model to assign appointments-related, services-related and fee-payments-related fields
class ApptFeeDataModel {
  final String serviceName;
  final int totalInstallment;
  final double totalFee;
  final int round;
  final int paymentID;
  final int instCounter;
  final String paymentDate;
  final double paidAmount;
  final double dueAmount;
  final int isWholePaid;
  final int apptID;

  ApptFeeDataModel(
      {required this.serviceName,
      required this.totalInstallment,
      required this.totalFee,
      required this.round,
      required this.paymentID,
      required this.instCounter,
      required this.paymentDate,
      required this.paidAmount,
      required this.dueAmount,
      required this.isWholePaid,
      required this.apptID});
}

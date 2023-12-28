import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dentistry/config/global_usage.dart';
import 'package:flutter_dentistry/models/db_conn.dart';
import 'package:flutter_dentistry/views/patients/patient_info.dart';
import 'package:flutter_dentistry/views/patients/patients.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart' as intl2;

void main() => runApp(const FeeRecord());

// Declare these two display total fee paid & total fee due.
double totalFeeToBePaid = 0;
double totalFeeDue = 0;
// Declare to show/hide the first widget containing totalFeeToBePaid/totalFeeDue
bool displayTotalFeeRow = false;

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
            child: Column(
              children: [
                Visibility(
                  visible: displayTotalFeeRow ? true : false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Fee: $totalFeeToBePaid AFN',
                            style: const TextStyle(
                                color: Colors.green, fontSize: 15.0)),
                        Text('Total Due: ${-totalFeeDue} AFN',
                            style: const TextStyle(
                                color: Colors.red, fontSize: 15.0)),
                      ],
                    ),
                  ),
                ),
                const Expanded(
                  child: FeeContent(),
                )
              ],
            ),
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
  final TextEditingController _installmentController = TextEditingController();

// This is to add payment made by a patient
  _onMakePayment(BuildContext context, int instCounter, int totalInstallment,
      double totalFee, double dueAmount, int apptID, Function onRefreshPage) {
// Call to fetch dentists
    _fetchStaff();
    // Any time a payment is made, installment should be incremented.
    int instIncrement = ++instCounter;
    _installmentController.text = '$instIncrement / $totalInstallment';

    return showDialog(
        context: context,
        builder: (ctx) {
          double displayedDueAmount = dueAmount;
          double lastEnteredAmount = 0;
          double receivable = 0;
          return StatefulBuilder(
            builder: (context, setState) {
              String? errorMessage;
              // This function deducts from due amount

              void deductDueAmount(String text) {
                receivable = text.isEmpty || double.parse(text) > dueAmount
                    ? 0
                    : double.parse(text);

                setState(() {
                  // If text is empty or greater than dueAmount, reset lastEnteredAmount
                  if (text.isEmpty || double.parse(text) > dueAmount) {
                    displayedDueAmount +=
                        lastEnteredAmount; // Add the last entered amount back
                    lastEnteredAmount = 0; // Reset last entered amount
                  } else {
                    displayedDueAmount += lastEnteredAmount -
                        receivable; // Deduct the new amount from the last entered amount
                    lastEnteredAmount =
                        receivable; // Update the last entered amount
                  }
                });
              }

              return AlertDialog(
                title: const Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text('دریافت فیس مریض'),
                ),
                content: Directionality(
                  textDirection: TextDirection.rtl,
                  child: SizedBox(
                    height: 450.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                            'لطفاً قیمت های مربوطه را در خانه های ذیل با دقت پر کنید.'),
                        Form(
                          key: _formKey4Payment,
                          child: SizedBox(
                            width: 500.0,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        '*',
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Container(
                                        width: 450,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 20.0, vertical: 10.0),
                                        child: TextFormField(
                                          controller: _payDateController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'تاریخ دریافت فیس نمی تواند خالی باشد.';
                                            }
                                            return errorMessage;
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
                                                  intl2.DateFormat(
                                                      'yyyy-MM-dd');
                                              final String formattedDate =
                                                  formatter.format(dateTime);
                                              _payDateController.text =
                                                  formattedDate;
                                            }
                                          },
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9.]'))
                                          ],
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'تاریخ دریافت فیس',
                                            suffixIcon: Icon(
                                                Icons.calendar_month_outlined),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(50.0)),
                                                borderSide: BorderSide(
                                                    color: Colors.grey)),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(50.0)),
                                                borderSide: BorderSide(
                                                    color: Colors.blue)),
                                            errorBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(50.0)),
                                                borderSide: BorderSide(
                                                    color: Colors.red)),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                50.0)),
                                                    borderSide: BorderSide(
                                                        color: Colors.red,
                                                        width: 1.5)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: 500.0,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 10.0),
                                    child: InputDecorator(
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'داکتر مربوطه',
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
                                            icon: const Icon(
                                                Icons.arrow_drop_down),
                                            value: defaultSelectedStaff,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.black),
                                            items: staffList.map((staff) {
                                              return DropdownMenuItem<String>(
                                                value: staff['staff_ID'],
                                                alignment:
                                                    Alignment.centerRight,
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
                                  Container(
                                    width: 450.0,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 10.0),
                                    child: TextFormField(
                                      controller: _installmentController,
                                      readOnly: true,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                          RegExp(GlobalUsage.allowedDigPeriod),
                                        ),
                                      ],
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'قسط دریافت',
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
                                  Row(
                                    children: [
                                      const Text(
                                        '*',
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Container(
                                        width: 450.0,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 20.0, vertical: 10.0),
                                        child: TextFormField(
                                          controller: _recievableController,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                              RegExp(
                                                  GlobalUsage.allowedDigPeriod),
                                            ),
                                          ],
                                          validator: (value) {
                                            double receivedAmount =
                                                value!.isEmpty
                                                    ? 0
                                                    : double.parse(value);
                                            if (value.isEmpty) {
                                              return 'مبلغ رسید نمی تواند خالی باشد.';
                                            } else if (receivedAmount >
                                                dueAmount) {
                                              return 'مبلغ رسید باید کمتر از مبلغ قابل دریافت باشد.';
                                            } else if (instCounter ==
                                                totalInstallment) {
                                              if (receivedAmount < dueAmount) {
                                                return 'آخرین قسط است باید همه فیس باقیمانده پرداخته شود.';
                                              } else {
                                                return null;
                                              }
                                            } else {
                                              return null;
                                            }
                                          },
                                          onChanged: (text) {
                                            deductDueAmount(text);
                                          },
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'مبلغ رسید',
                                            suffixIcon:
                                                Icon(Icons.money_rounded),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(50.0)),
                                                borderSide: BorderSide(
                                                    color: Colors.grey)),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(50.0)),
                                                borderSide: BorderSide(
                                                    color: Colors.blue)),
                                            errorBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(50.0)),
                                                borderSide: BorderSide(
                                                    color: Colors.red)),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                50.0)),
                                                    borderSide: BorderSide(
                                                        color: Colors.red,
                                                        width: 1.5)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 180.0,
                                        margin: const EdgeInsets.all(5),
                                        decoration: const BoxDecoration(
                                            border: Border(
                                          top: BorderSide(
                                              width: 1, color: Colors.grey),
                                          bottom: BorderSide(
                                              width: 1, color: Colors.grey),
                                        )),
                                        child: InputDecorator(
                                          decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              labelText: 'مجموع فیس',
                                              floatingLabelAlignment:
                                                  FloatingLabelAlignment
                                                      .center),
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Center(
                                              child: Text(
                                                '$totalFee افغانی',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.all(5),
                                        width: 180.0,
                                        decoration: const BoxDecoration(
                                            border: Border(
                                          top: BorderSide(
                                              width: 1, color: Colors.grey),
                                          bottom: BorderSide(
                                              width: 1, color: Colors.grey),
                                        )),
                                        child: InputDecorator(
                                          decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              labelText: 'باقی مبلغ',
                                              floatingLabelAlignment:
                                                  FloatingLabelAlignment
                                                      .center),
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Center(
                                              child: Text(
                                                '$displayedDueAmount افغانی',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
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
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextButton(
                          onPressed: () =>
                              Navigator.of(context, rootNavigator: true).pop(),
                          child: const Text('لغو')),
                      ElevatedButton(
                          onPressed: () async {
                            final conn = await onConnToDb();
                            if (_formKey4Payment.currentState!.validate()) {
                              bool dateResult = await _fetchPaidDate(
                                  _payDateController.text, apptID);

                              if (dateResult) {
                                errorMessage = null;

                                try {
                                  await conn.query(
                                      '''INSERT INTO fee_payments (installment_counter, payment_date, paid_amount, due_amount, whole_fee_paid, staff_ID, apt_ID)
                                    VALUES (?, ?, ?, ?, ?, ?, ?)''',
                                      [
                                        instCounter,
                                        _payDateController.text,
                                        receivable,
                                        displayedDueAmount,
                                        displayedDueAmount == 0 ? 1 : 0,
                                        defaultSelectedStaff,
                                        apptID
                                      ]);
                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  onRefreshPage();
                                } catch (e) {
                                  print('Error with inserting payment: $e');
                                }
                                await conn.close();
                              } else {
                                errorMessage =
                                    'تاریخ باید بزرگتر یا مساوی به تاریخ پرداخت قبلی باشد.';
                              }
                            }
                            _formKey4Payment.currentState!.validate();
                          },
                          child: const Text('ثبت')),
                    ],
                  ),
                ],
              );
            },
          );
        });
  }

  // Fetch staff which will be needed later.
  Future<void> _fetchStaff() async {
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

  Future<bool> _fetchPaidDate(String date, int aptID) async {
    try {
      final conn = await onConnToDb();
      final results = await conn.query(
          'SELECT payment_date FROM fee_payments WHERE apt_ID = ? AND payment_date <= ?',
          [aptID, date]);
      if (results.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Date error: $e');
      return false;
    }
  }

// Fetch appointments-related fields & fee
  Future<List<ApptFeeDataModel>> _fetchApptFee() async {
    final conn = await onConnToDb();
    final results = await conn.query(
        '''SELECT s.ser_name, a.installment, a.total_fee, a.round, fp.payment_ID, 
            fp.installment_counter, DATE_FORMAT(fp.payment_date, '%M %d, %Y'), fp.paid_amount, fp.due_amount, fp.whole_fee_paid, fp.apt_ID
            FROM services s 
            INNER JOIN appointments a ON s.ser_ID = a.service_ID
            INNER JOIN fee_payments fp ON fp.apt_ID = a.apt_ID WHERE a.pat_ID = ? ORDER BY fp.installment_counter DESC''',
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
  void initState() {
    super.initState();
    _fetchStaff();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchApptFee(),
      builder: (context, snapshot) {
        // To avoid incrementing these two variables by any widget tree built, they should be set zero.
        totalFeeToBePaid = 0;
        totalFeeDue = 0;
        if (snapshot.connectionState == ConnectionState.waiting) {
          displayTotalFeeRow = true;
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          if (snapshot.data!.isEmpty) {
            displayTotalFeeRow = false;
            return const Center(child: Text('No Fee and Installments found.'));
          } else {
            final apptFee = snapshot.data;
            final Map<String, List<ApptFeeDataModel>> groupedApptFees = {};

            for (var af in apptFee!) {
              String key = '${af.serviceName}-${af.apptID}'; // Composite key
              if (!groupedApptFees.containsKey(key)) {
                groupedApptFees[key] = [];
                totalFeeToBePaid += af.totalFee;
                totalFeeDue += af.dueAmount;
              }

              groupedApptFees[key]!.add(af);

              
              displayTotalFeeRow = true;
            }
            return ListView(
              children: groupedApptFees.entries.map<Widget>((entry) {
                // Since it is displaying like: servicename - ID, on the screen it should not be display so.
                final keyParts = entry.key.split('-');
                final serviceName = keyParts[0];
                final payments = entry.value;
                return Stack(
                  children: [
                    Card(
                      elevation: 0.3,
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            color: Colors.grey[200],
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  serviceName,
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
                                          'Installments: ${payments.last.totalInstallment}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          for (var payment in payments)
                            Column(
                              children: [
                                // Divider(color: Colors.grey, thickness: 0.5),
                                Container(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          width: 0.3, color: Colors.grey),
                                    ),
                                  ),
                                  child: NonExpandableCard(
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                                  payment.paymentDate,
                                                  style: const TextStyle(
                                                      fontSize: 18.0),
                                                ),
                                                const Text(
                                                  'تحت نظر: ',
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12.0),
                                                ),
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
                                                      width: 0.5,
                                                      color: Colors.grey),
                                                ),
                                              ),
                                              child: InputDecorator(
                                                decoration: const InputDecoration(
                                                    border: InputBorder.none,
                                                    labelText: 'Installment',
                                                    labelStyle: TextStyle(
                                                        color: Colors.grey),
                                                    floatingLabelAlignment:
                                                        FloatingLabelAlignment
                                                            .center),
                                                child: Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5.0),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                      child: Container(
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 104, 166, 106),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      5.0,
                                                                  vertical:
                                                                      2.0),
                                                          child: Text(
                                                            '${payment.instCounter.toString()} / ${payment.totalInstallment.toString()}',
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        12.0,
                                                                    color: Colors
                                                                        .white),
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
                                                tooltipBehavior:
                                                    TooltipBehavior(
                                                  color: const Color.fromARGB(
                                                      255, 106, 105, 105),
                                                  textStyle: const TextStyle(
                                                      fontSize: 8.0),
                                                  enable: true,
                                                  format:
                                                      'point.x: point.y افغانی',
                                                ),
                                                annotations: [
                                                  CircularChartAnnotation(
                                                    widget: Text(
                                                      '${payment.totalFee} افغانی',
                                                      style: const TextStyle(
                                                          fontSize: 8.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ],
                                                series: <DoughnutSeries<
                                                    FeeDoughnutData, String>>[
                                                  DoughnutSeries<
                                                      FeeDoughnutData, String>(
                                                    innerRadius: '70%',
                                                    dataSource: <FeeDoughnutData>[
                                                      FeeDoughnutData(
                                                          'Paid',
                                                          payment.paidAmount,
                                                          Colors.green),
                                                      FeeDoughnutData(
                                                          'Due',
                                                          payment.dueAmount,
                                                          Colors.pink),
                                                    ],
                                                    xValueMapper:
                                                        (FeeDoughnutData data,
                                                                _) =>
                                                            data.feePaid,
                                                    pointColorMapper:
                                                        (FeeDoughnutData data,
                                                                _) =>
                                                            data.color,
                                                    yValueMapper:
                                                        (FeeDoughnutData data,
                                                                _) =>
                                                            data.feeDue,
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
                              ],
                            ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 5.0,
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
                              onTap: payments.first.dueAmount <= 0
                                  ? null
                                  : () => _onMakePayment(
                                          context,
                                          payments.first.instCounter,
                                          payments.first.totalInstallment,
                                          payments.first.totalFee,
                                          payments.first.dueAmount,
                                          payments.first.apptID, () {
                                        setState(() {});
                                      }),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                      payments.first.dueAmount <= 0
                                          ? Icons.check_circle_outline
                                          : Icons.payments_outlined,
                                      color: payments.first.dueAmount <= 0
                                          ? Colors.green
                                          : Colors.grey),
                                  const SizedBox(width: 10.0),
                                  Text(
                                    payments.first.dueAmount <= 0
                                        ? 'Whole Fee Paid'
                                        : 'Earn Payment',
                                    style: TextStyle(
                                        color: payments.first.dueAmount <= 0
                                            ? Colors.green
                                            : const Color.fromRGBO(
                                                86, 85, 85, 0.765)),
                                  ),
                                ],
                              ),
                            ),
                            const PopupMenuItem<String>(
                              value: 'Option 2',
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.delete_forever_outlined,
                                      color: Colors.grey),
                                  SizedBox(width: 10.0),
                                  Text(
                                    'Delete',
                                    style: TextStyle(
                                      color: Color.fromRGBO(86, 85, 85, 0.765),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          icon: const Icon(Icons.more_vert,
                              color: Color.fromARGB(255, 148, 147, 147)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            );
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
      contentPadding: const EdgeInsets.only(left: 8.0),
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

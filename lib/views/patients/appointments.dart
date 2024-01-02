import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dentistry/config/global_usage.dart';
import 'package:flutter_dentistry/config/language_provider.dart';
import 'package:flutter_dentistry/config/translations.dart';
import 'package:flutter_dentistry/models/db_conn.dart';
import 'package:flutter_dentistry/views/main/dashboard.dart';
import 'package:flutter_dentistry/views/patients/new_appointment.dart';
import 'package:flutter_dentistry/views/patients/patient_info.dart';
import 'package:flutter_dentistry/views/patients/patients.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

void main() {
  runApp(const Appointment());
}

// Set global variables which are needed later.
var selectedLanguage;
var isEnglish;

// This is to show a snackbar message.
void _onShowSnack(Color backColor, String msg, BuildContext context) {
  Flushbar(
    backgroundColor: backColor,
    flushbarStyle: FlushbarStyle.GROUNDED,
    flushbarPosition: FlushbarPosition.BOTTOM,
    messageText: Directionality(
      textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
      child: Text(
        msg,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white),
      ),
    ),
    duration: const Duration(seconds: 3),
  ).show(context);
}

class Appointment extends StatefulWidget {
  const Appointment({super.key});

  @override
  State<Appointment> createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  @override
  Widget build(BuildContext context) {
    // Fetch translations keys based on the selected language.
    var languageProvider = Provider.of<LanguageProvider>(context);
    selectedLanguage = languageProvider.selectedLanguage;
    isEnglish = selectedLanguage == 'English';
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NewAppointment()),
              ).then((_) {
                setState(() {});
              });
              // This is assigned to identify appointments.round i.e., if it is true round is stored '1' otherwise increamented by 1
              GlobalUsage.newPatientCreated = false;
            },
            tooltip: 'افزودن جلسه جدید',
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          appBar: AppBar(
            title: const Text('Appointment'),
            leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const BackButtonIcon()),
            actions: [
              IconButton(
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const Patient()),
                    (route) => route.settings.name == 'Patient'),
                icon: const Icon(Icons.people_outline),
                tooltip: 'Patients',
                padding: const EdgeInsets.all(3.0),
                splashRadius: 30.0,
              ),
              const SizedBox(width: 15.0),
              IconButton(
                // This routing approach removes all middle routes from the stack which are between dashboard and this page.
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const Dashboard()),
                    (route) => route.settings.name == 'Dashboard'),
                icon: const Icon(Icons.home_outlined),
                tooltip: 'Dashboard',
                padding: const EdgeInsets.all(3.0),
                splashRadius: 30.0,
              ),
              const SizedBox(width: 15.0)

              /* Tooltip(
              message: 'افزودن جلسه جدید',
              child: InkWell(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.0),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ), */
            ],
          ),
          body: Center(
            child: Container(
              margin: const EdgeInsets.only(top: 15),
              width: MediaQuery.of(context).size.width * 0.9,
              child: Column(
                children: [
                  Expanded(
                    child: _AppointmentContent(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// This widget contains all appointment records and details using loop
class _AppointmentContent extends StatefulWidget {
  @override
  State<_AppointmentContent> createState() => _AppointmentContentState();
}

class _AppointmentContentState extends State<_AppointmentContent> {
// This function deletes an appointment after opening a dialog box.
  onDeleteAppointment(BuildContext context, int id, Function refresh) {
    return showDialog(
      useRootNavigator: true,
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Directionality(
              textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
              child: const Text('Delete an appointment'),
            ),
            content: Directionality(
              textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
              child: const Text(
                  'Are you sure you want to delete this appointment'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(translations[selectedLanguage]?['CancelBtn'] ?? ''),
              ),
              TextButton(
                onPressed: () async {
                  final conn = await onConnToDb();
                  final deleteResult = await conn
                      .query('DELETE FROM appointments WHERE apt_ID = ?', [id]);
                  if (deleteResult.affectedRows! > 0) {
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                    // ignore: use_build_context_synchronously
                    _onShowSnack(Colors.green, 'جلسه مریض حذف گردید.', context);
                    refresh();
                  }
                  await conn.close();
                },
                child: Text(translations[selectedLanguage]?['Delete'] ?? ''),
              ),
            ],
          );
        },
      ),
    );
  }

// This function edits an appointment
  /* onEditAppointment(BuildContext context, int id, String date, double paidAmount, double dueAmount) {
// The global for the form
    final formKey = GlobalKey<FormState>();
// The text editing controllers for the TextFormFields
    final dateController = TextEditingController();
    final paidController = TextEditingController();
    final dueController = TextEditingController();

  

    return showDialog(
      context: context,
      builder: ((context) {
        return AlertDialog(
          title: const Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              'تغییر سرویس',
              style: TextStyle(color: Colors.blue),
            ),
          ),
          content: Directionality(
            textDirection: TextDirection.rtl,
            child: Form(
              key: formKey,
              child: SizedBox(
                width: 500.0,
                height: 190.0,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(15.0),
                      child: TextFormField(
                        controller: nameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'نام سرویس الزامی میباشد.';
                          } else if (value.length < 5 || value.length > 30) {
                            return 'نام سرویس باید 5 الی 30 حرف شد.';
                          }
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(regExOnlyAbc),
                          ),
                        ],
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'نام سرویس (خدمات)',
                          suffixIcon: Icon(Icons.medical_services_sharp),
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
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1.5)),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(15.0),
                      child: TextFormField(
                        controller: feeController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                        ],
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'فیس تعیین شده',
                          suffixIcon: Icon(Icons.money),
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
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1.5)),
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
                      onPressed: () => Navigator.pop(context),
                      child: const Text('لغو')),
                  ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        String serName = nameController.text;
                        double serFee = feeController.text.isNotEmpty
                            ? double.parse(feeController.text)
                            : 0;
                        final conn = await onConnToDb();
                        final results = await conn.query(
                            'UPDATE services SET ser_name = ?, ser_fee = ? WHERE ser_ID = ?',
                            [serName, serFee, serviceId]);
                        if (results.affectedRows! > 0) {
                          _onShowSnack(
                              Colors.green, 'سرویس موفقانه تغییر کرد.');
                          setState(() {});
                        } else {
                          _onShowSnack(Colors.red,
                              'شما هیچ تغییراتی به این سرویس نیاوردید.');
                        }
                        // ignore: use_build_context_synchronously
                        Navigator.of(context, rootNavigator: true).pop();
                        await conn.close();
                      }
                    },
                    child: const Text(' تغییر دادن'),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
 */
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getAppointment(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          if (snapshot.data!.isEmpty) {
            return const Center(child: Text('No appointments found.'));
          } else {
            var data = snapshot.data!;

            var groupedData = groupBy(data, (obj) => obj['meetDate']);
            var groupedRound = groupBy(data, (obj) => obj['round']);

            return ListView.builder(
              itemCount: groupedData.keys.length,
              itemBuilder: (context, index) {
                var meetDate = groupedData.keys.elementAt(index);
                var round = groupedRound.keys.elementAt(index);
                return Card(
                  elevation: 0.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        color: Colors.grey[200],
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 5.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              meetDate,
                              style: const TextStyle(fontSize: 18.0),
                            ),
                            const Spacer(),
                            Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                              elevation: 0.5,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text('Round: $round',
                                    style:
                                        Theme.of(context).textTheme.labelSmall),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ...groupedData[meetDate]!
                          .map<Widget>((e) => Column(
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                                width: 0.3, color: Colors.grey),
                                          ),
                                        ),
                                        child: ExpandableCard(
                                          title: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.green,
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            color: Colors.green,
                                                            width: 2.0),
                                                      ),
                                                      child: const Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: Icon(
                                                          Icons
                                                              .calendar_today_outlined,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10.0),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          e['serviceName'],
                                                          style:
                                                              const TextStyle(
                                                                  fontSize:
                                                                      18.0),
                                                        ),
                                                        Text(
                                                          'تحت نظر: ${e['staffFName']} ${e['staffLName']}',
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize:
                                                                      12.0),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          child: FutureBuilder(
                                            future:
                                                _getServiceDetails(e['apptID']),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const Center(
                                                    child: Center(
                                                        child:
                                                            CircularProgressIndicator()));
                                              } else if (snapshot.hasError) {
                                                return Text(
                                                    'Error with service requirements: ${snapshot.error}');
                                              } else {
                                                if (snapshot.data!.isEmpty) {
                                                  return const Center(
                                                      child: Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Text(
                                                        'No requirements found.'),
                                                  ));
                                                } else {
                                                  var reqData = snapshot.data;
                                                  return ListTile(
                                                    title: Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              const Text(
                                                                'Service Name',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              Text(
                                                                e['serviceName'],
                                                                style:
                                                                    const TextStyle(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          112,
                                                                          112,
                                                                          112),
                                                                  fontSize:
                                                                      12.0,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        for (var req
                                                            in reqData!)
                                                          Column(children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    req.reqName ==
                                                                            'Teeth Selection'
                                                                        ? 'Teeth Selected'
                                                                        : req
                                                                            .reqName,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            12.0,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  Expanded(
                                                                    child: Text(
                                                                      req.reqValue ==
                                                                              'Teeth Selection'
                                                                          ? (e['reqValue'] != null
                                                                              ? e['reqValue'].split(', ').toSet().map(codeToDescription).join(
                                                                                  ', ')
                                                                              : '')
                                                                          // ignore: unnecessary_null_comparison
                                                                          : (req.reqValue != null
                                                                              ? req.reqValue.split(', ').join(', ')
                                                                              : ''),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .end,
                                                                      style:
                                                                          const TextStyle(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            112,
                                                                            112,
                                                                            112),
                                                                        fontSize:
                                                                            12.0,
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ]),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.3,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              IconButton(
                                                                tooltip: 'Edit',
                                                                splashRadius:
                                                                    23,
                                                                onPressed:
                                                                    () {},
                                                                icon: const Icon(
                                                                    Icons.edit,
                                                                    size: 16.0),
                                                              ),
                                                              IconButton(
                                                                tooltip:
                                                                    'Delete',
                                                                splashRadius:
                                                                    23,
                                                                onPressed: () =>
                                                                    onDeleteAppointment(
                                                                        context,
                                                                        e['apptID'],
                                                                        () {
                                                                  setState(
                                                                      () {});
                                                                }),
                                                                icon: const Icon(
                                                                    Icons
                                                                        .delete_forever_outlined,
                                                                    size: 16.0),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ))
                          .toList(),
                    ],
                  ),
                );
              },
            );
          }
        }
      },
    );
  }
}

// This widget shapes the expandable area of the card when clicked.
class ExpandableCard extends StatelessWidget {
  final Widget title;
  final Widget child;
  const ExpandableCard({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: title,
      children: <Widget>[
        child,
      ],
    );
  }
}

// This function fetches records of patients, appointments, staff and services using JOIN
Future<List<Map>> _getAppointment() async {
  final conn = await onConnToDb();

  const query =
      '''SELECT a.apt_ID, s.ser_ID, DATE_FORMAT(a.meet_date, "%M %d, %Y"), a.round, a.installment, a.discount, a.total_fee, s.ser_name, st.staff_ID, st.firstname, st.lastname
          FROM appointments a 
          INNER JOIN services s ON a.service_ID = s.ser_ID
          INNER JOIN staff st ON a.staff_ID = st.staff_ID
          WHERE a.pat_ID = ? ORDER BY a.meet_date DESC, a.round DESC''';

  final results = await conn.query(query, [PatientInfo.patID]);

  List<Map> appointments = [];

  for (var row in results) {
    appointments.add({
      'staffID': row[8],
      'meetDate': row[2].toString(),
      'round': row[3],
      'installment': row[4],
      'discount': row[5],
      'apptID': row[0],
      'staffFName': row[9].toString(),
      'staffLName': row[10].toString(),
      'serviceName': row[7].toString(),
      'serviceID': row[1],
      'totalFee': row[6]
    });
  }

  await conn.close();
  return appointments;
}

// Create a data model to set/get appointment details
class AppointmentDataModel {
  final int serviceID;
  final int staffID;
  final String staffFirstName;
  final String staffLastName;
  final String serviceName;
  final int aptID;
  final String meetDate;
  final int round;
  final int installment;
  final double totalFee;
  final double discount;

  AppointmentDataModel(
      {required this.serviceID,
      required this.staffID,
      required this.staffFirstName,
      required this.staffLastName,
      required this.serviceName,
      required this.aptID,
      required this.meetDate,
      required this.round,
      required this.installment,
      required this.totalFee,
      required this.discount});

  factory AppointmentDataModel.fromMap(Map<String, dynamic> map) {
    return AppointmentDataModel(
      serviceID: map['serviceID'],
      staffID: map['staffID'],
      staffFirstName: map['staffFirstName'], // and this line
      staffLastName: map['staffLastName'],
      serviceName: map['serviceName'],
      aptID: map['aptID'],
      meetDate: map['meetDate'],
      round: map['round'],
      installment: map['installment'],
      totalFee: map['totalFee'],
      discount: map['discount'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'staffID': staffID,
      'serviceID': serviceID,
      'staffFirstName': staffFirstName,
      'staffLastName': staffLastName,
      'serviceName': serviceName,
      'aptID': aptID,
      'meetDate': meetDate,
      'round': round,
      'installment': installment,
      'totalFee': totalFee,
      'discount': discount
    };
  }
}

// This function fetches records from service_requirments, patient_services, services and patients using JOIN
Future<List<ServiceDetailDataModel>> _getServiceDetails(
    int appointmentID) async {
  final conn = await onConnToDb();

  const query =
      ''' SELECT sr.req_name, ps.value, ps.apt_ID, ps.pat_ID, ps.apt_ID, ps.req_ID FROM service_requirements sr 
          INNER JOIN patient_services ps ON sr.req_ID = ps.req_ID 
          WHERE ps.pat_ID = ? AND ps.apt_ID = ?
          GROUP BY sr.req_name;''';

  final results = await conn.query(query, [PatientInfo.patID, appointmentID]);

  final requirements = results
      .map(
        (row) => ServiceDetailDataModel(
            appointmentID: row[2],
            patID: row[3],
            serviceID: row[4],
            reqID: row[5],
            reqName: row[0],
            reqValue: row[1]),
      )
      .toList();
  await conn.close();
  return requirements;
}

// Create the second data model for services including (service_requirements & patient_services tables)
class ServiceDetailDataModel {
  final int appointmentID;
  final int patID;
  final int serviceID;
  final int reqID;
  final String reqName;
  final String reqValue;

  ServiceDetailDataModel({
    required this.appointmentID,
    required this.patID,
    required this.serviceID,
    required this.reqID,
    required this.reqName,
    required this.reqValue,
  });
}

// This function makes name structure using the four qoudrants (Q1, Q2, Q3 & Q4)
Map<String, String> quadrantDescriptions = {
  'Q1': 'Top-Left',
  'Q2': 'Top-Right',
  'Q3': 'Bottom-Right',
  'Q4': 'Bottom-Left',
};
// Function to convert code to description
String codeToDescription(String code) {
  var parts = code.split('-');
  var quadrant = quadrantDescriptions[parts[0]];
  var tooth = parts[1];
  return '$quadrant, Tooth $tooth';
}

// This is to display an alert dialog to delete a patient
onAddRoundforService(BuildContext context,
    /* Function onDelete */ String service, int oldRound) {
  int? patientId = PatientInfo.patID;
  String? fName = PatientInfo.firstName;
  String? lName = PatientInfo.lastName;

  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Directionality(
        textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
        child: Text('Adding Rounds for $service with $oldRound'),
      ),
      content: Directionality(
        textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
        child: const Text('Contents'),
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment:
                !isEnglish ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () =>
                    Navigator.of(context, rootNavigator: true).pop(),
                child: Text(translations[selectedLanguage]?['CancelBtn'] ?? ''),
              ),
              TextButton(
                onPressed: () async {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context, rootNavigator: true).pop();
                },
                child: const Text('لغو'),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

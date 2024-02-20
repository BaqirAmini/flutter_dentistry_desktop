import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:intl/intl.dart' as intl2;

void main() {
  runApp(const Retreatment());
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

class Retreatment extends StatefulWidget {
  const Retreatment({Key? key}) : super(key: key);

  @override
  State<Retreatment> createState() => _RetreatmentState();
}

class _RetreatmentState extends State<Retreatment> {
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
          /* floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NewAppointment()),
              ).then((_) {
                setState(() {});
              });
              // This is assigned to identify retreatments.round i.e., if it is true round is stored '1' otherwise increamented by 1
              GlobalUsage.newPatientCreated = false;
            },
            tooltip: 'افزودن جلسه جدید',
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
 */
          appBar: AppBar(
            title: Text(
                '${PatientInfo.firstName} ${PatientInfo.lastName} Retreatments'),
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
      theme: ThemeData(useMaterial3: false),
    );
  }
}

// This widget contains all appointment records and details using loop
class _AppointmentContent extends StatefulWidget {
  @override
  State<_AppointmentContent> createState() => _AppointmentContentState();
}

class _AppointmentContentState extends State<_AppointmentContent> {
// Create an instance GlobalUsage to be access its method
  final GlobalUsage _gu = GlobalUsage();
  // Declare these variable since they are need to be inserted into retreatments.
  // These variable are used for editing schedule appointment
  int selectedStaffId = 0;
  int selectedServiceId = 0;
  late int? serviceId;
  late int? staffId;
  int? selectedPatientID;
  // This list is to be assigned services
  List<Map<String, dynamic>> services = [];
  final _retreatFormKey = GlobalKey<FormState>();

  bool _feeNotRequired = false;

  @override
  void initState() {
    super.initState();
    _gu.fetchStaff().then((staff) {
      setState(() {
        staffList = staff;
        staffId = staffList.isNotEmpty
            ? int.parse(staffList[0]['staff_ID'])
            : selectedStaffId;
      });
    });

    // Access the function to fetch services
    _gu.fetchServices().then((service) {
      setState(() {
        services = service;
        serviceId = services.isNotEmpty
            ? int.parse(services[0]['ser_ID'])
            : selectedServiceId;
      });
    });
  }

// This function deletes an appointment after opening a dialog box.
  _onDeleteRetreatment(BuildContext context, int id, Function refresh) {
    return showDialog(
      useRootNavigator: true,
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Directionality(
              textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
              child: const Text('Delete a retreatment'),
            ),
            content: Directionality(
              textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
              child: const Text(
                  'Are you sure you want to delete this retreatment'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(translations[selectedLanguage]?['CancelBtn'] ?? ''),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    final conn = await onConnToDb();
                    final deleteResult = await conn.query(
                        'DELETE FROM retreatments WHERE retreat_ID = ?', [id]);
                    if (deleteResult.affectedRows! > 0) {
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();
                      // ignore: use_build_context_synchronously
                      _onShowSnack(
                          Colors.green, 'عودی مریض حذف گردید.', context);
                      refresh();
                    }
                    await conn.close();
                  } catch (e) {
                    print('Deleting retreatment: $e');
                  }
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
      future: _getRetreatment(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          if (snapshot.data!.isEmpty) {
            return const Center(child: Text('No retreatments found.'));
          } else {
            var data = snapshot.data!;

            var groupedRetDateTime = groupBy(data, (obj) => obj['retreatDate']);
            // var groupedRound = groupBy(data, (obj) => obj['round']);

            return ListView.builder(
              itemCount: groupedRetDateTime.keys.length,
              itemBuilder: (context, index) {
                var retreatDTime = groupedRetDateTime.keys.elementAt(index);
                // var round = groupedRound.keys.elementAt(index);
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
                              intl2.DateFormat('MMM d, y hh:mm a')
                                  .format(DateTime.parse(retreatDTime)),
                              style: const TextStyle(fontSize: 18.0),
                            ),
                            const Spacer(),
                            Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                              elevation: 0.5,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text('Round: ',
                                    style:
                                        Theme.of(context).textTheme.labelSmall),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ...groupedRetDateTime[retreatDTime]!
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
                                                        color: Colors.purple,
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            color: Colors.purple,
                                                            width: 2.0),
                                                      ),
                                                      child: const Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: Icon(
                                                          Icons
                                                              .repeat_rounded,
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
                                                          'داکتر معالج: ${e['staffFirstName']} ${e['staffLastName']}',
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
                                          child: ListTile(
                                            title: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const Text(
                                                        'Service Name',
                                                        style: TextStyle(
                                                            fontSize: 12.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        e['serviceName'],
                                                        style: const TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              112,
                                                              112,
                                                              112),
                                                          fontSize: 12.0,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const Text(
                                                        'Reason',
                                                        style: TextStyle(
                                                            fontSize: 12.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        e['retreatReason'],
                                                        style: const TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              112,
                                                              112,
                                                              112),
                                                          fontSize: 12.0,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const Text(
                                                        'Outcomes',
                                                        style: TextStyle(
                                                            fontSize: 12.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        e['retreatOutcome'],
                                                        style: const TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              112,
                                                              112,
                                                              112),
                                                          fontSize: 12.0,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const Text(
                                                        'Details',
                                                        style: TextStyle(
                                                            fontSize: 12.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        e['retreatDetails'] ??
                                                            '--',
                                                        style: const TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              112,
                                                              112,
                                                              112),
                                                          fontSize: 12.0,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const Text(
                                                        'Fee Earned',
                                                        style: TextStyle(
                                                            fontSize: 12.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        e['retreatFee'] <= 0 ? 'For free' : '${e['retreatFee'].toString()} افغانی',
                                                        style: const TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              112,
                                                              112,
                                                              112),
                                                          fontSize: 12.0,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.3,
                                                  child: IconButton(
                                                    tooltip: 'Delete',
                                                    splashRadius: 23,
                                                    onPressed: () =>
                                                        _onDeleteRetreatment(
                                                            context,
                                                            e['retreatID'], () {
                                                      setState(() {});
                                                    }),
                                                    icon: const Icon(
                                                        Icons
                                                            .delete_forever_outlined,
                                                        size: 16.0,
                                                        color: Colors.red),
                                                  ),
                                                )
                                              ],
                                            ),
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
  const ExpandableCard({Key? key, required this.title, required this.child})
      : super(key: key);

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

// This function fetches records of patients, retreatments, staff and services using JOIN
Future<List<Map>> _getRetreatment() async {
  try {
    final conn = await onConnToDb();

    const query =
        '''SELECT r.apt_ID, r.service_ID, r.retreat_date, s.ser_name, r.retreat_cost, r.retreat_reason, r.retreat_outcome, r.outcome_details, st.staff_ID, st.firstname, st.lastname, r.retreat_ID FROM retreatments r 
                    INNER JOIN staff st ON r.staff_ID = st.staff_ID
                    INNER JOIN services s ON r.service_ID = s.ser_ID WHERE r.pat_ID = ? ORDER BY r.retreat_date DESC''';

// a.status = 'Pending' means it is scheduled in calendar not completed.
    final results = await conn.query(query, [PatientInfo.patID]);

    List<Map> retreatments = [];

    for (var row in results) {
      retreatments.add({
        'retreatDate': row[2].toString(),
        'apptID': row[0],
        'serviceName': row[3].toString(),
        'serviceID': row[1],
        'retreatFee': row[4],
        'retreatReason': row[5],
        'retreatOutcome': row[6],
        'retreatDetails': row[7],
        'staffID': row[8],
        'staffFirstName': row[9],
        'staffLastName': row[10],
        'retreatID': row[11]
      });
    }

    await conn.close();
    return retreatments;
  } catch (e) {
    print('Error with retrieving retreatments: $e');
    return [];
  }
}

// Create a data model to set/get appointment details
class RetreatmentDataModel {
  final int retreatID;
  final int serviceID;
  final int staffID;
  final String staffFirstName;
  final String staffLastName;
  final String serviceName;
  final int aptID;
  final DateTime retreatDate;
  final double retreatFee;
  final String retreatReason;
  final String retreatOutcome;
  final String retreatDetails;

  RetreatmentDataModel(
      {required this.retreatID,
      required this.serviceID,
      required this.staffID,
      required this.staffFirstName,
      required this.staffLastName,
      required this.serviceName,
      required this.aptID,
      required this.retreatDate,
      required this.retreatFee,
      required this.retreatReason,
      required this.retreatOutcome,
      required this.retreatDetails});

  factory RetreatmentDataModel.fromMap(Map<String, dynamic> map) {
    return RetreatmentDataModel(
        retreatID: map['retreatID'],
        serviceID: map['serviceID'],
        staffID: map['staffID'],
        staffFirstName: map['staffFirstName'], // and this line
        staffLastName: map['staffLastName'],
        serviceName: map['serviceName'],
        aptID: map['aptID'],
        retreatDate: map['retreatDate'],
        retreatFee: map['retreatFee'],
        retreatReason: map['retreatReason'],
        retreatOutcome: map['retreatOutcome'],
        retreatDetails: map['retreatDetails']);
  }

  Map<String, dynamic> toMap() {
    return {
      'staffID': staffID,
      'serviceID': serviceID,
      'staffFirstName': staffFirstName,
      'staffLastName': staffLastName,
      'serviceName': serviceName,
      'aptID': aptID,
      'retreatDate': retreatDate,
      'retreatFee': retreatFee,
      'retreatReason': retreatReason,
      'retreatOutcome': retreatOutcome,
      'retreatDetails': retreatDetails
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

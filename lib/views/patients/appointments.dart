import 'package:flutter/material.dart';
import 'package:flutter_dentistry/config/global_usage.dart';
import 'package:flutter_dentistry/config/language_provider.dart';
import 'package:flutter_dentistry/config/translations.dart';
import 'package:flutter_dentistry/models/db_conn.dart';
import 'package:flutter_dentistry/views/patients/new_appointment.dart';
import 'package:flutter_dentistry/views/patients/patient_info.dart';
import 'package:flutter_dentistry/views/patients/tooth_selection_info.dart';
import 'package:flutter_dentistry/views/services/service_related_fields.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const Appointment());
}

// Create the global key at the top level of your Dart file
final GlobalKey<ScaffoldMessengerState> _globalKey4Appt =
    GlobalKey<ScaffoldMessengerState>();

// This is shows snackbar when called
void _onShowSnack(Color backColor, String msg) {
  _globalKey4Appt.currentState?.showSnackBar(
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

// Set global variables which are needed later.
var selectedLanguage;
var isEnglish;

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
        child: ScaffoldMessenger(
          key: _globalKey4Appt,
          child: Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              tooltip: 'افزودن جلسه جدید',
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NewAppointment()),
                  ).then((_) {
                    setState(() {});
                  });
                  // This is assigned to identify appointments.round i.e., if it is true round is stored '1' otherwise increamented by 1
                  GlobalUsage.newPatientCreated = false;
                },
                child: const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            appBar: AppBar(
              title: const Text('Appointment'),
              leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const BackButtonIcon()),
              actions: [
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
                const SizedBox(width: 15)
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
                onPressed: () =>
                    Navigator.of(context, rootNavigator: true).pop(),
                child: Text(translations[selectedLanguage]?['CancelBtn'] ?? ''),
              ),
              TextButton(
                onPressed: () async {
                  final conn = await onConnToDb();
                  final deleteResult = await conn
                      .query('DELETE FROM appointments WHERE apt_ID = ?', [id]);
                  if (deleteResult.affectedRows! > 0) {
                    _onShowSnack(Colors.green, 'Deleted');
                    refresh();
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getAppointment(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Map<String, List<AppointmentDataModel>>? appoints = snapshot.data;
          return ListView(
            children: appoints!.entries.map((entry) {
              var visitDate = entry.key;
              var rounds = entry.value;
              return Card(
                child: Column(
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
                            visitDate,
                            style: const TextStyle(fontSize: 18.0),
                          ),
                          Container(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 400.0),
                            child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)),
                                elevation: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                      'Round: ${rounds.first.round.toString()}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall),
                                )),
                          )
                        ],
                      ),
                    ),
                    Column(
                      children: rounds.asMap().entries.map((roundEntry) {
                        var a = roundEntry.value;
                        var isLastRound = roundEntry.key == rounds.length - 1;
                        return Column(
                          children: [
                            ExpandableCard(
                              title: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                            padding: EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.calendar_today_outlined,
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
                                              a.serviceName,
                                              style: const TextStyle(
                                                  fontSize: 18.0),
                                            ),
                                            Text(
                                              'تحت نظر: ${a.staffFirstName} ${a.staffLastName}',
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12.0),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          'Paid: ${a.paidAmount}',
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12.0),
                                        ),
                                        Text(
                                          'Due: ${a.dueAmount}',
                                          style: const TextStyle(
                                              color: Colors.red,
                                              fontSize: 12.0),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              child: FutureBuilder(
                                future: _getServices(a.serviceID),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    var services = snapshot.data;
                                    for (var service in services!) {
                                      return ListTile(
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
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    a.serviceName,
                                                    style: const TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 112, 112, 112),
                                                      fontSize: 12.0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            for (var req
                                                in service.requirements.entries)
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      req.key ==
                                                              'Teeth Selection'
                                                          ? 'Teeth Selected'
                                                          : req.key,
                                                      style: const TextStyle(
                                                          fontSize: 12.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        req.key ==
                                                                'Teeth Selection'
                                                            ? req.value
                                                                .split(',')
                                                                .map(
                                                                    codeToDescription)
                                                                .join(', ')
                                                            : req.value,
                                                        textAlign:
                                                            TextAlign.end,
                                                        style: const TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              112,
                                                              112,
                                                              112),
                                                          fontSize: 12.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            SizedBox(
                                              width: 200,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  IconButton(
                                                    splashRadius: 23,
                                                    onPressed: () {},
                                                    icon: const Icon(Icons.edit,
                                                        size: 16.0),
                                                  ),
                                                  IconButton(
                                                    splashRadius: 23,
                                                    onPressed: () =>
                                                        onDeleteAppointment(
                                                            context, a.aptID,
                                                            () {
                                                      setState(() {});
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
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  return const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text(
                                        'No description found for this service.'),
                                  );
                                },
                              ),
                            ),
                            if (!isLastRound)
                              const Divider(
                                  color: Colors.grey,
                                  thickness: 0.5,
                                  height: 0.0),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            }).toList(), // Convert Iterable to List
          );
        } else {
          return const Center(child: CircularProgressIndicator());
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
Future<Map<String, List<AppointmentDataModel>>> _getAppointment() async {
  final conn = await onConnToDb();
  final results = await conn.query(
    '''SELECT p.firstname, p.lastname, 
        a.staff_ID, DATE_FORMAT(a.meet_date, "%M %d, %Y"), a.paid_amount, a.due_amount, a.round, a.installment, 
        a.discount, a.apt_ID, st.firstname, st.lastname, s.ser_name, s.ser_ID, a.round, a.installment, a.discount FROM patients p 
        INNER JOIN appointments a ON a.pat_ID = p.pat_ID
        INNER JOIN staff st ON a.staff_ID = st.staff_ID
        INNER JOIN services s ON s.ser_ID = a.service_ID
         WHERE a.pat_ID = ? ORDER BY a.meet_date DESC, a.round DESC''',
    [PatientInfo.patID],
  );

  Map<String, List<AppointmentDataModel>> appoints = {};

  for (var row in results) {
    String visitDate = row[3].toString();
    var appointment = AppointmentDataModel(
      staffID: row[2],
      staffFirstName: row[10],
      staffLastName: row[11],
      serviceName: row[12],
      serviceID: row[13],
      aptID: row[9],
      meetDate: visitDate,
      round: row[6],
      paidAmount: row[4],
      dueAmount: row[5],
      installment: row[7],
    );
    if (appoints.containsKey(visitDate)) {
      appoints[visitDate]!.add(appointment);
    } else {
      appoints[visitDate] = [appointment];
    }
  }

  await conn.close();
  return appoints;
}

// Create a data model to set/get appointment details
class AppointmentDataModel {
  final int staffID;
  final int serviceID;
  final String staffFirstName;
  final String staffLastName;
  final String serviceName;
  final int aptID;
  final String meetDate;
  final int round;
  final double paidAmount;
  final double dueAmount;
  final int installment;

  AppointmentDataModel(
      {required this.staffID,
      required this.serviceID,
      required this.staffFirstName,
      required this.staffLastName,
      required this.serviceName,
      required this.aptID,
      required this.meetDate,
      required this.round,
      required this.paidAmount,
      required this.dueAmount,
      required this.installment});
}

// This function fetches records from service_requirments, patient_services, services and patients using JOIN
Future<List<ServiceDataModel>> _getServices(int serID) async {
  final conn = await onConnToDb();
  final results = await conn.query(
      '''SELECT s.ser_ID, ps.pat_ID, sr.req_name, ps.value FROM service_requirements sr 
  INNER JOIN patient_services ps ON sr.req_ID = ps.req_ID 
  INNER JOIN services s ON s.ser_ID = ps.ser_ID 
  INNER JOIN patients p ON p.pat_ID = ps.pat_ID 
  WHERE ps.pat_ID = ? AND s.ser_ID = ?''', [PatientInfo.patID, serID]);

  Map<int, ServiceDataModel> servicesMap = {};

  for (var row in results) {
    int serviceID = row[0];
    String reqName = row[2];
    String value = row[3];

    if (!servicesMap.containsKey(serviceID)) {
      servicesMap[serviceID] = ServiceDataModel(
        serviceID: serviceID,
        requirements: {reqName: value},
      );
    } else {
      servicesMap[serviceID]!.requirements[reqName] = value;
    }
  }

  final services = servicesMap.values.toList();

  await conn.close();
  return services;
}

// Create the second data model for services including (service_requirements & patient_services tables)
class ServiceDataModel {
  final int serviceID;
  final Map<String, String> requirements;

  ServiceDataModel({
    required this.serviceID,
    required this.requirements,
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

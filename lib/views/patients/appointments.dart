import 'package:flutter/material.dart';
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
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            tooltip: 'افزودن جلسه جدید',
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NewAppointment()),
              ).then((_) {
                setState(() {});
              }),
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
    );
  }
}

/* class _AppointmentContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getAppointment(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var appoints = snapshot.data;
          return ListView(
            children: <Widget>[
              for (var a in appoints!)
                Column(
                  children: [
                    ExpandableCard(
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.green, width: 2.0),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      a.serviceName,
                                      style: const TextStyle(fontSize: 18.0),
                                    ),
                                    Text(
                                      a.meetDate,
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 12.0),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                    FontAwesomeIcons.houseMedicalCircleCheck)),
                            Column(
                              children: [
                                Text(
                                  'Paid: ${a.paidAmount}',
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 12.0),
                                ),
                                Text(
                                  'Due: ${a.dueAmount}',
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 12.0),
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
                                title: Column(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Service Name',
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold),
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
                                  for (var req in service.requirements.entries)
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text(
                                              req.key == 'Teeth Selection'
                                                  ? 'Teeth Selected'
                                                  : req.key,
                                              style: const TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.bold)),
                                          const SizedBox(width: 15.0),
                                          Expanded(
                                            child: Text(
                                              req.key == 'Teeth Selection'
                                                  ? req.value
                                                      .split(',')
                                                      .map(codeToDescription)
                                                      .join(', ')
                                                  : req.value,
                                              textAlign: TextAlign.end,
                                              style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 112, 112, 112),
                                                fontSize: 12.0,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ] // return FutureBuilder(future: service., builder: builder)                                ],
                                    ),
                              );
                            }
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Text('ssss');
                        },
                      ),
                    ),
                  ],
                ),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
 */

class _AppointmentContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getAppointment(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // var appoints = snapshot.data;
          Map<String, List<AppointmentDataModel>>? appoints = snapshot.data;
          return ListView(
            children: <Widget>[
              for (var entry in appoints!.entries)
                for (var a in entry.value)
                  Card(
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          color: Colors
                              .grey[200], // Change this to your desired color
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            a.meetDate,
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                        ExpandableCard(
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.green, width: 2.0),
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
                                          style:
                                              const TextStyle(fontSize: 18.0),
                                        ),
                                        Text(
                                          a.meetDate,
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
                                          color: Colors.grey, fontSize: 12.0),
                                    ),
                                    Text(
                                      'Due: ${a.dueAmount}',
                                      style: const TextStyle(
                                          color: Colors.red, fontSize: 12.0),
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
                                    title: Column(children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Service Name',
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.bold),
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
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                  req.key == 'Teeth Selection'
                                                      ? 'Teeth Selected'
                                                      : req.key,
                                                  style: const TextStyle(
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              const SizedBox(width: 15.0),
                                              Expanded(
                                                child: Text(
                                                  req.key == 'Teeth Selection'
                                                      ? req.value
                                                          .split(',')
                                                          .map(
                                                              codeToDescription)
                                                          .join(', ')
                                                      : req.value,
                                                  textAlign: TextAlign.end,
                                                  style: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 112, 112, 112),
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ]),
                                  );
                                }
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return Text('ssss');
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

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

// Fetch appointment details
/* Future<List<AppointmentDataModel>> getAppointment() async {
  final conn = await onConnToDb();
  final results = await conn.query(
    '''SELECT p.firstname, p.lastname, 
        a.staff_ID, DATE_FORMAT(a.meet_date, "%M %d, %Y"), a.paid_amount, a.due_amount, a.round, a.installment, 
        a.discount, a.apt_ID, st.firstname, st.lastname, s.ser_name, s.ser_ID FROM patients p 
        INNER JOIN appointments a ON a.pat_ID = p.pat_ID
        INNER JOIN staff st ON a.staff_ID = st.staff_ID
        INNER JOIN services s ON s.ser_ID = a.service_ID
         WHERE a.pat_ID = ?''',
    [PatientInfo.patID],
  );

  final appoints = results
      .map((row) => AppointmentDataModel(
          staffID: row[2],
          staffFirstName: row[10],
          staffLastName: row[11],
          serviceName: row[12],
          serviceID: row[13],
          aptID: row[9],
          meetDate: row[3].toString(),
          round: row[6],
          paidAmount: row[4],
          dueAmount: row[5],
          installment: row[7]))
      .toList();
  await conn.close();
  return appoints;
}
 */

Future<Map<String, List<AppointmentDataModel>>> getAppointment() async {
  final conn = await onConnToDb();
  final results = await conn.query(
    '''SELECT p.firstname, p.lastname, 
        a.staff_ID, DATE_FORMAT(a.meet_date, "%Y-%m-%d"), a.paid_amount, a.due_amount, a.round, a.installment, 
        a.discount, a.apt_ID, st.firstname, st.lastname, s.ser_name, s.ser_ID, a.round, a.installment, a.discount FROM patients p 
        INNER JOIN appointments a ON a.pat_ID = p.pat_ID
        INNER JOIN staff st ON a.staff_ID = st.staff_ID
        INNER JOIN services s ON s.ser_ID = a.service_ID
         WHERE a.pat_ID = ?''',
    [PatientInfo.patID],
  );

  Map<String, List<AppointmentDataModel>> appoints = {};

  for (var row in results) {
    String meetDate = row[3].toString();
    var appointment = AppointmentDataModel(
      staffID: row[2],
      staffFirstName: row[10],
      staffLastName: row[11],
      serviceName: row[12],
      serviceID: row[13],
      aptID: row[9],
      meetDate: meetDate,
      round: row[6],
      paidAmount: row[4],
      dueAmount: row[5],
      installment: row[7],
    );
    if (appoints.containsKey(meetDate)) {
      appoints[meetDate]!.add(appointment);
    } else {
      appoints[meetDate] = [appointment];
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

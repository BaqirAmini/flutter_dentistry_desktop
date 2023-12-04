import 'package:flutter/material.dart';
import 'package:flutter_dentistry/models/db_conn.dart';
import 'package:flutter_dentistry/views/patients/patient_info.dart';

void main() {
  runApp(const Appointment());
}

class Appointment extends StatelessWidget {
  const Appointment({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Appointment'),
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const BackButtonIcon()),
            actions: [
              Tooltip(
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
              ),
              const SizedBox(width: 15)
            ],
          ),
          body: Center(
            child: Container(
              margin: const EdgeInsets.only(top: 15),
              width: MediaQuery.of(context).size.width * 0.9,
              child: _AppointmentContent(),
            ),
          ),
        ),
      ),
    );
  }
}

class _AppointmentContent extends StatelessWidget {
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
                FutureBuilder(
                  future: _getServices(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final services = snapshot.data;
                      for (var service in services!) {
                        return HoverCard(
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
                                          service.serviceName,
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
                          child: ListTile(
                            title: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('Round',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge),
                                      const SizedBox(width: 15.0),
                                      Expanded(
                                        child: Text(
                                          a.round.toString(),
                                          textAlign: TextAlign.end,
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 112, 112, 112)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                for (int i = 0; i < services.length; i++)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text(service.reqName,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge),
                                        const SizedBox(width: 15.0),
                                        Expanded(
                                          child: Text(
                                            service.value,
                                            textAlign: TextAlign.end,
                                            style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 112, 112, 112)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }
                    } else if (snapshot.hasError) {
                      return Text('Error with service: ${snapshot.error}');
                    } else {
                      return const Row(
                        children: [
                          CircularProgressIndicator(),
                        ],
                      );
                    }

                    return const Text('ss');
                  },
                )
            ],
          );
        } else if (snapshot.hasError) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('No appointment found.',
                  style: Theme.of(context).textTheme.labelLarge),
            ],
          );
        } else {
          return const Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
            ],
          );
        }
      },
    );
  }
}

class HoverCard extends StatefulWidget {
  final Widget title;
  final Widget child;

  HoverCard({required this.title, required this.child});

  @override
  _HoverCardState createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => setState(() => _isHovering = true),
      onExit: (event) => setState(() => _isHovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
        transform: _isHovering
            ? Matrix4.translationValues(10, 0, 0)
            : Matrix4
                .identity(), // Move the card to the left/right when hovering
        child: Card(
          child: ExpansionTile(
            title: widget.title,
            children: <Widget>[
              widget.child,
            ],
          ),
        ),
      ),
    );
  }
}

/* SELECT s.ser_name, sr.req_name, ps.value FROM service_requirements sr
INNER JOIN patient_services ps ON sr.req_ID = ps.req_ID
INNER JOIN services s ON ps.ser_ID = s.ser_ID
WHERE ps.ser_ID = 2 AND ps.pat_ID = 72; */
// Fetch appointment details
Future<List<AppointmentDataModel>> getAppointment() async {
  final conn = await onConnToDb();
  final results = await conn.query(
    '''SELECT p.firstname, p.lastname, 
        a.staff_ID, DATE_FORMAT(a.meet_date, "%M %d, %Y"), a.paid_amount, a.due_amount, a.round, a.installment, 
        a.discount, a.apt_ID, st.firstname, st.lastname FROM patients p 
        INNER JOIN appointments a ON a.pat_ID = p.pat_ID
        INNER JOIN staff st ON a.staff_ID = st.staff_ID WHERE a.pat_ID = ?''',
    [PatientInfo.patID],
  );

  final appoints = results
      .map((row) => AppointmentDataModel(
          staffID: row[2],
          staffFirstName: row[10],
          staffLastName: row[11],
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

// Create a data model to set/get appointment details
class AppointmentDataModel {
  final int staffID;
  final String staffFirstName;
  final String staffLastName;
  final int aptID;
  final String meetDate;
  final int round;
  final double paidAmount;
  final double dueAmount;
  final int installment;

  AppointmentDataModel(
      {required this.staffID,
      required this.staffFirstName,
      required this.staffLastName,
      required this.aptID,
      required this.meetDate,
      required this.round,
      required this.paidAmount,
      required this.dueAmount,
      required this.installment});
}

// Fetch services
Future<List<ServiceDataModel>> _getServices() async {
  final conn = await onConnToDb();
  final results = await conn.query(
      '''SELECT ps.pat_ID, s.ser_ID, s.ser_name, sr.req_name, ps.value 
  FROM service_requirements sr 
  INNER JOIN patient_services ps ON sr.req_ID = ps.req_ID 
  INNER JOIN services s ON ps.ser_ID = s.ser_ID WHERE ps.pat_ID = ?''',
      [PatientInfo.patID]);
  final services = results
      .map((row) => ServiceDataModel(
          serviceID: row[1],
          serviceName: row[2],
          reqName: row[3],
          value: row[4]))
      .toList();
  await conn.close();
  return services;
}

// Create the second data model for services including (service_requirements & patient_services tables)
class ServiceDataModel {
  final int serviceID;
  final String serviceName;
  final String reqName;
  final String value;

  ServiceDataModel(
      {required this.serviceID,
      required this.serviceName,
      required this.reqName,
      required this.value});
}

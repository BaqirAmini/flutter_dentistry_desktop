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
                HoverCard(
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
                                border:
                                    Border.all(color: Colors.green, width: 2.0),
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
                                  a.service,
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
                                  style:
                                      Theme.of(context).textTheme.labelLarge),
                              const SizedBox(width: 15.0),
                              Expanded(
                                child: Text(
                                  a.round.toString(),
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(
                                      color:
                                          Color.fromARGB(255, 112, 112, 112)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text('Description',
                                  style:
                                      Theme.of(context).textTheme.labelLarge),
                              const SizedBox(width: 15.0),
                              Expanded(
                                child: Text(
                                  a.value,
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(
                                      color:
                                          Color.fromARGB(255, 112, 112, 112)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        } else if (snapshot.hasError) {
          return const Text('No appointment');
        } else {
          return Container(
            width: 200,
            height: 200,
            child: const CircularProgressIndicator(),
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

// Fetch appointment details
Future<List<AppointmentDataModel>> getAppointment() async {
  final conn = await onConnToDb();
  final results = await conn.query(
      '''SELECT S.ser_name, PS.req_ID, PS.value, A.apt_ID, DATE_FORMAT(A.meet_date, "%Y-%m-%d"), A.installment, A.round, A.paid_amount,
       A.due_amount, ST.staff_ID, ST.firstname, ST.lastname FROM services S 
      INNER JOIN patient_services PS ON S.ser_ID = PS.ser_ID 
      INNER JOIN appointments A ON S.ser_ID = A.service_ID 
      INNER JOIN staff ST ON ST.staff_ID = A.staff_ID 
      WHERE A.pat_ID = ?''', [PatientInfo.patID]);

  final appoints = results
      .map((row) => AppointmentDataModel(
          staffID: row[9],
          staffFirstName: row[10],
          staffLastName: row[11],
          aptID: row[3],
          value: row[2],
          // tooth: row[8] == 'tooth not required' ? '' : row[8],
          service: row[0],
          meetDate: row[4].toString(),
          round: row[6],
          paidAmount: row[7],
          dueAmount: row[8],
          installment: row[5]))
      .toList();
  return appoints;
}

// Create a data model to set/get appointment details
class AppointmentDataModel {
  final int staffID;
  final String staffFirstName;
  final String staffLastName;
  final int aptID;
  final String value;
  final String service;
  final String meetDate;
  // final String gum;
  final int round;
  final String? description;
  final double paidAmount;
  final double dueAmount;
  final int installment;

  AppointmentDataModel(
      {required this.staffID,
      required this.staffFirstName,
      required this.staffLastName,
      required this.aptID,
      required this.value,
      required this.service,
      required this.meetDate,
      required this.round,
      this.description,
      required this.paidAmount,
      required this.dueAmount,
      required this.installment});
}

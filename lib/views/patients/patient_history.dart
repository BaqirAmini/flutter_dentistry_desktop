import 'package:flutter/material.dart';
import 'package:flutter_dentistry/models/db_conn.dart';
import 'package:flutter_dentistry/views/main/dashboard.dart';
import 'package:flutter_dentistry/views/patients/patient_info.dart';
import 'package:flutter_dentistry/views/patients/patients.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(const PatientHistory());
}

class PatientHistory extends StatelessWidget {
  const PatientHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Patient Health History'),
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const BackButtonIcon()),
            actions: [
              /*  IconButton(
                onPressed: () {},
                icon: const Icon(Icons.health_and_safety_outlined),
                tooltip: 'New History',
                padding: const EdgeInsets.all(3.0),
                splashRadius: 30.0,
              ), */

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
            ],
          ),
          body: Center(
            child: Container(
              margin: const EdgeInsets.only(top: 15),
              width: MediaQuery.of(context).size.width * 0.9,
              child: _HistoryContent(),
            ),
          ),
        ),
      ),
      theme: ThemeData(useMaterial3: false),
    );
  }
}

class _HistoryContent extends StatefulWidget {
  @override
  State<_HistoryContent> createState() => _HistoryContentState();
}

class _HistoryContentState extends State<_HistoryContent> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getHistory(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final histories = snapshot.data;
            int positiveRecord = 0;
            List<Widget> hcChildren = [];
            for (var h in histories!) {
              if (h.result == 1) {
                positiveRecord++;
              }
              hcChildren.add(
                HoverCard(
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 34, 145, 38),
                                shape: BoxShape.circle,
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  FontAwesomeIcons.heartPulse,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Text(
                              h.condName.toString(),
                              style: Theme.of(context).textTheme.bodyLarge,
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: h.result == 1 ? Colors.red : Colors.blue,
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: h.result == 1
                                    ? const Icon(
                                        FontAwesomeIcons.plus,
                                        color: Colors.white,
                                        size: 14,
                                      )
                                    : const Icon(
                                        FontAwesomeIcons.minus,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                              ),
                            ),
                          ],
                        ),
                        /* SizedBox(
                  width: 100,
                  child: PopupMenuButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.more_horiz,
                      color: Colors.blue,
                    ),
                    tooltip: 'نمایش مینو',
                    itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                      PopupMenuItem(
                        child: ListTile(
                          leading: const Icon(
                            Icons.list,
                            size: 20.0,
                          ),
                          title: Text(
                            'Edit',
                            style: const TextStyle(fontSize: 15.0),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                    onSelected: null,
                  ),
                ),
 */
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
                              const Text('Diagnosis Date',
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(width: 15.0),
                              Expanded(
                                child: Text(
                                  h.dianosisDate!,
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 112, 112, 112),
                                      fontSize: 12.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Text('Severty',
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(width: 15.0),
                              Expanded(
                                child: Text(
                                  h.severty!,
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 112, 112, 112),
                                      fontSize: 12.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Text('Duration',
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(width: 15.0),
                              Expanded(
                                child: Text(
                                  h.duration!,
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 112, 112, 112),
                                      fontSize: 12.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Text('Description',
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(width: 15.0),
                              Expanded(
                                child: Text(
                                  h.notes!.isEmpty || h.notes == null
                                      ? '--'
                                      : h.notes.toString(),
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 112, 112, 112),
                                      fontSize: 12.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: positiveRecord > 0 ? true : false,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '$positiveRecord نتیجه مثبت',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: <Widget>[...hcChildren],
                  ),
                )
              ],
            );
          } else if (snapshot.hasError) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('No patient history found.',
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
        });
  }
}

class HoverCard extends StatefulWidget {
  final Widget title;
  final Widget child;

  const HoverCard({required this.title, required this.child});

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

Future<List<HistoryDataModel>> _getHistory() async {
  final conn = await onConnToDb();
  final results = await conn.query('''
SELECT d.cond_detail_ID, c.name, d.result, d.severty, d.duration, DATE_FORMAT(d.diagnosis_date, '%Y-%m-%d'), d.notes FROM conditions c 
INNER JOIN condition_details d ON c.cond_ID = d.cond_ID WHERE d.pat_ID = ? ORDER BY d.cond_detail_ID DESC''',
      [PatientInfo.patID]);

  final histories = results
      .map(
        (row) => HistoryDataModel(
            condDetailID: row[0],
            condName: row[1].toString(),
            result: row[2],
            severty: row[3] ?? "--",
            duration: row[4] ?? "--",
            dianosisDate: row[5].toString() == '0000-00-00' || row[5] == null
                ? '--'
                : row[5].toString(),
            notes: row[6].toString().isEmpty || row[6] == null
                ? '--'
                : row[6].toString()),
      )
      .toList();
  await conn.close();
  return histories;
}

// Create a data model class for patient health history
class HistoryDataModel {
  final int condDetailID;
  final String condName;
  final int result;
  final String? severty;
  final String? duration;
  final String? dianosisDate;
  final String? notes;

  HistoryDataModel(
      {required this.condDetailID,
      required this.condName,
      required this.result,
      this.severty,
      this.duration,
      this.dianosisDate,
      this.notes});
}

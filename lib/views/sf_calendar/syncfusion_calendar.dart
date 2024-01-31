import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dentistry/config/global_usage.dart';
import 'package:flutter_dentistry/models/db_conn.dart';
import 'package:flutter_dentistry/views/patients/patient_info.dart';
import 'package:flutter_dentistry/views/services/service_related_fields.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:windows_notification/notification_message.dart';
import 'package:windows_notification/windows_notification.dart';

// This is shows snackbar when called
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

class CalendarApp extends StatelessWidget {
  const CalendarApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Patient' 's Appointments Schedule'),
          leading: IconButton(
            splashRadius: 25.0,
            onPressed: () => Navigator.pop(context),
            icon: const BackButtonIcon(),
          ),
          actions: [
            IconButton(
                onPressed: showWithLargeImage,
                icon: Icon(Icons.notification_add))
          ],
        ),
        body: const CalendarPage(),
      ),
    );
  }

// This function is to give notifiction for users
  void showWithLargeImage() async {
    final winNotifyPlugin = WindowsNotification(
        applicationId:
            r"{7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}\Dental Clinics MIS\flutter_dentistry.exe");
    /* applicationId:
            r"{D65231B0-B2F1-4857-A4CE-A8E7C6EA7D27}\WindowsPowerShell\v1.0\powershell.exe"); */
    NotificationMessage message = NotificationMessage.fromPluginTemplate(
        "moon", "fly to the moon", "we are ready!");
    winNotifyPlugin.showNotificationPluginTemplate(message);
  }
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late int? serviceId;
  late int? staffId;
  // This is to fetch staff list
  List<Map<String, dynamic>> staffList = [];
  // This list is to be assigned services
  List<Map<String, dynamic>> services = [];
  late List<Meeting> _appointments;
  final _calFormKey = GlobalKey<FormState>();
// Create an instance GlobalUsage to be access its method
  final GlobalUsage _gu = GlobalUsage();

  @override
  void initState() {
    super.initState();
    _appointments = _getAppointments();
    _gu.fetchStaff().then((staff) {
      setState(() {
        staffList = staff;
        staffId =
            staffList.isNotEmpty ? int.parse(staffList[0]['staff_ID']) : null;
      });
    });

    // Access the function to fetch services
    _gu.fetchServices().then((service) {
      setState(() {
        services = service;
        serviceId =
            services.isNotEmpty ? int.parse(services[0]['ser_ID']) : null;
      });
    });
  }

  List<Meeting> _getAppointments() {
    final List<Meeting> meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime startTime = DateTime(today.year, today.month, today.day, 9);
    final DateTime endTime = startTime.add(const Duration(hours: 2));
    meetings.add(Meeting(
        'Conference', startTime, endTime, const Color(0xFF0F8644), false));
    return meetings;
  }

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      view: CalendarView.day,
      allowedViews: const [
        CalendarView.day,
        CalendarView.month,
        CalendarView.week,
        CalendarView.workWeek,
        CalendarView.schedule
      ],
      onTap: (CalendarTapDetails details) {
        if (details.targetElement == CalendarElement.calendarCell) {
          DateTime? selectedDate = details.date;
          _showAppointmentDialog(context, selectedDate!);
        }
      },
    );
  }

  _showAppointmentDialog(BuildContext context, DateTime selectedDate) async {
    DateTime selectedDateTime = DateTime.now();
    TextEditingController apptdatetimeController = TextEditingController();
    TextEditingController commentController = TextEditingController();
    String notifFrequency = '15 Minutes';
    apptdatetimeController.text = selectedDate.toString();
    int? patientId = PatientInfo.patID;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Set Details'),
              content: SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width * 0.3,
                child: Form(
                  key: _calFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'انتخاب داکتر',
                            labelStyle: TextStyle(color: Colors.blueAccent),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50.0)),
                                borderSide:
                                    BorderSide(color: Colors.blueAccent)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                                borderSide: BorderSide(color: Colors.blue)),
                            errorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                                borderSide: BorderSide(color: Colors.red)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                                borderSide:
                                    BorderSide(color: Colors.red, width: 1.5)),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.025,
                              padding: EdgeInsets.zero,
                              child: DropdownButton<String>(
                                isExpanded: true,
                                icon: const Icon(Icons.arrow_drop_down),
                                value: staffId.toString(),
                                style: const TextStyle(color: Colors.black),
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
                                    staffId = int.parse(newValue!);
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'خدمات مورد نیاز',
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50.0)),
                                borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50.0)),
                                borderSide: BorderSide(color: Colors.blue)),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: SizedBox(
                              height: 26.0,
                              child: DropdownButton<String>(
                                isExpanded: true,
                                icon: const Icon(Icons.arrow_drop_down),
                                value: serviceId.toString(),
                                items: services.map((service) {
                                  return DropdownMenuItem<String>(
                                    value: service['ser_ID'],
                                    alignment: Alignment.centerRight,
                                    child: Text(service['ser_name']),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    // Assign the selected service id into the static one.
                                    serviceId = int.parse(newValue!);
                                    print('Selected service: $serviceId');
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                        child: TextFormField(
                          controller: apptdatetimeController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Date and time should be set.';
                            }
                            return null;
                          },
                          readOnly: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'تاریخ و زمان جلسه',
                            suffixIcon: Icon(Icons.access_time),
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
                          onTap: () async {
                            final DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (pickedDate != null) {
                              // ignore: use_build_context_synchronously
                              final TimeOfDay? pickedTime =
                                  await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (pickedTime != null) {
                                selectedDateTime = DateTime(
                                  pickedDate.year,
                                  pickedDate.month,
                                  pickedDate.day,
                                  pickedTime.hour,
                                  pickedTime.minute,
                                );
                                apptdatetimeController.text =
                                    selectedDateTime.toString();
                              }
                            }
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                        child: TextFormField(
                          controller: commentController,
                          validator: (value) {
                            if (value!.isNotEmpty) {
                              if (value.length < 5 || value.length > 40) {
                                return 'Details should at least 5 and at most 40 characters.';
                              }
                              return null;
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'توضیحات',
                            suffixIcon: Icon(Icons.description_outlined),
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
                                  BorderSide(color: Colors.red, width: 1.5),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            suffixIcon:
                                Icon(Icons.notifications_active_outlined),
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0)),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0)),
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0)),
                              borderSide: BorderSide(color: Colors.red),
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: SizedBox(
                              height: 26.0,
                              child: DropdownButton(
                                // isExpanded: true,
                                icon: const Icon(Icons.arrow_drop_down),
                                value: notifFrequency,
                                items: <String>[
                                  '5 Minutes',
                                  '15 Minutes',
                                  '30 Minutes',
                                  '1 Hour',
                                  '2 Hours'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    notifFrequency = newValue!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text('Save'),
                  onPressed: () async {
                    if (_calFormKey.currentState!.validate()) {
                      try {
                        final conn = await onConnToDb();
                        final results = await conn.query(
                            'INSERT INTO appointments (pat_ID, service_ID, meet_date, staff_ID, status, notification, details) VALUES (?, ?, ?, ?, ?, ?, ?)',
                            [
                              patientId,
                              serviceId,
                              apptdatetimeController.text.toString(),
                              staffId,
                              'Pending',
                              notifFrequency,
                              commentController.text.isEmpty
                                  ? null
                                  : commentController.text
                            ]);
                        if (results.affectedRows! > 0) {
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pop();
                          // ignore: use_build_context_synchronously
                          _onShowSnack(
                              Colors.green, 'Appointment scheduled!', context);
                        }
                        await conn.close();
                      } catch (e) {
                        print('Appointment scheduling failed: $e');
                      }
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}

/// An object to set the appointment collection data source to calendar, which
/// used to map the custom appointment data to the calendar appointment, and
/// allows to add, remove or reset the appointment collection.
class MeetingDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).to;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).eventName;
  }

  @override
  Color getColor(int index) {
    return _getMeetingData(index).background;
  }

  @override
  bool isAllDay(int index) {
    return _getMeetingData(index).isAllDay;
  }

  Meeting _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final Meeting meetingData;
    if (meeting is Meeting) {
      meetingData = meeting;
    }

    return meetingData;
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the event data which will be rendered in calendar.
class Meeting {
  /// Creates a meeting class with required details.
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  /// Event name which is equivalent to subject property of [Appointment].
  String eventName;

  /// From which is equivalent to start time property of [Appointment].
  DateTime from;

  /// To which is equivalent to end time property of [Appointment].
  DateTime to;

  /// Background which is equivalent to color property of [Appointment].
  Color background;

  /// IsAllDay which is equivalent to isAllDay property of [Appointment].
  bool isAllDay;
}

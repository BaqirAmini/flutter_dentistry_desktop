import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:windows_notification/notification_message.dart';
import 'package:windows_notification/windows_notification.dart';

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
            IconButton(onPressed: showWithLargeImage, icon: Icon(Icons.notification_add))
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
  late List<Appointment> _appointments;
  final _calFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _appointments = _getAppointments();
  }

  List<Appointment> _getAppointments() {
    // Replace this with your actual data
    return <Appointment>[
      Appointment(
        startTime: DateTime.now(),
        endTime: DateTime.now().add(const Duration(hours: 1)),
        subject: 'Meeting',
        color: Colors.blue,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      view: CalendarView.day,
      onTap: (CalendarTapDetails details) {
        if (details.targetElement == CalendarElement.calendarCell) {
          _showDateTimeDialog(context);
        }
      },
    );
  }

  _showDateTimeDialog(BuildContext context) async {
    DateTime selectedDateTime = DateTime.now();
    TextEditingController apptdatetimeController = TextEditingController();
    TextEditingController commentController = TextEditingController();
    TextEditingController titleController = TextEditingController();
    String dropdownValue = '15 Minutes';

    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                    child: TextFormField(
                      controller: titleController,
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
                        labelText: 'عنوان جلسه',
                        suffixIcon: Icon(Icons.title_outlined),
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
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                          borderSide: BorderSide(color: Colors.red, width: 1.5),
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
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          // ignore: use_build_context_synchronously
                          final TimeOfDay? pickedTime = await showTimePicker(
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
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                          borderSide: BorderSide(color: Colors.red, width: 1.5),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.notifications_active_outlined),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: SizedBox(
                          height: 26.0,
                          child: DropdownButton(
                            // isExpanded: true,
                            icon: const Icon(Icons.arrow_drop_down),
                            value: dropdownValue,
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
                                dropdownValue = newValue!;
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
              onPressed: () {
                if (_calFormKey.currentState!.validate()) {}
              },
            ),
          ],
        );
      },
    );
  }
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}

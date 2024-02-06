import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dentistry/config/global_usage.dart';
import 'package:flutter_dentistry/config/language_provider.dart';
import 'package:flutter_dentistry/models/db_conn.dart';
import 'package:flutter_dentistry/views/main/dashboard.dart';
import 'package:flutter_dentistry/views/patients/new_patient.dart';
import 'package:flutter_dentistry/views/patients/patient_info.dart';
import 'package:flutter_dentistry/views/patients/patients.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:windows_notification/notification_message.dart';
import 'package:windows_notification/windows_notification.dart';
import 'package:intl/intl.dart' as intl2;

void main() => runApp(const CalendarApp());

// Add a state variable for the search term
ValueNotifier<String> _searchTermNotifier = ValueNotifier<String>('');

// ignore: prefer_typing_uninitialized_variables
var selectedLanguage;
// ignore: prefer_typing_uninitialized_variables
var isEnglish;

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

class CalendarApp extends StatefulWidget {
  const CalendarApp({Key? key}) : super(key: key);

  @override
  State<CalendarApp> createState() => _CalendarAppState();
}

class _CalendarAppState extends State<CalendarApp> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: SizedBox(
            width: 400.0,
            height: 40.0,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Search patients...',
                labelStyle: const TextStyle(color: Colors.white),
                suffixIcon: IconButton(
                  splashRadius: 25.0,
                  icon: const Icon(Icons.clear, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      _searchTermNotifier.value = '';
                    });
                  },
                ),
                enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    borderSide: BorderSide(color: Colors.white)),
              ),
              onChanged: (value) {
                setState(() {
                  _searchTermNotifier.value = value;
                });
              },
            ),
          ),
          actions: [
            IconButton(
              tooltip: 'Go to dashboard',
              splashRadius: 25.0,
              icon: const Icon(Icons.home_outlined),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Dashboard(),
                ),
              ),
            ),
          ],
        ),
        body: const CalendarPage(),
      ),
      theme: ThemeData(useMaterial3: false),
    );
  }
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final CalendarView _calendarView = CalendarView.day;
  // Declare these variable since they are need to be inserted into appointments.
  late int? serviceId;
  late int? staffId;
  int? selectedPatientID;
  // This is to fetch staff list
  List<Map<String, dynamic>> staffList = [];
  // This list is to be assigned services
  List<Map<String, dynamic>> services = [];
  late List<PatientAppointment> _appointments;
  final _apptCalFormKey = GlobalKey<FormState>();
  final _editApptCalFormKey = GlobalKey<FormState>();
// Create an instance GlobalUsage to be access its method
  final GlobalUsage _gu = GlobalUsage();
  // These variable are used for editing schedule appointment
  int selectedStaffId = 0;
  int selectedServiceId = 0;

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

  @override
  Widget build(BuildContext context) {
    // Fetch translations keys based on the selected language.
    var languageProvider = Provider.of<LanguageProvider>(context);
    selectedLanguage = languageProvider.selectedLanguage;
    isEnglish = selectedLanguage == 'English';

    return ValueListenableBuilder(
      valueListenable: _searchTermNotifier,
      builder: (context, value, child) {
        return FutureBuilder<AppointmentDataSource>(
          future: _getCalendarDataSource(searchTerm: value),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return SfCalendar(
                allowViewNavigation: true,
                allowDragAndDrop: true,
                dataSource: snapshot.data,
                view: _calendarView,
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
                    _scheduleAppointment(context, selectedDate!, () {
                      setState(() {});
                    });
                  } else if (details.targetElement ==
                      CalendarElement.appointment) {
                    // Access members of PatientAppointment class
                    Meeting meeting = details.appointments![0];
                    PatientAppointment appointment = meeting.patientAppointment;
                    int aptId = appointment.apptId;
                    int serviceID = appointment.serviceID;
                    int dentistID = appointment.staffID;
                    String dentistFName = appointment.dentistFName;
                    String dentistLName = appointment.dentistLName.isEmpty
                        ? ''
                        : appointment.dentistLName;
                    String serviceName = appointment.serviceName;
                    DateTime scheduleTime = appointment.visitTime;
                    String description = appointment.comments.isEmpty
                        ? ''
                        : appointment.comments;
                    String notifFreq = appointment.notifFreq;
                    int pID = appointment.patientID;
                    String pFirstName = appointment.patientFName;
                    String pLastName = appointment.patientLName;
                    // Call this function to see more details of an schedule appointment
                    _showAppoinmentDetails(
                        context,
                        dentistID,
                        serviceID,
                        aptId,
                        dentistFName,
                        dentistLName,
                        pID,
                        pFirstName,
                        pLastName,
                        serviceName,
                        scheduleTime.toString(),
                        description,
                        notifFreq);

                    _alertUpcomingAppointment(meeting);
                  }
                },
              );
            }
          },
        );
      },
    );
  }

// This function is to give notifiction for users
  Future<void> _alertUpcomingAppointment(Meeting meeting) async {
    final notificationTime = meeting.from.subtract(const Duration(minutes: 5));
    final delay = notificationTime.difference(DateTime.now());
    if (delay > Duration.zero) {
      await Future.delayed(delay);
      final winNotifyPlugin = WindowsNotification(
          // Work PC
          /*  applicationId:
            r"{7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}\Dental Clinics MIS\flutter_dentistry.exe"); */
          // Personal PC
          applicationId:
              r"{7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}\Dental Clinic System\flutter_dentistry.exe");
      NotificationMessage message = NotificationMessage.fromPluginTemplate(
          "appointment", "Upcoming Appointment", "You have an appointment");
      winNotifyPlugin.showNotificationPluginTemplate(message);
    }
  }

// Create this function to schedule an appointment
  _scheduleAppointment(
      BuildContext context, DateTime selectedDate, Function refresh) async {
    DateTime selectedDateTime = DateTime.now();
    TextEditingController apptdatetimeController = TextEditingController();
    TextEditingController commentController = TextEditingController();
    TextEditingController patientSearchableController = TextEditingController();
    String notifFrequency = '15 Minutes';
    apptdatetimeController.text = selectedDate.toString();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Schedule an appointment'),
              content: SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width * 0.3,
                child: SingleChildScrollView(
                  child: Form(
                    key: _apptCalFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Tooltip(
                          message: 'New Patient',
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const NewPatient()));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.blue, width: 2.0),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Icon(
                                  Icons.person_add_alt,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10.0),
                          child: Column(
                            children: [
                              TypeAheadField(
                                suggestionsCallback: (search) async {
                                  try {
                                    final conn = await onConnToDb();
                                    var results = await conn.query(
                                        'SELECT pat_ID, firstname, lastname, phone FROM patients WHERE firstname LIKE ?',
                                        ['%$search%']);

                                    // Convert the results into a list of Patient objects
                                    var suggestions = results
                                        .map((row) => PatientDataModel(
                                              patientId: row[0] as int,
                                              patientFName: row[1],
                                              patentLName: row[2],
                                              patientPhone: row[3],
                                            ))
                                        .toList();
                                    return suggestions;
                                  } catch (e) {
                                    print(
                                        'Something wrong with patient searchable dropdown: $e');
                                    return [];
                                  }
                                },
                                builder: (context, controller, focusNode) {
                                  patientSearchableController = controller;
                                  return TextFormField(
                                    controller: controller,
                                    focusNode: focusNode,
                                    autofocus: true,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Patient not selected';
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'انتخاب مریض',
                                      labelStyle: TextStyle(color: Colors.grey),
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
                                  );
                                },
                                itemBuilder: (context, patient) {
                                  return Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: ListTile(
                                      title: Text(
                                          '${patient.patientFName} ${patient.patentLName}'),
                                      subtitle: Text(patient.patientPhone),
                                    ),
                                  );
                                },
                                onSelected: (patient) {
                                  setState(
                                    () {
                                      patientSearchableController.text =
                                          '${patient.patientFName} ${patient.patentLName}';
                                      selectedPatientID = patient.patientId;
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
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
                                  borderSide: BorderSide(
                                      color: Colors.red, width: 1.5)),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: Container(
                                height: 26.0,
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
                                  borderSide: BorderSide(
                                      color: Colors.red, width: 1.5)),
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
                                    // ignore: use_build_context_synchronously
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
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(GlobalUsage.allowedEPChar))
                            ],
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
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
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
              ),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text('Save'),
                  onPressed: () async {
                    if (_apptCalFormKey.currentState!.validate()) {
                      try {
                        final conn = await onConnToDb();
                        final results = await conn.query(
                            'INSERT INTO appointments (pat_ID, service_ID, meet_date, staff_ID, status, notification, details) VALUES (?, ?, ?, ?, ?, ?, ?)',
                            [
                              selectedPatientID,
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
                          refresh();
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

// This function is to show scheduled appointment details
  _showAppoinmentDetails(
      BuildContext context,
      int staffID,
      int serviceId,
      int aptId,
      String dentistFName,
      String dentistLName,
      int patientID,
      String patientFName,
      String patientLName,
      String service,
      String time,
      String description,
      String frequency) async {
    String formattedTime =
        intl2.DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.parse(time));
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Patient Full Name: $patientFName $patientLName',
                  style: const TextStyle(color: Colors.blue, fontSize: 15.0)),
              Row(
                children: [
                  IconButton(
                      splashRadius: 25.0,
                      onPressed: () {
                        Navigator.pop(context);
                        _editAppointmentDetails(
                            context,
                            staffID,
                            serviceId,
                            aptId,
                            patientID,
                            patientFName,
                            patientLName,
                            time,
                            frequency,
                            description, () {
                          setState(() {});
                        });
                      },
                      icon: const Icon(Icons.edit_outlined,
                          size: 18.0, color: Colors.blue)),
                  const SizedBox(width: 10.0),
                  IconButton(
                      splashRadius: 25.0,
                      onPressed: () {
                        Navigator.pop(context);
                        _onDeleteAppointment(context, aptId, () {
                          setState(() {});
                        });
                      },
                      icon: const Icon(Icons.delete_outline,
                          size: 18.0, color: Colors.blue)),
                ],
              )
            ],
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            height: MediaQuery.of(context).size.height * 0.35,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_month_outlined,
                          color: Colors.grey),
                      const SizedBox(width: 15.0),
                      Text(formattedTime)
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.title_outlined, color: Colors.grey),
                      const SizedBox(width: 15.0),
                      Text(service.toString()),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.person_3_outlined, color: Colors.grey),
                      const SizedBox(width: 15.0),
                      Text('$dentistFName $dentistLName'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.notifications_active_outlined,
                          color: Colors.grey),
                      const SizedBox(width: 15.0),
                      Text(frequency),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outlined, color: Colors.grey),
                      const SizedBox(width: 15.0),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: Text(description))
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

// This function is to edit scheduled appointment details
  _editAppointmentDetails(
      BuildContext context,
      int dentistID,
      int selectedSerId,
      int apptId,
      int patientId,
      String patientFName,
      String patientLName,
      String selectedDate,
      String notifFreq,
      String description,
      Function refresh) async {
    DateTime selectedDateTime = DateTime.now();
    TextEditingController editApptTimeController = TextEditingController();
    TextEditingController editCommentController = TextEditingController();
    TextEditingController editPSearchableCntr = TextEditingController();
    editApptTimeController.text = selectedDate.toString();
    editCommentController.text = description;
    int currentPatID = patientId;
// Assign this argument to selectedStaffId to display this dentist in edit dialogbox.
    selectedStaffId = dentistID;
    selectedServiceId = selectedSerId;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit Appointment'),
              content: SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width * 0.3,
                child: SingleChildScrollView(
                  child: Form(
                    key: _editApptCalFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10.0),
                          child: Column(
                            children: [
                              TypeAheadField(
                                suggestionsCallback: (search) async {
                                  try {
                                    final conn = await onConnToDb();
                                    var results = await conn.query(
                                        'SELECT pat_ID, firstname, lastname, phone FROM patients WHERE firstname LIKE ? OR CONCAT(firstname, " ", lastname) LIKE ?',
                                        ['%$search%', '%$search%']);

                                    // Convert the results into a list of Patient objects
                                    var suggestions = results
                                        .map((row) => PatientDataModel(
                                              patientId: row[0] as int,
                                              patientFName: row[1],
                                              patentLName: row[2],
                                              patientPhone: row[3],
                                            ))
                                        .toList();
                                    return suggestions;
                                  } catch (e) {
                                    print(
                                        'Something wrong with patient searchable dropdown in edit dialog (General Calendar): $e');
                                    return [];
                                  }
                                },
                                builder: (context, controller, focusNode) {
                                  editPSearchableCntr = controller;
                                  return TextFormField(
                                    controller: controller,
                                    focusNode: focusNode,
                                    autofocus: true,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'انتخاب مریض',
                                      labelStyle: TextStyle(color: Colors.grey),
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
                                  );
                                },
                                itemBuilder: (context, patient) {
                                  return Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: ListTile(
                                      title: Text(
                                          '${patient.patientFName} ${patient.patentLName}'),
                                      subtitle: Text(patient.patientPhone),
                                    ),
                                  );
                                },
                                onSelected: (patient) {
                                  setState(
                                    () {
                                      editPSearchableCntr.text =
                                          '${patient.patientFName} ${patient.patentLName}';
                                      currentPatID = patient.patientId;
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
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
                                  borderSide: BorderSide(
                                      color: Colors.red, width: 1.5)),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: Container(
                                height: 26.0,
                                padding: EdgeInsets.zero,
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  value: selectedStaffId.toString(),
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
                                      selectedStaffId = int.parse(newValue!);
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
                                  value: selectedServiceId.toString(),
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
                                      selectedServiceId = int.parse(newValue!);
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
                            controller: editApptTimeController,
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
                                  borderSide: BorderSide(
                                      color: Colors.red, width: 1.5)),
                            ),
                            onTap: () async {
                              final DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.parse(selectedDate),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (pickedDate != null) {
                                // ignore: use_build_context_synchronously
                                final TimeOfDay? pickedTime =
                                    // ignore: use_build_context_synchronously
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
                                  editApptTimeController.text =
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
                            controller: editCommentController,
                            validator: (value) {
                              if (value!.isNotEmpty) {
                                if (value.length < 5 || value.length > 40) {
                                  return 'Details should at least 5 and at most 40 characters.';
                                }
                                return null;
                              }
                              return null;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(GlobalUsage.allowedEPChar))
                            ],
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
                                  value: notifFreq,
                                  items: <String>[
                                    '5 Minutes',
                                    '15 Minutes',
                                    '30 Minutes',
                                    '1 Hour',
                                    '2 Hours'
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      notifFreq = newValue!;
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
              ),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text('Save'),
                  onPressed: () async {
                    currentPatID = editPSearchableCntr.text.isEmpty
                        ? patientId
                        : currentPatID;
                    if (_editApptCalFormKey.currentState!.validate()) {
                      try {
                        final conn = await onConnToDb();
                        final results = await conn.query(
                            'UPDATE appointments SET pat_ID = ?, service_ID = ?, staff_ID = ?, meet_date = ?, notification = ?, details = ? WHERE apt_ID = ?',
                            [
                              currentPatID,
                              selectedServiceId,
                              selectedStaffId,
                              editApptTimeController.text.toString(),
                              notifFreq,
                              editCommentController.text.isEmpty
                                  ? null
                                  : editCommentController.text,
                              apptId
                            ]);
                        if (results.affectedRows! > 0) {
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pop();
                          // ignore: use_build_context_synchronously
                          _onShowSnack(Colors.green,
                              'The scheduled appointment updated.', context);
                          refresh();
                        } else {
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pop();
                          // ignore: use_build_context_synchronously
                          _onShowSnack(
                              Colors.red, 'No changes applied.', context);
                        }

                        await conn.close();
                      } catch (e) {
                        print(
                            'Appointment scheduling failed (General Calendar): $e');
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

// This function deletes a schedule appointment
  _onDeleteAppointment(BuildContext context, int apptId, Function refresh) {
    return showDialog(
      useRootNavigator: true,
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Directionality(
              textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
              child: const Text('Delete a scheduled appointment'),
            ),
            content: Directionality(
              textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
              child: const Text(
                  'Are you sure you want to delete this scheduled appointment'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  final conn = await onConnToDb();
                  final deleteResult = await conn.query(
                      'DELETE FROM appointments WHERE apt_ID = ?', [apptId]);
                  if (deleteResult.affectedRows! > 0) {
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                    // ignore: use_build_context_synchronously
                    _onShowSnack(Colors.green, 'جلسه موفقانه حذف شد.', context);
                    refresh();
                  }
                  await conn.close();
                },
                child: const Text('Delete'),
              ),
            ],
          );
        },
      ),
    );
  }

  // This function fetches the scheduled appointments from database
  Future<List<PatientAppointment>> _fetchAppointments(
      {String searchTerm = ''}) async {
    try {
      final conn = await onConnToDb();
      final results = await conn.query(
          '''SELECT st.firstname, st.lastname, s.ser_name, a.details, a.meet_date, a.apt_ID, a.notification, a.service_ID, a.staff_ID, p.pat_ID, p.firstname, p.lastname FROM staff st 
             INNER JOIN appointments a ON st.staff_ID = a.staff_ID 
             INNER JOIN patients p ON p.pat_ID = a.pat_ID
             INNER JOIN services s ON a.service_ID = s.ser_ID WHERE a.status = ? AND (LOWER(p.firstname) LIKE ? OR ? = '')''',
          [
            'Pending',
            '%$searchTerm%'.toLowerCase(),
            searchTerm.isEmpty ? '' : '%$searchTerm%'.toLowerCase()
          ]);
      return results
          .map((row) => PatientAppointment(
                dentistFName: row[0].toString(),
                dentistLName: row[1].toString(),
                serviceName: row[2].toString(),
                comments: row[3] == null ? '' : row[3].toString(),
                visitTime: row[4] as DateTime,
                apptId: row[5] as int,
                notifFreq: row[6].toString(),
                serviceID: row[7] as int,
                staffID: row[8] as int,
                patientID: row[9] as int,
                patientFName: row[10],
                patientLName: row[11] == null ? '' : row[11].toString(),
              ))
          .toList();
    } catch (e) {
      print('The scheduled appoinments cannot be retrieved: $e');
      return [];
    }
  }

// Dislay the scheduled appointment
  Future<AppointmentDataSource> _getCalendarDataSource(
      {String searchTerm = ''}) async {
    List<PatientAppointment> appointments =
        await _fetchAppointments(searchTerm: searchTerm);
    List<Meeting> meetings = appointments.map((appointment) {
      Color bgColor;

      switch (appointment.apptId % 5) {
        case 0:
          bgColor = Colors.red;
          break;
        case 1:
          bgColor = Colors.green;
          break;
        case 2:
          bgColor = Colors.blue;
          break;
        case 3:
          bgColor = const Color.fromARGB(255, 46, 12, 236);
          break;
        default:
          bgColor = Colors.purple;
      }

      return Meeting(
        from: appointment.visitTime,
        to: appointment.visitTime.add(const Duration(hours: 1)),
        eventName:
            'Appointment with Dentist ${appointment.dentistFName} ${appointment.dentistLName}',
        description: appointment.comments,
        patientAppointment: appointment,
        background: bgColor,
      );
    }).toList();

    return AppointmentDataSource(meetings);
  }
}

class Meeting {
  Meeting({
    required this.from,
    required this.to,
    required this.eventName,
    required this.description,
    required this.patientAppointment,
    this.background = const Color.fromARGB(255, 211, 40, 34),
  });

  DateTime from;
  DateTime to;
  String eventName;
  String description;
  PatientAppointment patientAppointment;
  Color background;
}

class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return false;
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the event data which will be rendered in calendar.
class PatientAppointment {
  final int staffID;
  final int apptId;
  final int serviceID;
  final int patientID;
  final String dentistFName;
  final String dentistLName;
  final String serviceName;
  final String patientFName;
  final String patientLName;
  final String comments;
  final DateTime visitTime;
  final String notifFreq;

  PatientAppointment(
      {required this.staffID,
      required this.apptId,
      required this.serviceID,
      required this.patientID,
      required this.dentistFName,
      required this.dentistLName,
      required this.serviceName,
      required this.patientFName,
      required this.patientLName,
      required this.comments,
      required this.visitTime,
      required this.notifFreq});
}

class PatientDataModel {
  final int patientId;
  final String patientFName;
  final String patentLName;
  final String patientPhone;

  PatientDataModel({
    required this.patientId,
    required this.patientFName,
    required this.patentLName,
    required this.patientPhone,
  });
}

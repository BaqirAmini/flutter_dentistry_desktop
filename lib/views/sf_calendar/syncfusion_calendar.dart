import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

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
        ),
        body: const CalendarPage(),
      ),
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
  late List<Appointment> _appointments;

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
      view: CalendarView.week,
      dataSource: _AppointmentDataSource(_appointments),
    );
  }
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}

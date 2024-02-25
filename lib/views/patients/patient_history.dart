import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dentistry/config/global_usage.dart';
import 'package:flutter_dentistry/models/db_conn.dart';
import 'package:flutter_dentistry/views/main/dashboard.dart';
import 'package:flutter_dentistry/views/patients/new_health_history.dart';
import 'package:flutter_dentistry/views/patients/patient_info.dart';
import 'package:flutter_dentistry/views/patients/patients.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart' as intl2;

void main() {
  runApp(const PatientHistory());
}

class PatientHistory extends StatefulWidget {
  const PatientHistory({Key? key}) : super(key: key);

  @override
  State<PatientHistory> createState() => _PatientHistoryState();
}

class _PatientHistoryState extends State<PatientHistory> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
                '${PatientInfo.firstName} ${PatientInfo.lastName} Health History'),
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
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
  final TextEditingController _editHDateController = TextEditingController();
  final TextEditingController _editHDetailsController = TextEditingController();
  String _editHCondGV = '';
  String _editHDurationGV = '';
  // Create a Map to store the group values for each condition
  int _editHCondResultGV = 0;
  final _patientHistEditFK = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _globalkey4HistEdit =
      GlobalKey<ScaffoldMessengerState>();

// This is shows snackbar when called
  void _onShowSnack(Color backColor, String msg) {
    _globalkey4HistEdit.currentState?.showSnackBar(
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

// Edit patient health history
  _onEditPatientHealthHistoryResult(
      int histCondID,
      int histResult,
      String? diagnosisDate,
      String? histSeverty,
      String? histDuration,
      String? histDetails,
      Function refresh) {
    _editHDateController.text =
        diagnosisDate!.isEmpty || diagnosisDate == '--' ? '' : diagnosisDate;
    _editHCondGV =
        histSeverty!.isEmpty || histSeverty == '--' ? 'نامعلوم' : histSeverty;
    _editHDurationGV = histDuration!.isEmpty || histDuration == '--'
        ? 'نامعلوم'
        : histDuration;
    _editHDetailsController.text =
        histDetails!.isEmpty || histDetails == '--' ? '' : histDetails;
    _editHCondResultGV = histResult;
    return showDialog(
        context: context,
        builder: (ctx) => StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: Directionality(
                    textDirection:
                        isEnglish ? TextDirection.ltr : TextDirection.rtl,
                    child: Text(
                      'تغییر تاریخچه صحی ${PatientInfo.firstName} ${PatientInfo.lastName}',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(color: Colors.blue),
                    ),
                  ),
                  content: Directionality(
                    textDirection:
                        isEnglish ? TextDirection.ltr : TextDirection.rtl,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Form(
                        key: _patientHistEditFK,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 20.0,
                                  right: 20.0,
                                  top: 10.0,
                                  bottom: 10.0),
                              width: 500,
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    labelText: 'نتیجه معاینه',
                                    floatingLabelAlignment:
                                        FloatingLabelAlignment.center),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Theme(
                                          data: Theme.of(context).copyWith(
                                            listTileTheme:
                                                const ListTileThemeData(
                                              horizontalTitleGap: 0.5,
                                            ),
                                          ),
                                          child: SizedBox(
                                            width: 100,
                                            child: RadioListTile(
                                              title: const Text(
                                                'مثبت',
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              value: 1,
                                              groupValue: _editHCondResultGV,
                                              onChanged: (int? value) {
                                                setState(
                                                  () {
                                                    _editHCondResultGV = value!;
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Theme(
                                          data: Theme.of(context).copyWith(
                                            listTileTheme:
                                                const ListTileThemeData(
                                              horizontalTitleGap: 0.5,
                                            ),
                                          ),
                                          child: RadioListTile(
                                            title: const Text(
                                              'منفی',
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            value: 0,
                                            groupValue: _editHCondResultGV,
                                            onChanged: (int? value) {
                                              setState(
                                                () {
                                                  _editHCondResultGV = value!;
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 500.0,
                              margin: const EdgeInsets.only(
                                  left: 20.0,
                                  right: 20.0,
                                  top: 10.0,
                                  bottom: 10.0),
                              child: TextFormField(
                                controller: _editHDateController,
                                onTap: () async {
                                  FocusScope.of(context).requestFocus(
                                    FocusNode(),
                                  );
                                  final DateTime? dateTime =
                                      await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime(2100));
                                  if (dateTime != null) {
                                    final intl2.DateFormat formatter =
                                        intl2.DateFormat('yyyy-MM-dd');
                                    final String formattedDate =
                                        formatter.format(dateTime);
                                    _editHDateController.text = formattedDate;
                                  }
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9.]'))
                                ],
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'تاریخ تشخیص / معاینه',
                                  suffixIcon:
                                      Icon(Icons.calendar_month_outlined),
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
                              ),
                            ),
                            Container(
                              width: 500.0,
                              margin: const EdgeInsets.only(
                                  left: 20.0,
                                  right: 20.0,
                                  top: 10.0,
                                  bottom: 10.0),
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 10.0),
                                  border: OutlineInputBorder(),
                                  labelText: 'شدت / سطح',
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(50.0),
                                    ),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(50.0),
                                    ),
                                    borderSide: BorderSide(color: Colors.blue),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Theme(
                                        data: Theme.of(context).copyWith(
                                          listTileTheme:
                                              const ListTileThemeData(
                                                  horizontalTitleGap: 0.5),
                                        ),
                                        child: RadioListTile(
                                            title: const Text(
                                              'خفیف',
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            value: 'خفیف',
                                            groupValue: _editHCondGV,
                                            onChanged: (String? value) {
                                              setState(() {
                                                _editHCondGV = value!;
                                              });
                                            }),
                                      ),
                                    ),
                                    Expanded(
                                      child: Theme(
                                        data: Theme.of(context).copyWith(
                                          listTileTheme:
                                              const ListTileThemeData(
                                                  horizontalTitleGap: 0.5),
                                        ),
                                        child: RadioListTile(
                                            title: const Text(
                                              'متوسط',
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            value: 'متوسط',
                                            groupValue: _editHCondGV,
                                            onChanged: (String? value) {
                                              setState(() {
                                                _editHCondGV = value!;
                                              });
                                            }),
                                      ),
                                    ),
                                    Expanded(
                                      child: Theme(
                                        data: Theme.of(context).copyWith(
                                          listTileTheme:
                                              const ListTileThemeData(
                                                  horizontalTitleGap: 0.5),
                                        ),
                                        child: RadioListTile(
                                            title: const Text(
                                              'شدید',
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            value: 'شدید',
                                            groupValue: _editHCondGV,
                                            onChanged: (String? value) {
                                              setState(() {
                                                _editHCondGV = value!;
                                              });
                                            }),
                                      ),
                                    ),
                                    Expanded(
                                      child: Theme(
                                        data: Theme.of(context).copyWith(
                                          listTileTheme:
                                              const ListTileThemeData(
                                                  horizontalTitleGap: 0.5),
                                        ),
                                        child: RadioListTile(
                                            title: const Text(
                                              'نامعلوم',
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            value: 'نامعلوم',
                                            groupValue: _editHCondGV,
                                            onChanged: (String? value) {
                                              setState(() {
                                                _editHCondGV = value!;
                                              });
                                            }),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: 500.0,
                              margin: const EdgeInsets.only(
                                  left: 20.0,
                                  right: 20.0,
                                  top: 10.0,
                                  bottom: 10.0),
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 10.0),
                                  border: OutlineInputBorder(),
                                  labelText: 'سابقه / مدت',
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(50.0),
                                    ),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(50.0),
                                    ),
                                    borderSide: BorderSide(color: Colors.blue),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Theme(
                                        data: Theme.of(context).copyWith(
                                          listTileTheme:
                                              const ListTileThemeData(
                                                  horizontalTitleGap: 0.5),
                                        ),
                                        child: RadioListTile(
                                            title: const Text(
                                              '1 هفته',
                                              style: TextStyle(fontSize: 10),
                                            ),
                                            value: '1 هفته',
                                            groupValue: _editHDurationGV,
                                            onChanged: (String? value) {
                                              setState(() {
                                                _editHDurationGV = value!;
                                              });
                                            }),
                                      ),
                                    ),
                                    Expanded(
                                      child: Theme(
                                        data: Theme.of(context).copyWith(
                                          listTileTheme:
                                              const ListTileThemeData(
                                                  horizontalTitleGap: 0.5),
                                        ),
                                        child: RadioListTile(
                                            title: const Text(
                                              '1 ماه',
                                              style: TextStyle(fontSize: 10),
                                            ),
                                            value: '1 ماه',
                                            groupValue: _editHDurationGV,
                                            onChanged: (String? value) {
                                              setState(() {
                                                _editHDurationGV = value!;
                                              });
                                            }),
                                      ),
                                    ),
                                    Expanded(
                                      child: Theme(
                                        data: Theme.of(context).copyWith(
                                          listTileTheme:
                                              const ListTileThemeData(
                                                  horizontalTitleGap: 0.5),
                                        ),
                                        child: RadioListTile(
                                            title: const Text(
                                              '6 ماه',
                                              style: TextStyle(fontSize: 10),
                                            ),
                                            value: '6 ماه',
                                            groupValue: _editHDurationGV,
                                            onChanged: (String? value) {
                                              setState(() {
                                                _editHDurationGV = value!;
                                              });
                                            }),
                                      ),
                                    ),
                                    Expanded(
                                      child: Theme(
                                        data: Theme.of(context).copyWith(
                                          listTileTheme:
                                              const ListTileThemeData(
                                                  horizontalTitleGap: 0.5),
                                        ),
                                        child: RadioListTile(
                                            title: const Text(
                                              'بیشتر',
                                              style: TextStyle(fontSize: 10),
                                            ),
                                            value: 'بیشتر از یک سال',
                                            groupValue: _editHDurationGV,
                                            onChanged: (String? value) {
                                              setState(() {
                                                _editHDurationGV = value!;
                                              });
                                            }),
                                      ),
                                    ),
                                    Expanded(
                                      child: Theme(
                                        data: Theme.of(context).copyWith(
                                          listTileTheme:
                                              const ListTileThemeData(
                                                  horizontalTitleGap: 0.5),
                                        ),
                                        child: RadioListTile(
                                            title: const Text(
                                              'نامعلوم',
                                              style: TextStyle(fontSize: 10),
                                            ),
                                            value: 'نامعلوم',
                                            groupValue: _editHDurationGV,
                                            onChanged: (String? value) {
                                              setState(() {
                                                _editHDurationGV = value!;
                                              });
                                            }),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: 500.0,
                              margin: const EdgeInsets.only(
                                  left: 20.0,
                                  right: 20.0,
                                  top: 10.0,
                                  bottom: 10.0),
                              child: TextFormField(
                                controller: _editHDetailsController,
                                validator: (value) {
                                  if (value!.isNotEmpty) {
                                    if (value.length > 40 ||
                                        value.length < 10) {
                                      return 'توضیحات باید حداقل 10 و حداکثر 40 حرف باشد.';
                                    }
                                  }
                                  return null;
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(GlobalUsage.allowedEPChar),
                                  ),
                                ],
                                minLines: 1,
                                maxLines: 2,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'توضیحات',
                                  suffixIcon: Icon(Icons.note_alt_outlined),
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
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () =>
                          Navigator.of(context, rootNavigator: true).pop(),
                      child: const Text('لغو'),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          // print('Editing $condID');
                          if (_patientHistEditFK.currentState!.validate()) {
                            try {
                              final conn = await onConnToDb();
                              var editResults = await conn.query(
                                  'UPDATE condition_details SET result = ?, severty = ?, duration = ?, diagnosis_date = ?, notes = ? WHERE pat_ID = ? AND cond_detail_ID = ?',
                                  [
                                    _editHCondResultGV,
                                    _editHCondGV.isEmpty ? null : _editHCondGV,
                                    _editHDurationGV.isEmpty
                                        ? null
                                        : _editHDurationGV,
                                    _editHDateController.text.isEmpty
                                        ? null
                                        : _editHDateController.text.toString(),
                                    _editHDetailsController.text.isEmpty
                                        ? null
                                        : _editHDetailsController.text,
                                    PatientInfo.patID,
                                    histCondID
                                  ]);
                              if (editResults.affectedRows! > 0) {
                                _onShowSnack(Colors.green,
                                    'این مورد تاریخچه صحی مریض موفقانه تغییر کرد.');
                                refresh();
                              } else {
                                _onShowSnack(
                                    Colors.red, 'هیچ تغییراتی نیاورده اید.');
                              }
                              // ignore: use_build_context_synchronously
                              Navigator.of(context, rootNavigator: true).pop();
                              await conn.close();
                            } catch (e) {
                              print(
                                  'Error occured with updating a patient health history: $e');
                            }
                          }
                        },
                        child: const Text('تغییر دادن')),
                  ],
                );
              },
            ));
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _globalkey4HistEdit,
      child: Scaffold(
        body: FutureBuilder(
            future: _getHistory(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('No health histories found for this patient.'),
                      const SizedBox(height: 15.0),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.050,
                        width: MediaQuery.of(context).size.width * 0.060,
                        child: Tooltip(
                          message: 'Add health histories',
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                side: const BorderSide(color: Colors.blue)),
                            onPressed: () {
                              PatientInfo.showElevatedBtn = true;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const NewHealthHistory(),
                                ),
                              ).then((_) {
                                setState(() {});
                              });
                            },
                            child: const Icon(Icons.add_outlined),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
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
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: h.result == 1
                                          ? Colors.red
                                          : Colors.blue,
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
                                            color: Color.fromARGB(
                                                255, 112, 112, 112),
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
                                            color: Color.fromARGB(
                                                255, 112, 112, 112),
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
                                            color: Color.fromARGB(
                                                255, 112, 112, 112),
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
                                            color: Color.fromARGB(
                                                255, 112, 112, 112),
                                            fontSize: 12.0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: IconButton(
                                  tooltip: 'Edit',
                                  splashRadius: 23,
                                  onPressed: () =>
                                      _onEditPatientHealthHistoryResult(
                                          h.condDetailID,
                                          h.result,
                                          h.dianosisDate.toString(),
                                          h.severty,
                                          h.duration,
                                          h.notes, () {
                                    setState(
                                      () {},
                                    );
                                  }),
                                  icon: const Icon(Icons.edit, size: 16.0),
                                ),
                              )
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
                }
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
            }),
      ),
    );
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

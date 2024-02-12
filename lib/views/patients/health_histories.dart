import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dentistry/config/global_usage.dart';
import 'package:flutter_dentistry/config/language_provider.dart';
import 'package:flutter_dentistry/models/db_conn.dart';
import 'package:flutter_dentistry/views/patients/patient_info.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as intl2;

// Set global variables which are needed later.
var selectedLanguage;
var isEnglish;

class HealthHistories extends StatefulWidget {
  const HealthHistories({super.key});

  @override
  State<HealthHistories> createState() => HealthHistoriesState();
}

class HealthHistoriesState extends State<HealthHistories> {
  final Map<int, TextEditingController> _histDiagDateController = {};
  final Map<int, TextEditingController> _histNoteController = {};
  final Map<int, String> _histCondGroupValue = {};
  final Map<int, String> _durationGroupValue = {};
  // Create a Map to store the group values for each condition
  final Map<int, int> _condResultGV = {};
  final _condFormKey = GlobalKey<FormState>();
  final _condEditFormKey = GlobalKey<FormState>();
  final _hisDetFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Fetch translations keys based on the selected language.
    var languageProvider = Provider.of<LanguageProvider>(context);
    selectedLanguage = languageProvider.selectedLanguage;
    isEnglish = selectedLanguage == 'English';

    return Center(
      child: Form(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.95,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'تاریخچه صحی مریض که قبل از خدمات دندان باید جداً درنظر گرفته شود:',
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                  Tooltip(
                    message: 'تاریخچه صحی جدید',
                    child: InkWell(
                      onTap: () => _onCreateNewHealthHistory(),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.blue, width: 2.0),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Icon(
                            Icons.add,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              FutureBuilder(
                future: _onFetchHealthHistory(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final conds = snapshot.data;
                    List<Widget> conditionWidgets =
                        []; // Create an empty list of widgets
                    for (var cond in conds!) {
                      // Set a dynamic group value for radio buttons
                      _condResultGV[cond.condID] ??= 0;
                      // Add each Text widget to the list
                      conditionWidgets.add(
                        Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom:
                                  BorderSide(width: 0.4, color: Colors.grey),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(' - ${cond.CondName}'),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
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
                                        child: RadioListTile(
                                          title: const Text(
                                            'مثبت',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          value: 1,
                                          groupValue:
                                              _condResultGV[cond.condID],
                                          onChanged: (int? value) {
                                            setState(
                                              () {
                                                _condResultGV[cond.condID] =
                                                    value!;
                                              },
                                            );
                                          },
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
                                          groupValue:
                                              _condResultGV[cond.condID],
                                          onChanged: (int? value) {
                                            setState(
                                              () {
                                                _condResultGV[cond.condID] =
                                                    value!;
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: PopupMenuButton(
                                        icon: const Icon(
                                          Icons.more_horiz,
                                          color: Colors.blue,
                                        ),
                                        tooltip: 'بیشتر...',
                                        itemBuilder: (BuildContext context) =>
                                            <PopupMenuEntry>[
                                          if (_condResultGV[cond.condID] == 1)
                                            PopupMenuItem(
                                              child: Directionality(
                                                textDirection:
                                                    TextDirection.rtl,
                                                child: ListTile(
                                                  leading:
                                                      const Icon(Icons.list),
                                                  title: const Text(
                                                      'تکمیل تاریخچه'),
                                                  onTap: () {
                                                    _onAddMoreDetailsforHistory(
                                                        cond.condID);
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ),
                                            ),
                                          PopupMenuItem(
                                            child: Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: Builder(builder:
                                                  (BuildContext context) {
                                                return ListTile(
                                                  leading:
                                                      const Icon(Icons.edit),
                                                  title:
                                                      const Text('تغییر دادن'),
                                                  onTap: () {
                                                    _onEditHealthHistory(
                                                        cond.condID,
                                                        cond.CondName);
                                                    Navigator.pop(context);
                                                  },
                                                );
                                              }),
                                            ),
                                          ),
                                          PopupMenuItem(
                                            child: Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: ListTile(
                                                  leading: const Icon(Icons
                                                      .delete_outline_rounded),
                                                  title: const Text('حذف کردن'),
                                                  onTap: () {
                                                    _onDeleteHealthHistory(
                                                        cond.condID);
                                                    Navigator.pop(context);
                                                  }),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Add your second RadioListTile here
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    // Return a Column with all the widgets
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.56,
                      margin: const EdgeInsets.all(10),
                      child: SingleChildScrollView(
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20.0),
                                ),
                                borderSide: BorderSide(color: Colors.grey)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment
                                .start, // Align text to the left
                            // For right alignment, use CrossAxisAlignment.end
                            children: conditionWidgets,
                          ),
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
              if (PatientInfo.showElevatedBtn)
                ElevatedButton(
                    onPressed: () => onAddPatientHistory(PatientInfo.patID),
                    child: Text('Add Changes'))
            ],
          ),
        ),
      ),
    );
  }

  final GlobalKey<ScaffoldMessengerState> _globalKey2 =
      GlobalKey<ScaffoldMessengerState>();
// This is shows snackbar when called
  void _onShowSnack(Color backColor, String msg) {
    _globalKey2.currentState?.showSnackBar(
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

  // Create new patient conditions
  _onCreateNewHealthHistory() {
    final condNameController = TextEditingController();
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Directionality(
          textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
          child: const Text('ایجاد تاریخچه صحی مریض'),
        ),
        content: Directionality(
          textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.12,
            width: 600,
            child: Form(
              key: _condFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: condNameController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp('[a-zA-Z,،?. \u0600-\u06FFF]'),
                      ),
                    ],
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'تاریخچه صحی مریض نمی تواند خالی باشد.';
                      } else if (value.length > 256) {
                        return 'تاریخچه صحی خیلی طولانی است. لطفاً کمی مختصرش کنید.';
                      }
                      return null;
                    },
                    minLines: 1,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'تاریخچه صحی مریض',
                      suffixIcon: Icon(Icons.note_alt_outlined),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                          borderSide: BorderSide(color: Colors.blue)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                          borderSide: BorderSide(color: Colors.red)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                          borderSide:
                              BorderSide(color: Colors.red, width: 1.5)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            child: const Text('لغو'),
          ),
          ElevatedButton(
              onPressed: () async {
                if (_condFormKey.currentState!.validate()) {
                  var condText = condNameController.text;
                  final conn = await onConnToDb();
                  final insertResults = await conn.query(
                      'INSERT INTO conditions (name) VALUES (?)', [condText]);
                  if (insertResults.affectedRows! > 0) {
                    _onShowSnack(Colors.green, 'سوال موفقانه ثبت گردید.');
                    setState(() {});
                  } else {
                    _onShowSnack(Colors.red, 'ثبت سوال ناکام شد.');
                  }
                  Navigator.of(context, rootNavigator: true).pop();
                  await conn.close();
                }
              },
              child: const Text('ثبت')),
        ],
      ),
    );
  }

// Fetch patient condidtions
  Future<List<PatientCondition>> _onFetchHealthHistory() async {
    final conn = await onConnToDb();
    final results = await conn.query('SELECT cond_ID, name FROM conditions');
    final conditions = results
        .map(
          (row) =>
              PatientCondition(condID: row[0], CondName: row[1].toString()),
        )
        .toList();
    await conn.close();
    return conditions;
  }

  _onAddMoreDetailsforHistory(int condID) {
    // If these two radio button types are null, assign a value to them.
    _histCondGroupValue[condID] ??= 'نامعلوم';
    _durationGroupValue[condID] ??= 'نامعلوم';
    _histDiagDateController[condID] ??= TextEditingController();
    _histNoteController[condID] ??= TextEditingController();
    return showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (BuildContext context, setState) {
          return AlertDialog(
            title: Directionality(
              textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
              child: const Text('جزییات بیشتر راجع به تاریخچه صحی'),
            ),
            content: Directionality(
              textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
              child: SizedBox(
                height: 380,
                child: Form(
                  key: _hisDetFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 500.0,
                        margin: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                        child: TextFormField(
                          controller: _histDiagDateController[condID],
                          onTap: () async {
                            FocusScope.of(context).requestFocus(
                              FocusNode(),
                            );
                            final DateTime? dateTime = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100));
                            if (dateTime != null) {
                              final intl2.DateFormat formatter =
                                  intl2.DateFormat('yyyy-MM-dd');
                              final String formattedDate =
                                  formatter.format(dateTime);
                              _histDiagDateController[condID]!.text =
                                  formattedDate;
                            }
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                          ],
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'تاریخ تشخیص / معاینه',
                            suffixIcon: Icon(Icons.calendar_month_outlined),
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
                        ),
                      ),
                      Container(
                        width: 500.0,
                        margin: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
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
                                    listTileTheme: const ListTileThemeData(
                                        horizontalTitleGap: 0.5),
                                  ),
                                  child: RadioListTile(
                                      title: const Text(
                                        'خفیف',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      value: 'خفیف',
                                      groupValue: _histCondGroupValue[condID],
                                      onChanged: (String? value) {
                                        setState(() {
                                          _histCondGroupValue[condID] = value!;
                                        });
                                      }),
                                ),
                              ),
                              Expanded(
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                    listTileTheme: const ListTileThemeData(
                                        horizontalTitleGap: 0.5),
                                  ),
                                  child: RadioListTile(
                                      title: const Text(
                                        'متوسط',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      value: 'متوسط',
                                      groupValue: _histCondGroupValue[condID],
                                      onChanged: (String? value) {
                                        setState(() {
                                          _histCondGroupValue[condID] = value!;
                                        });
                                      }),
                                ),
                              ),
                              Expanded(
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                    listTileTheme: const ListTileThemeData(
                                        horizontalTitleGap: 0.5),
                                  ),
                                  child: RadioListTile(
                                      title: const Text(
                                        'شدید',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      value: 'شدید',
                                      groupValue: _histCondGroupValue[condID],
                                      onChanged: (String? value) {
                                        setState(() {
                                          _histCondGroupValue[condID] = value!;
                                        });
                                      }),
                                ),
                              ),
                              Expanded(
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                    listTileTheme: const ListTileThemeData(
                                        horizontalTitleGap: 0.5),
                                  ),
                                  child: RadioListTile(
                                      title: const Text(
                                        'نامعلوم',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      value: 'نامعلوم',
                                      groupValue: _histCondGroupValue[condID],
                                      onChanged: (String? value) {
                                        setState(() {
                                          _histCondGroupValue[condID] = value!;
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
                            left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
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
                                    listTileTheme: const ListTileThemeData(
                                        horizontalTitleGap: 0.5),
                                  ),
                                  child: RadioListTile(
                                      title: const Text(
                                        '1 هفته',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      value: '1 هفته',
                                      groupValue: _durationGroupValue[condID],
                                      onChanged: (String? value) {
                                        setState(() {
                                          _durationGroupValue[condID] = value!;
                                        });
                                      }),
                                ),
                              ),
                              Expanded(
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                    listTileTheme: const ListTileThemeData(
                                        horizontalTitleGap: 0.5),
                                  ),
                                  child: RadioListTile(
                                      title: const Text(
                                        '1 ماه',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      value: '1 ماه',
                                      groupValue: _durationGroupValue[condID],
                                      onChanged: (String? value) {
                                        setState(() {
                                          _durationGroupValue[condID] = value!;
                                        });
                                      }),
                                ),
                              ),
                              Expanded(
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                    listTileTheme: const ListTileThemeData(
                                        horizontalTitleGap: 0.5),
                                  ),
                                  child: RadioListTile(
                                      title: const Text(
                                        '6 ماه',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      value: '6 ماه',
                                      groupValue: _durationGroupValue[condID],
                                      onChanged: (String? value) {
                                        setState(() {
                                          _durationGroupValue[condID] = value!;
                                        });
                                      }),
                                ),
                              ),
                              Expanded(
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                    listTileTheme: const ListTileThemeData(
                                        horizontalTitleGap: 0.5),
                                  ),
                                  child: RadioListTile(
                                      title: const Text(
                                        'بیشتر',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      value: 'بیشتر',
                                      groupValue: _durationGroupValue[condID],
                                      onChanged: (String? value) {
                                        setState(() {
                                          _durationGroupValue[condID] = value!;
                                        });
                                      }),
                                ),
                              ),
                              Expanded(
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                    listTileTheme: const ListTileThemeData(
                                        horizontalTitleGap: 0.5),
                                  ),
                                  child: RadioListTile(
                                      title: const Text(
                                        'نامعلوم',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      value: 'نامعلوم',
                                      groupValue: _durationGroupValue[condID],
                                      onChanged: (String? value) {
                                        setState(() {
                                          _durationGroupValue[condID] = value!;
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
                            left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                        child: TextFormField(
                          controller: _histNoteController[condID],
                          validator: (value) {
                            if (value!.isNotEmpty) {
                              if (value.length > 40 || value.length < 10) {
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
                  child: const Text('لغو')),
              ElevatedButton(
                onPressed: () async {
                  if (_hisDetFormKey.currentState!.validate()) {
                    Navigator.of(context, rootNavigator: true).pop();
                    _onShowSnack(Colors.green, 'این مورد تاریخچه تکمیل گردید.');
                  }
                },
                child: const Text('انجام'),
              ),
            ],
          );
        },
      ),
    );
  }

// Edit patient health history
  _onEditHealthHistory(int condID, String condText) {
    final condNameController = TextEditingController();
    condNameController.text = condText;
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Directionality(
          textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
          child: const Text('تغییر تاریخچه صحی مریض'),
        ),
        content: Directionality(
          textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
          child: SizedBox(
            height: 100,
            width: 600,
            child: Form(
              key: _condEditFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: condNameController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp('[a-zA-Z,،?. \u0600-\u06FFF]'),
                      ),
                    ],
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'تاریخچه صحی مریض نمی تواند خالی باشد.';
                      } else if (value.length > 256) {
                        return 'تاریخچه صحی خیلی طولانی است. لطفاً کمی مختصرش کنید.';
                      }
                      return null;
                    },
                    minLines: 1,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'تاریخچه صحی مریض',
                      suffixIcon: Icon(Icons.note_alt_outlined),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                          borderSide: BorderSide(color: Colors.blue)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                          borderSide: BorderSide(color: Colors.red)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                          borderSide:
                              BorderSide(color: Colors.red, width: 1.5)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            child: const Text('لغو'),
          ),
          ElevatedButton(
              onPressed: () async {
                print('Editing $condID');
                if (_condEditFormKey.currentState!.validate()) {
                  var condText = condNameController.text;
                  final conn = await onConnToDb();
                  final editResults = await conn.query(
                      'UPDATE conditions SET name = ? WHERE cond_ID = ?',
                      [condText, condID]);
                  if (editResults.affectedRows! > 0) {
                    _onShowSnack(
                        Colors.green, 'تاریخچه صحی مریض موفقانه تغییر کرد.');
                    setState(() {});
                  } else {
                    _onShowSnack(Colors.red, 'هیچ تغییراتی نیاورده اید.');
                  }
                  Navigator.of(context, rootNavigator: true).pop();
                  await conn.close();
                }
              },
              child: const Text('تغییر دادن')),
        ],
      ),
    );
  }

  _onDeleteHealthHistory(int condID) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Directionality(
          textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
          child: const Text('حذف تاریخچه صحی مریض'),
        ),
        content: Directionality(
          textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
          child: const Text(
              'آیا مطمیین هستید که میخواهید این تاریخچه صحی را حذف نمایید؟'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
              child: const Text('لغو')),
          ElevatedButton(
            onPressed: () async {
              final conn = await onConnToDb();
              final deleteResults = await conn
                  .query('DELETE FROM conditions WHERE cond_ID = ?', [condID]);
              if (deleteResults.affectedRows! > 0) {
                _onShowSnack(Colors.green, 'تاریخچه صحی موفقانه حذف گردید.');
                setState(() {});
              } else {
                _onShowSnack(Colors.red, 'حذف تاریخچه صحی ناکام شد.');
              }
              Navigator.of(context, rootNavigator: true).pop();
              await conn.close();
            },
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

// Store patients' Health History into condition_details table.
  Future<bool> onAddPatientHistory(int? patientID) async {
    try {
      // Connect to the database
      final conn = await onConnToDb();

      // Start a transaction
      await conn.transaction((ctx) async {
        for (var condID in _condResultGV.keys) {
          try {
            // Prepare an insert query
            var query =
                'INSERT INTO condition_details (cond_ID, result, severty, duration, diagnosis_date, pat_ID, notes) VALUES (?, ?, ?, ?, ?, ?, ?)';
            // Get the selected value ('مثبت' or 'منفی')
            var selectedResult = _condResultGV[condID] == 1 ? 1 : 0;
            var histDate = selectedResult == 1
                ? _histDiagDateController[condID]?.text
                : null;
            var histSeverty =
                selectedResult == 1 ? _histCondGroupValue[condID] : null;
            var histDuration =
                selectedResult == 1 ? _durationGroupValue[condID] : null;
            var histNotes =
                selectedResult == 1 ? _histNoteController[condID]?.text : null;

            await conn.query(query, [
              condID,
              selectedResult.toInt(),
              histSeverty,
              histDuration,
              histDate,
              patientID,
              histNotes
            ]);
          } catch (e) {
            print('Error occured while inserting histories: $e');
          }
        }
      });

      // Close the connection
      await conn.close();
      return true;
    } catch (e) {
      return false;
    }
  }
}

// Data Model Class
class PatientCondition {
  final int condID;
  // ignore: non_constant_identifier_names
  final String CondName;

  // Constructor
  // ignore: non_constant_identifier_names
  PatientCondition({required this.condID, required this.CondName});
}

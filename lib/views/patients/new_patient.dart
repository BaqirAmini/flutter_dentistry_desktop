import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dentistry/config/global_usage.dart';
import 'package:flutter_dentistry/config/language_provider.dart';
import 'package:flutter_dentistry/config/translations.dart';
import 'package:flutter_dentistry/models/db_conn.dart';
import 'package:flutter_dentistry/views/finance/fee/fee_related_fields.dart';
import 'package:flutter_dentistry/views/patients/new_appointment.dart';
import 'package:flutter_dentistry/views/patients/tooth_selection_info.dart';
import 'package:flutter_dentistry/views/services/service_related_fields.dart';
import 'package:flutter_dentistry/views/staff/staff_info.dart';
import 'package:intl/intl.dart' as intl2;
import 'package:provider/provider.dart';

void main() {
  return runApp(const NewPatient());
}

// Assign default selected staff
String? defaultSelectedStaff;
List<Map<String, dynamic>> staffList = [];
int? staffID;
// Set global variables which are needed later.
var selectedLanguage;
var isEnglish;

class NewPatient extends StatefulWidget {
  const NewPatient({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NewPatientState createState() => _NewPatientState();
}

class _NewPatientState extends State<NewPatient> {
  final GlobalKey<ScaffoldMessengerState> _globalKey2 =
      GlobalKey<ScaffoldMessengerState>();

  // Marital Status
  String maritalStatusDD = 'مجرد';
  var items = ['مجرد', 'متأهل'];

  // Blood group types
  String? bloodDropDown = 'نامعلوم';
  var bloodGroupItems = [
    'نامعلوم',
    'A+',
    'B+',
    'AB+',
    'O+',
    'A-',
    'B-',
    'AB-',
    'O-'
  ];

  // Declare a dropdown for ages
  int ageDropDown = 0;
  bool _ageSelected = false;
  int _currentStep = 0;

  final _nameController = TextEditingController();
  final _lNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addrController = TextEditingController();

// Global keys for forms created in this file.
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final _condFormKey = GlobalKey<FormState>();
  final _condEditFormKey = GlobalKey<FormState>();
  final _hisDetFormKey = GlobalKey<FormState>();

  // Radio Buttons
  String _sexGroupValue = 'مرد';
  final Map<int, TextEditingController> _histDiagDateController = {};
  final Map<int, TextEditingController> _histNoteController = {};
  final Map<int, String> _histCondGroupValue = {};
  final Map<int, String> _durationGroupValue = {};
  // Create a Map to store the group values for each condition
  final Map<int, int> _condResultGV = {};

  // Declare a list to contain patients' info
  List<Step> stepList() => [
        Step(
          state: _currentStep <= 0 ? StepState.editing : StepState.complete,
          isActive: _currentStep >= 0,
          title:
              Text(translations[selectedLanguage]?['َPatientPersInfo'] ?? ''),
          content: Center(
            child: Form(
              key: _formKey1,
              child: Column(
                children: [
                  Text(
                    translations[selectedLanguage]?['Step1Msg'] ?? '',
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    child: const Text(
                      '* نشان دهنده فیلد(خانه)های الزامی میباشد.',
                      textAlign: TextAlign.right,
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    '*',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    width: 400.0,
                                    margin: const EdgeInsets.only(
                                        left: 20.0,
                                        right: 10.0,
                                        top: 10.0,
                                        bottom: 10.0),
                                    child: TextFormField(
                                      controller: _nameController,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                          RegExp(GlobalUsage.allowedEPChar),
                                        ),
                                      ],
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return translations[selectedLanguage]
                                              ?['FNRequired'];
                                        } else if (value.length < 3 ||
                                            value.length > 10) {
                                          return translations[selectedLanguage]
                                              ?['FNLength'];
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        labelText:
                                            translations[selectedLanguage]
                                                    ?['FName'] ??
                                                '',
                                        suffixIcon: const Icon(Icons.person),
                                        enabledBorder: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50.0)),
                                            borderSide:
                                                BorderSide(color: Colors.grey)),
                                        focusedBorder: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50.0)),
                                            borderSide:
                                                BorderSide(color: Colors.blue)),
                                        errorBorder: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50.0)),
                                            borderSide:
                                                BorderSide(color: Colors.red)),
                                        focusedErrorBorder:
                                            const OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(50.0)),
                                                borderSide: BorderSide(
                                                    color: Colors.red,
                                                    width: 1.5)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 400.0,
                                margin: const EdgeInsets.only(
                                    left: 20.0,
                                    right: 10.0,
                                    top: 10.0,
                                    bottom: 10.0),
                                child: TextFormField(
                                  controller: _lNameController,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(GlobalUsage.allowedEPChar),
                                    ),
                                  ],
                                  validator: (value) {
                                    if (value!.isNotEmpty) {
                                      if (value.length < 3 ||
                                          value.length > 10) {
                                        return translations[selectedLanguage]
                                            ?['LNLength'];
                                      } else {
                                        return null;
                                      }
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'تخلص',
                                    suffixIcon: Icon(Icons.person),
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
                              Row(
                                children: [
                                  const Text(
                                    '*',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    width: 400.0,
                                    margin: const EdgeInsets.only(
                                        left: 20.0,
                                        right: 10.0,
                                        top: 10.0,
                                        bottom: 10.0),
                                    child: InputDecorator(
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        labelText:
                                            translations[selectedLanguage]
                                                    ?['Age'] ??
                                                '',
                                        enabledBorder: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50.0)),
                                            borderSide:
                                                BorderSide(color: Colors.grey)),
                                        focusedBorder: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50.0)),
                                            borderSide:
                                                BorderSide(color: Colors.blue)),
                                        errorText:
                                            ageDropDown == 0 && !_ageSelected
                                                ? 'Please select an age'
                                                : null,
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(50.0),
                                          ),
                                          borderSide: BorderSide(
                                              color: !_ageSelected
                                                  ? Colors.red
                                                  : Colors.grey),
                                        ),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: SizedBox(
                                          height: 26.0,
                                          child: DropdownButton(
                                            isExpanded: true,
                                            icon: const Icon(
                                                Icons.arrow_drop_down),
                                            value: ageDropDown,
                                            items: <DropdownMenuItem<int>>[
                                              const DropdownMenuItem(
                                                value: 0,
                                                child: Text('No age selected'),
                                              ),
                                              ...getAges().map((int ageItems) {
                                                return DropdownMenuItem(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  value: ageItems,
                                                  child: Directionality(
                                                    textDirection: isEnglish
                                                        ? TextDirection.ltr
                                                        : TextDirection.rtl,
                                                    child: Text(
                                                        '$ageItems ${translations[selectedLanguage]?['Year'] ?? ''} '),
                                                  ),
                                                );
                                              }).toList(),
                                            ],
                                            onChanged: (int? newValue) {
                                              if (newValue != 0) {
                                                // Ignore the 'Please select an age' option
                                                setState(() {
                                                  ageDropDown = newValue!;
                                                  _ageSelected = true;
                                                  ServiceInfo.patAge = newValue;
                                                });
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 400.0,
                                margin: const EdgeInsets.only(
                                    left: 20.0,
                                    right: 10.0,
                                    top: 10.0,
                                    bottom: 10.0),
                                child: InputDecorator(
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 10.0),
                                    border: const OutlineInputBorder(),
                                    labelText: translations[selectedLanguage]
                                        ?['Sex'],
                                    enabledBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(50.0),
                                      ),
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(50.0),
                                      ),
                                      borderSide:
                                          BorderSide(color: Colors.blue),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(
                                        width: 100,
                                        child: Theme(
                                          data: Theme.of(context).copyWith(
                                            listTileTheme:
                                                const ListTileThemeData(
                                                    horizontalTitleGap: 0.5),
                                          ),
                                          child: RadioListTile(
                                              title: const Text(
                                                'مرد',
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              value: 'مرد',
                                              groupValue: _sexGroupValue,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  _sexGroupValue = value!;
                                                });
                                              }),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 100,
                                        child: Theme(
                                          data: Theme.of(context).copyWith(
                                            listTileTheme:
                                                const ListTileThemeData(
                                                    horizontalTitleGap: 0.5),
                                          ),
                                          child: RadioListTile(
                                              title: const Text(
                                                'زن',
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              value: 'زن',
                                              groupValue: _sexGroupValue,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  _sexGroupValue = value!;
                                                });
                                              }),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                width: 400.0,
                                margin: const EdgeInsets.only(
                                    left: 20.0,
                                    right: 10.0,
                                    top: 10.0,
                                    bottom: 10.0),
                                child: InputDecorator(
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    labelText: translations[selectedLanguage]
                                        ?['Marital'],
                                    enabledBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50.0)),
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                    focusedBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50.0)),
                                        borderSide:
                                            BorderSide(color: Colors.blue)),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: SizedBox(
                                      height: 26.0,
                                      child: DropdownButton<String>(
                                        isExpanded: true,
                                        icon: const Icon(Icons.arrow_drop_down),
                                        value: maritalStatusDD,
                                        items: items.map((String items) {
                                          return DropdownMenuItem<String>(
                                            alignment: Alignment.centerRight,
                                            value: items,
                                            child: Text(items),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            maritalStatusDD = newValue!;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 400.0,
                                margin: const EdgeInsets.only(
                                    left: 20.0,
                                    right: 10.0,
                                    top: 10.0,
                                    bottom: 10.0),
                                child: Column(
                                  children: <Widget>[
                                    InputDecorator(
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        labelText:
                                            translations[selectedLanguage]
                                                ?['BloodGroup'],
                                        enabledBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50.0)),
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50.0)),
                                          borderSide:
                                              BorderSide(color: Colors.blue),
                                        ),
                                        errorBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50.0)),
                                          borderSide:
                                              BorderSide(color: Colors.red),
                                        ),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: SizedBox(
                                          height: 26.0,
                                          child: DropdownButton(
                                            // isExpanded: true,
                                            icon: const Icon(
                                                Icons.arrow_drop_down),
                                            value: bloodDropDown,
                                            items: bloodGroupItems
                                                .map((String bloodGroupItems) {
                                              return DropdownMenuItem(
                                                alignment:
                                                    Alignment.centerRight,
                                                value: bloodGroupItems,
                                                child: Text(bloodGroupItems),
                                              );
                                            }).toList(),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                bloodDropDown = newValue;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  const Text('*',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold)),
                                  Container(
                                    width: 400.0,
                                    margin: const EdgeInsets.only(
                                        left: 20.0,
                                        right: 10.0,
                                        top: 10.0,
                                        bottom: 10.0),
                                    child: TextFormField(
                                      textDirection: TextDirection.ltr,
                                      controller: _phoneController,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                          RegExp(GlobalUsage.allowedDigits),
                                        ),
                                      ],
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return translations[selectedLanguage]
                                                  ?['PhoneRequired'] ??
                                              '';
                                        } else if (value.startsWith('07') ||
                                            value.startsWith('۰۷')) {
                                          if (value.length < 10 ||
                                              value.length > 10) {
                                            return translations[
                                                        selectedLanguage]
                                                    ?['Phone10'] ??
                                                '';
                                          }
                                        } else if (value.startsWith('+93') ||
                                            value.startsWith('+۹۳')) {
                                          if (value.length < 12 ||
                                              value.length > 12) {
                                            return translations[
                                                        selectedLanguage]
                                                    ?['Phone12'] ??
                                                '';
                                          }
                                        } else {
                                          return translations[selectedLanguage]
                                                  ?['ValidPhone'] ??
                                              '';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        labelText:
                                            translations[selectedLanguage]
                                                    ?['Phone'] ??
                                                '',
                                        suffixIcon: const Icon(Icons.phone),
                                        enabledBorder: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50.0)),
                                            borderSide:
                                                BorderSide(color: Colors.grey)),
                                        focusedBorder: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50.0)),
                                            borderSide:
                                                BorderSide(color: Colors.blue)),
                                        errorBorder: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50.0)),
                                            borderSide:
                                                BorderSide(color: Colors.red)),
                                        focusedErrorBorder:
                                            const OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(50.0)),
                                                borderSide: BorderSide(
                                                    color: Colors.red,
                                                    width: 1.5)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 400.0,
                                margin: const EdgeInsets.only(
                                    left: 20.0,
                                    right: 10.0,
                                    top: 10.0,
                                    bottom: 10.0),
                                child: TextFormField(
                                  controller: _addrController,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(GlobalUsage.allowedEPChar),
                                    ),
                                  ],
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    labelText: translations[selectedLanguage]
                                            ?['Address'] ??
                                        '',
                                    suffixIcon:
                                        const Icon(Icons.location_on_outlined),
                                    enabledBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50.0)),
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                    focusedBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50.0)),
                                        borderSide:
                                            BorderSide(color: Colors.blue)),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Step(
          state: _currentStep <= 1 ? StepState.editing : StepState.complete,
          isActive: _currentStep >= 1,
          title: const Text('تاریخچه صحی مریض'),
          content: Center(
            child: Form(
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
                              border:
                                  Border.all(color: Colors.blue, width: 2.0),
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
                                  bottom: BorderSide(
                                      width: 0.4, color: Colors.grey),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
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
                                            itemBuilder:
                                                (BuildContext context) =>
                                                    <PopupMenuEntry>[
                                              if (_condResultGV[cond.condID] ==
                                                  1)
                                                PopupMenuItem(
                                                  child: Directionality(
                                                    textDirection:
                                                        TextDirection.rtl,
                                                    child: ListTile(
                                                      leading: const Icon(
                                                          Icons.list),
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
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  child: Builder(builder:
                                                      (BuildContext context) {
                                                    return ListTile(
                                                      leading: const Icon(
                                                          Icons.edit),
                                                      title: const Text(
                                                          'تغییر دادن'),
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
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  child: ListTile(
                                                      leading: const Icon(Icons
                                                          .delete_outline_rounded),
                                                      title: const Text(
                                                          'حذف کردن'),
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
                ],
              ),
            ),
          ),
        ),
        Step(
          state: _currentStep <= 2 ? StepState.editing : StepState.complete,
          isActive: _currentStep >= 2,
          title: const Text('خدمات مورد نیاز'),
          content: ServiceForm(formKey: _formKey2),
        ),
        Step(
          state: _currentStep <= 3 ? StepState.editing : StepState.complete,
          isActive: _currentStep >= 3,
          title: Text(translations[selectedLanguage]?['َServiceFee'] ?? ''),
          content: SizedBox(
            child: Center(
              child: FeeForm(formKey: _formKey3),
            ),
          ),
        ),
      ];

// Store patients' Health History into condition_details table.
  Future<bool> _onAddPatientHistory(int patientID) async {
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

// Add a new patient
  Future<void> onAddNewPatient(BuildContext context) async {
    _onAddPatientHistory(86);
    var firstName = _nameController.text;
    var lastName = _lNameController.text;
    var sex = _sexGroupValue;
    var age = ageDropDown;
    var maritalStatus = maritalStatusDD;
    var phone = _phoneController.text;
    var bGrop = bloodDropDown;
    var addr = _addrController.text;

    var conn = await onConnToDb();
    int? serviceID = ServiceInfo.selectedServiceID;
    // First Check the patient where it already exists
    var queryCheck = await conn
        .query('SELECT pat_ID, phone FROM patients WHERE phone = ?', [phone]);
    if (queryCheck.isNotEmpty) {
      _onShowSnack(
          Colors.red, 'مریض با این نمبر تماس قبلا در سیستم وجود دارد.');
      setState(() {
        _currentStep = 0;
      });
    } else {
      // Firstly insert a patient into patients table
      var insertPatQuery = await conn.query(
          'INSERT INTO patients (staff_ID, firstname, lastname, sex, age, marital_status, phone, blood_group, address) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
          [
            ServiceInfo.selectedDentistID,
            firstName,
            lastName,
            sex,
            age,
            maritalStatus,
            phone,
            bGrop,
            addr
          ]);
// Choose a specific patient to fetch his/here ID
      if (insertPatQuery.affectedRows! > 0) {
        String? meetDate = ServiceInfo.meetingDate;
        String? note = ServiceInfo.serviceNote;
        var fetchPatQuery = await conn.query(
            'SELECT * FROM patients WHERE firstname = ? AND sex = ? AND age = ? AND phone = ?',
            [firstName, sex, age, phone]);
        final row = fetchPatQuery.first;
        final patId = row['pat_ID'];

// Now insert patient health histories into condition_details
        if (await _onAddPatientHistory(patId)) {
          // Now create appointments
          if (await AppointmentFunction.onAddAppointment(
              patId, serviceID!, meetDate!, ServiceInfo.selectedDentistID!)) {
            // Here i fetch apt_ID (appointment ID) which needs to be passed.
            int appointmentID;
            final aptIdResult = await conn.query(
                'SELECT apt_ID FROM appointments WHERE meet_date = ? AND service_ID = ? AND round = ? AND pat_ID = ?',
                [meetDate, serviceID, 1, patId]);

            if (aptIdResult.isNotEmpty) {
              final row = aptIdResult.first;
              appointmentID = row['apt_ID'];
            } else {
              appointmentID = 0;
            }

            if (await AppointmentFunction.onAddServiceReq(
                patId, ServiceInfo.selectedServiceID!, note, appointmentID)) {
              // if it is inserted into the final tables which is fee_payments, it navigates to patients page.
              if (await AppointmentFunction.onAddFeePayment(
                  meetDate, ServiceInfo.selectedDentistID!, appointmentID)) {
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              }
            }
          }
        } else {
          print('Inserting patient health histories failed');
        }
      } else {
        print('Patient registration faield.');
      }
    }
  }

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

  @override
  Widget build(BuildContext context) {
    // Fetch translations keys based on the selected language.
    var languageProvider = Provider.of<LanguageProvider>(context);
    selectedLanguage = languageProvider.selectedLanguage;
    isEnglish = selectedLanguage == 'English';
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ScaffoldMessenger(
        key: _globalKey2,
        child: Directionality(
          textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              leading: Tooltip(
                message: 'رفتن به صفحه قبلی',
                child: IconButton(
                  icon: const BackButtonIcon(),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              title: Text(translations[selectedLanguage]?['PatientReg'] ?? ''),
            ),
            body: Stepper(
              steps: stepList(),
              type: StepperType.horizontal,
              onStepCancel: () {
                setState(() {
                  if (_currentStep > 0) {
                    _currentStep--;
                  }
                });
              },
              currentStep: _currentStep,
              onStepContinue: () {
                _ageSelected = ageDropDown > 0 ? true : false;
                if (_formKey1.currentState!.validate() && _ageSelected) {
                  if (_currentStep < stepList().length - 1) {
                    setState(() {
                      if (_currentStep == 2) {
                        if (_formKey2.currentState!.validate()) {
                          if (ServiceInfo.selectedServiceID == 2) {
                            if (ageDropDown > 13) {
                              if (ServiceInfo.fMaterialSelected &&
                                  Tooth.adultToothSelected) {
                                _currentStep++;
                              }
                            } else {
                              if (ServiceInfo.fMaterialSelected &&
                                  Tooth.childToothSelected) {
                                _currentStep++;
                              }
                            }
                          } else if (ServiceInfo.selectedServiceID == 1) {
                            if (ageDropDown > 13) {
                              if (Tooth.adultToothSelected) {
                                _currentStep++;
                              }
                            } else {
                              if (Tooth.childToothSelected) {
                                _currentStep++;
                              }
                            }
                          } else if (ServiceInfo.selectedServiceID == 3) {
                            if (ServiceInfo.levelSelected) {
                              _currentStep++;
                            }
                          } else if (ServiceInfo.selectedServiceID == 5) {
                            if (ServiceInfo.defaultOrthoType != null) {
                              _currentStep++;
                            }
                          } else if (ServiceInfo.selectedServiceID == 7) {
                            if (ServiceInfo.defaultMaxillo != null) {
                              if (ServiceInfo.defaultMaxillo ==
                                      'Tooth Extraction' ||
                                  ServiceInfo.defaultMaxillo ==
                                      'Tooth Reimplantation' ||
                                  ServiceInfo.defaultMaxillo ==
                                      'Abscess Treatment') {
                                if (ageDropDown > 13) {
                                  if (Tooth.adultToothSelected) {
                                    _currentStep++;
                                  }
                                } else {
                                  if (Tooth.childToothSelected) {
                                    _currentStep++;
                                  }
                                }
                              } else {
                                _currentStep++;
                              }
                            }
                          } else if (ServiceInfo.selectedServiceID == 9) {
                            if (ServiceInfo.dentureGroupValue == 'Partial') {
                              if (ageDropDown > 13) {
                                if (Tooth.adultToothSelected) {
                                  setState(() {
                                    _currentStep++;
                                  });
                                }
                              } else {
                                if (Tooth.childToothSelected) {
                                  setState(() {
                                    _currentStep++;
                                  });
                                }
                              }
                            } else {
                              if (ServiceInfo.defaultDentureValue != null &&
                                  ServiceInfo.defaultDentureValue
                                      .toString()
                                      .isNotEmpty) {
                                setState(() {
                                  _currentStep++;
                                });
                              }
                            }
                          } else if (ServiceInfo.selectedServiceID == 11 &&
                              ServiceInfo.defaultCrown != null) {
                            if (ageDropDown > 13) {
                              if (Tooth.adultToothSelected) {
                                _currentStep++;
                              }
                            } else {
                              if (Tooth.childToothSelected) {
                                _currentStep++;
                              }
                            }
                          } else if (ServiceInfo.selectedServiceID == 15) {
                            if (ageDropDown > 13) {
                              if (Tooth.adultToothSelected) {
                                _currentStep++;
                              }
                            } else {
                              if (Tooth.childToothSelected) {
                                _currentStep++;
                              }
                            }
                          } else {
                            _currentStep++;
                          }
                        }
                      } else {
                        _currentStep++;
                      }
                    });
                  } else {
                    if (_formKey3.currentState!.validate()) {
                      onAddNewPatient(context);
                    }
                  }
                }
              },
              controlsBuilder: (BuildContext context, ControlsDetails details) {
                return Row(
                  children: [
                    TextButton(
                      onPressed:
                          _currentStep == 0 ? null : details.onStepCancel,
                      child: Text(
                          translations[selectedLanguage]?['PrevBtn'] ?? ''),
                    ),
                    ElevatedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        side: const BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      onPressed: details.onStepContinue,
                      child: Text(_currentStep == stepList().length - 1
                          ? (translations[selectedLanguage]?['AddBtn'] ?? '')
                          : translations[selectedLanguage]?['NextBtn'] ?? ''),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // Declare a method to add ages 1 - 100
  List<int> getAges() {
    // Declare variables to contain from 1 - 100 for ages
    List<int> ages = [];
    for (int a = 1; a <= 100; a++) {
      ages.add(a);
    }
    return ages;
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

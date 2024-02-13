import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dentistry/config/global_usage.dart';
import 'package:flutter_dentistry/config/language_provider.dart';
import 'package:flutter_dentistry/config/translations.dart';
import 'package:flutter_dentistry/models/db_conn.dart';
import 'package:flutter_dentistry/views/finance/fee/fee_related_fields.dart';
import 'package:flutter_dentistry/views/patients/health_histories.dart';
import 'package:flutter_dentistry/views/patients/new_appointment.dart';
import 'package:flutter_dentistry/views/patients/patient_info.dart';
import 'package:flutter_dentistry/views/patients/tooth_selection_info.dart';
import 'package:flutter_dentistry/views/services/service_related_fields.dart';
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

  // Radio Buttons
  String _sexGroupValue = 'مرد';

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
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: const Center(
              child: HealthHistories(),
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

  HealthHistoriesState healthHistory = HealthHistoriesState();
// Add a new patient
  Future<void> onAddNewPatient(BuildContext context) async {
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
        if (await healthHistory.onAddPatientHistory(patId)) {
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
                  // Assign false value to not show the button for this page
                  PatientInfo.showElevatedBtn = false;
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
      theme: ThemeData(useMaterial3: false),
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

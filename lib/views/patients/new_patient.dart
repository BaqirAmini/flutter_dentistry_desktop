// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dentistry/config/language_provider.dart';
import 'package:flutter_dentistry/config/translations.dart';
import 'package:flutter_dentistry/models/db_conn.dart';
import 'package:flutter_dentistry/views/patients/adult_coordinate_system.dart';
import 'package:flutter_dentistry/views/patients/child_coordinate_system.dart';
import 'package:flutter_dentistry/views/staff/staff_info.dart';
import 'package:intl/intl.dart' as intl2;
import 'package:provider/provider.dart';

void main() {
  return runApp(const NewPatient());
}

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

  String? selectedTooth2;
  var selectedRemovableTooth;
  String removedTooth = 'عقل دندان';

  /*----------------------- Note #1: In fact the below variables contain service_details.ser_det_ID  ------------------*/
  // For Filling
  int selectedFill = 1;
  // For Bleaching
  int selectedServiceDetailID = 4;
// For prothesis
  int selectedProthis = 8;
  // For teeth cover
  int selectedMaterial = 10;
// For mouth test
  int mouthTest = 15;
  /*----------------------- End of Note #1  Do not get confused of variables name (They are ser_det_ID values) ------------------*/
  // ِDeclare variables for gender dropdown
  String genderDropDown = 'مرد';
  var genderItems = ['مرد', 'زن'];

  // Blood group types
  String? bloodDropDown;
  var bloodGroupItems = ['A+', 'B+', 'AB+', 'O+', 'A-', 'B-', 'AB-', 'O-'];

  //  پوش کردن دندان
  String? defaultCrown = 'Please select a material';
  List<String> crownItems = [
    'Please select a material',
    'Porcelain',
    'Metal-Porcelain',
    'CAD CAM',
    'Zirconia',
    'Mital',
    'Gold',
    'سایر'
  ];

  //  پرکاری دندان
  String? defaultFilling = 'Please select a material';
  List<String> fillingItems = [
    'Please select a material',
    'Amalgam',
    'Silicate',
    'Composite',
    'G.C (Glass Inomir)',
    'سایر',
  ];

  // ارتودانسی
  String defaultOrthoType = 'Please select a gum';
  List<String> orthoItems = [
    'Please select a gum',
    'فک بالا',
    'فک پایین',
    'هردو فک',
    'بستن دیاستم وسطی'
  ];

// MaxilloFacial وجه فک
  String defaultMaxillo = 'Please select a type';
  List<String> maxilloItems = [
    'Please select a type',
    'Tooth Extraction',
    'Abscess Treatment',
    'T.M.J',
    'Tooth Reimplantation',
    'Jaw Fracture Fixation'
  ];

// Gum selection for Abscess treatment
  String defaultGumAbscess = 'Please select a gum';
  List<String> abscessItems = [
    'Please select a gum',
    'فک بالا',
    'فک پایین',
    'هردو'
  ];

  // Bleaching
  String _defaultBleachValue = 'Please select a level';
  final List<String> _bleachingItems = [
    'Please select a level',
    'یک مرحله',
    'دو مرحله',
    'سه مرحله'
  ];

  // Select gums for Denture
  String _defaultDentureValue = 'Please select a gum';
  final List<String> _dentureItems = [
    'Please select a gum',
    'فک بالا',
    'فک پایین',
    'هردو'
  ];

  String? selectedSerId;
  List<Map<String, dynamic>> services = [];

  // Abscess affected area
  String defaultGumArea = 'Please select gum area';
  List<String> gumAreaItems = ['Please select gum area', 'راست', 'چپ', 'هردو'];

  @override
  void initState() {
    super.initState();
    fetchServices();
    onChooseGum2();
    fetchToothNum();
    chooseGumType1();
    fetchProtheses();
    fetchRemoveTooth();
  }

  Future<void> fetchServices() async {
    var conn = await onConnToDb();
    var queryService =
        await conn.query('SELECT ser_ID, ser_name FROM services WHERE ser_ID');
    setState(() {
      services = queryService
          .map((result) =>
              {'ser_ID': result[0].toString(), 'ser_name': result[1]})
          .toList();
    });
    selectedSerId = services.isNotEmpty ? services[0]['ser_ID'] : null;
    await conn.close();
  }

  // Declare a dropdown for ages
  int ageDropDown = 1;

  // Declare a variable for gum surgery
  int gumSurgeryDropDown = 1;

  // Declare a variable for teeth numbers
  int teethNumbers = 1;

  // Declare a variable for payment installment
  String payTypeDropdown = 'تکمیل';

  int _currentStep = 0;

  final _nameController = TextEditingController();
  final _lNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addrController = TextEditingController();
  final _totalExpController = TextEditingController();
  final _recievableController = TextEditingController();
  final _meetController = TextEditingController();
  final _noteController = TextEditingController();
  final _regExOnlyAbc = "[a-zA-Z,، \u0600-\u06FFF]";
  final _regExOnlydigits = "[0-9+]";
  final _regExDecimal = "[0-9.]";

  bool _isVisibleForFilling = true;
  bool _isVisibleForBleaching = false;
  bool _isVisibleForScaling = false;
  bool _isVisibleForOrtho = false;
  bool _isVisibleForProthesis = false;
  bool _isVisibleForRoot = false;
  bool _isVisibleGum = false;
  bool _isVisibleForTeethRemove = false;
  bool _isVisibleForCover = false;
  bool _isVisibleMouth = false;
  bool _isVisibleForPayment = false;
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final _condFormKey = GlobalKey<FormState>();
  final _condEditFormKey = GlobalKey<FormState>();
  final _hisDetFormKey = GlobalKey<FormState>();

  // Radio Buttons
  String _crownGroupValue = 'R.C.T';
  String _fillingGroupValue = 'R.C.T';
  String _abscessTreatValue = 'راست';
  String _tmgGroupValue = 'راست';
  String _sexGroupValue = 'مرد';
  String _spGroupValue = 'Scaling';
  String _dentureGroupValue = 'Full';
  String _histCondGroupValue = 'نا معلوم';
  // Create a Map to store the group values for each condition
  final Map<int, int> _condResultGV = {};

  /* ---------------- variable to get assigned values based on services types dropdown */

  /* ----------------END variable to get assigned values based on services types dropdown */

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
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
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
                                    right: 20.0,
                                    top: 10.0,
                                    bottom: 10.0),
                                child: TextFormField(
                                  controller: _nameController,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(_regExOnlyAbc),
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
                                    labelText: translations[selectedLanguage]
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
                                                color: Colors.red, width: 1.5)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 400.0,
                            margin: const EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                                top: 10.0,
                                bottom: 10.0),
                            child: TextFormField(
                              controller: _lNameController,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(_regExOnlyAbc),
                                ),
                              ],
                              validator: (value) {
                                if (value!.isNotEmpty) {
                                  if (value.length < 3 || value.length > 10) {
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
                            ),
                          ),
                          Container(
                            width: 400.0,
                            margin: const EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                                top: 10.0,
                                bottom: 10.0),
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'سن',
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
                                  child: DropdownButton(
                                    isExpanded: true,
                                    icon: const Icon(Icons.arrow_drop_down),
                                    value: ageDropDown,
                                    items: getAges().map((int ageItems) {
                                      return DropdownMenuItem(
                                        alignment: Alignment.centerRight,
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
                                    onChanged: (int? newValue) {
                                      setState(() {
                                        ageDropDown = newValue!;
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
                                right: 20.0,
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
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: const OutlineInputBorder(
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
                                  Expanded(
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                        listTileTheme: const ListTileThemeData(
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
                                right: 20.0,
                                top: 10.0,
                                bottom: 10.0),
                            child: InputDecorator(
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: translations[selectedLanguage]
                                    ?['Marital'],
                                enabledBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50.0)),
                                    borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: const OutlineInputBorder(
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
                                right: 20.0,
                                top: 10.0,
                                bottom: 10.0),
                            child: Column(
                              children: <Widget>[
                                InputDecorator(
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    labelText: translations[selectedLanguage]
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
                                      borderSide: BorderSide(color: Colors.red),
                                    ),
                                    errorText: bloodDropDown == null ||
                                            bloodDropDown!.isEmpty
                                        ? 'Please select a blood group'
                                        : null,
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: SizedBox(
                                      height: 26.0,
                                      child: DropdownButton(
                                        // isExpanded: true,
                                        icon: const Icon(Icons.arrow_drop_down),
                                        value: bloodDropDown,
                                        items: bloodGroupItems
                                            .map((String bloodGroupItems) {
                                          return DropdownMenuItem(
                                            alignment: Alignment.centerRight,
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
                                    right: 20.0,
                                    top: 10.0,
                                    bottom: 10.0),
                                child: TextFormField(
                                  textDirection: TextDirection.ltr,
                                  controller: _phoneController,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(_regExOnlydigits),
                                    ),
                                  ],
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return translations[selectedLanguage]
                                              ?['PhoneRequired'] ??
                                          '';
                                    } else if (value.startsWith('07')) {
                                      if (value.length < 10 ||
                                          value.length > 10) {
                                        return translations[selectedLanguage]
                                                ?['Phone10'] ??
                                            '';
                                      }
                                    } else if (value.startsWith('+93')) {
                                      if (value.length < 12 ||
                                          value.length > 12) {
                                        return translations[selectedLanguage]
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
                                    labelText: translations[selectedLanguage]
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
                                                color: Colors.red, width: 1.5)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 400.0,
                            margin: const EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                                top: 10.0,
                                bottom: 10.0),
                            child: TextFormField(
                              controller: _addrController,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(_regExOnlyAbc),
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50.0)),
                                    borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50.0)),
                                    borderSide: BorderSide(color: Colors.blue)),
                              ),
                            ),
                          ),
                        ],
                      )
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
                      InkWell(
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
                            Row(
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
                                            PopupMenuItem(
                                              child: Directionality(
                                                textDirection:
                                                    TextDirection.rtl,
                                                child: ListTile(
                                                  leading:
                                                      const Icon(Icons.list),
                                                  title: const Text(
                                                      'شرح بیشتر تاریخچه'),
                                                  onTap: () {
                                                    _onAddMoreDetailsforHistory();
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
                                                    leading:
                                                        const Icon(Icons.edit),
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
                                                    title:
                                                        const Text('حذف کردن'),
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
                          );
                        }
                        // Return a Column with all the widgets
                        return Container(
                          height: 400,
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
          content: SizedBox(
            child: Center(
              child: Form(
                key: _formKey2,
                child: Column(
                  children: [
                    const Text(
                        'لطفاً اوضاع عمومی مریض را با دقت ارزیابی نموده و طبق خدمات را به پیش ببرید'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 400.0,
                              margin: const EdgeInsets.only(
                                  left: 20.0,
                                  right: 20.0,
                                  top: 10.0,
                                  bottom: 10.0),
                              child: TextFormField(
                                controller: _meetController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'لطفا تاریخ مراجعه مریض را انتخاب کنید.';
                                  }
                                  return null;
                                },
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
                                    _meetController.text = formattedDate;
                                  }
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9.]'))
                                ],
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'تاریخ اولین مراجعه',
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
                              width: 400.0,
                              margin: const EdgeInsets.only(
                                  left: 20.0,
                                  right: 20.0,
                                  top: 10.0,
                                  bottom: 10.0),
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'نوعیت خدمات',
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
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: SizedBox(
                                    height: 26.0,
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      icon: const Icon(Icons.arrow_drop_down),
                                      value: selectedSerId,
                                      items: services.map((service) {
                                        return DropdownMenuItem<String>(
                                          value: service['ser_ID'],
                                          alignment: Alignment.centerRight,
                                          child: Text(service['ser_name']),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedSerId = newValue;
                                          if (selectedSerId == '2') {
                                            _isVisibleForFilling = true;
                                            _isVisibleForBleaching = false;
                                            _isVisibleForScaling = false;
                                            _isVisibleForOrtho = false;
                                            _isVisibleForProthesis = false;
                                            _isVisibleForTeethRemove = false;
                                            _isVisibleForCover = false;
                                            _isVisibleGum = false;
                                            _isVisibleForRoot = false;
                                            _isVisibleMouth = false;
                                          } else if (selectedSerId == '3') {
                                            _isVisibleForFilling = false;
                                            _isVisibleForBleaching = true;
                                            _isVisibleForProthesis = false;
                                            _isVisibleForScaling = false;
                                            _isVisibleForTeethRemove = false;
                                            _isVisibleForCover = false;
                                            _isVisibleGum = false;
                                            _isVisibleForOrtho = false;
                                            _isVisibleForRoot = false;
                                            _isVisibleMouth = false;
                                          } else if (selectedSerId == '4') {
                                            _isVisibleForScaling = true;
                                            _isVisibleForFilling = false;
                                            _isVisibleForBleaching = false;
                                            _isVisibleForProthesis = false;
                                            _isVisibleForTeethRemove = false;
                                            _isVisibleForCover = false;
                                            _isVisibleForOrtho = false;
                                            _isVisibleGum = false;
                                            _isVisibleForRoot = false;
                                            _isVisibleMouth = false;
                                            // Set the first dropdown value to avoid conflict
                                            selectedGumType1 = '3';
                                          } else if (selectedSerId == '5') {
                                            _isVisibleForOrtho = true;
                                            _isVisibleForFilling = false;
                                            _isVisibleForBleaching = false;
                                            _isVisibleForScaling = false;
                                            _isVisibleForProthesis = false;
                                            _isVisibleGum = false;
                                            _isVisibleForTeethRemove = false;
                                            _isVisibleForCover = false;
                                            _isVisibleForRoot = false;
                                            _isVisibleMouth = false;
                                          } else if (selectedSerId == '9') {
                                            _isVisibleForProthesis = true;
                                            _isVisibleForOrtho = false;
                                            _isVisibleForFilling = false;
                                            _isVisibleForBleaching = false;
                                            _isVisibleForScaling = false;
                                            _isVisibleGum = false;
                                            _isVisibleForTeethRemove = false;
                                            _isVisibleForCover = false;
                                            _isVisibleForRoot = false;
                                            _isVisibleMouth = false;
                                            // Set selected tooth '1'
                                            selectedTooth2 = '1';
                                          } else if (selectedSerId == '6') {
                                            _isVisibleForRoot = true;
                                            _isVisibleForProthesis = false;
                                            _isVisibleForOrtho = false;
                                            _isVisibleForFilling = false;
                                            _isVisibleForBleaching = false;
                                            _isVisibleForScaling = false;
                                            _isVisibleGum = false;
                                            _isVisibleForTeethRemove = false;
                                            _isVisibleForCover = false;
                                            _isVisibleMouth = false;
                                            // Set selected tooth '1'
                                            selectedTooth2 = '1';
                                          } else if (selectedSerId == '7') {
                                            _isVisibleGum = true;
                                            _isVisibleForProthesis = false;
                                            _isVisibleForOrtho = false;
                                            _isVisibleForFilling = false;
                                            _isVisibleForBleaching = false;
                                            _isVisibleForScaling = false;
                                            _isVisibleForRoot = false;
                                            _isVisibleForTeethRemove = false;
                                            _isVisibleForCover = false;
                                            _isVisibleMouth = false;
                                            selectedGumType1 = '3';
                                          } else if (selectedSerId == '8') {
                                            _isVisibleMouth = true;
                                            _isVisibleForProthesis = false;
                                            _isVisibleForOrtho = false;
                                            _isVisibleForFilling = false;
                                            _isVisibleForBleaching = false;
                                            _isVisibleForScaling = false;
                                            _isVisibleForRoot = false;
                                            _isVisibleGum = false;
                                            _isVisibleForTeethRemove = false;
                                            _isVisibleForCover = false;
                                          } else if (selectedSerId == '10') {
                                            _isVisibleForTeethRemove = true;
                                            _isVisibleForProthesis = false;
                                            _isVisibleForOrtho = false;
                                            _isVisibleForFilling = false;
                                            _isVisibleForBleaching = false;
                                            _isVisibleForScaling = false;
                                            _isVisibleForRoot = false;
                                            _isVisibleGum = false;
                                            _isVisibleForCover = false;
                                            _isVisibleMouth = false;
                                          } else if (selectedSerId == '11') {
                                            _isVisibleForCover = true;
                                            _isVisibleForProthesis = false;
                                            _isVisibleForOrtho = false;
                                            _isVisibleForFilling = false;
                                            _isVisibleForBleaching = false;
                                            _isVisibleForScaling = false;
                                            _isVisibleForRoot = false;
                                            _isVisibleGum = false;
                                            _isVisibleForTeethRemove = false;
                                            _isVisibleMouth = false;
                                            // Set selected tooth '1'
                                            selectedTooth2 = '1';
                                          } else {
                                            _isVisibleForProthesis = false;
                                            _isVisibleForOrtho = false;
                                            _isVisibleForFilling = false;
                                            _isVisibleForBleaching = false;
                                            _isVisibleForScaling = false;
                                            _isVisibleForRoot = false;
                                            _isVisibleMouth = false;
                                            _isVisibleGum = false;
                                            _isVisibleForTeethRemove = false;
                                            _isVisibleForCover = false;
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: (selectedSerId == '11') ? true : false,
                              child: Container(
                                width: 400.0,
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
                                    labelText: 'نوعیت',
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
                                                'R.C.T',
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              value: 'R.C.T',
                                              groupValue: _crownGroupValue,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  _crownGroupValue = value!;
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
                                                'Vital',
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              value: 'Vital',
                                              groupValue: _crownGroupValue,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  _crownGroupValue = value!;
                                                });
                                              }),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: (selectedSerId == '2') ? true : false,
                              child: Container(
                                margin: const EdgeInsets.only(
                                    left: 20.0,
                                    right: 20.0,
                                    top: 10.0,
                                    bottom: 10.0),
                                width: 400.0,
                                child: InputDecorator(
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 10.0),
                                    border: OutlineInputBorder(),
                                    labelText: 'نوعیت',
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
                                                'R.C.T',
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              value: 'R.C.T',
                                              groupValue: _fillingGroupValue,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  _fillingGroupValue = value!;
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
                                                'Operative',
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              value: 'Operative',
                                              groupValue: _fillingGroupValue,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  _fillingGroupValue = value!;
                                                });
                                              }),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: _isVisibleForTeethRemove,
                              child: Container(
                                width: 400.0,
                                margin: const EdgeInsets.only(
                                    left: 20.0,
                                    right: 20.0,
                                    top: 10.0,
                                    bottom: 10.0),
                                child: InputDecorator(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'نوعیت دندان',
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
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: SizedBox(
                                      height: 26.0,
                                      child: DropdownButton(
                                        isExpanded: true,
                                        icon: const Icon(Icons.arrow_drop_down),
                                        value: removeTeeth.any((tooth) =>
                                                tooth['td_ID'].toString() ==
                                                selectedTooth)
                                            ? selectedTooth
                                            : null,
                                        items: removeTeeth.map((tooth) {
                                          return DropdownMenuItem<String>(
                                            value: tooth['td_ID'].toString(),
                                            alignment: Alignment.centerRight,
                                            child: Text(tooth['tooth']),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            selectedTooth = newValue;
                                            selectedRemovableTooth =
                                                removeTeeth.firstWhere(
                                              (tooth) =>
                                                  tooth['td_ID'].toString() ==
                                                  newValue,
                                            );
                                            // Fetch type the teeth which will be removed (پوسیده، عقل دندان..)
                                            removedTooth =
                                                selectedRemovableTooth != null
                                                    ? selectedRemovableTooth[
                                                        'tooth']
                                                    : null;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: (defaultMaxillo == 'Abscess Treatment')
                                  ? true
                                  : false,
                              child: Container(
                                width: 400.0,
                                margin: const EdgeInsets.only(
                                    left: 20.0,
                                    right: 20.0,
                                    top: 10.0,
                                    bottom: 10.0),
                                child: InputDecorator(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'انتخاب فک',
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
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: SizedBox(
                                      height: 26.0,
                                      child: DropdownButton(
                                        isExpanded: true,
                                        icon: const Icon(Icons.arrow_drop_down),
                                        value: defaultGumAbscess,
                                        items: abscessItems.map((item) {
                                          return DropdownMenuItem<String>(
                                            value: item,
                                            alignment: Alignment.centerRight,
                                            child: Text(item),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            defaultGumAbscess = newValue!;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            /* Visibility(
                              visible: _isVisibleForFilling
                                  ? _isVisibleForFilling
                                  : _isVisibleForBleaching
                                      ? _isVisibleForBleaching
                                      : _isVisibleForProthesis
                                          ? _isVisibleForProthesis
                                          : _isVisibleForRoot
                                              ? _isVisibleForRoot
                                              : _isVisibleForTeethRemove
                                                  ? _isVisibleForTeethRemove
                                                  : _isVisibleForCover
                                                      ? _isVisibleForCover
                                                      : false,
                              child: Container(
                                width: 400.0,
                                margin: const EdgeInsets.only(
                                    left: 20.0,
                                    right: 20.0,
                                    top: 10.0,
                                    bottom: 10.0),
                                child: InputDecorator(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'فک / لثه',
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
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: SizedBox(
                                      height: 26.0,
                                      child: DropdownButton<String>(
                                        isExpanded: true,
                                        icon: const Icon(Icons.arrow_drop_down),
                                        value: selectedGumType2,
                                        items: gums.map((gums) {
                                          return DropdownMenuItem<String>(
                                            value: gums['teeth_ID'],
                                            alignment: Alignment.centerRight,
                                            child: Text(gums['gum']),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            selectedGumType2 = newValue;
                                            print('Gum: $selectedGumType2');
                                            if (selectedSerId == '10') {
                                              // Set this value since by changing لثه / فک below it, it should fetch the default selected value.
                                              removedTooth = 'عقل دندان';
                                              fetchRemoveTooth();
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
 */
                          ],
                        ),
                        Column(
                          children: [
                            Visibility(
                              visible: _isVisibleForCover,
                              child: Container(
                                width: 400.0,
                                margin: const EdgeInsets.only(
                                    left: 20.0,
                                    right: 20.0,
                                    top: 10.0,
                                    bottom: 10.0),
                                child: InputDecorator(
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    labelText: 'نوعیت مواد پوش',
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
                                        Radius.circular(50),
                                      ),
                                      borderSide: BorderSide(color: Colors.red),
                                    ),
                                    errorText: defaultCrown == null ||
                                            defaultCrown ==
                                                'Please select a material'
                                        ? 'Please select a material'
                                        : null,
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: SizedBox(
                                      height: 26.0,
                                      child: DropdownButton(
                                        isExpanded: true,
                                        icon: const Icon(Icons.arrow_drop_down),
                                        value: defaultCrown,
                                        items: crownItems.map((String items) {
                                          return DropdownMenuItem<String>(
                                            value: items,
                                            alignment: Alignment.centerRight,
                                            child: Text(items),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            defaultCrown = newValue;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: (selectedSerId == '9') ? true : false,
                              child: Container(
                                width: 400.0,
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
                                    labelText: 'نوعیت دینچر',
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(50.0),
                                      ),
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(50.0),
                                      ),
                                      borderSide:
                                          BorderSide(color: Colors.blue),
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
                                                'Full',
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              value: 'Full',
                                              groupValue: _dentureGroupValue,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  _dentureGroupValue = value!;
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
                                                'Partial',
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              value: 'Partial',
                                              groupValue: _dentureGroupValue,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  _dentureGroupValue = value!;
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
                                                'C.C Plate',
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              value: 'C.C Plate',
                                              groupValue: _dentureGroupValue,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  _dentureGroupValue = value!;
                                                });
                                              }),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              // ignore: unrelated_type_equality_checks
                              visible: (selectedSerId == '9' &&
                                      (_dentureGroupValue == 'Full' ||
                                          _dentureGroupValue == 'C.C Plate'))
                                  ? true
                                  : false,
                              child: Container(
                                width: 400.0,
                                margin: const EdgeInsets.only(
                                    left: 20.0,
                                    right: 20.0,
                                    top: 10.0,
                                    bottom: 10.0),
                                child: InputDecorator(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'انتخاب فک',
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
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: SizedBox(
                                      height: 26.0,
                                      child: DropdownButton<String>(
                                        isExpanded: true,
                                        icon: const Icon(Icons.arrow_drop_down),
                                        value: _defaultDentureValue,
                                        items: _dentureItems.map((String item) {
                                          return DropdownMenuItem<String>(
                                            alignment: Alignment.centerRight,
                                            value: item,
                                            child: Directionality(
                                              textDirection: isEnglish
                                                  ? TextDirection.ltr
                                                  : TextDirection.rtl,
                                              child: Text(item),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            defaultOrthoType = newValue!;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              // ignore: unrelated_type_equality_checks
                              visible: (selectedSerId == '2') ? true : false,
                              child: Container(
                                width: 400.0,
                                margin: const EdgeInsets.only(
                                    left: 20.0,
                                    right: 20.0,
                                    top: 10.0,
                                    bottom: 10.0),
                                child: InputDecorator(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'نوعیت مواد',
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
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: SizedBox(
                                      height: 26.0,
                                      child: DropdownButton<String>(
                                        isExpanded: true,
                                        icon: const Icon(Icons.arrow_drop_down),
                                        value: defaultFilling,
                                        items: fillingItems.map((String item) {
                                          return DropdownMenuItem<String>(
                                            alignment: Alignment.centerRight,
                                            value: item,
                                            child: Directionality(
                                              textDirection: isEnglish
                                                  ? TextDirection.ltr
                                                  : TextDirection.rtl,
                                              child: Text(item),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            defaultFilling = newValue!;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              // ignore: unrelated_type_equality_checks
                              visible: (selectedSerId == '5') ? true : false,
                              child: Container(
                                width: 400.0,
                                margin: const EdgeInsets.only(
                                    left: 20.0,
                                    right: 20.0,
                                    top: 10.0,
                                    bottom: 10.0),
                                child: InputDecorator(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'نوعیت ارتودانسی',
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
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: SizedBox(
                                      height: 26.0,
                                      child: DropdownButton<String>(
                                        isExpanded: true,
                                        icon: const Icon(Icons.arrow_drop_down),
                                        value: defaultOrthoType,
                                        items: orthoItems.map((String item) {
                                          return DropdownMenuItem<String>(
                                            alignment: Alignment.centerRight,
                                            value: item,
                                            child: Directionality(
                                              textDirection: isEnglish
                                                  ? TextDirection.ltr
                                                  : TextDirection.rtl,
                                              child: Text(item),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            defaultOrthoType = newValue!;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              // ignore: unrelated_type_equality_checks
                              visible: (selectedSerId == '7') ? true : false,
                              child: Container(
                                width: 400.0,
                                margin: const EdgeInsets.only(
                                    left: 20.0,
                                    right: 20.0,
                                    top: 10.0,
                                    bottom: 10.0),
                                child: InputDecorator(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'نوعیت',
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
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: SizedBox(
                                      height: 26.0,
                                      child: DropdownButton<String>(
                                        isExpanded: true,
                                        icon: const Icon(Icons.arrow_drop_down),
                                        value: defaultMaxillo,
                                        items: maxilloItems.map((String item) {
                                          return DropdownMenuItem<String>(
                                            alignment: Alignment.centerRight,
                                            value: item,
                                            child: Directionality(
                                              textDirection: isEnglish
                                                  ? TextDirection.ltr
                                                  : TextDirection.rtl,
                                              child: Text(item),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            defaultMaxillo = newValue!;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: (defaultMaxillo == 'Abscess Treatment')
                                  ? true
                                  : false,
                              child: Container(
                                width: 400.0,
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
                                    labelText: 'ناحیه آبسه',
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(50.0),
                                      ),
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(50.0),
                                      ),
                                      borderSide:
                                          BorderSide(color: Colors.blue),
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
                                                'راست',
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              value: 'راست',
                                              groupValue: _abscessTreatValue,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  _abscessTreatValue = value!;
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
                                                'چپ',
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              value: 'چپ',
                                              groupValue: _abscessTreatValue,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  _abscessTreatValue = value!;
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
                                                'هردو',
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              value: 'هردو',
                                              groupValue: _abscessTreatValue,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  _abscessTreatValue = value!;
                                                });
                                              }),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: (defaultMaxillo == 'T.M.J' &&
                                      selectedSerId == '7')
                                  ? true
                                  : false,
                              child: Container(
                                width: 400.0,
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
                                    labelText: 'ناحیه',
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(50.0),
                                      ),
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(50.0),
                                      ),
                                      borderSide:
                                          BorderSide(color: Colors.blue),
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
                                                'راست',
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              value: 'راست',
                                              groupValue: _tmgGroupValue,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  _tmgGroupValue = value!;
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
                                                'چپ',
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              value: 'چپ',
                                              groupValue: _tmgGroupValue,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  _tmgGroupValue = value!;
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
                                                'هردو',
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              value: 'هردو',
                                              groupValue: _tmgGroupValue,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  _tmgGroupValue = value!;
                                                });
                                              }),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: (selectedSerId == '4') ? true : false,
                              child: Container(
                                width: 400.0,
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
                                    labelText: 'نوعیت اجرا',
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(50.0),
                                      ),
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(50.0),
                                      ),
                                      borderSide:
                                          BorderSide(color: Colors.blue),
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
                                                'Scaling',
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              value: 'Scaling',
                                              groupValue: _spGroupValue,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  _spGroupValue = value!;
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
                                                'Polishing',
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              value: 'Polishing',
                                              groupValue: _spGroupValue,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  _spGroupValue = value!;
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
                                                'Both',
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              value: 'Both',
                                              groupValue: _spGroupValue,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  _spGroupValue = value!;
                                                });
                                              }),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: _isVisibleForBleaching,
                              child: Container(
                                width: 400.0,
                                margin: const EdgeInsets.only(
                                    left: 20.0,
                                    right: 20.0,
                                    top: 10.0,
                                    bottom: 10.0),
                                child: InputDecorator(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'نوعیت سفید کردن دندانها',
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
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: SizedBox(
                                      height: 26.0,
                                      child: DropdownButton(
                                        isExpanded: true,
                                        icon: const Icon(Icons.arrow_drop_down),
                                        value: _defaultBleachValue,
                                        items: _bleachingItems.map((item) {
                                          return DropdownMenuItem<String>(
                                            value: item,
                                            alignment: Alignment.centerRight,
                                            child: Text(item),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            _defaultBleachValue = newValue!;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: true,
                              child: Container(
                                width: 400.0,
                                margin: const EdgeInsets.only(
                                    left: 20.0,
                                    right: 20.0,
                                    top: 10.0,
                                    bottom: 10.0),
                                child: TextFormField(
                                  controller: _noteController,
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
                                      RegExp(_regExOnlyAbc),
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
                            ),
                          ],
                        ),
                      ],
                    ),
                    Visibility(
                      visible: (selectedSerId == '1' ||
                              selectedSerId == '2' ||
                              selectedSerId == '11' ||
                              selectedSerId == '15' ||
                              defaultMaxillo == 'Tooth Extraction' ||
                              defaultMaxillo == 'Tooth Reimplantation' ||
                              (selectedSerId == '9' &&
                                  _dentureGroupValue == 'Partial'))
                          ? true
                          : false,
                      child: Container(
                        margin: const EdgeInsets.only(top: 20),
                        width: (ageDropDown <= 13) ? 470 : 770,
                        height: 300,
                        child: (ageDropDown <= 13)
                            ? const ChildQuadrantGrid()
                            : const AdultQuadrantGrid(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Step(
          state: _currentStep <= 3 ? StepState.editing : StepState.complete,
          isActive: _currentStep >= 3,
          title: Text(translations[selectedLanguage]?['َServiceFee'] ?? ''),
          content: SizedBox(
            child: Center(
              child: Form(
                key: _formKey3,
                child: SizedBox(
                  width: 500.0,
                  child: Column(
                    children: [
                      const Text(
                          'لطفاً هزینه و اقساط را در خانه های ذیل انتخاب نمایید.'),
                      Container(
                        margin: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                        child: TextFormField(
                          controller: _totalExpController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'مصارف کل نمیتواند خالی باشد.';
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(_regExDecimal),
                            ),
                          ],
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'کل مصارف',
                            suffixIcon: Icon(Icons.money_rounded),
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
                        margin: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'نوعیت پرداخت',
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
                              child: DropdownButton(
                                isExpanded: true,
                                icon: const Icon(Icons.arrow_drop_down),
                                value: payTypeDropdown,
                                items: onPayInstallment()
                                    .map((String installmentItems) {
                                  return DropdownMenuItem(
                                    alignment: Alignment.centerRight,
                                    value: installmentItems,
                                    child: Directionality(
                                      textDirection: isEnglish
                                          ? TextDirection.ltr
                                          : TextDirection.rtl,
                                      child: Text(installmentItems),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    payTypeDropdown = newValue!;
                                    if (payTypeDropdown != 'تکمیل') {
                                      _isVisibleForPayment = true;
                                    } else {
                                      _isVisibleForPayment = false;
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _isVisibleForPayment,
                        child: Container(
                          margin: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                          child: TextFormField(
                            controller: _recievableController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'مبلغ رسید نمی تواند خالی باشد.';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'مبلغ رسید',
                              suffixIcon: Icon(Icons.money_rounded),
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
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ];

// Add a new patient
  Future<void> onAddNewPatient(BuildContext context) async {
    var staffId = StaffInfo.staffID;
    var firstName = _nameController.text;
    var lastName = _lNameController.text;
    var sex = genderDropDown;
    var age = ageDropDown;
    var maritalStatus = maritalStatusDD;
    var phone = _phoneController.text;
    var bGrop = bloodDropDown;
    var addr = _addrController.text;
    var conn = await onConnToDb();
    int serviceID = int.parse(selectedSerId!);
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
      int? tDetailID;
      if (serviceID == 2 ||
          serviceID == 6 ||
          serviceID == 9 ||
          serviceID == 11) {
        // Query for those services which require tooth numbers (1 - 8)

        // Fetch tooth ID based on its primary key from tooth_details.
        var toothResult = await conn.query(
            'SELECT * FROM tooth_details WHERE tooth = ? AND tooth_ID = ?',
            [selectedTooth2, selectedGumType2]);
        if (toothResult.isNotEmpty) {
          var tdRow = toothResult.first;
          tDetailID = tdRow['td_ID'];
        }
      } else if (serviceID == 10) {
        var removeResult = await conn.query(
            'SELECT * FROM tooth_details WHERE tooth = ? AND tooth_ID = ?',
            [removedTooth, selectedGumType2]);
        if (removeResult.isNotEmpty) {
          var row = removeResult.first;
          tDetailID = row['td_ID'];
        }
      } else if (serviceID == 3) {
        var bleachResult = await conn.query(
            'SELECT * FROM tooth_details WHERE tooth = ? AND tooth_ID = ?',
            ['tooth not required', selectedGumType2]);
        if (bleachResult.isNotEmpty) {
          var row = bleachResult.first;
          tDetailID = row['td_ID'];
        }
      } else if (serviceID == 4) {
        var scaleResult = await conn.query(
            'SELECT * FROM tooth_details WHERE tooth = ? AND tooth_ID = ?',
            ['tooth not required', selectedGumType1]);
        if (scaleResult.isNotEmpty) {
          var row = scaleResult.first;
          tDetailID = row['td_ID'];
        }
      } else if (serviceID == 5) {
        var orthoResult = await conn.query(
            'SELECT * FROM tooth_details WHERE tooth = ? AND tooth_ID = ?',
            ['tooth not required', selectedGumType1]);
        if (orthoResult.isNotEmpty) {
          var row = orthoResult.first;
          tDetailID = row['td_ID'];
        }
      } else if (serviceID == 7) {
        var gumResult = await conn.query(
            'SELECT * FROM tooth_details WHERE tooth = ? AND tooth_ID = ?',
            ['tooth not required', selectedGumType1]);
        if (gumResult.isNotEmpty) {
          var row = gumResult.first;
          tDetailID = row['td_ID'];
        }
      } else {
        var toothResult = await conn.query(
            'SELECT * FROM tooth_details WHERE tooth = ? AND tooth_ID = ?',
            ['tooth not required', selectedGumType2]);
        if (toothResult.isNotEmpty) {
          var tdRow = toothResult.first;
          tDetailID = tdRow['td_ID'];
        }
      }

// Declare this variable to be assigned ser_det_ID of service_details table
      int? serviceDID;
      if (serviceID == 2) {
        serviceDID = selectedFill;
      } else if (serviceID == 3) {
        serviceDID = selectedServiceDetailID;
      } else if (serviceID == 9) {
        serviceDID = selectedProthis;
      } else if (serviceID == 11) {
        serviceDID = selectedMaterial;
      } else if (serviceID == 8) {
        tDetailID = null;
        serviceDID = 15;
      } else {
        serviceDID = 15;
      }

      // Firstly insert a patient into patients table
      var queryResult = await conn.query(
          'INSERT INTO patients (staff_ID, firstname, lastname, sex, age, marital_status, phone, blood_group, address) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
          [
            staffId,
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
      if (queryResult.affectedRows! > 0) {
        String meetDate = _meetController.text;
        String note = _noteController.text;
        var queryResult1 = await conn.query(
            'SELECT * FROM patients WHERE firstname = ? AND sex = ? AND age = ? AND phone = ?',
            [firstName, sex, age, phone]);
        final row = queryResult1.first;
        final patId = row['pat_ID'];
        double totalAmount = double.parse(_totalExpController.text);
        double recieved = totalAmount;
        double dueAmount = 0;
        int installment = payTypeDropdown == 'تکمیل'
            ? 1
            : payTypeDropdown == 'دو قسط'
                ? 2
                : 3;
        if (payTypeDropdown != 'تکمیل') {
          recieved = double.parse(_recievableController.text);
          dueAmount = totalAmount - recieved;
        }

        // Now add appointment of the patient
        var queryResult2 = await conn.query(
            'INSERT INTO appointments (pat_ID, tooth_detail_ID, service_detail_ID, installment, round, paid_amount, due_amount, meet_date, staff_ID, note) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
            [
              patId,
              tDetailID,
              serviceDID,
              installment,
              1,
              recieved,
              dueAmount,
              meetDate,
              staffId,
              note
            ]);

        if (queryResult2.affectedRows! > 0) {
          _onShowSnack(Colors.green, 'مریض موفقانه افزوده شد.');
          _nameController.clear();
          _lNameController.clear();
          _phoneController.clear();
          _addrController.clear();
          _noteController.clear();
          _meetController.clear();
          _totalExpController.clear();
          _recievableController.clear();
          setState(() {
            _currentStep = 0;
          });
        } else {
          print('Adding appointments faield.');
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

// Create an alert dialog to confirm fields are inserted correctly.
  onConfirmForm() {
    return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Directionality(
                textDirection:
                    isEnglish ? TextDirection.ltr : TextDirection.rtl,
                child: const Text('کسب اطمینان'),
              ),
              content: Directionality(
                textDirection:
                    isEnglish ? TextDirection.ltr : TextDirection.rtl,
                child: const Text(
                    'آیا کاملاً مطمیین هستید در قسمت خانه پری این صفحه؟'),
              ),
              actions: [
                TextButton(
                    onPressed: () =>
                        Navigator.of(context, rootNavigator: true).pop(),
                    child: const Text('نگاه مجدد')),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _currentStep++;
                      });
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: const Text('بله')),
              ],
            ));
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
            height: 100,
            width: 600,
            child: Form(
              key: _condFormKey,
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

  _onAddMoreDetailsforHistory() {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Directionality(
          textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
          child: const Text('جزییات بیشتر راجع به تاریخچه صحی'),
        ),
        content: Directionality(
          textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
          child: SizedBox(
            width: 500,
            child: Form(
              key: _hisDetFormKey,
              child: Column(
                children: [
                  const Text(
                      'آیا مطمیین هستید که میخواهید این تاریخچه صحی را حذف نمایید؟'),
                  Container(
                    width: 400.0,
                    margin: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                    child: TextFormField(
                      controller: _meetController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'لطفا تاریخ مراجعه مریض را انتخاب کنید.';
                        }
                        return null;
                      },
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
                          _meetController.text = formattedDate;
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
                        labelText: 'شدت / سصح',
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
                                  groupValue: _histCondGroupValue,
                                  onChanged: (String? value) {
                                    setState(() {
                                      _histCondGroupValue = value!;
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
                                  groupValue: _histCondGroupValue,
                                  onChanged: (String? value) {
                                    setState(() {
                                      _histCondGroupValue = value!;
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
                                  groupValue: _histCondGroupValue,
                                  onChanged: (String? value) {
                                    setState(() {
                                      _histCondGroupValue = value!;
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
                                    'نا معلوم',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  value: 'نا معلوم',
                                  groupValue: _histCondGroupValue,
                                  onChanged: (String? value) {
                                    setState(() {
                                      _histCondGroupValue = value!;
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
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
              child: const Text('لغو')),
          ElevatedButton(
            onPressed: () async {
              /*  final conn = await onConnToDb();
              final deleteResults = await conn
                  .query('DELETE FROM conditions WHERE cond_ID = ?', [condID]);
              if (deleteResults.affectedRows! > 0) {
                _onShowSnack(Colors.green, 'تاریخچه صحی موفقانه حذف گردید.');
                setState(() {});
              } else {
                _onShowSnack(Colors.red, 'حذف تاریخچه صحی ناکام شد.');
              }
              Navigator.of(context, rootNavigator: true).pop();
              await conn.close(); */
            },
            child: const Text('انجام'),
          ),
        ],
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
                if (_formKey1.currentState!.validate()) {
                  if (_currentStep < stepList().length - 1) {
                    setState(() {
                      if (_currentStep == 1) {
                        if (_formKey2.currentState!.validate()) {
                          onConfirmForm();
                        }
                      } else {
                        onConfirmForm();
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

//  نوعیت کشیدن دندان
  String? selectedTooth;

  List<Map<String, dynamic>> removeTeeth = [];
  Future<void> fetchRemoveTooth() async {
    print('Testing gum: $selectedGumType2');
    var conn = await onConnToDb();
    if (selectedGumType2 != null) {
      var results = await conn.query(
          'SELECT td_ID, tooth FROM tooth_details WHERE (td_ID >= 35 AND td_ID <= 49) AND tooth_ID = ?',
          [selectedGumType2]);

      setState(() {
        removeTeeth = results
            .map(
                (result) => {'td_ID': result[0].toString(), 'tooth': result[1]})
            .toList();
        selectedTooth = removeTeeth.isNotEmpty ? removeTeeth[0]['td_ID'] : null;
      });
    } else {
      // Set a default value for selectedTooth using the defaultResult query
      var defaultResult = await conn.query(
          'SELECT td_ID, tooth FROM tooth_details WHERE td_ID >= 35 AND td_ID <= 37');
      if (defaultResult.isNotEmpty) {
        setState(() {
          selectedTooth = defaultResult.first['td_ID'].toString();
          removeTeeth = defaultResult
              .map((result) =>
                  {'td_ID': result['td_ID'], 'tooth': result['tooth']})
              .toList();
          selectedTooth = removeTeeth.isNotEmpty
              ? removeTeeth[0]['td_ID'].toString()
              : null;
        });
        // selectedTooth = removeTeeth.isNotEmpty ? removeTeeth[0]['td_ID'] : null;
      }
    }

    await conn.close();
  }

  //  لثه برای جرم گیری
  String? selectedGumType1;
  List<Map<String, dynamic>> gumsType1 = [];
  Future<void> chooseGumType1() async {
    var conn = await onConnToDb();
    var results = await conn.query(
        'SELECT teeth_ID, gum from teeth WHERE teeth_ID IN (1, 2, 3) ORDER BY teeth_ID DESC');
    gumsType1 = results
        .map((result) => {'teeth_ID': result[0].toString(), 'gum': result[1]})
        .toList();
    selectedGumType1 = gumsType1.isNotEmpty ? gumsType1[0]['teeth_ID'] : null;
    await conn.close();
  }

  List<String> onTeethScaling() {
    List<String> gumItems = ['بالا', 'پایین', 'هردو'];
    return gumItems;
  }

  //  جراحی لثه دندان
  List<int> onGumSurgery() {
    List<int> gumSurgeryItems = [1, 2, 3, 4];
    return gumSurgeryItems;
  }

  //  لثه برای استفاده متعدد
  String? selectedGumType2;
  List<Map<String, dynamic>> gums = [];

  Future<void> onChooseGum2() async {
    var conn = await onConnToDb();
    var queryResult = await conn.query(
        'SELECT teeth_ID, gum FROM teeth WHERE teeth_ID IN (4, 5, 6, 7, 1)');
    gums = queryResult
        .map((row) => {'teeth_ID': row[0].toString(), 'gum': row[1]})
        .toList();
    selectedGumType2 = gums.isNotEmpty ? gums[1]['teeth_ID'] : null;
    await conn.close();
  }

  //  پروتز دندان
  String? selectedProthesis;
  List<Map<String, dynamic>> protheses = [];
  Future<void> fetchProtheses() async {
    var conn = await onConnToDb();
    var results = await conn.query(
        'SELECT ser_det_ID, service_specific_value FROM service_details WHERE ser_id = 9');
    setState(() {
      protheses = results
          .map((result) => {
                'ser_det_ID': result[0].toString(),
                'service_specific_value': result[1]
              })
          .toList();
    });
    selectedProthesis =
        protheses.isNotEmpty ? protheses[0]['ser_det_ID'] : null;
    await conn.close();
  }

  //  تعداد دندان
  List<Map<String, dynamic>> teeth = [];
  Future<void> fetchToothNum() async {
    String? toothId = selectedGumType2 ?? '4';
    var conn = await onConnToDb();
    var results = await conn.query(
        'SELECT td_ID, tooth from tooth_details WHERE tooth_ID = ? LIMIT 8',
        [toothId]);
    teeth = results
        .map((result) => {'td_ID': result[0].toString(), 'tooth': result[1]})
        .toList();
    selectedTooth2 = teeth.isNotEmpty ? teeth[0]['td_ID'] : null;
    await conn.close();
  }

  //  اقساط پرداخت
  List<String> onPayInstallment() {
    List<String> installmentItems = ['تکمیل', 'دو قسط', 'سه قسط'];
    return installmentItems;
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

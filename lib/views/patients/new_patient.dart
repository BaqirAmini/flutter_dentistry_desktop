// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dentistry/models/db_conn.dart';
import 'package:flutter_dentistry/views/patients/patients.dart';
import 'package:flutter_dentistry/views/staff/staff_info.dart';
import 'package:intl/intl.dart' as intl2;

void main() {
  return runApp(const NewPatient());
}

class NewPatient extends StatefulWidget {
  const NewPatient({Key? key}): super(key: key);

  @override
  _NewPatientState createState() => _NewPatientState();
}

class _NewPatientState extends State<NewPatient> {
   GlobalKey<ScaffoldMessengerState> _globalKey2 =
      GlobalKey<ScaffoldMessengerState>();

  String maritalStatusDD = 'مجرد';
  var items = ['مجرد', 'متاهل'];
  String? selectedToothDetail_ID;

  // ِDeclare variables for gender dropdown
  String genderDropDown = 'مرد';
  var genderItems = ['مرد', 'زن'];

  // Blood group types
  String bloodDropDown = 'نامشخص';
  var bloodGroupItems = [
    'نامشخص',
    'A+',
    'B+',
    'AB+',
    'O+',
    'A-',
    'B-',
    'AB-',
    'O-'
  ];

  String? selectedSerId;
  List<Map<String, dynamic>> services = [];

  @override
  void initState() {
    super.initState();
    fetchServices();
    onFillTeeth();
    onChooseGum2();
    fetchToothNum();
    chooseGumType1();
    fetchBleachings();
    fetchProtheses();
    fetchToothCover();
  }

  Future<void> fetchServices() async {
    var conn = await onConnToDb();
    var queryService = await conn
        .query('SELECT ser_ID, ser_name FROM services WHERE ser_ID > 1');
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

  /* ---------------- variable to get assigned values based on services types dropdown */

  /* ----------------END variable to get assigned values based on services types dropdown */

  // Declare a list to contain patients' info
  List<Step> stepList() => [
        Step(
          state: _currentStep <= 0 ? StepState.editing : StepState.complete,
          isActive: _currentStep >= 0,
          title: const Text('معلومات شخصی مریض'),
          content: Center(
            child: SizedBox(
              width: 500.0,
              child: Form(
                key: _formKey1,
                child: Column(
                  children: [
                    const Text(
                        'لطفا معلومات شخصی مریض را با دقت در خانه های ذیل وارد کنید.'),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                      child: TextFormField(
                        controller: _nameController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(_regExOnlyAbc),
                          ),
                        ],
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'نام مریض الزامی است.';
                          } else if (value.length < 3 || value.length > 10) {
                            return 'نام مریض باید بین 3 و 12 حرف باشد.';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'نام',
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
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1.5)),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
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
                              return 'تخلص باید از سه الی ده حرف باشد.';
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
                                    textDirection: TextDirection.rtl,
                                    child: Text('$ageItems سال '),
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
                      margin: const EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'جنیست',
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
                              value: genderDropDown,
                              items: genderItems.map((String genderItems) {
                                return DropdownMenuItem(
                                  alignment: Alignment.centerRight,
                                  value: genderItems,
                                  child: Text(genderItems),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  genderDropDown = newValue!;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'حالت مدنی',
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
                              value: maritalStatusDD,
                              items: items.map((String items) {
                                return DropdownMenuItem(
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
                      margin: const EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'گروپ خون',
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
                              value: bloodDropDown,
                              items:
                                  bloodGroupItems.map((String bloodGroupItems) {
                                return DropdownMenuItem(
                                  alignment: Alignment.centerRight,
                                  value: bloodGroupItems,
                                  child: Text(bloodGroupItems),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  bloodDropDown = newValue!;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
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
                            return 'نمبر تماس الزامی است.';
                          } else if (value.startsWith('07')) {
                            if (value.length < 10 || value.length > 10) {
                              return 'نمبر تماس باید 10 عدد باشد.';
                            }
                          } else if (value.startsWith('+93')) {
                            if (value.length < 12 || value.length > 12) {
                              return 'نمبر تماس  همراه با کود کشور باید 12 عدد باشد.';
                            }
                          } else {
                            return 'نمبر تماس نا معتبر است.';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'نمبر تماس',
                          suffixIcon: Icon(Icons.phone),
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
                      child: TextFormField(
                        controller: _addrController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(_regExOnlyAbc),
                          ),
                        ],
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'آدرس',
                          suffixIcon: Icon(Icons.location_on_outlined),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0)),
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0)),
                              borderSide: BorderSide(color: Colors.blue)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Step(
          state: _currentStep <= 1 ? StepState.editing : StepState.complete,
          isActive: _currentStep >= 1,
          title: const Text('خدمات مورد نیاز مریض'),
          content: SizedBox(
            child: Center(
              child: Form(
                key: _formKey2,
                child: SizedBox(
                  width: 500.0,
                  child: Column(
                    children: [
                      const Text(
                          'لطفا نوعیت سرویس (خدمات) و خانه های مربوطه آنرا با دقت پر کنید.'),
                      Container(
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
                            labelText: 'تاریخ اولین مراجعه',
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
                        margin: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'نوعیت خدمات',
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
                        visible: _isVisibleForBleaching,
                        child: Container(
                          margin: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'نوعیت سفید کردن دندانها',
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
                                  value: selectedBleachStep,
                                  items: teethBleachings.map((step) {
                                    return DropdownMenuItem<String>(
                                      value: step['ser_det_ID'],
                                      alignment: Alignment.centerRight,
                                      child:
                                          Text(step['service_specific_value']),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedBleachStep = newValue;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _isVisibleForTeethRemove,
                        child: Container(
                          margin: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'نوعیت دندان',
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
                                  value: selectedTooth,
                                  items: removeTeeth.map((tooth) {
                                    return DropdownMenuItem<String>(
                                      value: tooth['td_ID'],
                                      alignment: Alignment.centerRight,
                                      child: Text(tooth['tooth']),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedTooth = newValue;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _isVisibleForScaling
                            ? _isVisibleForScaling
                            : _isVisibleForOrtho
                                ? _isVisibleForOrtho
                                : _isVisibleGum
                                    ? _isVisibleGum
                                    : false,
                        child: Container(
                          margin: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'فک / لثه',
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
                                  value: selectedGumType1,
                                  items: gumsType1.map((gumType1) {
                                    return DropdownMenuItem<String>(
                                      value: gumType1['teeth_ID'],
                                      alignment: Alignment.centerRight,
                                      child: Text(gumType1['gum']),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedGumType1 = newValue;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
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
                          margin: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'فک / لثه',
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
                                      if (selectedSerId == '10') {
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
                      Visibility(
                        visible: _isVisibleForCover,
                        child: Container(
                          margin: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'نوعیت مواد پوش',
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
                                  value: selectedCover,
                                  items: coverings.map((covering) {
                                    return DropdownMenuItem<String>(
                                      value: covering['ser_det_ID'],
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                          covering['service_specific_value']),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedCover = newValue;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _isVisibleForProthesis
                            ? _isVisibleForProthesis
                            : false,
                        child: Container(
                          margin: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'نوعیت پروتیز',
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
                                  value: selectedProthesis,
                                  items: protheses.map((prothesis) {
                                    return DropdownMenuItem<String>(
                                      value: prothesis['ser_det_ID'],
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                          prothesis['service_specific_value']),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedProthesis = newValue;
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
                        visible: _isVisibleForFilling,
                        child: Container(
                          margin: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'نوعیت مواد',
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
                                  value: selectedFilling,
                                  items: teethFillings.map((material) {
                                    return DropdownMenuItem<String>(
                                      alignment: Alignment.centerRight,
                                      value: material['ser_det_ID'],
                                      child: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Text(
                                            material['service_specific_value']),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedFilling = newValue!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _isVisibleForFilling
                            ? _isVisibleForFilling
                            : _isVisibleForRoot
                                ? _isVisibleForRoot
                                : _isVisibleForProthesis
                                    ? _isVisibleForProthesis
                                    : _isVisibleForCover
                                        ? _isVisibleForCover
                                        : false,
                        child: Container(
                          margin: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'دندان',
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
                                  value: selectedToothDetail_ID,
                                  items: teeth.map((tooth) {
                                    return DropdownMenuItem<String>(
                                      value: tooth['td_ID'],
                                      alignment: Alignment.centerRight,
                                      child: Text(tooth['tooth']),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedToothDetail_ID = newValue;
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
                          margin: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                          child: TextFormField(
                            controller: _noteController,
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
                                RegExp(_regExOnlyAbc),
                              ),
                            ],
                            maxLines: 3,
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
        Step(
          state: _currentStep <= 1 ? StepState.editing : StepState.complete,
          isActive: _currentStep >= 1,
          title: const Text('هزینه ها / فیس'),
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
                                      textDirection: TextDirection.rtl,
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
      int toothDetID = int.parse(selectedToothDetail_ID!);
      // Fetch tooth ID based on its primary key from tooth_details.
      int? toothID;
      var toothResult = await conn.query(
          'SELECT tooth_ID FROM tooth_Details WHERE td_ID = ?', [toothDetID]);
      if (toothResult.isNotEmpty) {
        var tdRow = toothResult.first;
        toothID = tdRow['tooth_ID'];
      }

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

      if (queryResult.affectedRows! > 0) {
        String meetDate = _meetController.text;
        int serviceID = int.parse(selectedSerId!);
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

        print(
            'patient ID: $patId, total amount: $totalAmount, recieved: $recieved, Due amount: $dueAmount, installment: $installment, Staff: $staffId');
        // Now add appointment of the patient
        var queryResult2 = await conn.query(
            'INSERT INTO appointments (pat_ID, tooth_detail_ID, ser_ID, installment, round, paid_amount, due_amount, meet_date, staff_ID, note) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
            [
              patId,
              toothDetID,
              serviceID,
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
              title: const Directionality(
                textDirection: TextDirection.rtl,
                child: Text('کسب اطمینان'),
              ),
              content: const Directionality(
                textDirection: TextDirection.rtl,
                child:
                    Text('آیا کاملاً مطمیین هستید در قسمت خانه پری این صفحه؟'),
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ScaffoldMessenger(
        key: _globalKey2,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              leading: Tooltip(
                message: 'رفتن به صفحه قبلی',
                child: IconButton(
                  icon: const BackButtonIcon(),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Patient()));
                  },
                ),
              ),
              title: const Text('افزودن مریض'),
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
                      child: const Text('قبلی'),
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
                          ? 'ثبت کردن'
                          : 'ادامه'),
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

//  سفید کردن دندان
  String? selectedBleachStep;
  List<Map<String, dynamic>> teethBleachings = [];

  Future<void> fetchBleachings() async {
    var conn = await onConnToDb();
    var results = await conn.query(
        'SELECT ser_det_ID, service_specific_value FROM service_details WHERE ser_id = 3');
    setState(() {
      teethBleachings = results
          .map((result) => {
                'ser_det_ID': result[0].toString(),
                'service_specific_value': result[1]
              })
          .toList();
    });
    selectedBleachStep =
        teethBleachings.isNotEmpty ? teethBleachings[0]['ser_det_ID'] : null;
    await conn.close();
  }

//  نوعیت کشیدن دندان
  String? selectedTooth;
  List<Map<String, dynamic>> removeTeeth = [];
  Future<void> fetchRemoveTooth() async {
    var conn = await onConnToDb();
    var results = await conn.query(
        'SELECT td_ID, tooth FROM tooth_details WHERE td_ID >= 35 AND tooth_ID = ?',
        [selectedGumType2]);
    setState(() {
      removeTeeth = results
          .map((result) => {'td_ID': result[0].toString(), 'tooth': result[1]})
          .toList();
    });
    selectedTooth = removeTeeth.isNotEmpty ? removeTeeth[0]['td_ID'] : null;
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

  //  پوش کردن دندان
  String? selectedCover;
  List<Map<String, dynamic>> coverings = [];
  Future<void> fetchToothCover() async {
    var conn = await onConnToDb();
    var results = await conn.query(
        'SELECT ser_det_ID, service_specific_value FROM service_details WHERE ser_id = 11');
    setState(() {
      coverings = results
          .map((result) => {
                'ser_det_ID': result[0].toString(),
                'service_specific_value': result[1]
              })
          .toList();
    });
    selectedCover = coverings.isNotEmpty ? coverings[0]['ser_det_ID'] : null;
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

  //  پرکاری دندان
  String? selectedFilling;
  List<Map<String, dynamic>> teethFillings = [];

  Future<void> onFillTeeth() async {
    var conn = await onConnToDb();
    var queryFill = await conn.query(
        'SELECT ser_det_ID, service_specific_value FROM service_details WHERE ser_det_ID >= 1 AND ser_det_ID < 4');
    teethFillings = queryFill
        .map((result) => {
              'ser_det_ID': result[0].toString(),
              'service_specific_value': result[1]
            })
        .toList();

    selectedFilling =
        teethFillings.isNotEmpty ? teethFillings[0]['ser_det_ID'] : null;
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
    selectedToothDetail_ID = teeth.isNotEmpty ? teeth[0]['td_ID'] : null;
    await conn.close();
  }

  //  اقساط پرداخت
  List<String> onPayInstallment() {
    List<String> installmentItems = ['تکمیل', 'دو قسط', 'سه قسط'];
    return installmentItems;
  }
}

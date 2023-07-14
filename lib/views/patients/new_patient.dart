import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dentistry/views/patients/patients.dart';

void main() {
  return runApp(const NewPatient());
}

class NewPatient extends StatefulWidget {
  const NewPatient({super.key});

  @override
  _NewPatientState createState() => _NewPatientState();
}

class _NewPatientState extends State<NewPatient> {
  String dropdownValue = 'مجرد';
  var items = ['مجرد', 'متاهل'];

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

  // Services types dropdown variables
  String serviceDropDown = 'پرکاری دندان';
  var serviceItems = [
    'پرکاری دندان',
    'سفید کردن دندان',
    'جرم گیری دندان',
    'ارتودانسی',
    'جراحی ریشه دندان',
    'جراحی لثه دندان',
    'معاینه دهن',
    'پروتیز دندان',
    'کشیدن دندان',
    'پوش کردن دندان'
  ];

  // Declare a dropdown for ages
  int ageDropDown = 1;

  // Declare a variable for tooth bleaching
  String stageDropDown = 'یک مرحله یی';

  // Declare a variable for tooth scaling
  String gumDropDown = 'بالا';

  // Declare a variable for gum surgery
  int gumSurgeryDropDown = 1;

  // Declare a variable for canal root surgery
  String _gumTypeSelected = 'بالا - راست';

  // Declare a variable for teeth covering
  String teethCovering = 'پورسلن';

  // Declare a variable for teeth prosthesis
  String teethProsthesis = 'پروتز قسمی';

  // Declare a variable for teeth filling
  String teethFilling = 'کامپوزیت';

  // Declare a variable for teeth numbers
  int teethNumbers = 1;

  // Declase a variable for removing teeth
  String _teethRemoveSelected = 'ساده';

  // Declare a variable for payment installment
  String installments = 'تکمیل';

  int _currentStep = 0;

  final _nameController = TextEditingController();
  final _lNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addrController = TextEditingController();
  final _regExOnlyAbc = "[a-zA-Z,، \u0600-\u06FFF]";
  final _regExOnlydigits = "[0-9+]";

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
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
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
                      margin: const EdgeInsets.all(20.0),
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
                      margin: const EdgeInsets.all(20.0),
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
                      margin: const EdgeInsets.all(20.0),
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
                          child: Container(
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
                      margin: const EdgeInsets.all(20.0),
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
                          child: Container(
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
                      margin: const EdgeInsets.all(20.0),
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
                          child: Container(
                            height: 26.0,
                            child: DropdownButton(
                              isExpanded: true,
                              icon: const Icon(Icons.arrow_drop_down),
                              value: dropdownValue,
                              items: items.map((String items) {
                                return DropdownMenuItem(
                                  alignment: Alignment.centerRight,
                                  value: items,
                                  child: Text(items),
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
                    ),
                    Container(
                      margin: const EdgeInsets.all(20.0),
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
                          child: Container(
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
                      margin: const EdgeInsets.all(20.0),
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
                      margin: const EdgeInsets.all(20.0),
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
                        margin: const EdgeInsets.all(20.0),
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
                            child: Container(
                              height: 26.0,
                              child: DropdownButton(
                                isExpanded: true,
                                icon: const Icon(Icons.arrow_drop_down),
                                value: serviceDropDown,
                                items: serviceItems.map((String serviceItems) {
                                  return DropdownMenuItem(
                                    value: serviceItems,
                                    alignment: Alignment.centerRight,
                                    child: Text(serviceItems),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    serviceDropDown = newValue!;
                                    if (serviceDropDown == 'پرکاری دندان') {
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
                                    } else if (serviceDropDown ==
                                        'سفید کردن دندان') {
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
                                    } else if (serviceDropDown ==
                                        'جرم گیری دندان') {
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
                                    } else if (serviceDropDown == 'ارتودانسی') {
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
                                    } else if (serviceDropDown ==
                                        'پروتیز دندان') {
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
                                    } else if (serviceDropDown ==
                                        'جراحی ریشه دندان') {
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
                                    } else if (serviceDropDown ==
                                        'جراحی لثه دندان') {
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
                                    } else if (serviceDropDown ==
                                        'معاینه دهن') {
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
                                    } else if (serviceDropDown ==
                                        'کشیدن دندان') {
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
                                    } else if (serviceDropDown ==
                                        'پوش کردن دندان') {
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
                          margin: const EdgeInsets.all(20.0),
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
                              child: Container(
                                height: 26.0,
                                child: DropdownButton(
                                  isExpanded: true,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  value: stageDropDown,
                                  items: onTeethBleaching()
                                      .map((String stageItems) {
                                    return DropdownMenuItem(
                                      alignment: Alignment.centerRight,
                                      value: stageItems,
                                      child: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Text(stageItems),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      stageDropDown = newValue!;
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
                          margin: const EdgeInsets.all(20.0),
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
                              child: Container(
                                height: 26.0,
                                child: DropdownButton(
                                  isExpanded: true,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  value: _teethRemoveSelected,
                                  items:
                                      onTeethRemove().map((String teethType) {
                                    return DropdownMenuItem(
                                      alignment: Alignment.centerRight,
                                      value: teethType,
                                      child: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Text(teethType),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _teethRemoveSelected = newValue!;
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
                                : false,
                        child: Container(
                          margin: const EdgeInsets.all(20.0),
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
                              child: Container(
                                height: 26.0,
                                child: DropdownButton(
                                  isExpanded: true,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  value: gumDropDown,
                                  items:
                                      onTeethScaling().map((String gumItems) {
                                    return DropdownMenuItem(
                                      alignment: Alignment.centerRight,
                                      value: gumItems,
                                      child: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Text(gumItems),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      gumDropDown = newValue!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _isVisibleGum ? _isVisibleGum : false,
                        child: Container(
                          margin: const EdgeInsets.all(20.0),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'گواردینات',
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
                              child: Container(
                                height: 26.0,
                                child: DropdownButton(
                                  isExpanded: true,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  value: gumSurgeryDropDown,
                                  items: onGumSurgery().map((int gumItems) {
                                    return DropdownMenuItem(
                                      alignment: Alignment.centerRight,
                                      value: gumItems,
                                      child: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Text('$gumItems'),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (int? newValue) {
                                    setState(() {
                                      gumSurgeryDropDown = newValue!;
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
                          margin: const EdgeInsets.all(20.0),
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
                              child: Container(
                                height: 26.0,
                                child: DropdownButton(
                                  isExpanded: true,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  value: _gumTypeSelected,
                                  items: gumTypes2().map((String rootItems) {
                                    return DropdownMenuItem(
                                      alignment: Alignment.centerRight,
                                      value: rootItems,
                                      child: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Text(rootItems),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _gumTypeSelected = newValue!;
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
                          margin: const EdgeInsets.all(20.0),
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
                              child: Container(
                                height: 26.0,
                                child: DropdownButton(
                                  isExpanded: true,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  value: teethCovering,
                                  items: onTeethCovering()
                                      .map((String coverItems) {
                                    return DropdownMenuItem(
                                      alignment: Alignment.centerRight,
                                      value: coverItems,
                                      child: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Text(coverItems),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      teethCovering = newValue!;
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
                          margin: const EdgeInsets.all(20.0),
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
                              child: Container(
                                height: 26.0,
                                child: DropdownButton(
                                  isExpanded: true,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  value: teethProsthesis,
                                  items: onTeethProsthesis()
                                      .map((String prosthesisItems) {
                                    return DropdownMenuItem(
                                      alignment: Alignment.centerRight,
                                      value: prosthesisItems,
                                      child: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Text(prosthesisItems),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      teethProsthesis = newValue!;
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
                          margin: const EdgeInsets.all(20.0),
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
                              child: Container(
                                height: 26.0,
                                child: DropdownButton(
                                  isExpanded: true,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  value: teethFilling,
                                  items: onTeethFilling()
                                      .map((String teethFillingItems) {
                                    return DropdownMenuItem(
                                      alignment: Alignment.centerRight,
                                      value: teethFillingItems,
                                      child: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Text(teethFillingItems),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      teethFilling = newValue!;
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
                          margin: const EdgeInsets.all(20.0),
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
                              child: Container(
                                height: 26.0,
                                child: DropdownButton(
                                  isExpanded: true,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  value: teethNumbers,
                                  items:
                                      onTeethNumbers().map((int teethNumber) {
                                    return DropdownMenuItem(
                                      alignment: Alignment.centerRight,
                                      value: teethNumber,
                                      child: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Text('دندان $teethNumber'),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (int? newValue) {
                                    setState(() {
                                      teethNumbers = newValue!;
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
                          margin: const EdgeInsets.all(20.0),
                          child: TextFormField(
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
              child: SizedBox(
                width: 500.0,
                child: Column(
                  children: [
                    const Text(
                        'لطفاً هزینه و اقساط را در خانه های ذیل انتخاب نمایید.'),
                    Container(
                      margin: const EdgeInsets.all(20.0),
                      child: const TextField(
                        decoration: InputDecoration(
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
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(20.0),
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
                          child: Container(
                            height: 26.0,
                            child: DropdownButton(
                              isExpanded: true,
                              icon: const Icon(Icons.arrow_drop_down),
                              value: installments,
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
                                  installments = newValue!;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(20.0),
                      child: const TextField(
                        decoration: InputDecoration(
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
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ))),
      ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            leading: Tooltip(
              message: 'رفتن به صفحه قبلی',
              child: IconButton(
                icon: const BackButtonIcon(),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Patient()));
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
              setState(() {
                if (_currentStep < stepList().length - 1) {
                  if (_formKey1.currentState!.validate()) {
                    _currentStep++;
                  }
                }
              });
            },
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
  List<String> onTeethBleaching() {
    List<String> stageItems = [
      'یک مرحله یی',
      'دو مرحله یی',
      'سه مرحله یی',
      'چهار مرحله یی'
    ];
    return stageItems;
  }

//  نوعیت کشیدن دندان
  List<String> onTeethRemove() {
    List<String> _teethRemoveItems = ['ساده', 'عقلی', 'امپکت'];
    return _teethRemoveItems;
  }

  //  لثه برای جرم گیری
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
  List<String> gumTypes2() {
    List<String> canalRootItems = [
      'بالا - راست',
      'بالا - چپ',
      'پایین - راست',
      'پایین - چپ',
      'هردو'
    ];
    return canalRootItems;
  }

  //  پوش کردن دندان
  List<String> onTeethCovering() {
    List<String> teethCoverItems = ['پورسلن', 'میتل', 'زرگونیم', 'گیگم'];
    return teethCoverItems;
  }

  //  پروتز دندان
  List<String> onTeethProsthesis() {
    List<String> prosthesisItems = ['پروتز قسمی', 'پروتز کامل'];
    return prosthesisItems;
  }

  //  پرکاری دندان
  List<String> onTeethFilling() {
    List<String> teethFillingItems = ['کامپوزیت', 'املگم', 'سایر مواد'];
    return teethFillingItems;
  }

  //  تعداد دندان
  List<int> onTeethNumbers() {
    List<int> teethNumItems = [1, 2, 3, 4, 5, 6, 7, 8];
    return teethNumItems;
  }

  //  اقساط پرداخت
  List<String> onPayInstallment() {
    List<String> installmentItems = ['تکمیل', 'دو قسط', 'سه قسط'];
    return installmentItems;
  }
}

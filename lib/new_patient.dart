import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  String canalRootSurgery = 'بالا - راست';

  // Declare a variable for teeth covering
  String teethCovering = 'پورسلن';

  // Declare a variable for teeth prosthesis
  String teethProsthesis = 'پروتز قسمی';

  // Declare a variable for teeth filling
  String teethFilling = 'کامپوزیت';

  // Declare a variable for teeth numbers
  int teethNumbers = 1;

  // Declare a variable for payment installment
  String installments = 'تکمیل';

  int _currentStep = 0;

  // Declare a list to contain patients' info
  List<Step> stepList() => [
        Step(
            state: _currentStep <= 0 ? StepState.editing : StepState.complete,
            isActive: _currentStep >= 0,
            title: const Text('معلومات شخصی مریض'),
            content: SizedBox(
                width: 100.0,
                child: Center(
                  child: SizedBox(
                    width: 500.0,
                    child: Column(
                      children: [
                        const Text(
                            'لطفا معلومات شخصی مریض را با دقت در خانه های ذیل وارد کنید.'),
                        Container(
                          margin: const EdgeInsets.all(20.0),
                          child: const TextField(
                            decoration: InputDecoration(
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
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(20.0),
                          child: const TextField(
                            decoration: InputDecoration(
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
                          child: TextField(
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
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
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(20.0),
                          child: TextField(
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
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
                ))),
        Step(
            state: _currentStep <= 1 ? StepState.editing : StepState.complete,
            isActive: _currentStep >= 1,
            title: const Text('خدمات مورد نیاز مریض'),
            content: SizedBox(
                child: Center(
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
                              items:
                                  onTeethBleaching().map((String stageItems) {
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
                    Container(
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
                              items: onTeethScaling().map((String gumItems) {
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
                    Container(
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
                    Container(
                      margin: const EdgeInsets.all(20.0),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'جراحی ریشه دندان',
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
                              value: canalRootSurgery,
                              items:
                                  onCanalRootSurgery().map((String rootItems) {
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
                                  canalRootSurgery = newValue!;
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
                          labelText: 'نوعیت پوش دندان',
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
                              items: onTeethCovering().map((String coverItems) {
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
                    Container(
                      margin: const EdgeInsets.all(20.0),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'نوعیت پروتز',
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
                    Container(
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
                    Container(
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
                              items: onTeethNumbers().map((int teethNumber) {
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
                    Container(
                      margin: const EdgeInsets.all(20.0),
                      child: const TextField(
                        maxLines: 3,
                        decoration: InputDecoration(
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
                  ],
                ),
              ),
            ))),
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
                              items:
                                  onPayInstallment().map((String installmentItems) {
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
                onPressed: () {},
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
                  _currentStep++;
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

  //  جرم گیری دندان
  List<String> onTeethScaling() {
    List<String> gumItems = ['بالا', 'پایین', 'هردو'];
    return gumItems;
  }

  //  جراحی لثه دندان
  List<int> onGumSurgery() {
    List<int> gumSurgeryItems = [1, 2, 3, 4];
    return gumSurgeryItems;
  }

  //  جراحی ریشه دندان
  List<String> onCanalRootSurgery() {
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

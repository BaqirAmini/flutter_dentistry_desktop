import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dentistry/config/global_usage.dart';
import 'package:flutter_dentistry/config/language_provider.dart';
import 'package:flutter_dentistry/models/db_conn.dart';
import 'package:flutter_dentistry/views/patients/adult_coordinate_system.dart';
import 'package:flutter_dentistry/views/patients/child_coordinate_system.dart';
import 'package:intl/intl.dart' as intl2;
import 'package:provider/provider.dart';

// Set global variables which are needed later.
var selectedLanguage;
bool isEnglish = false;

class CustomForm extends StatelessWidget {
  const CustomForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ServiceForm(formKey: GlobalKey<FormState>());
  }
}

class ServiceForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const ServiceForm({required this.formKey});

  @override
  State<ServiceForm> createState() => _ServiceFormState();
}

class _ServiceFormState extends State<ServiceForm> {
  // This is to fetch staff list
  List<Map<String, dynamic>> staffList = [];

//  پوش کردن دندان
  final List<String> _crownItems = [
    'Porcelain',
    'Metal-Porcelain',
    'Design Porcelain',
    'Style Porcelain',
    'CAD CAM',
    'Zirconia',
    'Mital',
    'Gold',
    'وسایر'
  ];

  List<String> fillingItems = [
    'Amalgam',
    'Silicate',
    'Composite',
    'G.C (Glass Inomir)',
    'وسایر',
  ];

  // ارتودانسی
  final List<String> _orthoItems = [
    'فک بالا',
    'فک پایین',
    'هردو فک',
    'بستن دیاستم وسطی'
  ];

// MaxilloFacial وجه فک
  List<String> maxilloItems = [
    'Tooth Extraction',
    'Abscess Treatment',
    'T.M.J',
    'Tooth Reimplantation',
    'Jaw Fracture Fixation'
  ];

// Gum selection for Abscess treatment
  List<String> abscessItems = ['فک بالا', 'فک پایین', 'هردو'];

  // Bleaching
  final List<String> _bleachingItems = ['یک مرحله', 'دو مرحله', 'سه مرحله'];

  // Select gums for Denture
  final List<String> _dentureItems = ['فک بالا', 'فک پایین', 'هردو'];

  List<Map<String, dynamic>> services = [];

// Create an instance GlobalUsage to be access its method
  GlobalUsage gu = GlobalUsage();

  @override
  void initState() {
    super.initState();
    gu.fetchServices().then((service) {
      setState(() {
        services = service;
        ServiceInfo.selectedServiceID =
            services.isNotEmpty ? int.parse(services[0]['ser_ID']) : null;
      });
    });
    // Call to fetch staff
    gu.fetchStaff().then((staff) {
      setState(() {
        staffList = staff;
        ServiceInfo.selectedDentistID =
            staffList.isNotEmpty ? int.parse(staffList[0]['staff_ID']) : null;
      });
    });
  }

  // Set controllers for textfields
  final _visitTimeController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Fetch translations keys based on the selected language.
    /*  var languageProvider = Provider.of<LanguageProvider>(context);
    selectedLanguage = languageProvider.selectedLanguage;
    isEnglish = selectedLanguage == 'English'; */
    ServiceInfo.serviceNote = _noteController.text;
    ServiceInfo.meetingDate = _visitTimeController.text.toString();
    DateTime selectedDateTime = DateTime.now();
    return Form(
      key: widget.formKey,
      child: Center(
        child: Column(
          children: [
            Text(
              'لطفاً با دقت سرویس ها (خدمات) زیر را انتخاب نموده و طبق آن معلومات مرتبط آنرا به خانه های زیر درج نمایید.',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          '*',
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: 400.0,
                          margin: const EdgeInsets.only(
                              left: 20.0, right: 10.0, top: 10.0, bottom: 10.0),
                          child: TextFormField(
                            controller: _visitTimeController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'لطفا زمان مراجعه مریض را انتخاب کنید.';
                              }
                              return null;
                            },
                            onTap: () async {
                              FocusScope.of(context).requestFocus(
                                FocusNode(),
                              );
                              final DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
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
                                  _visitTimeController.text =
                                      selectedDateTime.toString();
                                }
                              }
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9.]'))
                            ],
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'زمان اولین مراجعه',
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
                              value: ServiceInfo.selectedServiceID.toString(),
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
                                  ServiceInfo.selectedServiceID =
                                      int.parse(newValue!);
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible:
                          (ServiceInfo.selectedServiceID == 9) ? true : false,
                      child: Container(
                        width: 400.0,
                        margin: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
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
                                        'Full',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      value: 'Full',
                                      groupValue: ServiceInfo.dentureGroupValue,
                                      onChanged: (String? value) {
                                        setState(() {
                                          ServiceInfo.dentureGroupValue =
                                              value!;
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
                                        'Partial',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      value: 'Partial',
                                      groupValue: ServiceInfo.dentureGroupValue,
                                      onChanged: (String? value) {
                                        setState(() {
                                          ServiceInfo.dentureGroupValue =
                                              value!;
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
                                        'C.C Plate',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      value: 'C.C Plate',
                                      groupValue: ServiceInfo.dentureGroupValue,
                                      onChanged: (String? value) {
                                        setState(() {
                                          ServiceInfo.dentureGroupValue =
                                              value!;
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
                      visible:
                          (ServiceInfo.selectedServiceID == 11) ? true : false,
                      child: Container(
                        width: 400.0,
                        margin: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            border: OutlineInputBorder(),
                            labelText: 'نوعیت',
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50.0)),
                                borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50.0)),
                                borderSide: BorderSide(color: Colors.blue)),
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
                                        'R.C.T',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      value: 'R.C.T',
                                      groupValue: ServiceInfo.crownGroupValue,
                                      onChanged: (String? value) {
                                        setState(() {
                                          ServiceInfo.crownGroupValue = value!;
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
                                        'Vital',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      value: 'Vital',
                                      groupValue: ServiceInfo.crownGroupValue,
                                      onChanged: (String? value) {
                                        setState(() {
                                          ServiceInfo.crownGroupValue = value!;
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
                      visible:
                          (ServiceInfo.selectedServiceID == 2) ? true : false,
                      child: Container(
                        margin: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                        width: 400.0,
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            border: OutlineInputBorder(),
                            labelText: 'نوعیت',
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50.0)),
                                borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50.0)),
                                borderSide: BorderSide(color: Colors.blue)),
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
                                        'R.C.T',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      value: 'R.C.T',
                                      groupValue: ServiceInfo.fillingGroupValue,
                                      onChanged: (String? value) {
                                        setState(() {
                                          ServiceInfo.fillingGroupValue =
                                              value!;
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
                                        'Operative',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      value: 'Operative',
                                      groupValue: ServiceInfo.fillingGroupValue,
                                      onChanged: (String? value) {
                                        setState(() {
                                          ServiceInfo.fillingGroupValue =
                                              value!;
                                        });
                                      }),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Visibility(
                      visible:
                          ServiceInfo.selectedServiceID == 11 ? true : false,
                      child: Container(
                        width: 400.0,
                        margin: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'نوعیت مواد پوش',
                            enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0)),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0)),
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            errorBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(50),
                              ),
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            errorText: ServiceInfo.defaultCrown == null ||
                                    ServiceInfo.defaultCrown ==
                                        'Please select a material'
                                ? 'Please select a material'
                                : null,
                          ),
                          child: DropdownButtonHideUnderline(
                            child: SizedBox(
                              height: 26.0,
                              child: DropdownButton<String>(
                                isExpanded: true,
                                icon: const Icon(Icons.arrow_drop_down),
                                value: ServiceInfo.defaultCrown,
                                items: [
                                  const DropdownMenuItem(
                                      value: null,
                                      child: Text('Please select a material')),
                                  ..._crownItems.map((String items) {
                                    return DropdownMenuItem<String>(
                                      value: items,
                                      alignment: Alignment.centerRight,
                                      child: Text(items),
                                    );
                                  }).toList(),
                                ],
                                onChanged: (String? newValue) {
                                  setState(() {
                                    if (newValue != null) {
                                      ServiceInfo.defaultCrown = newValue;
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
                      // ignore: unrelated_type_equality_checks
                      visible: (ServiceInfo.selectedServiceID == 9 &&
                              (ServiceInfo.dentureGroupValue == 'Full' ||
                                  ServiceInfo.dentureGroupValue == 'C.C Plate'))
                          ? true
                          : false,
                      child: Container(
                        width: 400.0,
                        margin: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'انتخاب فک',
                            enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50.0)),
                                borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50.0)),
                                borderSide: BorderSide(color: Colors.blue)),
                            errorText: ServiceInfo.defaultDentureValue == null
                                ? 'Please select a gum'
                                : null,
                            errorBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(50.0),
                              ),
                              borderSide: BorderSide(
                                  color: ServiceInfo.defaultDentureValue == null
                                      ? Colors.red
                                      : Colors.grey),
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: SizedBox(
                              height: 26.0,
                              child: DropdownButton<String>(
                                isExpanded: true,
                                icon: const Icon(Icons.arrow_drop_down),
                                value: ServiceInfo.defaultDentureValue,
                                items: [
                                  const DropdownMenuItem(
                                      value: null,
                                      child: Text('Please select a gum')),
                                  ..._dentureItems.map((String item) {
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
                                ],
                                onChanged: (String? newValue) {
                                  setState(() {
                                    if (newValue != null) {
                                      ServiceInfo.defaultDentureValue =
                                          newValue;
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
                      // ignore: unrelated_type_equality_checks
                      visible:
                          (ServiceInfo.selectedServiceID == 2) ? true : false,
                      child: Container(
                        width: 400.0,
                        margin: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'نوعیت مواد',
                            enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50.0)),
                                borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50.0)),
                                borderSide: BorderSide(color: Colors.blue)),
                            errorText: !ServiceInfo.fMaterialSelected
                                ? 'Please select filling material'
                                : null,
                            errorBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(50.0),
                              ),
                              borderSide: BorderSide(
                                  color: !ServiceInfo.fMaterialSelected
                                      ? Colors.red
                                      : Colors.grey),
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: SizedBox(
                              height: 26.0,
                              child: DropdownButton<String>(
                                isExpanded: true,
                                icon: const Icon(Icons.arrow_drop_down),
                                value: ServiceInfo.defaultFilling,
                                items: <DropdownMenuItem<String>>[
                                  const DropdownMenuItem(
                                    value: null,
                                    child: Text('Please select an item'),
                                  ),
                                  ...fillingItems.map((String item) {
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
                                ],
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      ServiceInfo.defaultFilling = newValue;
                                      ServiceInfo.fMaterialSelected = true;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      // ignore: unrelated_type_equality_checks
                      visible:
                          (ServiceInfo.selectedServiceID == 5) ? true : false,
                      child: Container(
                        width: 400.0,
                        margin: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'نوعیت ارتودانسی',
                            enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50.0)),
                                borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50.0)),
                                borderSide: BorderSide(color: Colors.blue)),
                            errorText: ServiceInfo.defaultOrthoType == null
                                ? 'Please select a gum'
                                : null,
                            errorBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(50.0),
                              ),
                              borderSide: BorderSide(
                                  color: ServiceInfo.defaultOrthoType == null
                                      ? Colors.red
                                      : Colors.grey),
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: SizedBox(
                              height: 26.0,
                              child: DropdownButton<String>(
                                isExpanded: true,
                                icon: const Icon(Icons.arrow_drop_down),
                                value: ServiceInfo.defaultOrthoType,
                                items: [
                                  const DropdownMenuItem(
                                    value: null,
                                    child: Text('Please select a gum'),
                                  ),
                                  ..._orthoItems.map((String item) {
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
                                ],
                                onChanged: (String? newValue) {
                                  setState(() {
                                    if (newValue != null) {
                                      ServiceInfo.defaultOrthoType = newValue;
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
                      // ignore: unrelated_type_equality_checks
                      visible:
                          (ServiceInfo.selectedServiceID == 7) ? true : false,
                      child: Container(
                        width: 400.0,
                        margin: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'نوعیت',
                            enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50.0)),
                                borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50.0)),
                                borderSide: BorderSide(color: Colors.blue)),
                            errorText: ServiceInfo.defaultMaxillo == null
                                ? 'Please select a type'
                                : null,
                            errorBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(50.0),
                              ),
                              borderSide: BorderSide(
                                  color: ServiceInfo.defaultMaxillo == null
                                      ? Colors.red
                                      : Colors.grey),
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: SizedBox(
                              height: 26.0,
                              child: DropdownButton<String>(
                                isExpanded: true,
                                icon: const Icon(Icons.arrow_drop_down),
                                value: ServiceInfo.defaultMaxillo,
                                items: [
                                  const DropdownMenuItem(
                                    value: null,
                                    child: Text('Please select a type'),
                                  ),
                                  ...maxilloItems.map((String item) {
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
                                  }).toList()
                                ],
                                onChanged: (String? newValue) {
                                  setState(() {
                                    if (newValue != null) {
                                      ServiceInfo.defaultMaxillo = newValue;
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
                      visible: (ServiceInfo.defaultMaxillo == 'T.M.J' &&
                              ServiceInfo.selectedServiceID == 7)
                          ? true
                          : false,
                      child: Container(
                        width: 400.0,
                        margin: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
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
                                        'راست',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      value: 'راست',
                                      groupValue: ServiceInfo.tmgGroupValue,
                                      onChanged: (String? value) {
                                        setState(() {
                                          ServiceInfo.tmgGroupValue = value!;
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
                                        'چپ',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      value: 'چپ',
                                      groupValue: ServiceInfo.tmgGroupValue,
                                      onChanged: (String? value) {
                                        setState(() {
                                          ServiceInfo.tmgGroupValue = value!;
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
                                        'هردو',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      value: 'هردو',
                                      groupValue: ServiceInfo.tmgGroupValue,
                                      onChanged: (String? value) {
                                        setState(() {
                                          ServiceInfo.tmgGroupValue = value!;
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
                      visible:
                          (ServiceInfo.selectedServiceID == 4) ? true : false,
                      child: Container(
                        width: 400.0,
                        margin: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
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
                                        'Scaling',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      value: 'Scaling',
                                      groupValue: ServiceInfo.spGroupValue,
                                      onChanged: (String? value) {
                                        setState(() {
                                          ServiceInfo.spGroupValue = value!;
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
                                        'Polishing',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      value: 'Polishing',
                                      groupValue: ServiceInfo.spGroupValue,
                                      onChanged: (String? value) {
                                        setState(() {
                                          ServiceInfo.spGroupValue = value!;
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
                                        'Both',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      value: 'Both',
                                      groupValue: ServiceInfo.spGroupValue,
                                      onChanged: (String? value) {
                                        setState(() {
                                          ServiceInfo.spGroupValue = value!;
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
                      visible:
                          ServiceInfo.selectedServiceID == 3 ? true : false,
                      child: Container(
                        width: 400.0,
                        margin: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'مراحل سفید کردن',
                            enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0)),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0)),
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            errorText: ServiceInfo.defaultBleachValue == null
                                ? 'Please select a bleaching level'
                                : null,
                            errorBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(50.0),
                              ),
                              borderSide: BorderSide(
                                  color: ServiceInfo.defaultBleachValue == null
                                      ? Colors.red
                                      : Colors.grey),
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: SizedBox(
                              height: 26.0,
                              child: DropdownButton<String>(
                                isExpanded: true,
                                icon: const Icon(Icons.arrow_drop_down),
                                value: ServiceInfo.defaultBleachValue,
                                items: [
                                  const DropdownMenuItem(
                                    value: null,
                                    child: Text('Please select a level'),
                                  ),
                                  ..._bleachingItems.map((item) {
                                    return DropdownMenuItem<String>(
                                      value: item,
                                      alignment: Alignment.centerRight,
                                      child: Text(item),
                                    );
                                  }).toList(),
                                ],
                                onChanged: (String? newValue) {
                                  setState(() {
                                    if (newValue != null) {
                                      ServiceInfo.defaultBleachValue = newValue;
                                      ServiceInfo.levelSelected = true;
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 400.0,
                      margin: const EdgeInsets.all(15.0),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'انتخاب داکتر',
                          labelStyle: TextStyle(color: Colors.blueAccent),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0)),
                              borderSide: BorderSide(color: Colors.blueAccent)),
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
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1.5)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.025,
                            padding: EdgeInsets.zero,
                            child: DropdownButton<String>(
                              isExpanded: true,
                              icon: const Icon(Icons.arrow_drop_down),
                              value: ServiceInfo.selectedDentistID.toString(),
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
                                  ServiceInfo.selectedDentistID =
                                      int.parse(newValue!);
                                });
                              },
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
                    ),
                  ],
                ),
              ],
            ),
            Visibility(
              visible: (ServiceInfo.selectedServiceID == 1 ||
                      ServiceInfo.selectedServiceID == 2 ||
                      ServiceInfo.selectedServiceID == 11 ||
                      ServiceInfo.selectedServiceID == 15 ||
                      (ServiceInfo.selectedServiceID == 7 &&
                          ServiceInfo.defaultMaxillo == 'Tooth Extraction') ||
                      (ServiceInfo.selectedServiceID == 7 &&
                          ServiceInfo.defaultMaxillo == 'Abscess Treatment') ||
                      (ServiceInfo.selectedServiceID == 7 &&
                          ServiceInfo.defaultMaxillo ==
                              'Tooth Reimplantation') ||
                      (ServiceInfo.selectedServiceID == 9 &&
                          ServiceInfo.dentureGroupValue == 'Partial'))
                  ? true
                  : false,
              child: Container(
                margin: const EdgeInsets.only(top: 20),
                width: (ServiceInfo.patAge <= 13) ? 470 : 770,
                height: 300,
                child: (ServiceInfo.patAge <= 13)
                    ? const ChildQuadrantGrid()
                    : const AdultQuadrantGrid(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Static class
class ServiceInfo {
  static int? selectedDentistID;
  static int? selectedServiceID;
  // This age is essential for teeth selection chart switch
  static int patAge = 1;
  static String? defaultOrthoType;
  static String? defaultCrown;
  static String? defaultGumAbscess;
  static String? defaultFilling;
  static String? defaultMaxillo;
  static String? defaultBleachValue;
  static bool levelSelected = false;
  static String? defaultDentureValue;
  static bool fMaterialSelected = false;
  // Radio Buttons
  static String crownGroupValue = 'R.C.T';
  static String fillingGroupValue = 'R.C.T';
  static String tmgGroupValue = 'راست';
  static String spGroupValue = 'Scaling';
  static String dentureGroupValue = 'Full';
  // Text Fields
  static String? meetingDate;
  static String? serviceNote;
}

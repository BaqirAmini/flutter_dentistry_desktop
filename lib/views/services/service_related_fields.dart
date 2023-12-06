import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dentistry/config/language_provider.dart';
import 'package:flutter_dentistry/models/db_conn.dart';
import 'package:flutter_dentistry/views/patients/adult_coordinate_system.dart';
import 'package:flutter_dentistry/views/patients/child_coordinate_system.dart';
import 'package:intl/intl.dart' as intl2;
import 'package:provider/provider.dart';

void main() => runApp(const CustomForm());

// Set global variables which are needed later.
var selectedLanguage;
bool isEnglish = false;

class CustomForm extends StatelessWidget {
  const CustomForm({super.key});

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
//  پوش کردن دندان
  String? _defaultCrown;
  final List<String> _crownItems = [
    'Porcelain',
    'Metal-Porcelain',
    'CAD CAM',
    'Zirconia',
    'Mital',
    'Gold',
    'وسایر'
  ];

  //  پرکاری دندان
  String? defaultFilling;
  bool _fMaterialSelected = false;
  List<String> fillingItems = [
    'Amalgam',
    'Silicate',
    'Composite',
    'G.C (Glass Inomir)',
    'وسایر',
  ];

  // ارتودانسی
  String? _defaultOrthoType;
  final List<String> _orthoItems = [
    'فک بالا',
    'فک پایین',
    'هردو فک',
    'بستن دیاستم وسطی'
  ];

// MaxilloFacial وجه فک
  String? defaultMaxillo;
  List<String> maxilloItems = [
    'Tooth Extraction',
    'Abscess Treatment',
    'T.M.J',
    'Tooth Reimplantation',
    'Jaw Fracture Fixation'
  ];

// Gum selection for Abscess treatment
  String? defaultGumAbscess;
  List<String> abscessItems = ['فک بالا', 'فک پایین', 'هردو'];

  // Bleaching
  String? _defaultBleachValue;
  bool _levelSelected = false;
  final List<String> _bleachingItems = ['یک مرحله', 'دو مرحله', 'سه مرحله'];

  // Select gums for Denture
  String? _defaultDentureValue;
  final List<String> _dentureItems = ['فک بالا', 'فک پایین', 'هردو'];

  String? selectedSerId;
  List<Map<String, dynamic>> services = [];

  @override
  void initState() {
    super.initState();
    fetchServices();
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
  int ageDropDown = 0;
  final _meetController = TextEditingController();
  final _noteController = TextEditingController();
  final _regExOnlyAbc = "[a-zA-Z,، \u0600-\u06FFF]";
  final _regExOnlydigits = "[0-9+]";
  final _regExDecimal = "[0-9.]";

  // Radio Buttons
  String _crownGroupValue = 'R.C.T';
  String _fillingGroupValue = 'R.C.T';
  String _abscessTreatValue = 'راست';
  String _tmgGroupValue = 'راست';
  String _sexGroupValue = 'مرد';
  String _spGroupValue = 'Scaling';
  String _dentureGroupValue = 'Full';

  @override
  Widget build(BuildContext context) {
    // Fetch translations keys based on the selected language.
    /*  var languageProvider = Provider.of<LanguageProvider>(context);
    selectedLanguage = languageProvider.selectedLanguage;
    isEnglish = selectedLanguage == 'English'; */
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Testing'),
        ),
        body: Center(
          child: Form(
            key: widget.formKey,
            child: Center(
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
                                          listTileTheme: const ListTileThemeData(
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
                                          listTileTheme: const ListTileThemeData(
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
                            visible: (selectedSerId == '7' &&
                                    defaultMaxillo == 'Abscess Treatment')
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
                                  errorText: defaultGumAbscess == null
                                      ? 'Please select a gum'
                                      : null,
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(50.0),
                                    ),
                                    borderSide: BorderSide(
                                        color: defaultGumAbscess == null
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
                                      value: defaultGumAbscess,
                                      items: [
                                        const DropdownMenuItem(
                                          value: null,
                                          child: Text('Please select a gum'),
                                        ),
                                        ...abscessItems.map((item) {
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
                                            defaultGumAbscess = newValue;
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Visibility(
                            visible: selectedSerId == '11' ? true : false,
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
                                  errorText: _defaultCrown == null ||
                                          _defaultCrown ==
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
                                      value: _defaultCrown,
                                      items: [
                                        const DropdownMenuItem(
                                            value: null,
                                            child:
                                                Text('Please select a material')),
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
                                            _defaultCrown = newValue;
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
                                          listTileTheme: const ListTileThemeData(
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
                                          listTileTheme: const ListTileThemeData(
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
                                  errorText: _defaultDentureValue == null
                                      ? 'Please select a gum'
                                      : null,
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(50.0),
                                    ),
                                    borderSide: BorderSide(
                                        color: _defaultDentureValue == null
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
                                      value: _defaultDentureValue,
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
                                            _defaultDentureValue = newValue;
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
                            visible: (selectedSerId == '2') ? true : false,
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
                                  labelText: 'نوعیت مواد',
                                  enabledBorder: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50.0)),
                                      borderSide: BorderSide(color: Colors.grey)),
                                  focusedBorder: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50.0)),
                                      borderSide: BorderSide(color: Colors.blue)),
                                  errorText: !_fMaterialSelected
                                      ? 'Please select filling material'
                                      : null,
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(50.0),
                                    ),
                                    borderSide: BorderSide(
                                        color: !_fMaterialSelected
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
                                      value: defaultFilling,
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
                                            defaultFilling = newValue;
                                            _fMaterialSelected = true;
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
                            visible: (selectedSerId == '5') ? true : false,
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
                                  labelText: 'نوعیت ارتودانسی',
                                  enabledBorder: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50.0)),
                                      borderSide: BorderSide(color: Colors.grey)),
                                  focusedBorder: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50.0)),
                                      borderSide: BorderSide(color: Colors.blue)),
                                  errorText: _defaultOrthoType == null
                                      ? 'Please select a gum'
                                      : null,
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(50.0),
                                    ),
                                    borderSide: BorderSide(
                                        color: _defaultOrthoType == null
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
                                      value: _defaultOrthoType,
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
                                            _defaultOrthoType = newValue;
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
                            visible: (selectedSerId == '7') ? true : false,
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
                                  labelText: 'نوعیت',
                                  enabledBorder: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50.0)),
                                      borderSide: BorderSide(color: Colors.grey)),
                                  focusedBorder: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50.0)),
                                      borderSide: BorderSide(color: Colors.blue)),
                                  errorText: defaultMaxillo == null
                                      ? 'Please select a type'
                                      : null,
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(50.0),
                                    ),
                                    borderSide: BorderSide(
                                        color: defaultMaxillo == null
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
                                      value: defaultMaxillo,
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
                                            defaultMaxillo = newValue;
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
                            visible: (selectedSerId == '7' &&
                                    defaultMaxillo == 'Abscess Treatment')
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
                                          listTileTheme: const ListTileThemeData(
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
                                          listTileTheme: const ListTileThemeData(
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
                                          listTileTheme: const ListTileThemeData(
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
                                          listTileTheme: const ListTileThemeData(
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
                                          listTileTheme: const ListTileThemeData(
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
                                          listTileTheme: const ListTileThemeData(
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
                            visible: selectedSerId == '3' ? true : false,
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
                                  errorText: _defaultBleachValue == null
                                      ? 'Please select a bleaching level'
                                      : null,
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(50.0),
                                    ),
                                    borderSide: BorderSide(
                                        color: _defaultBleachValue == null
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
                                      value: _defaultBleachValue,
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
                                            _defaultBleachValue = newValue;
                                            _levelSelected = true;
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
                            (selectedSerId == '7' &&
                                defaultMaxillo == 'Tooth Extraction') ||
                            (selectedSerId == '7' &&
                                defaultMaxillo == 'Tooth Reimplantation') ||
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
    );
  }
}

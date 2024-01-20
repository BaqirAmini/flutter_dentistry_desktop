// ignore_for_file: prefer_const_constructors
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dentistry/config/language_provider.dart';
import 'package:flutter_dentistry/config/translations.dart';
import 'package:flutter_dentistry/models/db_conn.dart';
import 'package:flutter_dentistry/views/staff/staff.dart';
import 'package:flutter_dentistry/views/staff/staff_info.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as intl2;
import 'package:path/path.dart' as p;

void main() {
  return runApp(const NewStaffForm());
}

class NewStaffForm extends StatefulWidget {
  const NewStaffForm({Key? key}) : super(key: key);

  @override
  State<NewStaffForm> createState() => _NewStaffFormState();
}

// ignore: prefer_typing_uninitialized_variables
var languageProvider;
// ignore: prefer_typing_uninitialized_variables
var selectedLanguage;

class _NewStaffFormState extends State<NewStaffForm> {
// The global for the form
  final _newStaffFormKey = GlobalKey<FormState>();
// The text editing controllers for the TextFormFields
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _familyPhone1Controller = TextEditingController();
  final _familyPhone2Controller = TextEditingController();
  final _salaryController = TextEditingController();
  final _prepaymentController = TextEditingController();
  final _tazkiraController = TextEditingController();
  final _addressController = TextEditingController();
  final _hireDateController = TextEditingController();
  File? _selectedContractFile;
  bool _isLoadingFile = false;
  final _contractFileMessage = ValueNotifier<String>('');

  final _regExOnlyAbc = "[a-zA-Z,-، \u0600-\u06FFF]";
  final _regExOnlydigits = "[0-9+]";
  final _tazkiraPattern = RegExp(r'^\d{4}-\d{4}-\d{5}$');
  bool _isIntern = false;

  void onShowSnackBar(String content) {
    final snackbar = SnackBar(
      content: Center(
        child: Text(
          content,
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    // Fetch translations keys based on the selected language.
    languageProvider = Provider.of<LanguageProvider>(context);
    selectedLanguage = languageProvider.selectedLanguage;
    var isEnglish = selectedLanguage == 'English';

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _newStaffFormKey,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      translations[selectedLanguage]?['StaffRegMsg'] ?? '',
                      style:
                          TextStyle(color: Color.fromARGB(255, 133, 133, 133)),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      '* نماینگر فیلد (خانه) های الزامی میباشد.',
                      style: TextStyle(color: Colors.red, fontSize: 12.0),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  right: MediaQuery.of(context).size.width *
                                      0.007),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    '*',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.31,
                                    margin: const EdgeInsets.only(
                                        left: 20.0,
                                        right: 10.0,
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
                                                  ?['FNRequired'] ??
                                              '';
                                        } else if (value.length < 3) {
                                          return translations[selectedLanguage]
                                                  ?['FNLength'] ??
                                              '';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText:
                                            translations[selectedLanguage]
                                                    ?['FName'] ??
                                                '',
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
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.31,
                              margin: const EdgeInsets.only(
                                  left: 20.0,
                                  right: 20.0,
                                  top: 10.0,
                                  bottom: 10.0),
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: translations[selectedLanguage]
                                          ?['Position'] ??
                                      '',
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
                                child: DropdownButtonHideUnderline(
                                  child: SizedBox(
                                    height: 26.0,
                                    child: DropdownButton(
                                      isExpanded: true,
                                      icon: const Icon(Icons.arrow_drop_down),
                                      value: StaffInfo.staffDefaultPosistion,
                                      items: StaffInfo.staffPositionItems
                                          .map((String positionItems) {
                                        return DropdownMenuItem(
                                          value: positionItems,
                                          alignment: Alignment.centerRight,
                                          child: Text(positionItems),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          StaffInfo.staffDefaultPosistion =
                                              newValue!;
                                          _isIntern = newValue == 'کار آموز'
                                              ? true
                                              : false;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  right: MediaQuery.of(context).size.width *
                                      0.007),
                              child: Row(
                                children: [
                                  const Text(
                                    '*',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.31,
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
                                            return translations[
                                                        selectedLanguage]
                                                    ?['Phone10'] ??
                                                '';
                                          }
                                        } else if (value.startsWith('+93')) {
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
                                      // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText:
                                            translations[selectedLanguage]
                                                    ?['Phone'] ??
                                                '',
                                        suffixIcon: Icon(Icons.phone),
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
                            Container(
                              margin: EdgeInsets.only(
                                  right: MediaQuery.of(context).size.width *
                                      0.007),
                              child: Row(
                                children: [
                                  const Text(
                                    '*',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.31,
                                    margin: const EdgeInsets.only(
                                        left: 20.0,
                                        right: 10.0,
                                        top: 10.0,
                                        bottom: 10.0),
                                    child: TextFormField(
                                      textDirection: TextDirection.ltr,
                                      controller: _familyPhone1Controller,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                          RegExp(_regExOnlydigits),
                                        ),
                                      ],
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'این نمبر تماس عضوی فامیل نمی تواند خالی باشد.';
                                        } else if (value.startsWith('07')) {
                                          if (value.length < 10 ||
                                              value.length > 10) {
                                            return translations[
                                                        selectedLanguage]
                                                    ?['Phone10'] ??
                                                '';
                                          }
                                        } else if (value.startsWith('+93')) {
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
                                      // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'نمبر تماس عضو فامیل (1)',
                                        suffixIcon: Icon(Icons.phone),
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
                            Container(
                              width: MediaQuery.of(context).size.width * 0.31,
                              margin: const EdgeInsets.only(
                                  left: 20.0,
                                  right: 20.0,
                                  top: 10.0,
                                  bottom: 10.0),
                              child: TextFormField(
                                textDirection: TextDirection.ltr,
                                controller: _familyPhone2Controller,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(_regExOnlydigits),
                                  ),
                                ],
                                validator: (value) {
                                  if (value!.isNotEmpty) {
                                    if (value.startsWith('07')) {
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
                                  }
                                  return null;
                                },
                                // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'نمبر تماس عضو فامیل (2)',
                                  suffixIcon: Icon(Icons.phone),
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
                              width: MediaQuery.of(context).size.width * 0.31,
                              margin: const EdgeInsets.only(
                                  left: 20.0,
                                  right: 20.0,
                                  top: 10.0,
                                  bottom: 10.0),
                              child: TextFormField(
                                controller: _salaryController,
                                validator: (value) {
                                  if (value!.isNotEmpty) {
                                    final salary = double.tryParse(value);
                                    if (salary! < 1000 || salary > 100000) {
                                      return translations[selectedLanguage]
                                              ?['ValidSalary'] ??
                                          '';
                                    }
                                  }
                                  return null;
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9.]'))
                                ],
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: translations[selectedLanguage]
                                          ?['Salary'] ??
                                      '',
                                  suffixIcon: Icon(Icons.money),
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
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.31,
                              margin: const EdgeInsets.only(
                                  left: 20.0,
                                  right: 20.0,
                                  top: 10.0,
                                  bottom: 10.0),
                              child: TextFormField(
                                controller: _lastNameController,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(_regExOnlyAbc),
                                  ),
                                ],
                                validator: (value) {
                                  if (value!.isNotEmpty) {
                                    if (value.length < 3 || value.length > 10) {
                                      return translations[selectedLanguage]
                                              ?['LNLength'] ??
                                          '';
                                    } else {
                                      return null;
                                    }
                                  } else {
                                    return null;
                                  }
                                },
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: translations[selectedLanguage]
                                          ?['LName'] ??
                                      '',
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
                            Container(
                              margin: EdgeInsets.only(
                                  right: MediaQuery.of(context).size.width *
                                      0.005),
                              child: Row(
                                children: [
                                  const Text(
                                    '*',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.307,
                                    margin: const EdgeInsets.only(
                                        left: 20.0,
                                        right: 20.0,
                                        top: 10.0,
                                        bottom: 10.0),
                                    child: TextFormField(
                                      controller: _hireDateController,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'لطفا تاریخ استخدام کارمند را انتخاب کنید.';
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
                                          _hireDateController.text =
                                              formattedDate;
                                        }
                                      },
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9.]'))
                                      ],
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'تاریخ استخدام',
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
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.31,
                              margin: const EdgeInsets.only(
                                  left: 20.0,
                                  right: 20.0,
                                  top: 10.0,
                                  bottom: 10.0),
                              child: TextFormField(
                                enabled: _isIntern ? true : false,
                                controller: _prepaymentController,
                                validator: !_isIntern
                                    ? null
                                    : (value) {
                                        if (value!.isEmpty) {
                                          return 'پول ضمانت نمی تواند خالی باشد.';
                                        }
                                        return null;
                                      },
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9.]'))
                                ],
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'مقدار پول بطور ضمانت',
                                  suffixIcon: Icon(Icons.money),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50.0)),
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                  disabledBorder: OutlineInputBorder(
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
                              width: MediaQuery.of(context).size.width * 0.31,
                              margin: const EdgeInsets.only(
                                  left: 20.0,
                                  right: 20.0,
                                  top: 10.0,
                                  bottom: 10.0),
                              child: TextFormField(
                                controller: _tazkiraController,
                                validator: (value) {
                                  if (value!.isNotEmpty) {
                                    if (!_tazkiraPattern.hasMatch(value)) {
                                      return translations[selectedLanguage]
                                              ?['ValidTazkira'] ??
                                          '';
                                    }
                                  }
                                  return null;
                                },
                                // keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9-]'),
                                  ),
                                ],
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: translations[selectedLanguage]
                                          ?['Tazkira'] ??
                                      '',
                                  suffixIcon: Icon(Icons.perm_identity),
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
                              width: MediaQuery.of(context).size.width * 0.31,
                              margin: const EdgeInsets.only(
                                  left: 20.0,
                                  right: 20.0,
                                  top: 10.0,
                                  bottom: 10.0),
                              child: TextFormField(
                                controller: _addressController,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(_regExOnlyAbc),
                                  ),
                                ],
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: translations[selectedLanguage]
                                          ?['Address'] ??
                                      '',
                                  suffixIcon: Icon(Icons.location_on_outlined),
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                        width: 1.0,
                                        color: _selectedContractFile == null
                                            ? Colors.red
                                            : Colors.blue),
                                  ),
                                  margin: const EdgeInsets.all(5.0),
                                  padding: EdgeInsets.all(8.0),
                                  width:
                                      MediaQuery.of(context).size.width * 0.31,
                                  child: InkWell(
                                      onTap: () async {
                                        setState(() {
                                          _isLoadingFile = true;
                                        });

                                        final result = await FilePicker.platform
                                            .pickFiles(
                                                allowMultiple: true,
                                                type: FileType.custom,
                                                allowedExtensions: [
                                              'jpg',
                                              'jpeg',
                                              'png',
                                              'pdf',
                                              'docx'
                                            ]);
                                        if (result != null) {
                                          setState(() {
                                            _isLoadingFile = false;
                                            _selectedContractFile = File(result
                                                .files.single.path
                                                .toString());
                                          });
                                        }
                                      },
                                      child: _selectedContractFile == null &&
                                              !_isLoadingFile
                                          ? const Icon(Icons.add,
                                              size: 30, color: Colors.blue)
                                          : _isLoadingFile
                                              ? const Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                          strokeWidth: 3.0))
                                              : Center(
                                                  child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    p.basename(
                                                        _selectedContractFile!
                                                            .path),
                                                    style: TextStyle(
                                                        fontSize: 12.0),
                                                  ),
                                                ))),
                                ),
                                if (_selectedContractFile == null && !_isIntern)
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Text(
                                        'لطفاً قرارداد خط را انتخاب کنید.',
                                        style: TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 12.0)),
                                  ),
                                ValueListenableBuilder<String>(
                                  valueListenable: _contractFileMessage,
                                  builder: (context, value, child) {
                                    if (value.isEmpty) {
                                      return const SizedBox
                                          .shrink(); // or Container()
                                    } else {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          child: Text(
                                            value,
                                            style: const TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.redAccent),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.32,
                    margin: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        side: const BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      onPressed: () async {
                        String? fileType;
                        String fname = _nameController.text;
                        String lname = _lastNameController.text;
                        String pos = StaffInfo.staffDefaultPosistion;
                        double salary = 0;
                        String phone = _phoneController.text;
                        String tazkira = _tazkiraController.text;
                        String addr = _addressController.text;
                        if (_salaryController.text.isEmpty) {
                          salary = 0;
                        } else {
                          salary = double.parse(_salaryController.text);
                        }
                        String hireDate = _hireDateController.text;
                        double prePaidAmount =
                            _prepaymentController.text.isEmpty
                                ? 0
                                : double.parse(_prepaymentController.text);
                        String familyPhone1 = _familyPhone1Controller.text;
                        String? familyPhone2 =
                            _familyPhone2Controller.text.isEmpty
                                ? null
                                : _familyPhone2Controller.text;
                        Uint8List? contractFile;
                        if (_selectedContractFile != null) {
                          contractFile =
                              await _selectedContractFile!.readAsBytes();
                          fileType = p.extension(_selectedContractFile!.path);
                        }
                        try {
                          final conn = await onConnToDb();
                          if (!_isIntern) {
                            if (_newStaffFormKey.currentState!.validate() &&
                                _selectedContractFile != null) {
                              if (contractFile!.length > 1024 * 1024) {
                                _contractFileMessage.value =
                                    'اندازه این فایل باید 1 میگابایت یا کمتر باشد.';
                              } else if (_selectedContractFile == null) {
                                _contractFileMessage.value =
                                    'لطفاً قرارداد خط را انتخاب کنید.';
                              } else {
                                await conn.query(
                                    'INSERT INTO staff (firstname, lastname, hire_date, position, salary, prepayment, phone, family_phone1, family_phone2, contract_file, file_type, tazkira_ID, address) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
                                    [
                                      fname,
                                      lname,
                                      hireDate,
                                      pos,
                                      salary,
                                      prePaidAmount,
                                      phone,
                                      familyPhone1,
                                      familyPhone2,
                                      contractFile,
                                      fileType,
                                      tazkira,
                                      addr
                                    ]);
                                Navigator.of(context).pop();
                                await conn.close();
                              }
                            }
                          } else {
                            if (_selectedContractFile != null) {
                              if (_newStaffFormKey.currentState!.validate() &&
                                  _selectedContractFile != null) {
                                if (contractFile!.length > 1024 * 1024) {
                                  _contractFileMessage.value =
                                      'اندازه این فایل باید 1 میگابایت یا کمتر باشد.';
                                } else {
                                  await conn.query(
                                      'INSERT INTO staff (firstname, lastname, hire_date, position, salary, prepayment, phone, family_phone1, family_phone2, contract_file, file_type, tazkira_ID, address) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
                                      [
                                        fname,
                                        lname,
                                        hireDate,
                                        pos,
                                        salary,
                                        prePaidAmount,
                                        phone,
                                        familyPhone1,
                                        familyPhone2,
                                        contractFile,
                                        fileType,
                                        tazkira,
                                        addr
                                      ]);
                                  Navigator.of(context).pop();
                                  await conn.close();
                                }
                              }
                            } else {
                              if (_newStaffFormKey.currentState!.validate()) {
                                await conn.query(
                                    'INSERT INTO staff (firstname, lastname, hire_date, position, salary, prepayment, phone, family_phone1, family_phone2, tazkira_ID, address) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
                                    [
                                      fname,
                                      lname,
                                      hireDate,
                                      pos,
                                      salary,
                                      prePaidAmount,
                                      phone,
                                      familyPhone1,
                                      familyPhone2,
                                      tazkira,
                                      addr
                                    ]);
                                Navigator.of(context).pop();
                                await conn.close();
                              }
                            }
                          }
                        } catch (e) {
                          print('(1) Inserting staff failed. $e');
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            translations[selectedLanguage]?['AddBtn'] ?? ''),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

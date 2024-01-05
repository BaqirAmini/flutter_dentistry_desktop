// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dentistry/config/language_provider.dart';
import 'package:flutter_dentistry/config/translations.dart';
import 'package:flutter_dentistry/models/db_conn.dart';
import 'package:provider/provider.dart';

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
  // position types dropdown variables
  String positionDropDown = 'داکتر دندان';
  var positionItems = [
    'داکتر دندان',
    'نرس',
    'مدیر سیستم',
  ];
// The global for the form
  final _newStaffFormKey = GlobalKey<FormState>();
// The text editing controllers for the TextFormFields
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _salaryController = TextEditingController();
  final _tazkiraController = TextEditingController();
  final _addressController = TextEditingController();

  final _regExOnlyAbc = "[a-zA-Z,، \u0600-\u06FFF]";
  final _regExOnlydigits = "[0-9+]";
  final _tazkiraPattern = RegExp(r'^\d{4}-\d{4}-\d{5}$');

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

    return SingleChildScrollView(
      child: Center(
        child: Form(
          key: _newStaffFormKey,
          child: SizedBox(
            width: 500.0,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    translations[selectedLanguage]?['StaffRegMsg'] ?? '',
                    style: TextStyle(color: Color.fromARGB(255, 133, 133, 133)),
                  ),
                ),
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
                        return translations[selectedLanguage]?['FNRequired'] ??
                            '';
                      } else if (value.length < 3) {
                        return translations[selectedLanguage]?['FNLength'] ??
                            '';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: translations[selectedLanguage]?['FName'] ?? '',
                      suffixIcon: Icon(Icons.person),
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
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
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
                          return translations[selectedLanguage]?['LNLength'] ??
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
                      labelText: translations[selectedLanguage]?['LName'] ?? '',
                      suffixIcon: Icon(Icons.person),
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
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText:
                          translations[selectedLanguage]?['Position'] ?? '',
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
                    child: DropdownButtonHideUnderline(
                      child: SizedBox(
                        height: 26.0,
                        child: DropdownButton(
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down),
                          value: positionDropDown,
                          items: positionItems.map((String positionItems) {
                            return DropdownMenuItem(
                              value: positionItems,
                              alignment: Alignment.centerRight,
                              child: Text(positionItems),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              positionDropDown = newValue!;
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
                        return translations[selectedLanguage]
                                ?['PhoneRequired'] ??
                            '';
                      } else if (value.startsWith('07')) {
                        if (value.length < 10 || value.length > 10) {
                          return translations[selectedLanguage]?['Phone10'] ??
                              '';
                        }
                      } else if (value.startsWith('+93')) {
                        if (value.length < 12 || value.length > 12) {
                          return translations[selectedLanguage]?['Phone12'] ??
                              '';
                        }
                      } else {
                        return translations[selectedLanguage]?['ValidPhone'] ??
                            '';
                      }
                      return null;
                    },
                    // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: translations[selectedLanguage]?['Phone'] ?? '',
                      suffixIcon: Icon(Icons.phone),
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
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
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
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                    ],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText:
                          translations[selectedLanguage]?['Salary'] ?? '',
                      suffixIcon: Icon(Icons.money),
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
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
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
                      labelText:
                          translations[selectedLanguage]?['Tazkira'] ?? '',
                      suffixIcon: Icon(Icons.perm_identity),
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
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                  child: TextFormField(
                    controller: _addressController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(_regExOnlyAbc),
                      ),
                    ],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText:
                          translations[selectedLanguage]?['Address'] ?? '',
                      suffixIcon: Icon(Icons.location_on_outlined),
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
                  ),
                ),
                Container(
                  width: 400.0,
                  height: 35.0,
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
                      String fname = _nameController.text;
                      String lname = _lastNameController.text;
                      String pos = positionDropDown;
                      double salary = 0;
                      String phone = _phoneController.text;
                      String tazkira = _tazkiraController.text;
                      String addr = _addressController.text;
                      if (_salaryController.text.isEmpty) {
                        salary = 0;
                      } else {
                        salary = double.parse(_salaryController.text);
                      }

                      if (_newStaffFormKey.currentState!.validate()) {
                        try {
                          final conn = await onConnToDb();
                          var query = await conn.query(
                              'INSERT INTO staff (firstname, lastname, position, salary, phone, tazkira_ID, address) VALUES (?, ?, ?, ?, ?, ?, ?)',
                              [
                                fname,
                                lname,
                                pos,
                                salary,
                                phone,
                                tazkira,
                                addr
                              ]);
                          if (query.affectedRows! > 0) {
                            onShowSnackBar(translations[selectedLanguage]
                                    ?['StaffRegSuccess'] ??
                                '');
                            _nameController.clear();
                            _lastNameController.clear();
                            _salaryController.clear();
                            _phoneController.clear();
                            _tazkiraController.clear();
                            _addressController.clear();
                          } else {
                            print('Inserting staff failed!');
                          }
                          await conn.close();
                        } on SocketException {
                          onShowSnackBar('Database not found.');
                        }
                      }
                    },
                    child:
                        Text(translations[selectedLanguage]?['AddBtn'] ?? ''),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

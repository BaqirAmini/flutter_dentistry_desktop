// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dentistry/models/db_conn.dart';

class NewStaffForm extends StatefulWidget {
  const NewStaffForm({super.key});

  @override
  State<NewStaffForm> createState() => _NewStaffFormState();
}

class _NewStaffFormState extends State<NewStaffForm> {
  // position types dropdown variables
  String positionDropDown = 'داکتر دندان';
  var positionItems = [
    'داکتر دندان',
    'نرس',
    'مدیر سیستم',
  ];
// The global for the form
  final _formKey = GlobalKey<FormState>();
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
      backgroundColor: Colors.blue,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Form(
          key: _formKey,
          child: SizedBox(
            width: 500.0,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20.0),
                  child: const Text(
                    'لطفا معلومات مرتبط به کارمند را در فورمهای ذیل با دقت درج نمایید.',
                    style: TextStyle(color: Color.fromARGB(255, 133, 133, 133)),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                  child: TextFormField(
                    controller: _nameController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(_regExOnlyAbc),
                      ),
                    ],
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'نام الزامی است.';
                      } else if (value.length < 3) {
                        return 'نام باید حداقل 3 حرف باشد.';
                      }
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'نام',
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
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
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
                          return 'تخلص باید از سه الی ده حرف باشد.';
                        } else {
                          return null;
                        }
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'تخلص',
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
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'عنوان وظیفه',
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
                      child: Container(
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
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
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
                    // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'نمبر تماس',
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
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                  child: TextFormField(
                    controller: _salaryController,
                    validator: (value) {
                      if (value!.isNotEmpty) {
                        final salary = double.tryParse(value!);
                        if (salary! < 1000 || salary > 100000) {
                          return 'مقدار معاش باید بین 1000 افغانی و 100,000 افغانی باشد.';
                        }
                      }
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                    ],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'مقدار معاش',
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
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                  child: TextFormField(
                    controller: _tazkiraController,
                    validator: (value) {
                      if (value!.isNotEmpty) {
                        if (!_tazkiraPattern.hasMatch(value)) {
                          return 'فورمت نمبر تذکره باید xxxx-xxxx-xxxxx باشد.';
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
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'نمبر تذکره',
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
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                  child: TextFormField(
                    controller: _addressController,
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
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
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

                      if (_formKey.currentState!.validate()) {
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
                            onShowSnackBar('کارمند موفقانه اضافه شد.');
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
                        } on SocketException catch (e) {
                          onShowSnackBar('Database not found.');
                        }
                      }
                    },
                    child: const Text('ثبت کردن'),
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

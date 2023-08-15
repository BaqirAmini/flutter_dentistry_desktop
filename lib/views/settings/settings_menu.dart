// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:flutter_dentistry/views/staff/staff_info.dart';
import 'package:flutter_dentistry/models/db_conn.dart';
import 'package:galileo_mysql/galileo_mysql.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart' as INTL;
import 'package:csv/csv.dart';

FilePickerResult? filePickerResult;
File? pickedFile;

// Create the global key at the top level of your Dart file
final GlobalKey<ScaffoldMessengerState> _globalKeyForProfile =
    GlobalKey<ScaffoldMessengerState>();

// This is shows snackbar when called
void _onShowSnack(Color backColor, String msg) {
  _globalKeyForProfile.currentState?.showSnackBar(
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

class SettingsMenu extends StatefulWidget {
  const SettingsMenu({super.key});

  @override
  State<SettingsMenu> createState() => _SettingsMenuState();
}

class _SettingsMenuState extends State<SettingsMenu> {
  // Declare this method for refreshing UI of staff info
  void _onUpdate() {
    setState(() {});
  }

  int _selectedIndex = 1;
  @override
  Widget build(BuildContext context) {
    // Assign the method declared above to static function for later use
    StaffInfo.onUpdateProfile = _onUpdate;

    return ScaffoldMessenger(
      key: _globalKeyForProfile,
      child: Scaffold(
        body: Row(
          children: [
            Flexible(
              flex: 1,
              child: Card(
                margin: const EdgeInsets.only(left: 0.0),
                child: ListView(
                  children: [
                    const ListTile(
                      title: Text(
                        'معلومات شخصی',
                        style: TextStyle(
                            color: Color.fromARGB(255, 119, 118, 118),
                            fontSize: 14),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: const Text('پروفایل من'),
                      onTap: () {
                        setState(() {
                          _selectedIndex = 1;
                        });
                      },
                    ),
                    const Divider(),
                    const ListTile(
                      title: Text(
                        'امنیت',
                        style: TextStyle(
                            color: Color.fromARGB(255, 119, 118, 118),
                            fontSize: 14),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.key_outlined),
                      title: const Text('تغییر رمز'),
                      onTap: () {
                        setState(() {
                          _selectedIndex = 2;
                        });
                      },
                    ),
                    const Divider(),
                    const ListTile(
                      title: Text(
                        'هنگام سازی',
                        style: TextStyle(
                            color: Color.fromARGB(255, 119, 118, 118),
                            fontSize: 14),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.backup_outlined),
                      title: const Text('پشتیبان گیری'),
                      onTap: () {
                        setState(() {
                          _selectedIndex = 3;
                        });
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.restore_outlined),
                      title: const Text('بازیابی'),
                      onTap: () {
                        setState(() {
                          _selectedIndex = 4;
                        });
                      },
                    ),
                    const Divider(),
                    const ListTile(
                      title: Text(
                        'مرتبط به سیستم',
                        style: TextStyle(
                            color: Color.fromARGB(255, 119, 118, 118),
                            fontSize: 14),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.color_lens_outlined),
                      title: const Text('نمایه ها'),
                      onTap: () {
                        setState(() {
                          _selectedIndex = 5;
                        });
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.language_rounded),
                      title: const Text('زبان'),
                      onTap: () {
                        setState(() {
                          _selectedIndex = 6;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 3,
              child: onShowSettingsItem(_selectedIndex, onUpdatePhoto),
            ),
          ],
        ),
      ),
    );
  }

// This method is to update profile picture of the user
  void onUpdatePhoto() async {
    final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png']);
    if (result != null) {
      final conn = await onConnToDb();
      pickedFile = File(result.files.single.path.toString());
      final bytes = await pickedFile!.readAsBytes();
      // Check if the file size is larger than 1MB
      if (bytes.length > 1024 * 1024) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Center(
              child: Text('عکس حداکثر باید 1MB باشد.'),
            ),
          ),
        );
        return;
      }
      // final photo = MySQL.escapeBuffer(bytes);
      var results = await conn.query(
          'UPDATE staff SET photo = ? WHERE staff_ID = ?',
          [bytes, StaffInfo.staffID]);
      setState(() {
        if (results.affectedRows! > 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.green,
              content: Center(
                child: Text('عکس پروفایل تان موفقانه تغییر کرد.'),
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Center(
                child: Text('متاسفم، تغییر عکس پروفایل ناکام شد..'),
              ),
            ),
          );
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('هیچ عکسی را انتخاب نکردید.'),
        ),
      );
    }
  }
}

// Switch between settings menu items
Widget onShowSettingsItem(int index, [void Function()? onUpdatePhoto]) {
  if (index == 1) {
    return onShowProfile(onUpdatePhoto);
  } else if (index == 2) {
    return onChangePwd();
  } else if (index == 3) {
    return onBackUpData();
  } else if (index == 4) {
    return onRestoreData();
  } else {
    return const SizedBox.shrink();
  }
}

// Change/update password using this function
onChangePwd() {
// The global for the form
  final formKeyChangePwd = GlobalKey<FormState>();
// The text editing controllers for the TextFormFields
  final currentPwdController = TextEditingController();
  final newPwdController = TextEditingController();
  final unConfirmController = TextEditingController();
  bool isHiddenCurrentPwd = true;
  bool isHiddenNewPwd = true;
  bool isHiddenRetypePwd = true;
  return StatefulBuilder(
    builder: (context, setState) {
      // 1) Toggle to show/hide current password only using eye icons

      void toggleCurrentPassword() {
        setState(() {
          isHiddenCurrentPwd = !isHiddenCurrentPwd;
        });
      }

      // 2) Toggle to show/hide new password only using eye icons
      void toggleNewPassword() {
        setState(() {
          isHiddenNewPwd = !isHiddenNewPwd;
        });
      }

      // 3) Toggle to show/hide re-type password only using eye icons
      void toggleConfirmPassword() {
        setState(() {
          isHiddenRetypePwd = !isHiddenRetypePwd;
        });
      }

      return Card(
        child: Center(
          child: Form(
            key: formKeyChangePwd,
            child: SizedBox(
              width: 500.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20.0),
                    child: const Text(
                      'لطفا رمز فعلی و جدید تانرا با دقت وارد نمایید.',
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 15.0, bottom: 15.0),
                    child: TextFormField(
                      textDirection: TextDirection.ltr,
                      controller: currentPwdController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'رمز فعلی تان الزامی است.';
                        }
                      },
                      obscureText: isHiddenCurrentPwd,
                      decoration: InputDecoration(
                        prefix: InkWell(
                          onTap: toggleCurrentPassword,
                          child: Icon(
                            isHiddenCurrentPwd
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.blue,
                          ),
                        ),
                        border: const OutlineInputBorder(),
                        labelText: 'رمز فعلی',
                        suffixIcon: const Icon(Icons.password_rounded),
                        enabledBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0)),
                            borderSide: BorderSide(color: Colors.grey)),
                        focusedBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0)),
                            borderSide: BorderSide(color: Colors.blue)),
                        errorBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0)),
                            borderSide: BorderSide(color: Colors.red)),
                        focusedErrorBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0)),
                            borderSide:
                                BorderSide(color: Colors.red, width: 1.5)),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 15.0, bottom: 15.0),
                    child: TextFormField(
                      textDirection: TextDirection.ltr,
                      controller: newPwdController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'رمز جدید تانرا وارد کنید.';
                        } else if (value.length < 6) {
                          return 'رمز تان باید حداقل 6 حرف باشد.';
                        }
                      },
                      obscureText: isHiddenNewPwd,
                      decoration: InputDecoration(
                        prefix: InkWell(
                          onTap: toggleNewPassword,
                          child: Icon(
                            isHiddenNewPwd
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.blue,
                          ),
                        ),
                        border: const OutlineInputBorder(),
                        labelText: 'رمز جدید',
                        suffixIcon: const Icon(Icons.password_rounded),
                        enabledBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0)),
                            borderSide: BorderSide(color: Colors.grey)),
                        focusedBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0)),
                            borderSide: BorderSide(color: Colors.blue)),
                        errorBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0)),
                            borderSide: BorderSide(color: Colors.red)),
                        focusedErrorBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0)),
                            borderSide:
                                BorderSide(color: Colors.red, width: 1.5)),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 15.0, bottom: 15.0),
                    child: TextFormField(
                      textDirection: TextDirection.ltr,
                      controller: unConfirmController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'لطفا رمز جدید تانرا دوباره وارد کنید.';
                        } else if (unConfirmController.text !=
                            newPwdController.text) {
                          return 'تکرار رمز تان با اصل آن مطابقت نمیکند.';
                        }
                      },
                      obscureText: isHiddenRetypePwd,
                      decoration: InputDecoration(
                        prefix: InkWell(
                          onTap: toggleConfirmPassword,
                          child: Icon(
                            isHiddenRetypePwd
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.blue,
                          ),
                        ),
                        border: const OutlineInputBorder(),
                        labelText: 'تکرار رمز جدید',
                        hintStyle:
                            const TextStyle(color: Colors.blue, fontSize: 12.0),
                        hintText:
                            'هر آنچه که در اینجا وارد میکنید باید با رمز تان مطابقت کند',
                        suffixIcon: const Icon(Icons.password_rounded),
                        enabledBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0)),
                            borderSide: BorderSide(color: Colors.grey)),
                        focusedBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0)),
                            borderSide: BorderSide(color: Colors.blue)),
                        errorBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0)),
                            borderSide: BorderSide(color: Colors.red)),
                        focusedErrorBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0)),
                            borderSide:
                                BorderSide(color: Colors.red, width: 1.5)),
                      ),
                    ),
                  ),
                  Container(
                    width: 400.0,
                    height: 35.0,
                    margin: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 15.0, bottom: 15.0),
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
                        if (formKeyChangePwd.currentState!.validate()) {
                          String currentPwd = currentPwdController.text;
                          String newPwd = newPwdController.text;
                          final conn = await onConnToDb();
                          // First make sure the current password matches.
                          var results = await conn.query(
                              'SELECT * FROM staff_auth WHERE password = PASSWORD(?)',
                              [currentPwd]);

                          if (results.isNotEmpty) {
                            var updatedResult = await conn.query(
                                'UPDATE staff_auth SET password = PASSWORD(?) WHERE staff_ID = ?',
                                [newPwd, StaffInfo.staffID]);
                            if (updatedResult.affectedRows! > 0) {
                              _onShowSnack(
                                  Colors.green, 'رمز تان موفقانه تغییر کرد.');
                              currentPwdController.clear();
                              newPwdController.clear();
                              unConfirmController.clear();
                            } else {
                              _onShowSnack(Colors.red,
                                  'شما هیچ تغییراتی در قسمت رمز فعلی تان نیاوردید.');
                            }
                          } else {
                            _onShowSnack(
                                Colors.red, 'رمز فعلی تان نادرست است.');
                          }
                        }
                      },
                      child: const Text('تغییر دادن'),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

onShowProfile([void Function()? onUpdatePhoto]) {
  return Card(
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ignore: sized_box_for_whitespace
          Flexible(
            flex: 1,
            child: SizedBox(
              width: 100,
              height: 100,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50.0,
                    backgroundImage:
                        pickedFile != null ? FileImage(pickedFile!) : null,
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: SizedBox(
                      height: 38,
                      width: 38,
                      child: Card(
                        shape: const CircleBorder(),
                        child: Center(
                          child: Tooltip(
                            message: 'تغییر عکس پروفایل',
                            child: IconButton(
                              onPressed: onUpdatePhoto,
                              icon: const Icon(
                                Icons.edit,
                                size: 14.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 15.0,
          ),
          Column(
            children: [
              Text(
                '${StaffInfo.firstName} ${StaffInfo.lastName ?? ""}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.only(
                    top: 3.0, bottom: 3.5, right: 10.0, left: 10.0),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 240, 239, 239),
                  borderRadius: BorderRadius.all(
                    Radius.circular(12.0),
                  ),
                ),
                child: Text(
                  '${StaffInfo.position}',
                  style: const TextStyle(color: Colors.blue, fontSize: 12.0),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20.0,
          ),
          Flexible(
            flex: 3,
            child: SizedBox(
              width: 500.0,
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        color: const Color.fromARGB(255, 240, 239, 239),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'نام',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Color.fromARGB(255, 118, 116, 116),
                              ),
                            ),
                            Text('${StaffInfo.firstName}'),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 240.0,
                            padding: const EdgeInsets.all(10.0),
                            color: const Color.fromARGB(255, 240, 239, 239),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text(
                                  'تخلص',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Color.fromARGB(255, 118, 116, 116),
                                  ),
                                ),
                                Text(
                                    '${StaffInfo.lastName ?? StaffInfo.lastName}'),
                              ],
                            ),
                          ),
                          Container(
                            width: 240.0,
                            padding: const EdgeInsets.all(10.0),
                            color: const Color.fromARGB(255, 240, 239, 239),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text(
                                  'وظیفه',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Color.fromARGB(255, 118, 116, 116),
                                  ),
                                ),
                                Text('${StaffInfo.position}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        color: const Color.fromARGB(255, 240, 239, 239),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'نمبر تذکره',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Color.fromARGB(255, 118, 116, 116),
                              ),
                            ),
                            Text('${StaffInfo.tazkira}'),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 240.0,
                            padding: const EdgeInsets.all(10.0),
                            color: const Color.fromARGB(255, 240, 239, 239),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text(
                                  'معاش',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Color.fromARGB(255, 118, 116, 116),
                                  ),
                                ),
                                Text('${StaffInfo.salary} افغانی'),
                              ],
                            ),
                          ),
                          Container(
                            width: 240.0,
                            padding: const EdgeInsets.all(10.0),
                            color: const Color.fromARGB(255, 240, 239, 239),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text(
                                  'نمبر تماس',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Color.fromARGB(255, 118, 116, 116),
                                  ),
                                ),
                                Text('${StaffInfo.phone}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15.0),
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        color: const Color.fromARGB(255, 240, 239, 239),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'آدرس',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Color.fromARGB(255, 118, 116, 116),
                              ),
                            ),
                            Text('${StaffInfo.address}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: Card(
                        shape: const CircleBorder(),
                        child: Tooltip(
                          message: 'تغییر معلومات شخصی',
                          child: Builder(builder: (BuildContext context) {
                            return IconButton(
                              onPressed: () {
                                onEditProfileInfo(context);
                              },
                              icon: const Icon(Icons.edit, size: 16.0),
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

// This function is to create a backup of the system
onBackUpData() {
  bool isBackupInProg = false;
  return StatefulBuilder(
    builder: (context, setState) {
      return Card(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const ListTile(
                title: Card(
                  color: Color.fromARGB(255, 240, 239, 239),
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'احتیاط: برای جلوگیری از نابود شدن اطلاعات تان، لطفا فایل پشتیبانی را در یک جای محفوظ که قرار ذیل است ذخیره کنید:',
                      style: TextStyle(fontSize: 14.0, color: Colors.red),
                    ),
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 270.0),
              ),
              const ListTile(
                title: Text(
                  '1 - حافظه کلود (ابری ) مثل Google Drive و یا Microsoft OneDrive است.',
                  style: TextStyle(fontSize: 12.0),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 280.0),
              ),
              const ListTile(
                title: Text(
                  '2 - حافظه بیرونی مثل هارددیسک است.',
                  style: TextStyle(fontSize: 12.0),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 280.0),
              ),
              const SizedBox(
                height: 20.0,
              ),
              SizedBox(
                height: 35.0,
                width: 400.0,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    side: const BorderSide(color: Colors.blue),
                  ),
                  onPressed: () async {
                    setState(() {
                      isBackupInProg = true;
                    });
                    final conn = await onConnToDb();
                    // List of tables
                    var tables = [
                      'clinics',
                      'staff',
                      'staff_auth',
                      'patients',
                      'appointments',
                      'services',
                      'service_details',
                      'teeth',
                      'tooth_details',
                      'expenses',
                      'expense_detail',
                      'taxes',
                      'tax_payments'
                    ];
                    // for (var table in tables) {
                    // Convert results to CSV format
                    /*     var csvData = '';
                // ignore: avoid_function_literals_in_foreach_calls
                results.forEach((row) {
                  csvData += '${row.join(',')}\n';
                }); */

                    // Get local storage directory
                    var directory = await getApplicationDocumentsDirectory();
                    var path = directory.path;

                    // Format current date and time as a string
                    var now = DateTime.now();
                    var formatter = INTL.DateFormat('yyyy-MM-dd_HH-mm-ssa');
                    var formattedDate = formatter.format(now);

                    // Write data to file
                    var file = File('$path/backup_$formattedDate.csv');
                    var sink = file.openWrite(encoding: utf8);
                    for (var table in tables) {
                      // Query to export data from any table
                      var results = await conn.query('SELECT * FROM $table');
                      // Write table name to CSV file
                      sink.writeln(table);
                      // Write column names to CSV file
                      sink.writeln(
                          results.fields.map((field) => field.name).join(','));

                      // Write data to CSV file
                      for (var row in results) {
                        var newRow = row.map((value) {
                          if (value is int ||
                              value is double ||
                              value == null) {
                            return value;
                          } else if (value is Blob) {
                            // Convert BLOB data to base64-encoded string
                            var base64String = base64Encode(value.toBytes());
                            return "'$base64String'";
                          } else {
                            return "'$value'";
                          }
                        }).join(',');
                        sink.writeln(newRow);
                        // sink.writeln(const ListToCsvConverter().convert(row));
                      }
                    }

                    print('The PATH is: $path');
                    // }

                    // Close connection
                    await conn.close();
                    // Close file
                    await sink.close();
                    _onShowSnack(
                        Colors.green, 'فایل پشتبیانی موفقانه ایجاد شد.');
                    setState(() {
                      isBackupInProg = false;
                    });
                  },
                  icon: isBackupInProg
                      ? const Center(
                          child: SizedBox(
                            height: 18.0,
                            width: 18.0,
                            child: CircularProgressIndicator(
                              strokeWidth: 3.0,
                            ),
                          ),
                        )
                      : const Icon(Icons.backup_outlined),
                  label: isBackupInProg
                      ? const Text('اندکی صبر...')
                      : const Text('ایجاد فایل پشتیبانی'),
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
            ],
          ),
        ),
      );
    },
  );
}

// This function is to restore the backedup file
onRestoreData() {
  bool isRestoreInProg = false;
  return StatefulBuilder(
    builder: (context, setState) {
      return Card(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'توجه: قبل از انجام بازیابی، از موجودیت فایل پشتیبانی اطمینان حاصل کنید.',
                style: TextStyle(fontSize: 12.0),
              ),
              const SizedBox(
                height: 20.0,
              ),
              SizedBox(
                height: 35.0,
                width: 400.0,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    side: const BorderSide(color: Colors.blue),
                  ),
                  onPressed: () async {
                    setState(() {
                      isRestoreInProg = true;
                    });

                    // Show file picker
                    filePickerResult = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['csv'],
                    );
                    PlatformFile file;
                    if (filePickerResult != null) {
                      // Get Selected file
                      PlatformFile file = filePickerResult!.files.first;
                      // Connect to the database
                      final conn = await onConnToDb();

                      // List of tables
                      var tables = [
                        'clinics',
                        'staff',
                        'staff_auth',
                        'patients',
                        'appointments',
                        'services',
                        'service_details',
                        'teeth',
                        'tooth_details',
                        'expenses',
                        'expense_detail',
                        'taxes',
                        'tax_payments'
                      ];

                      // Primary keys of tables
                      var primaryKeys = {
                        'clinics': 'cli_ID',
                        'staff': 'staff_ID',
                        'staff_auth': 'auth_ID',
                        'patients': 'pat_ID',
                        'appointments': 'apt_ID',
                        'services': 'ser_ID',
                        'service_details': 'ser_det_ID',
                        'teeth': 'teeth_ID',
                        'tooth_details': 'td_ID',
                        'expenses': 'exp_ID',
                        'expense_detail': 'exp_detail_ID',
                        'taxes': 'tax_ID',
                        'tax_payments': 'tax_pay_ID'
                      };
                      // Open selected file
                      var lines = File(file.path!).readAsLinesSync();
                      // Initialize a variable to keep track of the total number of inserted records
                      int insertedRecords = 0;
                      // ignore: prefer_typing_uninitialized_variables

                      // ignore: prefer_typing_uninitialized_variables
                      var currentTable;
                      for (var line in lines) {
                        if (tables.contains(line)) {
                          // Line is a table
                          currentTable = line;
                        } else if (line
                            .startsWith('${primaryKeys[currentTable]},')) {
                          // Line is column names, ignore
                          continue;
                        } else {
                          // Line is data, insert into table
                          var values = line.split(',');
                          // Check if value is a base64-encoded string
                          if (values[0].startsWith('data:image/')) {
                            // Decode base64-encoded string
                            var base64String = values[0].substring(22);
                            var bytes = base64Decode(base64String);

                            // Create new Blob object from bytes
                            var blob = Blob.fromBytes(bytes);

                            // Insert Blob object into database
                            await conn.query(
                                'INSERT INTO staff (photo) VALUES (?)', [blob]);
                          } else {
                            var insertSql = """
                                  INSERT IGNORE INTO $currentTable 
                                  VALUES (${values.join(',')}) """;

                            var restoreDone = await conn.query(insertSql);
                            insertedRecords += restoreDone.affectedRows!;
                          }
                        }
                      }
                      // Show success or error message after all data has been inserted
                      if (insertedRecords > 0) {
                        _onShowSnack(Colors.green, 'بازیابی موفقانه انجام شد.');
                      } else {
                        _onShowSnack(
                            Colors.red, 'این اطلاعات قبلا در سیستم وجود دارد.');
                      }
                      setState(() {
                        isRestoreInProg = false;
                      });

                      // Close connection
                      await conn.close();
                    } else {
                      _onShowSnack(Colors.red,
                          'شما هیچ فایل پشتیبانی را انتخاب نکرده اید.');
                      setState(() {
                        isRestoreInProg = false;
                      });
                    }
                  },
                  icon: isRestoreInProg
                      ? const Center(
                          child: SizedBox(
                            height: 18.0,
                            width: 18.0,
                            child: CircularProgressIndicator(
                              strokeWidth: 3.0,
                            ),
                          ),
                        )
                      : const Icon(Icons.restore_outlined),
                  label: isRestoreInProg
                      ? const Text('لطفاً صبر...')
                      : const Text('بازیابی فایل اطلاعات'),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

// This dialog edits a staff
onEditProfileInfo(BuildContext context) {
  // position types dropdown variables
  String positionDropDown = 'داکتر دندان';
  var positionItems = [
    'داکتر دندان',
    'نرس',
    'مدیر سیستم',
  ];
// The global for the form
  final formKeyEditStaff = GlobalKey<FormState>();
// The text editing controllers for the TextFormFields
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final salaryController = TextEditingController();
  final tazkiraController = TextEditingController();
  final addressController = TextEditingController();

  const regExOnlyAbc = "[a-zA-Z,، \u0600-\u06FFF]";
  const regExOnlydigits = "[0-9+]";
  final tazkiraPattern = RegExp(r'^\d{4}-\d{4}-\d{5}$');

  // Assign values from static class members
  nameController.text = StaffInfo.firstName!;
  lastNameController.text =
      StaffInfo.lastName == null ? '' : StaffInfo.lastName!;
  phoneController.text = StaffInfo.phone!;
  salaryController.text = StaffInfo.salary.toString();
  tazkiraController.text = StaffInfo.tazkira!;
  addressController.text = StaffInfo.address!;

  return showDialog(
    context: context,
    builder: ((context) {
      return StatefulBuilder(
        builder: ((context, setState) {
          return AlertDialog(
            title: const Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                'تغییر معلومات شخصی من',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            content: Directionality(
              textDirection: TextDirection.rtl,
              child: Form(
                key: formKeyEditStaff,
                child: SizedBox(
                  width: 500.0,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                          child: TextFormField(
                            controller: nameController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'نام نمی تواند خالی باشد.';
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
                                  borderSide: BorderSide(
                                      color: Colors.red, width: 1.5)),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                          child: TextFormField(
                            controller: lastNameController,
                            validator: (value) {
                              if (value!.isNotEmpty) {
                                if (value.length < 3 || value.length > 10) {
                                  return 'تخلص باید حداقل 3 و حداکثر 10 حرف باشد.';
                                }
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
                          margin: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                          child: TextFormField(
                            controller: phoneController,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(regExOnlydigits),
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
                                  borderSide: BorderSide(
                                      color: Colors.red, width: 1.5)),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                          child: TextFormField(
                            controller: salaryController,
                            validator: (value) {
                              if (value!.isNotEmpty) {
                                final salary = double.tryParse(value);
                                if (salary! < 1000 || salary > 100000) {
                                  return 'مقدار معاش باید بین 1000 افغانی و 100,000 افغانی باشد.';
                                }
                              }
                              return null;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9.]'))
                            ],
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'مقدار معاش (به افغانی)',
                              suffixIcon: Icon(Icons.money),
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
                          margin: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                          child: TextFormField(
                            controller: tazkiraController,
                            validator: (value) {
                              if (value!.isNotEmpty) {
                                if (!tazkiraPattern.hasMatch(value)) {
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
                          margin: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                          child: TextFormField(
                            controller: addressController,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(regExOnlyAbc),
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
                  ),
                ),
              ),
            ),
            actions: [
              Directionality(
                  textDirection: TextDirection.rtl,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('لغو')),
                      ElevatedButton(
                        onPressed: () async {
                          if (formKeyEditStaff.currentState!.validate()) {
                            // Fetch staff info from forms and assign them into variables.
                            String firstName = nameController.text;
                            String lastName = lastNameController.text.isEmpty
                                ? ''
                                : lastNameController.text;
                            String phone = phoneController.text;
                            double salary = salaryController.text.isEmpty
                                ? 0
                                : double.parse(salaryController.text);
                            String tazkiraID = tazkiraController.text.isEmpty
                                ? ''
                                : tazkiraController.text;
                            String address = addressController.text.isEmpty
                                ? ''
                                : addressController.text;

                            final conn = await onConnToDb();
                            var updateResult = await conn.query(
                                'UPDATE staff SET firstname = ?, lastname = ?, salary = ?, phone = ?, tazkira_ID = ?, address = ? WHERE staff_ID = ?',
                                [
                                  firstName,
                                  lastName,
                                  salary,
                                  phone,
                                  tazkiraID,
                                  address,
                                  StaffInfo.staffID
                                ]);
                            await conn.close();
                            if (updateResult.affectedRows! > 0) {
                              _onShowSnack(Colors.green,
                                  'معلومات تان موفقانه تغییر کرد.');
                              setState(() {
                                StaffInfo.firstName = firstName;
                                StaffInfo.lastName = lastName;
                                StaffInfo.phone = phone;
                                StaffInfo.salary = salary;
                                StaffInfo.tazkira = tazkiraID;
                                StaffInfo.address = address;

                                // Call this function to refresh staff info UI
                                StaffInfo.onUpdateProfile!();
                              });
                            } else {
                              _onShowSnack(
                                  Colors.red, 'شما هیچ تغییراتی نیاوردید.');
                            }
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('تغییر'),
                      ),
                    ],
                  ))
            ],
          );
        }),
      );
    }),
  );
}

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:flutter_dentistry/views/staff/staff_info.dart';

import 'package:flutter_dentistry/models/db_conn.dart';

FilePickerResult? filePickerResult;
File? pickedFile;

class SettingsMenu extends StatefulWidget {
  const SettingsMenu({super.key});

  @override
  State<SettingsMenu> createState() => _SettingsMenuState();
}

class _SettingsMenuState extends State<SettingsMenu> {
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Row(
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
Widget onShowSettingsItem(int index, void Function() onUpdatePhoto) {
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
  final formKey = GlobalKey<FormState>();
// The text editing controllers for the TextFormFields
  final userNameController = TextEditingController();
  final unConfirmController = TextEditingController();
  return Card(
    child: Center(
      child: Form(
        key: formKey,
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
                margin: const EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: userNameController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'رمز فعلی',
                    suffixIcon: Icon(Icons.password_rounded),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        borderSide: BorderSide(color: Colors.blue)),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: userNameController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'رمز جدید',
                    suffixIcon: Icon(Icons.password_rounded),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        borderSide: BorderSide(color: Colors.blue)),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: unConfirmController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'تکرار رمز جدید',
                    hintText:
                        'هر آنچه که در اینجا وارد میکنید باید با رمز تان مطابقت کند',
                    suffixIcon: Icon(Icons.password_rounded),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        borderSide: BorderSide(color: Colors.blue)),
                  ),
                ),
              ),
              Container(
                width: 400.0,
                height: 35.0,
                margin: const EdgeInsets.only(bottom: 20.0),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    side: const BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  onPressed: () {},
                  child: const Text('تغییر دادن'),
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}

onShowProfile(void Function() onUpdatePhoto) {
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
                  'احتیاط: برای جلوگیری از دست دادن اطلاعات تان، لطفا فایل پشتیبانی را در یک جای محفوظ که قرار ذیل است ذخیره کنید:',
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
              onPressed: () {},
              icon: const Icon(Icons.backup_outlined),
              label: const Text('صدور فایل پشتیبانی'),
            ),
          ),
        ],
      ),
    ),
  );
}

// This function is to restore the backedup file
onRestoreData() {
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
              onPressed: () {},
              icon: const Icon(Icons.restore_outlined),
              label: const Text('بازیابی فایل اطلاعات'),
            ),
          ),
        ],
      ),
    ),
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
                        onPressed: () {
                          if (formKeyEditStaff.currentState!.validate()) {

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

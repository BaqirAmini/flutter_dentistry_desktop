// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dentistry/config/global_usage.dart';
import 'package:flutter_dentistry/config/language_provider.dart';
import 'package:flutter_dentistry/config/translations.dart';
import 'package:flutter_dentistry/models/db_conn.dart';
import 'package:flutter_dentistry/views/main/dashboard.dart';
import 'package:flutter_dentistry/views/patients/appointments.dart';
import 'package:flutter_dentistry/views/patients/fee_installments.dart';
import 'package:flutter_dentistry/views/patients/patient_history.dart';
import 'package:flutter_dentistry/views/patients/xrays.dart';
import 'package:flutter_dentistry/views/settings/settings_menu.dart';
import 'package:flutter_dentistry/views/sf_calendar/syncfusion_calendar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_dentistry/views/patients/patient_info.dart';
import 'package:galileo_mysql/galileo_mysql.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const PatientDetail());
}

// This is shows snackbar when called
void _onShowSnack(Color backColor, String msg, BuildContext context) {
  Flushbar(
    backgroundColor: backColor,
    flushbarStyle: FlushbarStyle.GROUNDED,
    flushbarPosition: FlushbarPosition.BOTTOM,
    messageText: Directionality(
      textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
      child: Text(
        msg,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white),
      ),
    ),
    duration: const Duration(seconds: 3),
  ).show(context);
}

// Set global variables which are needed later.
var selectedLanguage;
var isEnglish;

class PatientDetail extends StatefulWidget {
  const PatientDetail({Key? key}) : super(key: key);

  @override
  State<PatientDetail> createState() => _PatientDetailState();
}

class _PatientDetailState extends State<PatientDetail> {
  @override
  Widget build(BuildContext context) {
    // Fetch translations keys based on the selected language.
    var languageProvider = Provider.of<LanguageProvider>(context);
    selectedLanguage = languageProvider.selectedLanguage;
    isEnglish = selectedLanguage == 'English';
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.green,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CalendarApp()),
              ).then((_) {
                setState(() {});
              });
            },
            tooltip: 'تعیین زمان جلسه مابعد',
            child: const Icon(
              Icons.edit_calendar_outlined,
              color: Colors.white,
            ),
          ),
          appBar: AppBar(
            title: const Text('سوابق مریض'),
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const BackButtonIcon(),
            ),
            actions: [
              IconButton(
                // onPressed: () {},
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Dashboard(),
                )),
                icon: const Icon(Icons.home_outlined),
                tooltip: 'Dashboard',
                padding: const EdgeInsets.all(3.0),
                splashRadius: 30.0,
              ),
              const SizedBox(width: 15.0)
            ],
          ),
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width * 0.23,
                      child: const _PatientProfile(),
                    ),
                    _PatientMoreDetail(),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Card(
                      elevation: 0.5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: const _NavigationArea()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PatientProfile extends StatefulWidget {
  const _PatientProfile({Key? key}) : super(key: key);

  @override
  State<_PatientProfile> createState() => _PatientProfileState();
}

class _PatientProfileState extends State<_PatientProfile> {
  bool _isLoadingPhoto = false;
  late ImageProvider _image;
// This method is to update profile picture of a patient
  void _onUpdatePatientPhoto() async {
    setState(() {
      _isLoadingPhoto = true;
    });

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
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Center(
              child: Text('عکس حداکثر باید 1MB باشد.'),
            ),
          ),
        );
        setState(() {
          _isLoadingPhoto = false;
        });
        return;
      }
      // final photo = MySQL.escapeBuffer(bytes);
      var results = await conn.query(
          'UPDATE patients SET photo = ? WHERE pat_ID = ?',
          [bytes, PatientInfo.patID]);
      setState(() {
        if (results.affectedRows! > 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.green,
              content: Center(
                child: Text('عکس مریض موفقانه تغییر کرد.'),
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
        setState(() {
          _isLoadingPhoto = false;
        });
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Center(child: Text('هیچ عکسی را انتخاب نکردید.')),
        ),
      );
      setState(() {
        _isLoadingPhoto = false;
      });
    }
  }

  Uint8List? uint8list;
  // This function fetches patient photo
  Future<void> _onFetchPatientPhoto(int staffID) async {
    final conn = await onConnToDb();
    final result = await conn.query(
        'SELECT photo FROM patients WHERE pat_ID = ?', [PatientInfo.patID]);

    Blob? staffPhoto =
        result.first['photo'] != null ? result.first['photo'] as Blob : null;

    // Convert image of BLOB type to binary first.
    uint8list =
        staffPhoto != null ? Uint8List.fromList(staffPhoto.toBytes()) : null;
    await conn.close();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  FutureBuilder(
                    future: _onFetchPatientPhoto(PatientInfo.patID!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return CircleAvatar(
                            radius: 30.0,
                            backgroundImage: _image = (uint8list != null)
                                ? MemoryImage(uint8list!)
                                : const AssetImage(
                                        'assets/graphics/user_profile2.jpg')
                                    as ImageProvider);
                      }
                    },
                  ),
                  Positioned(
                    top: -5.0,
                    right: -15.0,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.05,
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: Card(
                        shape: const CircleBorder(),
                        child: Center(
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: _isLoadingPhoto
                                  ? const SizedBox(
                                      height: 18.0,
                                      width: 18.0,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3.0,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.edit,
                                      size: 12.0,
                                      color: Colors.grey,
                                    ),
                            ),
                            onTap: () => _onUpdatePatientPhoto(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // const SizedBox(width: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.12,
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                      child: Text(
                          '${PatientInfo.firstName} ${PatientInfo.lastName}',
                          style: Theme.of(context).textTheme.headlineSmall),
                    ),
                    const SizedBox(height: 10.0),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              MediaQuery.of(context).size.width * 0.017),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.phone_android,
                              color: Colors.grey, size: 14),
                          const SizedBox(width: 5.0),
                          Expanded(
                            child: Text(
                              '${PatientInfo.phone}',
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 14.0),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          /*  SizedBox(
            width: 260,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.phone_android,
                        color: Colors.grey, size: 14),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        '${PatientInfo.phone}',
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 14.0),
                      ),
                    )
                  ],
                ),
                /*   const SizedBox(height: 5.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.home, color: Colors.grey, size: 14),
                    const SizedBox(width: 8.0),
                    SizedBox(
                      width: 150,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          '${PatientInfo.address}',
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 12.0),
                        ),
                      ),
                    ),
                  ],
                ), */
              ],
            ),
          ),
 */
        ],
      ),
    );
  }
}

class _NavigationArea extends StatelessWidget {
  const _NavigationArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: HoverCard(
                  title: Row(
                    children: [
                      const Icon(FontAwesomeIcons.userDoctor),
                      const SizedBox(width: 10.0),
                      Text('جلسات',
                          style: Theme.of(context).textTheme.bodyLarge),
                    ],
                  ),
                  indexNum: 100,
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: HoverCard(
                  title: const Row(
                    children: [
                      Icon(FontAwesomeIcons.moneyBill1),
                      SizedBox(width: 10.0),
                      Text('فیس / اقساط'),
                    ],
                  ),
                  indexNum: 101,
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: HoverCard(
                  title: const Row(
                    children: [
                      Icon(FontAwesomeIcons.heartPulse),
                      SizedBox(width: 10.0),
                      Text('تاریخچه صحی مریض'),
                    ],
                  ),
                  indexNum: 102,
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: HoverCard(
                  title: const Row(
                    children: [
                      Icon(FontAwesomeIcons.fileImage),
                      SizedBox(width: 10.0),
                      Text('X-Rays / Files'),
                    ],
                  ),
                  indexNum: 103,
                ),
              ),
            ),
          ],
        ),
        // Add more cards here for each setting
      ],
    );
  }
}

class HoverCard extends StatefulWidget {
  final Widget title;
  final int indexNum;

  HoverCard({required this.title, required this.indexNum});

  @override
  _HoverCardState createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => setState(() => _isHovering = true),
      onExit: (event) => setState(() => _isHovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
        transform: _isHovering
            ? Matrix4.translationValues(10, 0, 0)
            : Matrix4
                .identity(), // Move the card to the left/right when hovering
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.2),
            border: Border.all(color: Colors.grey, width: 0.5),
          ),
          child: Center(
            child: ListTile(
              title: widget.title,
              trailing: const Icon(Icons.arrow_forward_ios_sharp),
              onTap: () {
                if (widget.indexNum == 100) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Appointment()));
                } else if (widget.indexNum == 102) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PatientHistory()));
                } else if (widget.indexNum == 101) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FeeRecord(),
                    ),
                  );
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const XRayUploadScreen(),
                      ));
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _PatientMoreDetail extends StatefulWidget {
  @override
  State<_PatientMoreDetail> createState() => _PatientMoreDetailState();
}

class _PatientMoreDetailState extends State<_PatientMoreDetail> {
  final _editPatFormKey = GlobalKey<FormState>();
  // The text editing controllers for the TextFormFields
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final hireDateController = TextEditingController();
  final familyPhone1Controller = TextEditingController();
  final familyPhone2Controller = TextEditingController();
  final salaryController = TextEditingController();
  final prePaidController = TextEditingController();
  final tazkiraController = TextEditingController();
  final _addrController = TextEditingController();

  // Radio Buttons
  String _sexGroupValue = 'مرد';
// This function edits patient's personal info
  onEditPatientInfo(BuildContext context) {
    _firstNameController.text = PatientInfo.firstName!;
    _lastNameController.text = PatientInfo.lastName!;
    _phoneController.text = PatientInfo.phone!;
    _addrController.text = PatientInfo.address!;
    _sexGroupValue = PatientInfo.sex!;
    PatientInfo.maritalStatusDD = PatientInfo.maritalStatus!;
    PatientInfo.ageDropDown = PatientInfo.age!;
    PatientInfo.bloodDropDown = PatientInfo.bloodGroup;

    return showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Directionality(
              textDirection: TextDirection.rtl,
              child: Text('تغییر معلومات شخصی مریض'),
            ),
            content: Directionality(
              textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
              child: SingleChildScrollView(
                child: Form(
                  key: _editPatFormKey,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 20.0),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                left: 20.0,
                                right: 10.0,
                                top: 10.0,
                                bottom: 10.0),
                            child: TextFormField(
                              controller: _firstNameController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'نام مریض الزامی میباشد.';
                                } else if (value.length < 3 ||
                                    value.length > 10) {
                                  return 'نام مریض باید 4 تا 9 حرف باشد.';
                                }
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'نام',
                                suffixIcon: Icon(Icons.person_add_alt_outlined),
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
                                left: 20.0,
                                right: 10.0,
                                top: 10.0,
                                bottom: 10.0),
                            child: TextFormField(
                              controller: _lastNameController,
                              validator: (value) {
                                if (value!.isNotEmpty) {
                                  if (value.length < 3 || value.length > 10) {
                                    return 'تخلص مریض باید 3 تا 9 حرف باشد.';
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
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 1.5)),
                              ),
                            ),
                          ),
                          Container(
                            width: 400.0,
                            margin: const EdgeInsets.only(
                                left: 20.0,
                                right: 10.0,
                                top: 10.0,
                                bottom: 10.0),
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
                                border: OutlineInputBorder(),
                                labelText: 'جنسیت',
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                        listTileTheme: const ListTileThemeData(
                                            horizontalTitleGap: 0.5),
                                      ),
                                      child: RadioListTile(
                                          title: const Text(
                                            'مرد',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          value: 'مرد',
                                          groupValue: _sexGroupValue,
                                          onChanged: (String? value) {
                                            setState(() {
                                              _sexGroupValue = value!;
                                            });
                                          }),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                        listTileTheme: const ListTileThemeData(
                                            horizontalTitleGap: 0.5),
                                      ),
                                      child: RadioListTile(
                                          title: const Text(
                                            'زن',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          value: 'زن',
                                          groupValue: _sexGroupValue,
                                          onChanged: (String? value) {
                                            setState(() {
                                              _sexGroupValue = value!;
                                            });
                                          }),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
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
                                child: InputDecorator(
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    labelText: 'سن',
                                    enabledBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50.0)),
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                    focusedBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50.0)),
                                        borderSide:
                                            BorderSide(color: Colors.blue)),
                                    errorText: PatientInfo.ageDropDown == 0 &&
                                            !PatientInfo.ageSelected
                                        ? 'Please select an age'
                                        : null,
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(50.0),
                                      ),
                                      borderSide: BorderSide(
                                          color: !PatientInfo.ageSelected
                                              ? Colors.red
                                              : Colors.grey),
                                    ),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: SizedBox(
                                      height: 26.0,
                                      child: DropdownButton(
                                        isExpanded: true,
                                        icon: const Icon(Icons.arrow_drop_down),
                                        value: PatientInfo.ageDropDown,
                                        items: <DropdownMenuItem<int>>[
                                          const DropdownMenuItem(
                                            value: 0,
                                            child: Text('No age selected'),
                                          ),
                                          ...PatientInfo.getAges()
                                              .map((int ageItems) {
                                            return DropdownMenuItem(
                                              alignment: Alignment.centerRight,
                                              value: ageItems,
                                              child: Directionality(
                                                textDirection: isEnglish
                                                    ? TextDirection.ltr
                                                    : TextDirection.rtl,
                                                child: Text('$ageItems سال'),
                                              ),
                                            );
                                          }).toList(),
                                        ],
                                        onChanged: (int? newValue) {
                                          if (newValue != 0) {
                                            // Ignore the 'Please select an age' option
                                            setState(() {
                                              PatientInfo.ageDropDown =
                                                  newValue!;
                                              PatientInfo.ageSelected = true;
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
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
                                  RegExp(GlobalUsage.allowedDigits),
                                ),
                              ],
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return translations[selectedLanguage]
                                          ?['PhoneRequired'] ??
                                      '';
                                } else if (value.startsWith('07')) {
                                  if (value.length < 10 || value.length > 10) {
                                    return translations[selectedLanguage]
                                            ?['Phone10'] ??
                                        '';
                                  }
                                } else if (value.startsWith('+93')) {
                                  if (value.length < 12 || value.length > 12) {
                                    return translations[selectedLanguage]
                                            ?['Phone12'] ??
                                        '';
                                  }
                                } else {
                                  return translations[selectedLanguage]
                                          ?['ValidPhone'] ??
                                      '';
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
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 1.5)),
                              ),
                            ),
                          ),
                          Container(
                            width: 400.0,
                            margin: const EdgeInsets.only(
                                left: 20.0,
                                right: 10.0,
                                top: 10.0,
                                bottom: 10.0),
                            child: TextFormField(
                              controller: _addrController,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(GlobalUsage.allowedEPChar),
                                ),
                              ],
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: translations[selectedLanguage]
                                        ?['Address'] ??
                                    '',
                                suffixIcon:
                                    const Icon(Icons.location_on_outlined),
                                enabledBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50.0)),
                                    borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50.0)),
                                    borderSide: BorderSide(color: Colors.blue)),
                              ),
                            ),
                          ),
                          Container(
                            width: 400.0,
                            margin: const EdgeInsets.only(
                                left: 20.0,
                                right: 10.0,
                                top: 10.0,
                                bottom: 10.0),
                            child: InputDecorator(
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
                                border: const OutlineInputBorder(),
                                labelText: translations[selectedLanguage]
                                    ?['Sex'],
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(50.0),
                                  ),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(50.0),
                                  ),
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                        listTileTheme: const ListTileThemeData(
                                            horizontalTitleGap: 0.5),
                                      ),
                                      child: RadioListTile(
                                          title: const Text(
                                            'مرد',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          value: 'مرد',
                                          groupValue: _sexGroupValue,
                                          onChanged: (String? value) {
                                            setState(() {
                                              _sexGroupValue = value!;
                                            });
                                          }),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                        listTileTheme: const ListTileThemeData(
                                            horizontalTitleGap: 0.5),
                                      ),
                                      child: RadioListTile(
                                          title: const Text(
                                            'زن',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          value: 'زن',
                                          groupValue: _sexGroupValue,
                                          onChanged: (String? value) {
                                            setState(() {
                                              _sexGroupValue = value!;
                                            });
                                          }),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 400.0,
                            margin: const EdgeInsets.only(
                                left: 20.0,
                                right: 10.0,
                                top: 10.0,
                                bottom: 10.0),
                            child: InputDecorator(
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: translations[selectedLanguage]
                                    ?['Marital'],
                                enabledBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50.0)),
                                    borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: const OutlineInputBorder(
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
                                    value: PatientInfo.maritalStatusDD,
                                    items:
                                        PatientInfo.items.map((String items) {
                                      return DropdownMenuItem<String>(
                                        alignment: Alignment.centerRight,
                                        value: items,
                                        child: Text(items),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        PatientInfo.maritalStatusDD = newValue!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 400.0,
                            margin: const EdgeInsets.only(
                                left: 20.0,
                                right: 10.0,
                                top: 10.0,
                                bottom: 10.0),
                            child: Column(
                              children: <Widget>[
                                InputDecorator(
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    labelText: translations[selectedLanguage]
                                        ?['BloodGroup'],
                                    enabledBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50.0)),
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50.0)),
                                      borderSide:
                                          BorderSide(color: Colors.blue),
                                    ),
                                    errorBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50.0)),
                                      borderSide: BorderSide(color: Colors.red),
                                    ),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: SizedBox(
                                      height: 26.0,
                                      child: DropdownButton(
                                        // isExpanded: true,
                                        icon: const Icon(Icons.arrow_drop_down),
                                        value: PatientInfo.bloodDropDown,
                                        items: PatientInfo.bloodGroupItems
                                            .map((String bloodGroupItems) {
                                          return DropdownMenuItem(
                                            alignment: Alignment.centerRight,
                                            value: bloodGroupItems,
                                            child: Text(bloodGroupItems),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            PatientInfo.bloodDropDown =
                                                newValue;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () =>
                      Navigator.of(context, rootNavigator: true).pop(),
                  child: const Text('لغو')),
              ElevatedButton(
                  onPressed: () async {
                    try {
                      if (_editPatFormKey.currentState!.validate()) {
                        final conn = await onConnToDb();
                        String firstName = _firstNameController.text;
                        String? lastName = _lastNameController.text.isEmpty
                            ? null
                            : _lastNameController.text;
                        int selectedAge = PatientInfo.ageDropDown;
                        String selectedSex = _sexGroupValue;
                        String marital = PatientInfo.maritalStatusDD;
                        String phone = _phoneController.text;
                        String bloodGroup = PatientInfo.bloodDropDown!;
                        String? address = _addrController.text.isEmpty
                            ? null
                            : _addrController.text;
                        final results = await conn.query(
                            'UPDATE patients SET firstname = ?, lastname = ?, age = ?, sex = ?, marital_status = ?, phone = ?, blood_group = ?, address = ? WHERE pat_ID = ?',
                            [
                              firstName,
                              lastName,
                              selectedAge,
                              selectedSex,
                              marital,
                              phone,
                              bloodGroup,
                              address,
                              PatientInfo.patID
                            ]);
                        if (results.affectedRows! > 0) {
                          Navigator.of(context, rootNavigator: true).pop();
                          _onShowSnack(Colors.green,
                              'معلومات مریض موفقانه تغییر کرد.', context);
                          _reload();
                        } else {
                          Navigator.of(context, rootNavigator: true).pop();
                          _onShowSnack(Colors.red, 'شما هیچ تغییراتی نیاوردید.',
                              context);
                        }
                      }
                    } catch (e) {
                      print('Editing patient\' info failed: $e');
                    }
                  },
                  child: const Text('تغییر')),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    void _reload() {
      setState(() {});
    }

    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.3,
          width: MediaQuery.of(context).size.width * 0.52,
          child: Card(
            elevation: 0.5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 20.0, bottom: 20.0),
                      child: Column(
                        children: [
                          const Text(
                            'جنسیت',
                            style:
                                TextStyle(color: Colors.grey, fontSize: 12.0),
                          ),
                          Text('${PatientInfo.sex}'),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20.0, bottom: 20.0),
                      child: Column(
                        children: [
                          const Text('حالت مدنی',
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 12.0)),
                          Text('${PatientInfo.maritalStatus}'),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 20.0, bottom: 20.0),
                      child: Column(
                        children: [
                          const Text('سن',
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 12.0)),
                          Text('${PatientInfo.age} سال'),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20.0, bottom: 20.0),
                      child: Column(
                        children: [
                          const Text('گروپ خون',
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 12.0)),
                          Text('${PatientInfo.bloodGroup}'),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 20.0, bottom: 20.0),
                      child: SizedBox(
                        width: 220,
                        child: Column(
                          children: [
                            const Text('آدرس',
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 12.0)),
                            Text('${PatientInfo.address}'),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20.0, bottom: 20.0),
                      child: Column(
                        children: [
                          const Text('تاریخ ثبت',
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 12.0)),
                          Text('${PatientInfo.regDate}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 8.0,
          left: 8.0,
          child: Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              child: InkWell(
                  customBorder: const CircleBorder(),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.edit,
                        size: 16.0, color: Color.fromARGB(255, 123, 123, 123)),
                  ),
                  onTap: () => onEditPatientInfo(context))),
        ),
      ],
    );
  }
}

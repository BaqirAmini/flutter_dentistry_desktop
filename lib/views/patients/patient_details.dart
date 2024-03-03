// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:ui';
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
import 'package:flutter_dentistry/views/patients/retreatments.dart';
import 'package:flutter_dentistry/views/patients/xrays.dart';
import 'package:flutter_dentistry/views/settings/settings_menu.dart';
import 'package:flutter_dentistry/views/sf_calendar/patient_specific_sfcalendar.dart';
import 'package:flutter_dentistry/views/staff/staff.dart';
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
        textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
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
            title: Text(
                '${translations[selectedLanguage]?['PatRecords'] ?? ''}: ${PatientInfo.firstName} ${PatientInfo.lastName}'),
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
      theme: ThemeData(useMaterial3: false),
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
  final ValueNotifier<bool> _isHovering = ValueNotifier<bool>(false);
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
              FutureBuilder(
                future: _onFetchPatientPhoto(PatientInfo.patID!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return InkWell(
                      onTap: _onUpdatePatientPhoto,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        onEnter: (event) => _isHovering.value = true,
                        onExit: (event) => _isHovering.value = false,
                        child: ValueListenableBuilder<bool>(
                          valueListenable: _isHovering,
                          builder: (context, isHovering, child) {
                            return isHovering
                                ? Stack(
                                    children: [
                                      CircleAvatar(
                                        radius: 30.0,
                                        backgroundImage: _image = (uint8list !=
                                                null)
                                            ? MemoryImage(uint8list!)
                                            : const AssetImage(
                                                    'assets/graphics/user_profile2.jpg')
                                                as ImageProvider,
                                      ),
                                      Positioned.fill(
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 2.5, sigmaY: 2.5),
                                          child: Container(
                                            color: Colors.black.withOpacity(0),
                                          ),
                                        ),
                                      ),
                                      Positioned.fill(
                                        child: Center(
                                          child: _isLoadingPhoto
                                              ? const CircularProgressIndicator(
                                                  color: Colors.white)
                                              : const Icon(Icons.camera_alt,
                                                  color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  )
                                : CircleAvatar(
                                    radius: 30.0,
                                    backgroundImage: _image = (uint8list !=
                                            null)
                                        ? MemoryImage(uint8list!)
                                        : const AssetImage(
                                                'assets/graphics/user_profile2.jpg')
                                            as ImageProvider,
                                  );
                          },
                        ),
                      ),
                    );
                  }
                },
              ),
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
                      const Icon(FontAwesomeIcons.userDoctor,
                          color: Colors.blue),
                      const SizedBox(width: 10.0),
                      Text(
                          translations[selectedLanguage]?['Appointments'] ?? '',
                          style: const TextStyle(color: Colors.blue)),
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
                  title: Row(
                    children: [
                      const Icon(FontAwesomeIcons.moneyBill1,
                          color: Colors.blue),
                      const SizedBox(width: 10.0),
                      Text(
                          translations[selectedLanguage]?['FeeInstallment'] ??
                              '',
                          style: const TextStyle(
                              color: Colors.blue, fontSize: 18.0)),
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
                  title: Row(
                    children: [
                      const Icon(FontAwesomeIcons.heartPulse,
                          color: Colors.blue),
                      const SizedBox(width: 10.0),
                      Text(translations[selectedLanguage]?['Histories'] ?? '',
                          style: const TextStyle(
                              color: Colors.blue, fontSize: 18.0)),
                    ],
                  ),
                  indexNum: 102,
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: HoverCard(
                  title: Row(
                    children: [
                      Icon(FontAwesomeIcons.fileImage, color: Colors.blue),
                      SizedBox(width: 10.0),
                      Text('X-Rays / Files',
                          style: TextStyle(color: Colors.blue, fontSize: 18.0)),
                    ],
                  ),
                  indexNum: 103,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.3,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: HoverCard(
              title: Row(
                children: [
                  const Icon(Icons.repeat, color: Colors.blue),
                  const SizedBox(width: 10.0),
                  Text(translations[selectedLanguage]?['Retreatment'] ?? '',
                      style:
                          const TextStyle(color: Colors.blue, fontSize: 18.0)),
                ],
              ),
              indexNum: 104,
            ),
          ),
        ),
      ],
    );
  }
}

class HoverCard extends StatefulWidget {
  final Widget title;
  final int indexNum;

  const HoverCard({super.key, required this.title, required this.indexNum});

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
            border: Border.all(color: Colors.blue, width: 0.5),
          ),
          child: Center(
            child: ListTile(
              hoverColor: Colors.transparent,
              title: widget.title,
              trailing:
                  const Icon(Icons.arrow_forward_ios_sharp, color: Colors.blue),
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
                } else if (widget.indexNum == 103) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const XRayUploadScreen(),
                      ));
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Retreatment(),
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

// ignore: must_be_immutable
class _PatientMoreDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width * 0.52,
      child: Card(
        elevation: 0.5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                      Text(
                        translations[selectedLanguage]?['Sex'] ?? '',
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12.0),
                      ),
                      Text('${PatientInfo.sex}'),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20.0, bottom: 20.0),
                  child: Column(
                    children: [
                      Text(translations[selectedLanguage]?['Marital'] ?? '',
                          style: const TextStyle(
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
                      Text(translations[selectedLanguage]?['Age'] ?? '',
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 12.0)),
                      Text(
                          '${PatientInfo.age} ${translations[selectedLanguage]?['Year'] ?? ''}'),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20.0, bottom: 20.0),
                  child: Column(
                    children: [
                      Text(translations[selectedLanguage]?['BloodGroup'] ?? '',
                          style: const TextStyle(
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
                        Text(translations[selectedLanguage]?['Address'] ?? '',
                            style: const TextStyle(
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
                      Text(translations[selectedLanguage]?['RegDate'] ?? '',
                          style: const TextStyle(
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
    );
  }
}

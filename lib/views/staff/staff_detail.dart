// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dentistry/models/db_conn.dart';
import 'package:flutter_dentistry/views/main/dashboard.dart';
import 'package:flutter_dentistry/views/settings/settings_menu.dart';
import 'package:flutter_dentistry/views/staff/staff_info.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galileo_mysql/galileo_mysql.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

int gStaffID = 0;
String gStaffFName = '';
String gStaffLName = '';
String gStaffPhone = '';
String gStaffFPhone1 = '';
String gStaffFPhone2 = '';
String gStaffPos = '';
double gStaffSalary = 0;
double gStaffPrePay = 0;
String gStaffTazkira = '';
Uint8List? gStaffContract;
String gstaffFType = '';
String gStaffAddr = '';
String gStaffHDate = '';

class StaffDetail extends StatelessWidget {
  final int staffID;
  final String staffFName;
  final String? staffLName;
  final String staffPhone;
  final String stafffphone1;
  final String? stafffphone2;
  final String staffPos;
  final double? staffSalary;
  final double? staffPrPayment;
  final String? tazkiraID;
  final Uint8List? contractFile;
  final String? fileType;
  final String? staffAddr;
  final String staffHDate;
  const StaffDetail({
    Key? key,
    required this.staffID,
    required this.staffFName,
    this.staffLName,
    required this.staffPhone,
    required this.stafffphone1,
    this.stafffphone2,
    required this.staffPos,
    required this.staffSalary,
    this.staffPrPayment,
    this.tazkiraID,
    this.contractFile,
    this.fileType,
    this.staffAddr,
    required this.staffHDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    gStaffID = staffID;
    gStaffFName = staffFName;
    gStaffLName = staffLName ?? '';
    gStaffPhone = staffPhone;
    gStaffFPhone1 = stafffphone1;
    gStaffFPhone2 = stafffphone2 ?? '';
    gStaffPos = staffPos;
    gStaffAddr = staffAddr ?? '';
    gstaffFType = fileType ?? '';
    gStaffContract = contractFile;
    gStaffPrePay = staffPrPayment ?? 0;
    gStaffSalary = staffSalary ?? 0;
    gStaffTazkira = tazkiraID ?? '';
    gStaffHDate = staffHDate;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('سوابق کارمند'),
            leading: IconButton(
              splashRadius: 27.0,
              onPressed: () => Navigator.pop(context),
              icon: const BackButtonIcon(),
            ),
            actions: [
              IconButton(
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const Dashboard()),
                    (route) => route.settings.name == 'Dashboard'),
                icon: const Icon(Icons.home_outlined),
                tooltip: 'Dashboard',
                padding: const EdgeInsets.all(3.0),
                splashRadius: 27.0,
              ),
              const SizedBox(width: 15.0)
            ],
          ),
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: const _StaffProfile(),
                ),
                _StaffMoreDetail(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StaffProfile extends StatefulWidget {
  const _StaffProfile({Key? key}) : super(key: key);

  @override
  State<_StaffProfile> createState() => _StaffProfileState();
}

class _StaffProfileState extends State<_StaffProfile> {
  bool _isLoadingPhoto = false;
  late ImageProvider _image;
  final ValueNotifier<bool> _isHovering = ValueNotifier<bool>(false);

// This method is to update profile picture of a staff
  void _onUpdateStaffPhoto() async {
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
          'UPDATE staff SET photo = ? WHERE staff_ID = ?', [bytes, gStaffID]);
      setState(() {
        if (results.affectedRows! > 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.green,
              content: Center(
                child: Text('عکس کارمند موفقانه تغییر کرد.'),
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

  @override
  void initState() {
    super.initState();
    // Clear image caching since Flutter by default does.
    imageCache.clear();
    imageCache.clearLiveImages();
    StaffInfo.onFetchStaffPhoto(gStaffID);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Clear image caching since Flutter by default does.
    imageCache.clear();
    imageCache.clearLiveImages();
    StaffInfo.onFetchStaffPhoto(gStaffID);
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
                future: StaffInfo.onFetchStaffPhoto(gStaffID),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return InkWell(
                      onTap: _onUpdateStaffPhoto,
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
                                        backgroundImage: _image = (StaffInfo
                                                    .uint8list !=
                                                null)
                                            ? MemoryImage(StaffInfo.uint8list!)
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
                                    backgroundImage: _image = (StaffInfo
                                                .uint8list !=
                                            null)
                                        ? MemoryImage(StaffInfo.uint8list!)
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              MediaQuery.of(context).size.width * 0.017),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.1,
                        child: Text('$gStaffFName $gStaffLName',
                            style: Theme.of(context).textTheme.headlineSmall),
                      ),
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
                              gStaffPhone,
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
                          style: const TextStyle(onEditStaffInfo
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

class _StaffMoreDetail extends StatefulWidget {
  @override
  State<_StaffMoreDetail> createState() => _StaffMoreDetailState();
}

class _StaffMoreDetailState extends State<_StaffMoreDetail> {
  String? fileExtension = gstaffFType;
// This function edits patient's personal info
  onEditStaffInfo(BuildContext context) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Directionality(
          textDirection: TextDirection.rtl,
          child: Text('تغییر معلومات شخصی مریض'),
        ),
        content: const Directionality(
          textDirection: TextDirection.rtl,
          child: Text('آیا کاملاً مطمیین هستید در قسمت خانه پری این صفحه؟'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
              child: const Text('لغو')),
          ElevatedButton(
              onPressed: () {
                setState(() {});
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: const Text('تغییر')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      width: MediaQuery.of(context).size.width * 0.52,
      child: Card(
        elevation: 0.5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 20.0, bottom: 20.0),
                      child: Column(
                        children: [
                          const Text(
                            'تاریخ استخدام',
                            style:
                                TextStyle(color: Colors.grey, fontSize: 12.0),
                          ),
                          Text(gStaffHDate),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20.0, bottom: 20.0),
                      child: Column(
                        children: [
                          const Text('بست',
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 12.0)),
                          Text(gStaffPos),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (gStaffPos != 'کار آموز')
                      Container(
                        margin: const EdgeInsets.only(left: 20.0, bottom: 20.0),
                        child: Column(
                          children: [
                            const Text('معاش',
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 12.0)),
                            Text('$gStaffSalary افغانی'),
                          ],
                        ),
                      ),
                    if (gStaffPos == 'کار آموز')
                      Container(
                        margin: const EdgeInsets.only(left: 20.0, bottom: 20.0),
                        child: Column(
                          children: [
                            const Text('مقدار پول ضمانت',
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 12.0)),
                            Text('$gStaffPrePay افغانی'),
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
                            const Text('نمبر تماس عضو فامیل 1',
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 12.0)),
                            Text(gStaffFPhone1),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20.0, bottom: 20.0),
                      child: Column(
                        children: [
                          const Text('نمبر تماس عضو فامیل 2',
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 12.0)),
                          Text(gStaffFPhone2),
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
                          const Text('آدرس',
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 12.0)),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.07,
                            child: Text(gStaffAddr),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20.0, bottom: 20.0),
                      child: Column(
                        children: [
                          const Text(
                            'نمبر تذکره',
                            style:
                                TextStyle(color: Colors.grey, fontSize: 12.0),
                          ),
                          Text(gStaffTazkira),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(left: 20.0, bottom: 20.0),
              child: InkWell(
                onTap: () async {
                  // This is your Uint8List variable
                  Uint8List? convertToU8List = gStaffContract;

                  // Write the Uint8List to a temporary file
                  var tempDir = await getTemporaryDirectory();
                  File tempFile =
                      File('${tempDir.path}/temp_file$fileExtension');

                  if (convertToU8List == null) {
                    const snackbar = SnackBar(
                      content: Center(
                        child: Text(
                          'فایل قرارداد یافت نشد.',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      backgroundColor: Colors.red,
                    );
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  } else {
                    await tempFile.writeAsBytes(convertToU8List);
                    OpenFile.open(tempFile.path);
                  }

                  // Open the file with the appropriate viewer
                  /*  if (fileExtension == '.pdf') {
                        // It's a PDF file
                        // ignore: use_build_context_synchronously
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SfPdfViewer.file(
                              File(tempFile.path),
                            ),
                          ),
                        );
                      } else if (fileExtension == '.png' ||
                          fileExtension == '.jpg' ||
                          fileExtension == '.jpeg') {
                        // It's an image file
                        // ignore: use_build_context_synchronously
                        OpenFile.open(tempFile.path);
                        /*  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Image.memory(convertToU8List)),
                        ); */
                      } else if (fileExtension == '.docx') {
                        // It's a Word document
                        OpenFile.open(tempFile.path);
                      } */
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blue, width: 1.3),
                  ),
                  child: Tooltip(
                    message: 'باز کردن قرارداد خط',
                    child: Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.008),
                      child: fileExtension == '.docx'
                          ? Icon(FontAwesomeIcons.fileWord,
                              size: MediaQuery.of(context).size.width * 0.012,
                              color: Colors.blue)
                          : fileExtension == '.png' ||
                                  fileExtension == '.jpeg' ||
                                  fileExtension == '.jpg'
                              ? Icon(FontAwesomeIcons.fileImage,
                                  size:
                                      MediaQuery.of(context).size.width * 0.012,
                                  color: Colors.blue)
                              : Icon(FontAwesomeIcons.solidFilePdf,
                                  size:
                                      MediaQuery.of(context).size.width * 0.012,
                                  color: Colors.blue),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

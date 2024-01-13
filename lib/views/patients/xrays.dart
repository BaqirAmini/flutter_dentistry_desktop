import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dentistry/config/global_usage.dart';
import 'package:flutter_dentistry/models/db_conn.dart';
import 'package:flutter_dentistry/views/main/dashboard.dart';
import 'package:flutter_dentistry/views/patients/patient_info.dart';
import 'package:flutter_dentistry/views/patients/patients.dart';
import 'package:flutter_dentistry/views/settings/settings_menu.dart';
import 'package:flutter_dentistry/views/staff/staff_info.dart';
import 'package:intl/intl.dart' as intl2;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

void main() => runApp(XRayUploadScreen());

class XRayUploadScreen extends StatelessWidget {
  XRayUploadScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('X-Ray Categories'),
            leading: IconButton(
                splashRadius: 27.0,
                onPressed: () => Navigator.pop(context),
                icon: const BackButtonIcon()),
            actions: [
              IconButton(
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const Patient()),
                    (route) => route.settings.name == 'Patient'),
                icon: const Icon(Icons.people_outline),
                tooltip: 'Patients',
                padding: const EdgeInsets.all(3.0),
                splashRadius: 30.0,
              ),
              const SizedBox(width: 15.0),
              IconButton(
                  splashRadius: 27.0,
                  tooltip: 'Dashboard',
                  padding: const EdgeInsets.all(3.0),
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const Dashboard(),
                      )),
                  icon: const Icon(Icons.home_outlined)),
              const SizedBox(width: 15.0)
            ],
            backgroundColor: Colors.blue,
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: Material(
                color: Colors.white70,
                child: TabBar(
                  unselectedLabelColor: Colors.blue,
                  labelColor: Colors.green,
                  indicatorColor: Colors.green,
                  tabs: [
                    Tab(
                      text: 'Periapical ',
                    ),
                    Tab(
                      text: 'Orthopantomagram (OPG)',
                    ),
                    Tab(
                      text: '3D',
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: TabBarView(
            children: [
              _ImageThumbNail(xrayCategory: 'Periapical'),
              _ImageThumbNail(xrayCategory: 'OPG'),
              _ImageThumbNail(xrayCategory: '3D')
            ],
          ),
        ),
      ),
    );
  }
}

// This function fetches all x-ray images details from database.
Future<List<XRayDataModel>> _fetchXRayImages(String type) async {
  try {
    final conn = await onConnToDb();
    final results = await conn.query(
        'SELECT xray_ID, xray_name, DATE_FORMAT(reg_date, "%M %d, %Y"), xray_type, description FROM patient_xrays WHERE pat_ID = ? AND xray_type = ?',
        [PatientInfo.patID, type]);
    final xrays = results
        .map((row) => XRayDataModel(
            xrayID: row[0],
            xrayImage: row[1].toString(),
            xrayDate: row[2].toString(),
            xrayType: row[3],
            xrayDescription: row[4].toString()))
        .toList();
    return xrays;
  } catch (e) {
    print('Error retrieving xrays: $e');
    return Future.value([]);
  }
}

// Create this class to separate the the repeated widget
// ignore: must_be_immutable
class _ImageThumbNail extends StatefulWidget {
  final String xrayCategory;

  _ImageThumbNail({Key? key, required this.xrayCategory}) : super(key: key);

  @override
  State<_ImageThumbNail> createState() => __ImageThumbNailState();
}

class __ImageThumbNailState extends State<_ImageThumbNail> {
  File? _selectedImage;
  bool _isLoadingXray = false;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<XRayDataModel>>(
      future: _fetchXRayImages(widget.xrayCategory),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          if (snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No X-Ray Image Found.',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: 15.0),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.065,
                    width: MediaQuery.of(context).size.width * 0.065,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          side: const BorderSide(color: Colors.blue)),
                      onPressed: () {
                        int tabIndex = DefaultTabController.of(context).index;
                        _onUploadXRayImage(tabIndex, () {
                          setState(() {});
                        });
                      },
                      child: const Icon(Icons.add_a_photo_outlined),
                    ),
                  ),
                ],
              ),
            );
          } else {
            var xrayData = snapshot.data;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Directionality(
                    textDirection: TextDirection.rtl,
                    child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                            'آدرس همه فایل های اکسری که تا حالا آپلود گریده اند: Users/account-name/Documents/DCMIS',
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold))),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: GridView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: xrayData!.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4, // Adjust number of images per row
                        crossAxisSpacing: 10.0, // Adjust horizontal spacing
                        mainAxisSpacing: 10.0, // Adjust vertical spacing
                      ),
                      itemBuilder: (context, index) {
                        final xray = xrayData[index];
                        return MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ImageViewer(
                                      images: xrayData, initialIndex: index),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blue)),
                              child: File(xray.xrayImage).existsSync()
                                  ? Image.file(
                                      File(xray.xrayImage),
                                      fit: BoxFit.cover,
                                    )
                                  : const Center(
                                      child: Text('Image not found'),
                                    ), // Replace this with your placeholder widget
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.065,
                    width: MediaQuery.of(context).size.width * 0.065,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          side: const BorderSide(color: Colors.blue)),
                      onPressed: () {
                        int tabIndex = DefaultTabController.of(context).index;
                        _onUploadXRayImage(tabIndex, () {
                          setState(() {});
                        });
                      },
                      child: const Icon(Icons.add_a_photo_outlined),
                    ),
                  ),
                ],
              ),
            );
          }
        }
      },
    );
  }

  _onUploadXRayImage(int index, Function onRefresh) {
    String xrayType = index == 0
        ? 'Periapical'
        : index == 1
            ? 'OPG'
            : '3D';

    TextEditingController dateContoller = TextEditingController();
    TextEditingController xrayNoteController = TextEditingController();
    final xrayFormKey = GlobalKey<FormState>();

    return showDialog(
        context: context,
        builder: (ctx) => StatefulBuilder(
              builder: (context, setState) {
                final xrayMessage = ValueNotifier<String>('');
                return AlertDialog(
                  title: const Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text('آپلود اکسری',
                        style: TextStyle(color: Colors.blue)),
                  ),
                  content: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.39,
                    height: MediaQuery.of(context).size.height * 1,
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: SingleChildScrollView(
                        child: Form(
                          key: xrayFormKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 30.0, vertical: 5.0),
                                child: Card(
                                  elevation: 3.0,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('نوعیت اکسری:'),
                                        Text(xrayType),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1.0,
                                          color: _selectedImage == null
                                              ? Colors.red
                                              : Colors.blue),
                                    ),
                                    margin: const EdgeInsets.all(5.0),
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                    child: InkWell(
                                      onTap: () async {
                                        setState(() {
                                          _isLoadingXray = true;
                                        });

                                        final result = await FilePicker.platform
                                            .pickFiles(
                                                allowMultiple: true,
                                                type: FileType.custom,
                                                allowedExtensions: [
                                              'jpg',
                                              'jpeg',
                                              'png'
                                            ]);
                                        if (result != null) {
                                          setState(() {
                                            _isLoadingXray = false;
                                            _selectedImage = File(result
                                                .files.single.path
                                                .toString());
                                          });
                                        }
                                      },
                                      child: _selectedImage == null &&
                                              !_isLoadingXray
                                          ? const Icon(Icons.add,
                                              size: 40, color: Colors.blue)
                                          : _isLoadingXray
                                              ? const Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                          strokeWidth: 3.0))
                                              : Image.file(_selectedImage!,
                                                  fit: BoxFit.fill),
                                    ),
                                  ),
                                  if (_selectedImage == null)
                                    const Padding(
                                      padding: EdgeInsets.only(right: 8.0),
                                      child: Text(
                                        'لطفاً فایل اکسری را انتخاب کنید.',
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.redAccent),
                                      ),
                                    ),
                                  ValueListenableBuilder<String>(
                                    valueListenable: xrayMessage,
                                    builder: (context, value, child) {
                                      if (value.isEmpty) {
                                        return const SizedBox
                                            .shrink(); // or Container()
                                      } else {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    '*',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.005),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.338,
                                    margin: const EdgeInsets.only(
                                        left: 20.0,
                                        right: 10.0,
                                        top: 10.0,
                                        bottom: 10.0),
                                    child: TextFormField(
                                      controller: dateContoller,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'تاریخ نمی تواند خالی باشد.';
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
                                          dateContoller.text = formattedDate;
                                        }
                                      },
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9.]'))
                                      ],
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'تاریخ',
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
                                margin: const EdgeInsets.all(5.0),
                                width:
                                    MediaQuery.of(context).size.width * 0.335,
                                child: TextFormField(
                                  controller: xrayNoteController,
                                  validator: (value) {
                                    if (value!.isNotEmpty) {
                                      if (value.length > 40 ||
                                          value.length < 10) {
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
                      ),
                    ),
                  ),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextButton(
                            onPressed: () =>
                                Navigator.of(context, rootNavigator: true)
                                    .pop(),
                            child: const Text('لغو')),
                        ElevatedButton(
                            onPressed: () async {
                              try {
                                if (xrayFormKey.currentState!.validate() &&
                                    _selectedImage != null) {
                                  final conn = await onConnToDb();
                                  final date = dateContoller.text;
                                  final description = xrayNoteController.text;
                                  Directory? userDir =
                                      await getApplicationDocumentsDirectory();
                                  // Name of the uploaded xray image name
                                  final xrayImageName =
                                      p.basename(_selectedImage!.path);
                                  // Patient directory path for instance, Users/name-specified-in-windows/Documents/DCMIS/Ali123
                                  final patientDirPath = p.join(
                                      userDir.path,
                                      'DCMIS',
                                      '${PatientInfo.firstName}${PatientInfo.patID}');
                                  // Patient Directory for instance, DCMIS/Ali123
                                  final patientsDir = Directory(patientDirPath);
                                  if (!patientsDir.existsSync()) {
                                    // If the directory is not existing, create it.
                                    patientsDir.createSync(recursive: true);
                                  }
                                  final xrayImagePath =
                                      p.join(patientDirPath, xrayImageName);
                                  // Firstly, query to check if the selected x-ray already exists, it should not be allowed
                                  final duplicateResult = await conn.query(
                                      'SELECT * FROM patient_xrays WHERE pat_ID = ? AND xray_name = ? AND xray_type = ?',
                                      [
                                        PatientInfo.patID,
                                        xrayImagePath,
                                        xrayType
                                      ]);
                                  // Check to not allow duplicates.
                                  if (duplicateResult.isNotEmpty) {
                                    xrayMessage.value =
                                        'اکسری با این نام قبلاً در سیستم وجود دارد. پس یا این فایل را تغییر نام داده و یا فایل دیگری را انتخاب نموده و دوباره آپلود کنید.';
                                  } else {
                                    // It should not allow x-ray images with size more than 10MB.
                                    var xraySize =
                                        await _selectedImage!.readAsBytes();
                                    if (xraySize.length > 10 * 1024 * 1024) {
                                      xrayMessage.value =
                                          'اندازه فایل اکسری باید کمتر از 10 میگابایت باشد.';
                                    } else {
                                      await _selectedImage!.copy(xrayImagePath);
                                      await conn.query(
                                          'INSERT INTO patient_xrays (pat_ID, xray_name, xray_type, reg_date, description) VALUES (?, ?, ?, ?, ?)',
                                          [
                                            PatientInfo.patID,
                                            xrayImagePath,
                                            xrayType,
                                            date,
                                            description
                                          ]);
                                      // ignore: use_build_context_synchronously
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                      onRefresh();
                                    }
                                  }
                                }
                              } catch (e) {
                                print('Uploading X-Ray failed. $e');
                              }
                            },
                            child: const Text('آپلود اکسری')),
                      ],
                    ),
                  ],
                );
              },
            ));
  }
}

class ImageViewer extends StatefulWidget {
  final List<XRayDataModel> images;
  final int initialIndex;

  const ImageViewer(
      {Key? key, required this.images, required this.initialIndex})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  int counter = 0;
  late PageController controller;
  final TransformationController _transformationController =
      TransformationController();

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('X-Ray Viewer'),
      ),
      body: Stack(
        children: <Widget>[
          PageView.builder(
            controller: controller,
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              counter = index == widget.images.length - 1
                  ? widget.images.length - 1
                  : index > 0
                      ? index
                      : 0;
              print('Index: $index');
              return MouseRegion(
                cursor: SystemMouseCursors.click,
                child: InteractiveViewer(
                  transformationController: _transformationController,
                  onInteractionEnd: _onInteractionEnd,
                  boundaryMargin: const EdgeInsets.all(20.0),
                  minScale: 0.1,
                  maxScale: 2.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        width: MediaQuery.of(context).size.width * 0.43,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Date Added:',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            Text(
                              widget.images[index].xrayDate,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        width: MediaQuery.of(context).size.width * 0.43,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Description:',
                                style: Theme.of(context).textTheme.labelLarge),
                            Text(widget.images[index].xrayDescription,
                                style: Theme.of(context).textTheme.bodyLarge),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: Image.file(File(widget.images[index].xrayImage),
                            fit: BoxFit.contain),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            child: Container(
              margin: const EdgeInsets.only(left: 30.0),
              child: Visibility(
                visible: counter > 0 ? true : false,
                child: IconButton(
                    splashRadius: 30.0,
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.grey),
                    onPressed: () {
                      if (counter > 0) {
                        controller.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                        setState(() {
                          counter--;
                        });
                      }
                      print('Previous index: $counter');
                    }),
              ),
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.only(right: 30.0),
              child: Visibility(
                visible: counter < widget.images.length - 1 ? true : false,
                child: IconButton(
                    splashRadius: 30.0,
                    icon: const Icon(Icons.arrow_forward_ios_rounded,
                        color: Colors.grey),
                    onPressed: () {
                      if (counter < widget.images.length - 1) {
                        controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                        setState(() {
                          counter++;
                        });
                      }
                      print('Current index: $counter');
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }

// This function controls the zooming when it goes beyond the scale specified.
  void _onInteractionEnd(ScaleEndDetails details) {
    _transformationController.value = Matrix4.identity();
  }
}

// Data Model of X-Ray
class XRayDataModel {
  final int xrayID;
  final String xrayImage;
  final String xrayDate;
  final String xrayType;
  final String xrayDescription;

  // Calling the constructor
  XRayDataModel(
      {required this.xrayID,
      required this.xrayImage,
      required this.xrayDate,
      required this.xrayType,
      required this.xrayDescription});
}

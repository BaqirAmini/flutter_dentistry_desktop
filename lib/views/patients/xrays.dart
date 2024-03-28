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
import 'package:flutter_dentistry/views/patients/patient_info.dart';
import 'package:flutter_dentistry/views/patients/patients.dart';
import 'package:intl/intl.dart' as intl2;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dentistry/config/developer_options.dart';

void main() => runApp(const XRayUploadScreen());

int counter = 0;
// ignore: prefer_typing_uninitialized_variables
var selectedLanguage;
// ignore: prefer_typing_uninitialized_variables
var isEnglish;

class XRayUploadScreen extends StatelessWidget {
  const XRayUploadScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fetch translations keys based on the selected language.
    var languageProvider = Provider.of<LanguageProvider>(context);
    selectedLanguage = languageProvider.selectedLanguage;
    isEnglish = selectedLanguage == 'English';
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Directionality(
          textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                  '${translations[selectedLanguage]?['Xray4'] ?? ''}${PatientInfo.firstName} ${PatientInfo.lastName}'),
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
                    onPressed: () =>
                        Navigator.of(context).push(MaterialPageRoute(
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
            body: const TabBarView(
              children: [
                _ImageThumbNail(xrayCategory: 'Periapical'),
                _ImageThumbNail(xrayCategory: 'OPG'),
                _ImageThumbNail(xrayCategory: '3D')
              ],
            ),
          ),
        ),
      ),
      theme: ThemeData(useMaterial3: false),
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

  const _ImageThumbNail({Key? key, required this.xrayCategory})
      : super(key: key);

  @override
  State<_ImageThumbNail> createState() => __ImageThumbNailState();
}

class __ImageThumbNailState extends State<_ImageThumbNail> {
  File? _selectedImage;
  bool _isLoadingXray = false;
  @override
  Widget build(BuildContext context) {
    // Fetch translations keys based on the selected language.
    var languageProvider = Provider.of<LanguageProvider>(context);
    selectedLanguage = languageProvider.selectedLanguage;
    isEnglish = selectedLanguage == 'English';
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
                    translations[selectedLanguage]?['XrayNotFound'] ?? '',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: 15.0),
                  if (Features.XRayManage)
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
                    )
                  else
                    Stack(
                      children: [
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
                              Flushbar(
                                backgroundColor: Colors.redAccent,
                                flushbarStyle: FlushbarStyle.GROUNDED,
                                flushbarPosition: FlushbarPosition.BOTTOM,
                                messageText: Directionality(
                                  textDirection: isEnglish
                                      ? TextDirection.ltr
                                      : TextDirection.rtl,
                                  child: Text(
                                    translations[selectedLanguage]
                                            ?['PremAppPurchase'] ??
                                        '',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                duration: const Duration(seconds: 3),
                              ).show(context);
                            },
                            child: const Icon(Icons.add_a_photo_outlined),
                          ),
                        ),
                        isEnglish
                            ? const Positioned(
                                top: 5.0,
                                left: 5.0,
                                child: Icon(Icons.workspace_premium_outlined,
                                    color: Colors.red),
                              )
                            : const Positioned(
                                top: 5.0,
                                right: 5.0,
                                child: Icon(Icons.workspace_premium_outlined,
                                    color: Colors.red),
                              ),
                      ],
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
                  Directionality(
                    textDirection:
                        isEnglish ? TextDirection.ltr : TextDirection.rtl,
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            '${translations[selectedLanguage]?['XrayPath'] ?? ''}Users/account-name/Documents/CROWN',
                            style: const TextStyle(
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
                        try {
                          final xray = xrayData[index];
                          return MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  counter =
                                      index; // Update the counter to the selected index
                                });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ImageViewer(
                                        images: xrayData, initialIndex: index),
                                  ),
                                );
                              },
                              child: Visibility(
                                visible: File(xray.xrayImage).existsSync()
                                    ? true
                                    : false,
                                child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.blue)),
                                    child: Image.file(
                                      File(xray.xrayImage),
                                      fit: BoxFit.cover,
                                    )),
                              ),
                            ),
                          );
                        } catch (e) {
                          print('Final image: $e');
                        }
                        return null;
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
                  title: Directionality(
                    textDirection:
                        isEnglish ? TextDirection.ltr : TextDirection.rtl,
                    child: Text(
                        translations[selectedLanguage]?['UploadXray'] ?? '',
                        style: const TextStyle(color: Colors.blue)),
                  ),
                  content: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.39,
                    height: MediaQuery.of(context).size.height * 0.55,
                    child: Directionality(
                      textDirection:
                          isEnglish ? TextDirection.ltr : TextDirection.rtl,
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
                                        Text(translations[selectedLanguage]
                                                ?['XrayType'] ??
                                            ''),
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
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Text(
                                        translations[selectedLanguage]
                                                ?['XrayFileRequired'] ??
                                            '',
                                        style: const TextStyle(
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
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 20.0),
                                    child: TextFormField(
                                      controller: dateContoller,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return translations[selectedLanguage]
                                                  ?['XrayDateRequired'] ??
                                              '';
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
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        labelText:
                                            translations[selectedLanguage]
                                                    ?['XrayDate'] ??
                                                '',
                                        suffixIcon: const Icon(
                                            Icons.calendar_month_outlined),
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
                                        errorBorder: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50.0)),
                                            borderSide:
                                                BorderSide(color: Colors.red)),
                                        focusedErrorBorder:
                                            const OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(50.0)),
                                                borderSide: BorderSide(
                                                    color: Colors.red,
                                                    width: 1.5)),
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
                                        return translations[selectedLanguage]
                                                ?['OtherDDLLength'] ??
                                            '';
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
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    labelText: translations[selectedLanguage]
                                            ?['RetDetails'] ??
                                        '',
                                    suffixIcon:
                                        const Icon(Icons.note_alt_outlined),
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
                                    errorBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50.0)),
                                        borderSide:
                                            BorderSide(color: Colors.red)),
                                    focusedErrorBorder:
                                        const OutlineInputBorder(
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
                      mainAxisAlignment: isEnglish
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        TextButton(
                            onPressed: () =>
                                Navigator.of(context, rootNavigator: true)
                                    .pop(),
                            child: Text(translations[selectedLanguage]
                                    ?['CancelBtn'] ??
                                '')),
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
                                  // Patient directory path for instance, Users/name-specified-in-windows/Documents/CROWN/Ali123
                                  final patientDirPath = p.join(
                                      userDir.path,
                                      'CROWN',
                                      '${PatientInfo.firstName}${PatientInfo.patID}');
                                  // Patient Directory for instance, CROWN/Ali123
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
                                        translations[selectedLanguage]
                                                ?['DupXrayMsg'] ??
                                            '';
                                  } else {
                                    // It should not allow x-ray images with size more than 10MB.
                                    var xraySize =
                                        await _selectedImage!.readAsBytes();
                                    if (xraySize.length > 10 * 1024 * 1024) {
                                      xrayMessage.value =
                                          translations[selectedLanguage]
                                                  ?['XraySizeMsg'] ??
                                              '';
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
                            child: Text(translations[selectedLanguage]
                                    ?['XrayUploadBtn'] ??
                                '')),
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
  late PageController controller;
  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(translations[selectedLanguage]?['XrayDetails'] ?? ''),
        ),
        body: Stack(
          children: <Widget>[
            PageView.builder(
              controller: controller,
              itemCount: widget.images.length,
              onPageChanged: (index) {
                setState(() {
                  counter = index;
                });
              },
              itemBuilder: (context, index) {
                try {
                  // This widget contains date, description and the image itself.
                  return Directionality(
                    textDirection:
                        isEnglish ? TextDirection.ltr : TextDirection.rtl,
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
                                translations[selectedLanguage]?['UploadedAt'] ??
                                    '',
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
                              Text(
                                  '${translations[selectedLanguage]?['RetDetails'] ?? ''}:',
                                  style:
                                      Theme.of(context).textTheme.labelLarge),
                              Text(widget.images[index].xrayDescription,
                                  style: Theme.of(context).textTheme.bodyLarge),
                            ],
                          ),
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            // When tapped, it opens the image using windows default image viewer.
                            onTap: () =>
                                OpenFile.open(widget.images[index].xrayImage),
                            child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black)),
                                width: MediaQuery.of(context).size.width * 0.5,
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                child: FutureBuilder(
                                  future: File(widget.images[index].xrayImage)
                                      .exists()
                                      .then((exists) {
                                    if (exists) {
                                      return File(
                                          widget.images[index].xrayImage);
                                    } else {
                                      throw Exception('Image file not found');
                                    }
                                  }),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<File> snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      if (snapshot.hasError) {
                                        // If there's an error, return a message
                                        return Center(
                                            child: Text(
                                                translations[selectedLanguage]
                                                        ?['XrayNotFound'] ??
                                                    ''));
                                      } else {
                                        // If the file exists, display it
                                        return Image.file(snapshot.data!,
                                            fit: BoxFit.fill);
                                      }
                                    } else {
                                      // While the file is being checked, display a loading spinner
                                      return const CircularProgressIndicator();
                                    }
                                  },
                                )),
                          ),
                        ),
                      ],
                    ),
                  );
                } catch (e) {
                  print('The last image: $e');
                }
              },
            ),
            // Due to applying localization this Positioned() is duplicated
            isEnglish
                ? Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    child: Container(
                      margin: const EdgeInsets.only(left: 30.0),
                      child: Visibility(
                        visible: counter > 0,
                        child: IconButton(
                            tooltip: translations[selectedLanguage]
                                    ?['PrevXray'] ??
                                '',
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
                            }),
                      ),
                    ),
                  )
                : Positioned(
                    top: 0,
                    bottom: 0,
                    right: 0,
                    child: Container(
                      margin: const EdgeInsets.only(right: 30.0),
                      child: Visibility(
                        visible: counter > 0,
                        child: IconButton(
                            tooltip: translations[selectedLanguage]
                                    ?['PrevXray'] ??
                                '',
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
                            }),
                      ),
                    ),
                  ),
            isEnglish
                ? Positioned(
                    top: 0,
                    bottom: 0,
                    right: 0,
                    child: Container(
                      margin: const EdgeInsets.only(right: 30.0),
                      child: Visibility(
                        visible: counter < widget.images.length - 1,
                        child: IconButton(
                            tooltip: translations[selectedLanguage]
                                    ?['NextXray'] ??
                                '',
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
                            }),
                      ),
                    ),
                  )
                : Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    child: Container(
                      margin: const EdgeInsets.only(left: 30.0),
                      child: Visibility(
                        visible: counter < widget.images.length - 1,
                        child: IconButton(
                            tooltip: translations[selectedLanguage]
                                    ?['NextXray'] ??
                                '',
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
                            }),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
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

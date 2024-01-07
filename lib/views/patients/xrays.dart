import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dentistry/config/global_usage.dart';
import 'package:flutter_dentistry/models/db_conn.dart';
import 'package:flutter_dentistry/views/settings/settings_menu.dart';
import 'package:flutter_dentistry/views/staff/staff_info.dart';
import 'package:intl/intl.dart' as intl2;

void main() => runApp(XRayUploadScreen());
bool _isLoadingPhoto = false;

class XRayUploadScreen extends StatelessWidget {
  XRayUploadScreen({Key? key}) : super(key: key);
  final _opgImages = [
    'assets/xrays/opg1.jpg',
    'assets/xrays/opg2.jpg',
    'assets/xrays/opg3.jpg',
    'assets/xrays/opg4.jpg',
    'assets/xrays/opg1.jpg',
    'assets/xrays/opg2.jpg',
    'assets/xrays/opg3.jpg',
    'assets/xrays/opg4.jpg',
  ];

  final _periapicalImages = [
    'assets/xrays/peri1.jpg',
    'assets/xrays/peri2.jpg',
    'assets/xrays/peri3.jpg',
    'assets/xrays/peri4.jpg',
    'assets/xrays/peri1.jpg',
    'assets/xrays/peri2.jpg',
    'assets/xrays/peri3.jpg',
    'assets/xrays/peri4.jpg',
    'assets/xrays/peri1.jpg',
    'assets/xrays/peri2.jpg',
    'assets/xrays/peri3.jpg',
    'assets/xrays/peri4.jpg',
  ];

  final _3DImages = [
    'assets/xrays/3D1.jpg',
    'assets/xrays/3D2.jpg',
    'assets/xrays/3D3.jpg',
    'assets/xrays/3D4.jpg',
  ];

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
                splashRadius: 30.0,
                onPressed: () => Navigator.pop(context),
                icon: const BackButtonIcon()),
            actions: [
              IconButton(
                  splashRadius: 30.0,
                  onPressed: () {},
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
              _ImageThumbNail(xrayType: _periapicalImages),
              _ImageThumbNail(xrayType: _opgImages),
              _ImageThumbNail(xrayType: _3DImages)
            ],
          ),
        ),
      ),
    );
  }
}

// Create this class to separate the the repeated widget
// ignore: must_be_immutable
class _ImageThumbNail extends StatefulWidget {
  List<String> xrayType = [];

  _ImageThumbNail({Key? key, required this.xrayType}) : super(key: key);

  @override
  State<_ImageThumbNail> createState() => __ImageThumbNailState();
}

class __ImageThumbNailState extends State<_ImageThumbNail> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.7,
            child: GridView.builder(
              scrollDirection: Axis.vertical,
              itemCount: widget.xrayType.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // Adjust number of images per row
                crossAxisSpacing: 10.0, // Adjust horizontal spacing
                mainAxisSpacing: 10.0, // Adjust vertical spacing
              ),
              itemBuilder: (context, index) {
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImageViewer(
                              images: widget.xrayType, initialIndex: index),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)),
                      child: Image.asset(widget.xrayType[index],
                          fit: BoxFit.cover),
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
                _onUploadXRayImage(tabIndex);
              },
              child: const Icon(Icons.add_a_photo_outlined),
            ),
          ),
        ],
      ),
    );
  }

  _onUploadXRayImage(int index) {
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
      builder: (ctx) => AlertDialog(
        title: const Directionality(
          textDirection: TextDirection.rtl,
          child: Text('آپلود اکسری'),
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.39,
          height: MediaQuery.of(context).size.height * 0.7,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Form(
              key: xrayFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('نوعیت اکسری:'),
                        Text(xrayType),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(5.0),
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          side: const BorderSide(color: Colors.blue)),
                      onPressed: () => _onPickXRay(),
                      child: const Icon(Icons.add),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(5.0),
                    child: Row(
                      children: [
                        const Text(
                          '*',
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 7.0),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.34,
                          margin: const EdgeInsets.only(
                              left: 20.0, right: 10.0, top: 10.0, bottom: 10.0),
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
                              final DateTime? dateTime = await showDatePicker(
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
                              suffixIcon: Icon(Icons.calendar_month_outlined),
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
                  Container(
                    margin: const EdgeInsets.all(5.0),
                    width: MediaQuery.of(context).size.width * 0.34,
                    child: TextFormField(
                      controller: xrayNoteController,
                      validator: (value) {
                        if (value!.isNotEmpty) {
                          if (value.length > 40 || value.length < 10) {
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
                            borderSide:
                                BorderSide(color: Colors.red, width: 1.5)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
              child: const Text('لغو')),
          ElevatedButton(
              onPressed: () {
                if (xrayFormKey.currentState!.validate()) {}
              },
              child: const Text('آپلود اکسری')),
        ],
      ),
    );
  }

// This method is to update profile picture of the user
  void _onPickXRay() async {
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
}

class ImageViewer extends StatefulWidget {
  final List<String> images;
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
                  boundaryMargin: const EdgeInsets.all(20.0),
                  minScale: 0.1,
                  maxScale: 2.0,
                  child: Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.height * 4.0,
                      child: Image.asset(widget.images[index],
                          fit: BoxFit.contain),
                    ),
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
}

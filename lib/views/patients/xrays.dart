import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class XRayUploadScreen extends StatefulWidget {
  const XRayUploadScreen({super.key});

  @override
  _XRayUploadScreen createState() => _XRayUploadScreen();
}

class _XRayUploadScreen extends State<XRayUploadScreen> {
  List<File> _imageFiles = [];
  final TransformationController _controller = TransformationController();
  String? _selectedPatient;
  final TextEditingController _notesController = TextEditingController();

  // This is just a sample list of patients. You should replace this with your actual list.
  final List<String> _patients = ['John', 'Jane', 'Doe'];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            leading: Tooltip(
              message: 'رفتن به داشبورد',
              child: IconButton(
                icon: const Icon(Icons.home_outlined),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            title: const Text('X-Ray'),
          ),
          body: Directionality(
            textDirection: TextDirection.rtl,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    DropdownButton<String>(
                      value: _selectedPatient,
                      hint: const Text('Select a patient'),
                      items: _patients.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedPatient = newValue;
                        });
                      },
                    ),
                    if (_selectedPatient != null)
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Text('Patient Information'),
                              Text('Name: $_selectedPatient'),
                              // Add more patient information here
                            ],
                          ),
                        ),
                      ),
                    ElevatedButton(
                      child: const Text('Select X-Ray Images'),
                      onPressed: () async {
                        final result = await FilePicker.platform.pickFiles(
                            type: FileType.image, allowMultiple: true);

                        if (result != null) {
                          setState(() {
                            _imageFiles = result.paths
                                .map((path) => File(path!))
                                .toList();
                          });
                        } else {
                          print('No images selected.');
                        }
                      },
                    ),
                    for (var imageFile in _imageFiles) Image.file(imageFile),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width *
                            0.8, // Adjust the TextField width here
                        child: TextField(
                          controller: _notesController,
                          maxLines: 5,
                          decoration: InputDecoration(
                              hintText: "Enter your notes here"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

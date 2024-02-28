import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dentistry/config/global_usage.dart';
import 'package:flutter_dentistry/config/language_provider.dart';
import 'package:flutter_dentistry/models/db_conn.dart';
import 'package:flutter_dentistry/views/main/dashboard.dart';
import 'package:flutter_dentistry/views/patients/new_patient.dart';
import 'package:flutter_dentistry/views/patients/patient_details.dart';
import 'package:flutter_dentistry/views/services/service_related_fields.dart';
import 'package:flutter_dentistry/views/staff/staff_info.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'patient_info.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_dentistry/config/translations.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

void main() {
  return runApp(const Patient());
}

// Assign default selected staff
String? defaultSelectedStaff;
List<Map<String, dynamic>> staffList = [];

int? staffID;
int? patientID;

// ignore: prefer_typing_uninitialized_variables
var selectedLanguage;
// ignore: prefer_typing_uninitialized_variables
var isEnglish;

// Assign default selected staff
String? defaultSelectedPatient;
List<Map<String, dynamic>> patientsList = [];
// This dialog creates prescription
onCreatePrescription(BuildContext context) {
  // This list will contain medicine types
  List<Map<String, dynamic>> medicines = [
    {
      'type': 'Syrups',
      'piece': '150mg',
      'qty': '1',
      'dose': '1 x 1',
      'nameController': TextEditingController(),
      'descController': TextEditingController()
    }
  ];
  const regExOnlyAbc = "[a-zA-Z,، \u0600-\u06FFF]";
  TextEditingController patientSearchableController = TextEditingController();
  int? selectedPatientID;
  String? selectedPFName;
  String? selectedPLName;
  int? selectedPAge;
  String? selectedPSex;

  // Set 1 - 100 for medicine quantity
  List<String> medicineQty = [];
  for (int i = 1; i <= 100; i++) {
    medicineQty.add('$i');
  }

// Key for Form widget
  final formKeyPresc = GlobalKey<FormState>();
  // ignore: use_build_context_synchronously
  return showDialog(
    context: context,
    builder: ((context) {
      return StatefulBuilder(
        builder: (BuildContext context, setState) {
          return AlertDialog(
            title: Directionality(
              textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
              child: const Text(
                'تجویز نسخه برای مریض',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            actions: [
              Directionality(
                  textDirection:
                      isEnglish ? TextDirection.ltr : TextDirection.rtl,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () =>
                              Navigator.of(context, rootNavigator: true).pop(),
                          child: const Text('بستن')),
                      ElevatedButton(
                        onPressed: () async {
                          if (formKeyPresc.currentState!.validate()) {
                            /* -------------------- Fetch staff firstname & lastname ---------------- */
                            final conn = await onConnToDb();
                            final results = await conn.query(
                                'SELECT * FROM staff WHERE staff_ID = ?',
                                [defaultSelectedStaff]);
                            var row = results.first;
                            String drFirstName = row['firstname'];
                            String drLastName = row['lastname'] ?? '';
                            String drPhone = row['phone'];
                            /* --------------------/. Fetch staff firstname & lastname ---------------- */

                            // Current date
                            DateTime now = DateTime.now();
                            String formattedDate =
                                intl.DateFormat('yyyy/MM/dd').format(now);

                            const imageProvider = AssetImage(
                              'assets/graphics/logo1.png',
                            );
                            final dentalLogo =
                                await flutterImageProvider(imageProvider);
                            final pdf = pw.Document();
                            final fontData = await rootBundle
                                .load('assets/fonts/per_sans_font.ttf');
                            final ttf = pw.Font.ttf(fontData);

                            pdf.addPage(pw.Page(
                              pageFormat: PdfPageFormat.a4,
                              build: (pw.Context context) {
                                return pw.Column(children: [
                                  pw.Header(
                                    level: 0,
                                    child: pw.Row(
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.center,
                                        children: [
                                          pw.Image(
                                            dentalLogo,
                                            width: 100.0,
                                            height: 100.0,
                                          ),
                                          pw.Directionality(
                                            textDirection: pw.TextDirection.rtl,
                                            child: pw.Column(children: [
                                              pw.Text(
                                                'کلینیک تخصصی دندان درمان',
                                                style: pw.TextStyle(
                                                  fontSize: 20,
                                                  font: ttf,
                                                  fontWeight:
                                                      pw.FontWeight.bold,
                                                  color: const PdfColor(
                                                      51 / 255,
                                                      153 / 255,
                                                      255 / 255),
                                                ),
                                              ),
                                              pw.Text(
                                                'آدرس: دشت برچی، قلعه ناظر، مقابل پسته خانه',
                                                style: pw.TextStyle(
                                                  fontSize: 12,
                                                  font: ttf,
                                                  color: const PdfColor(
                                                      51 / 255,
                                                      153 / 255,
                                                      255 / 255),
                                                ),
                                              ),
                                              pw.Text(
                                                'داکتر $drFirstName $drLastName',
                                                style: pw.TextStyle(
                                                  font: ttf,
                                                  fontSize: 12,
                                                  color: const PdfColor(
                                                      51 / 255,
                                                      153 / 255,
                                                      255 / 255),
                                                ),
                                              ),
                                            ]),
                                          ),
                                        ]),
                                  ),
                                  pw.Row(
                                    mainAxisAlignment:
                                        pw.MainAxisAlignment.spaceBetween,
                                    children: <pw.Widget>[
                                      pw.Directionality(
                                          child: pw.Text(
                                            'Date: $formattedDate',
                                            style: pw.TextStyle(font: ttf),
                                          ),
                                          textDirection: pw.TextDirection.rtl),
                                      pw.Directionality(
                                          child: pw.Align(
                                            alignment: pw.Alignment.centerLeft,
                                            child: pw.Text(
                                              'Age: $selectedPAge',
                                              style: pw.TextStyle(font: ttf),
                                            ),
                                          ),
                                          textDirection: pw.TextDirection.rtl),
                                      pw.Directionality(
                                          child: pw.Align(
                                            alignment: pw.Alignment.centerLeft,
                                            child: pw.Text(
                                              'Sex: $selectedPSex',
                                              style: pw.TextStyle(font: ttf),
                                            ),
                                          ),
                                          textDirection: pw.TextDirection.rtl),
                                      pw.Directionality(
                                          child: pw.Align(
                                            alignment: pw.Alignment.centerRight,
                                            child: pw.Text(
                                              'Patient\'s Name: $selectedPFName $selectedPLName',
                                              style: pw.TextStyle(font: ttf),
                                            ),
                                          ),
                                          textDirection: pw.TextDirection.rtl),
                                      /*  pw.Paragraph(
                                          text: 'تاریخ: $formattedDate'), */
                                    ],
                                  ),
                                  pw.Header(level: 1, text: 'Px'),
                                  ...medicines
                                      .map((medicine) => pw.Padding(
                                            padding: const pw.EdgeInsets.only(
                                                top: 10,
                                                left:
                                                    15.0), // Adjust the value as needed
                                            child: pw.Align(
                                              alignment:
                                                  pw.Alignment.centerLeft,
                                              child: pw.Table(
                                                columnWidths: {
                                                  0: const pw.FixedColumnWidth(
                                                      100),
                                                  1: const pw.FixedColumnWidth(
                                                      150),
                                                  2: const pw.FixedColumnWidth(
                                                      80),
                                                  3: const pw.FixedColumnWidth(
                                                      80),
                                                  4: const pw.FixedColumnWidth(
                                                      80),
                                                  5: const pw.FixedColumnWidth(
                                                      180),
                                                }, // Make each column the same width
                                                children: [
                                                  pw.TableRow(
                                                    children: [
                                                      pw.Text(
                                                          (medicine['type'] ==
                                                                  'Syrups')
                                                              ? 'SYR'
                                                              : (medicine['type'] ==
                                                                      'Capsules')
                                                                  ? 'CAP'
                                                                  : (medicine['type'] ==
                                                                          'Tablets')
                                                                      ? 'TAB'
                                                                      : (medicine['type'] ==
                                                                              'Ointments')
                                                                          ? 'UNG'
                                                                          : (medicine['type'] == 'Solutions')
                                                                              ? 'SOL'
                                                                              : (medicine['type'] == 'Ampoules')
                                                                                  ? 'AMP'
                                                                                  : (medicine['type'] == 'Flourides')
                                                                                      ? 'FL'
                                                                                      : (medicine['type']),
                                                          style: pw.TextStyle(font: ttf)),
                                                      pw.Text(
                                                          (medicine[
                                                                  'nameController']
                                                              .text),
                                                          style: pw.TextStyle(
                                                              font: ttf)),
                                                      pw.Text(
                                                          '${medicine['piece']}',
                                                          style: pw.TextStyle(
                                                              font: ttf)),
                                                      pw.Text(
                                                          '${medicine['dose']}',
                                                          style: pw.TextStyle(
                                                              font: ttf)),
                                                      pw.Text(
                                                          'N = ${medicine['qty']}',
                                                          style: pw.TextStyle(
                                                              font: ttf)),
                                                      pw.Directionality(
                                                        textDirection: pw
                                                            .TextDirection.rtl,
                                                        child: pw.Text(
                                                          '${medicine['descController'].text ?? ''}',
                                                          style: pw.TextStyle(
                                                              font: ttf),
                                                        ),
                                                      ), // Use an empty string if the description is null
                                                      pw.SizedBox(width: 2.0)
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                  pw.Spacer(),
                                  pw.Text('Signature:'),
                                  pw.SizedBox(height: 20.0),
                                  pw.Divider(
                                    height: 10,
                                    thickness: 1.0,
                                  ),
                                  pw.Row(
                                      mainAxisAlignment:
                                          pw.MainAxisAlignment.spaceBetween,
                                      children: [
                                        pw.Text('Phone: $drPhone'),
                                        pw.Text(
                                            'Email: darman.clinic@gmail.com'),
                                      ]),
                                ]);
                              },
                            ));

                            // Save the PDF
                            final bytes = await pdf.save();
                            final fileName = selectedPFName!.isNotEmpty
                                ? '$selectedPFName.pdf'
                                : 'prescription.pdf';
                            await Printing.sharePdf(
                                bytes: bytes, filename: fileName);
                            Navigator.pop(context);
                            /*   // Print the PDF
                            await Printing.layoutPdf(
                              onLayout: (PdfPageFormat format) async => bytes,
                            ); */
                            await conn.close();
                          }
                        },
                        child: const Text('ایجاد نسخه'),
                      ),
                    ],
                  ))
            ],
            content: Form(
              key: formKeyPresc,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.35,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.30,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.14,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 10.0),
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'انتخاب داکتر',
                                  labelStyle:
                                      TextStyle(color: Colors.blueAccent),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.0)),
                                      borderSide:
                                          BorderSide(color: Colors.blueAccent)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.0)),
                                      borderSide:
                                          BorderSide(color: Colors.blue)),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.0)),
                                      borderSide:
                                          BorderSide(color: Colors.red)),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.0)),
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 1.5)),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: Container(
                                    height: 18.0,
                                    padding: EdgeInsets.zero,
                                    child: DropdownButton(
                                      isExpanded: true,
                                      icon: const Icon(Icons.arrow_drop_down),
                                      value: defaultSelectedStaff,
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.black),
                                      items: staffList.map((staff) {
                                        return DropdownMenuItem<String>(
                                          value: staff['staff_ID'],
                                          alignment: Alignment.centerRight,
                                          child: Text(staff['firstname'] +
                                              ' ' +
                                              staff['lastname']),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          defaultSelectedStaff = newValue;
                                          staffID = int.parse(newValue!);
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.14,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 10.0),
                              child: Column(
                                children: [
                                  TypeAheadField(
                                    suggestionsCallback: (search) async {
                                      try {
                                        final conn = await onConnToDb();
                                        var results = await conn.query(
                                            'SELECT pat_ID, firstname, lastname, phone, age, sex FROM patients WHERE firstname LIKE ?',
                                            ['%$search%']);

                                        // Convert the results into a list of Patient objects
                                        var suggestions = results
                                            .map((row) => PatientDataModel(
                                                patientId: row[0] as int,
                                                patientFName: row[1],
                                                patientLName: row[2] ?? '',
                                                patientPhone: row[3],
                                                patientAge: row[4] as int,
                                                patientGender: row[5]))
                                            .toList();
                                        await conn.close();
                                        return suggestions;
                                      } catch (e) {
                                        print(
                                            'Something wrong with patient searchable dropdown: $e');
                                        return [];
                                      }
                                    },
                                    builder: (context, controller, focusNode) {
                                      patientSearchableController = controller;
                                      return TextFormField(
                                        controller: controller,
                                        focusNode: focusNode,
                                        autofocus: true,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Patient not selected';
                                          }
                                          return null;
                                        },
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'انتخاب مریض',
                                          labelStyle:
                                              TextStyle(color: Colors.grey),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15.0)),
                                              borderSide: BorderSide(
                                                  color: Colors.grey)),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15.0)),
                                              borderSide: BorderSide(
                                                  color: Colors.blue)),
                                          errorBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15.0)),
                                              borderSide: BorderSide(
                                                  color: Colors.red)),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              15.0)),
                                                  borderSide: BorderSide(
                                                      color: Colors.red,
                                                      width: 1.5)),
                                        ),
                                      );
                                    },
                                    itemBuilder: (context, patient) {
                                      return Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: ListTile(
                                          title: Text(
                                              '${patient.patientFName} ${patient.patientLName}'),
                                          subtitle: Text(patient.patientPhone),
                                        ),
                                      );
                                    },
                                    onSelected: (patient) {
                                      setState(
                                        () {
                                          patientSearchableController.text =
                                              '${patient.patientFName} ${patient.patientLName}';
                                          selectedPatientID = patient.patientId;
                                          selectedPFName = patient.patientFName;
                                          selectedPLName = patient.patientLName;
                                          selectedPAge = patient.patientAge;
                                          selectedPSex = patient.patientGender;
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      ...medicines.map((medicine) {
                        return SizedBox(
                          width: MediaQuery.of(context).size.width * 0.31,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 20.0,
                                    right: 20.0,
                                    top: 10.0,
                                    bottom: 10.0),
                                child: InputDecorator(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Medicine Type',
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50.0)),
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50.0)),
                                      borderSide:
                                          BorderSide(color: Colors.blue),
                                    ),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: SizedBox(
                                      height: 26.0,
                                      child: DropdownButton<String>(
                                        isExpanded: true,
                                        value: medicine['type'],
                                        onChanged: (newValue) {
                                          setState(() {
                                            medicine['type'] = newValue;
                                          });
                                        },
                                        items: <String>[
                                          'Syrups',
                                          'Capsules',
                                          'Tablets',
                                          'Mouthwashes',
                                          'Ointments',
                                          'Gels',
                                          'Solutions',
                                          'Ampoules',
                                          'Flourides',
                                          'Sprays',
                                          'Lozenges',
                                          'Drops',
                                          'Toothpastes',
                                        ].map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 20.0,
                                    right: 20.0,
                                    top: 10.0,
                                    bottom: 10.0),
                                child: TextFormField(
                                  controller: medicine['nameController'],
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'نام دارو الزامی میباشد.';
                                    } else if (value.length > 20 ||
                                        value.length < 5) {
                                      return 'نام دارو باید حداقل 5 و حداکثر 20 حرف باشد.';
                                    }
                                    return null;
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(regExOnlyAbc),
                                    ),
                                  ],
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Medicine Name',
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
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 20.0,
                                    right: 20.0,
                                    top: 10.0,
                                    bottom: 10.0),
                                child: InputDecorator(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Pieces',
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50.0)),
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50.0)),
                                      borderSide:
                                          BorderSide(color: Colors.blue),
                                    ),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: SizedBox(
                                      height: 26.0,
                                      child: DropdownButton<String>(
                                        isExpanded: true,
                                        value: medicine['piece'],
                                        onChanged: (newValue) {
                                          setState(() {
                                            medicine['piece'] = newValue;
                                          });
                                        },
                                        items: <String>[
                                          '50mg',
                                          '100mg',
                                          '150mg',
                                          '250mg',
                                          '500mg'
                                        ].map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 20.0,
                                    right: 20.0,
                                    top: 10.0,
                                    bottom: 10.0),
                                child: InputDecorator(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Quantity',
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50.0)),
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50.0)),
                                      borderSide:
                                          BorderSide(color: Colors.blue),
                                    ),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: SizedBox(
                                      height: 26.0,
                                      child: DropdownButton<String>(
                                        isExpanded: true,
                                        value: medicine['qty'],
                                        onChanged: (newValue) {
                                          setState(() {
                                            medicine['qty'] = newValue;
                                          });
                                        },
                                        items: medicineQty
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 20.0,
                                    right: 20.0,
                                    top: 10.0,
                                    bottom: 10.0),
                                child: InputDecorator(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Doses',
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50.0)),
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50.0)),
                                      borderSide:
                                          BorderSide(color: Colors.blue),
                                    ),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: SizedBox(
                                      height: 26.0,
                                      child: DropdownButton<String>(
                                        isExpanded: true,
                                        value: medicine['dose'],
                                        onChanged: (newValue) {
                                          setState(() {
                                            medicine['dose'] = newValue;
                                          });
                                        },
                                        items: <String>[
                                          '1 x 1',
                                          '1 x 2',
                                          '1 x 3'
                                        ].map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 20.0,
                                    right: 20.0,
                                    top: 10.0,
                                    bottom: 10.0),
                                child: TextFormField(
                                  controller: medicine['descController'],
                                  validator: (value) {
                                    if (value!.isNotEmpty) {
                                      if (value.length > 25 ||
                                          value.length < 5) {
                                        return 'توضیحات باید حداقل 5 و حداکثر 25 حرف باشد.';
                                      }
                                    }
                                    return null;
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(regExOnlyAbc),
                                    ),
                                  ],
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Details',
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
                              IconButton(
                                tooltip: 'حذف دارو',
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.redAccent,
                                  size: 18.0,
                                ),
                                onPressed: () {
                                  setState(() {
                                    medicines.remove(medicine);
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(
                        height: 30,
                      ),
                      Tooltip(
                        message: 'افزودن دارو',
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              medicines.add({
                                'type': 'Syrups',
                                'piece': '150mg',
                                'qty': '1',
                                'dose': '1 x 1',
                                'nameController': TextEditingController(),
                                'descController': TextEditingController()
                              });
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: Colors.blue, width: 2.0),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.add,
                                color: Colors.blue,
                              ),
                            ),
                          ),
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
    }),
  );
}

bool containsPersian(String input) {
  final persianRegex = RegExp(r'[\u0600-\u06FF]');
  return persianRegex.hasMatch(input);
}

String reverseString(String input) {
  return input.split('').reversed.join('');
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

class Patient extends StatefulWidget {
  const Patient({Key? key}) : super(key: key);

  @override
  _PatientState createState() => _PatientState();
}

class _PatientState extends State<Patient> {
  // Fetch staff which will be needed later.
  Future<void> fetchStaff() async {
    // Fetch staff for purchased by fields
    var conn = await onConnToDb();
    var results = await conn.query(
        'SELECT staff_ID, firstname, lastname FROM staff WHERE position = ?',
        ['داکتر دندان']);
    defaultSelectedStaff =
        staffList.isNotEmpty ? staffList[0]['staff_ID'] : null;
    // setState(() {
    staffList = results
        .map((result) => {
              'staff_ID': result[0].toString(),
              'firstname': result[1],
              'lastname': result[2]
            })
        .toList();
    // });
    await conn.close();
  }

  // Fetch patients
  Future<void> fetchPatients() async {
    // Fetch patients for prescription
    var conn = await onConnToDb();
    var results =
        await conn.query('SELECT pat_ID, firstname, lastname FROM patients');
    defaultSelectedPatient =
        patientsList.isNotEmpty ? patientsList[0]['pat_ID'] : null;
    // setState(() {
    patientsList = results
        .map((result) => {
              'pat_ID': result[0].toString(),
              'firstname': result[1],
              'lastname': result[2]
            })
        .toList();
    // });
    await conn.close();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Call the function to list staff in the dropdown.
    fetchStaff();
    fetchPatients();
  }

  @override
  Widget build(BuildContext context) {
    // Fetch translations keys based on the selected language.
    var languageProvider = Provider.of<LanguageProvider>(context);
    selectedLanguage = languageProvider.selectedLanguage;
    isEnglish = selectedLanguage == 'English';
    // Call the function to list staff in the dropdown.
    fetchStaff();
    fetchPatients();
    return Directionality(
      textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
          appBar: AppBar(
            title: Text(translations[selectedLanguage]?['AllPatients'] ?? ''),
          ),
          body: const PatientDataTable()),
    );
  }
}

// This is to display an alert dialog to delete a patient
onDeletePatient(BuildContext context, Function onRefresh) {
  int? patientId = PatientInfo.patID;
  String? fName = PatientInfo.firstName;
  String? lName = PatientInfo.lastName;

  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Directionality(
        textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
        child: Text(
            '${translations[selectedLanguage]?['DeletePatientTitle'] ?? ''} $fName $lName'),
      ),
      content: Directionality(
        textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
        child: Text(translations[selectedLanguage]?['ConfirmDelete'] ?? ''),
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment:
                !isEnglish ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () =>
                    Navigator.of(context, rootNavigator: true).pop(),
                child: Text(translations[selectedLanguage]?['CancelBtn'] ?? ''),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    final conn = await onConnToDb();
                    final results = await conn.query(
                        'DELETE FROM patients WHERE pat_ID = ?', [patientId]);
                    if (results.affectedRows! > 0) {
                      // ignore: use_build_context_synchronously
                      _onShowSnack(
                          Colors.green,
                          translations[selectedLanguage]?['DeleteSuccess'] ??
                              '',
                          context);
                      onRefresh();
                    } else {
                      // ignore: use_build_context_synchronously
                      _onShowSnack(
                          Colors.red, 'متاسفم، مریض حذف نشد.', context);
                    }
                    await conn.close();
                  } catch (e) {
                    if (e is SocketException) {
                      // Handle the exception here
                      print('Failed to connect to the database: $e');
                    } else {
                      // Rethrow any other exception
                      rethrow;
                    }
                  } finally {
                    // ignore: use_build_context_synchronously
                    Navigator.of(context, rootNavigator: true).pop();
                  }
                },
                child: Text(translations[selectedLanguage]?['Delete'] ?? ''),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

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
onEditPatientInfo(BuildContext context, Function onRefresh) {
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
                          margin: const EdgeInsets.only(
                              left: 20.0, right: 10.0, top: 10.0, bottom: 10.0),
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
                              left: 20.0, right: 10.0, top: 10.0, bottom: 10.0),
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
                          margin: const EdgeInsets.only(
                              left: 20.0, right: 10.0, top: 10.0, bottom: 10.0),
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                          margin: const EdgeInsets.only(
                              left: 20.0, right: 10.0, top: 10.0, bottom: 10.0),
                          child: InputDecorator(
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'سن',
                              enabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.blue)),
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
                                        PatientInfo.ageDropDown = newValue!;
                                        PatientInfo.ageSelected = true;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 20.0, right: 10.0, top: 10.0, bottom: 10.0),
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
                          margin: const EdgeInsets.only(
                              left: 20.0, right: 10.0, top: 10.0, bottom: 10.0),
                          child: TextFormField(
                            controller: _addrController,
                            validator: (value) {
                              if (value!.isNotEmpty) {
                                if (value.length > 40 || value.length < 5) {
                                  return 'آدرس باید حداقل 5 و حداکثر 40 حرف باشد.';
                                }
                                return null;
                              }
                            },
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
                              errorBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50.0)),
                                borderSide: BorderSide(color: Colors.red),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 20.0, right: 10.0, top: 10.0, bottom: 10.0),
                          child: InputDecorator(
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10.0),
                              border: const OutlineInputBorder(),
                              labelText: translations[selectedLanguage]?['Sex'],
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                          margin: const EdgeInsets.only(
                              left: 20.0, right: 10.0, top: 10.0, bottom: 10.0),
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
                                  items: PatientInfo.items.map((String items) {
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
                          margin: const EdgeInsets.only(
                              left: 20.0, right: 10.0, top: 10.0, bottom: 10.0),
                          child: Column(
                            children: <Widget>[
                              InputDecorator(
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: translations[selectedLanguage]
                                      ?['BloodGroup'],
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50.0)),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50.0)),
                                    borderSide: BorderSide(color: Colors.blue),
                                  ),
                                  errorBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50.0)),
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
                                          PatientInfo.bloodDropDown = newValue;
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
                        onRefresh();
                      } else {
                        Navigator.of(context, rootNavigator: true).pop();
                        _onShowSnack(
                            Colors.red, 'شما هیچ تغییراتی نیاوردید.', context);
                      }
                      await conn.close();
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

// Data table widget is here
class PatientDataTable extends StatefulWidget {
  const PatientDataTable({Key? key}) : super(key: key);

  @override
  _PatientDataTableState createState() => _PatientDataTableState();
}

class _PatientDataTableState extends State<PatientDataTable> {
  int _sortColumnIndex = 0;
  bool _sortAscending = true;
// The filtered data source
  List<PatientData> _filteredData = [];

  List<PatientData> _data = [];

  Future<void> _fetchData() async {
    final conn = await onConnToDb();
    final queryResult = await conn.query(
        'SELECT firstname, lastname, age, sex, marital_status, phone, pat_ID, DATE_FORMAT(reg_date, "%Y-%m-%d"), blood_group, address FROM patients ORDER BY reg_date DESC');
    conn.close();

    _data = queryResult.map((row) {
      return PatientData(
        firstName: row[0],
        lastName: row[1] ?? '',
        age: row[2].toString(),
        sex: row[3],
        maritalStatus: row[4],
        phone: row[5],
        patID: row[6],
        regDate: row[7].toString(),
        bloodGroup: row[8] ?? '',
        address: row[9] ?? '',
        patientDetail: const Icon(Icons.list),
        editPatient: const Icon(Icons.edit_outlined),
        deletePatient: const Icon(Icons.delete),
      );
    }).toList();
    _filteredData = List.from(_data);
    await conn.close();
    // Notify the framework that the state of the widget has changed
    setState(() {});
    // Print the data that was fetched from the database
    print('Data from database: $_data');
  }

// The text editing controller for the search TextField
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
// Set the filtered data to the original data at first
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchData());
  }

// Create instance of this class to its members
  final GlobalUsage _gu = GlobalUsage();

  @override
  Widget build(BuildContext context) {
    // Create a new instance of the PatientDataSource class and pass it the _filteredData list
    final dataSource = PatientDataSource(_filteredData, _fetchData);

    return Scaffold(
        body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 400.0,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: translations[selectedLanguage]?['Search'] ?? '',
                    suffixIcon: IconButton(
                      splashRadius: 25.0,
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _filteredData = _data;
                        });
                      },
                    ),
                    enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        borderSide: BorderSide(color: Colors.blue)),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _filteredData = _data
                          .where((element) => element.firstName
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                          .toList();
                    });
                  },
                ),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  side: const BorderSide(
                    color: Colors.blue,
                  ),
                ),
                onPressed: () async {
                  onCreatePrescription(context);
                },
                child: Text(translations[selectedLanguage]?['GenPresc'] ?? ''),
              ),
              // Set access role to only allow 'system admin' to make such changes
              if (StaffInfo.staffRole == 'مدیر سیستم')
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const NewPatient()))
                        .then((_) {
                      _fetchData();
                    });
                    // This is assigned to identify appointments.round i.e., if it is true round is stored '1' otherwise increamented by 1
                    GlobalUsage.newPatientCreated = true;
                  },
                  child: Text(
                      translations[selectedLanguage]?['AddNewPatient'] ?? ''),
                ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${translations[selectedLanguage]?['AllPatients'] ?? ''} | ',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(
                width: 80.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Tooltip(
                    message: 'Excel',
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.blue, width: 2.0),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Icon(
                            FontAwesomeIcons.fileExcel,
                            color: Colors.blue,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Tooltip(
                    message: 'PDF',
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.blue, width: 2.0),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Icon(
                            FontAwesomeIcons.filePdf,
                            color: Colors.blue,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ))
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              if (_filteredData.isEmpty)
                const SizedBox(
                  width: 200,
                  height: 200,
                  child: Center(child: Text('هیچ مریضی یافت نشد.')),
                )
              else
                PaginatedDataTable(
                  sortAscending: _sortAscending,
                  sortColumnIndex: _sortColumnIndex,
                  header: null,
                  columns: [
                    DataColumn(
                      label: Text(
                        translations[selectedLanguage]?['FName'] ?? '',
                        style: const TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                      onSort: (columnIndex, ascending) {
                        setState(() {
                          _sortColumnIndex = columnIndex;
                          _sortAscending = ascending;
                          _filteredData.sort(
                              (a, b) => a.firstName.compareTo(b.firstName));
                          if (!ascending) {
                            _filteredData = _filteredData.reversed.toList();
                          }
                        });
                      },
                    ),
                    DataColumn(
                      label: Text(
                        translations[selectedLanguage]?['LName'] ?? '',
                        style: const TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                      onSort: (columnIndex, ascending) {
                        setState(() {
                          _sortColumnIndex = columnIndex;
                          _sortAscending = ascending;
                          _filteredData.sort(
                              ((a, b) => a.lastName.compareTo(b.lastName)));
                          if (!ascending) {
                            _filteredData = _filteredData.reversed.toList();
                          }
                        });
                      },
                    ),
                    DataColumn(
                      label: Text(
                        translations[selectedLanguage]?['Age'] ?? '',
                        style: const TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                      onSort: (columnIndex, ascending) {
                        setState(() {
                          _sortColumnIndex = columnIndex;
                          _sortAscending = ascending;
                          _filteredData
                              .sort(((a, b) => a.age.compareTo(b.age)));
                          if (!ascending) {
                            _filteredData = _filteredData.reversed.toList();
                          }
                        });
                      },
                    ),
                    DataColumn(
                      label: Text(
                        translations[selectedLanguage]?['Sex'] ?? '',
                        style: const TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                      onSort: (columnIndex, ascending) {
                        setState(() {
                          _sortColumnIndex = columnIndex;
                          _sortAscending = ascending;
                          _filteredData
                              .sort(((a, b) => a.sex.compareTo(b.sex)));
                          if (!ascending) {
                            _filteredData = _filteredData.reversed.toList();
                          }
                        });
                      },
                    ),
                    DataColumn(
                      label: Text(
                        translations[selectedLanguage]?['Marital'] ?? '',
                        style: const TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                      onSort: (columnIndex, ascending) {
                        setState(() {
                          _sortColumnIndex = columnIndex;
                          _sortAscending = ascending;
                          _filteredData.sort(((a, b) =>
                              a.maritalStatus.compareTo(b.maritalStatus)));
                          if (!ascending) {
                            _filteredData = _filteredData.reversed.toList();
                          }
                        });
                      },
                    ),
                    DataColumn(
                      label: Text(
                        translations[selectedLanguage]?['Phone'] ?? '',
                        style: const TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                      onSort: (columnIndex, ascending) {
                        setState(() {
                          _sortColumnIndex = columnIndex;
                          _sortAscending = ascending;
                          _filteredData
                              .sort(((a, b) => a.phone.compareTo(b.phone)));
                          if (!ascending) {
                            _filteredData = _filteredData.reversed.toList();
                          }
                        });
                      },
                    ),
                    DataColumn(
                      label: Text(
                        translations[selectedLanguage]?['Details'] ?? '',
                        style: const TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                    // Set access role to only allow 'system admin' to make such changes
                    if (StaffInfo.staffRole == 'مدیر سیستم')
                      DataColumn(
                        label: Text(
                            translations[selectedLanguage]?['Edit'] ?? '',
                            style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold)),
                      ),
                    if (StaffInfo.staffRole == 'مدیر سیستم')
                      DataColumn(
                        label: Text(
                            translations[selectedLanguage]?['Delete'] ?? '',
                            style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold)),
                      ),
                  ],
                  source: dataSource,
                  rowsPerPage: _filteredData.length < 8
                      ? _gu.calculateRowsPerPage(context)
                      : _gu.calculateRowsPerPage(context),
                )
            ],
          ),
        ),
      ],
    ));
  }
}

class PatientDataSource extends DataTableSource {
  List<PatientData> data;
  Function onRefresh;
  PatientDataSource(this.data, this.onRefresh);

  void sort(Comparator<PatientData> compare, bool ascending) {
    data.sort(compare);
    if (!ascending) {
      data = data.reversed.toList();
    }
    notifyListeners();
  }

  @override
  DataRow getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(data[index].firstName)),
      DataCell(Text(data[index].lastName)),
      DataCell(Text(
          '${data[index].age} ${translations[selectedLanguage]?['Year'] ?? ''}')),
      DataCell(Text(data[index].sex)),
      DataCell(Text(data[index].maritalStatus)),
      DataCell(Text(data[index].phone)),
      // DataCell(Text(data[index].service)),
      DataCell(
        Builder(builder: (BuildContext context) {
          return IconButton(
            splashRadius: 25.0,
            icon: data[index].patientDetail,
            onPressed: (() {
              PatientInfo.patID = data[index].patID;
              PatientInfo.firstName = data[index].firstName;
              PatientInfo.lastName = data[index].lastName;
              PatientInfo.phone = data[index].phone;
              PatientInfo.sex = data[index].sex;
              // Set age which is used to display patient details
              PatientInfo.age = int.parse(data[index].age);
              // Set age which is used when a new appointment is create for an existing patient
              ServiceInfo.patAge = int.parse(data[index].age);
              PatientInfo.regDate = data[index].regDate;
              PatientInfo.bloodGroup = data[index].bloodGroup;
              PatientInfo.address = data[index].address;
              PatientInfo.maritalStatus = data[index].maritalStatus;
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const PatientDetail())))
                  .then((_) => onRefresh());
            }),
            color: Colors.blue,
            iconSize: 20.0,
          );
        }),
      ),
      // Set access role to only allow 'system admin' to make such changes
      if (StaffInfo.staffRole == 'مدیر سیستم')
        DataCell(
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                splashRadius: 25.0,
                icon: data[index].editPatient,
                onPressed: () {
                  // Assign these values to static members of this class to be used later
                  PatientInfo.patID = data[index].patID;
                  PatientInfo.firstName = data[index].firstName;
                  PatientInfo.lastName = data[index].lastName;
                  PatientInfo.phone = data[index].phone;
                  PatientInfo.sex = data[index].sex;
                  PatientInfo.age = int.parse(data[index].age);
                  PatientInfo.regDate = data[index].regDate;
                  PatientInfo.bloodGroup = data[index].bloodGroup;
                  PatientInfo.address = data[index].address;
                  PatientInfo.maritalStatus = data[index].maritalStatus;
                  onEditPatientInfo(context, onRefresh);
                },
                color: Colors.blue,
                iconSize: 20.0,
              );
            },
          ),
        ),
      // Set access role to only allow 'system admin' to make such changes
      if (StaffInfo.staffRole == 'مدیر سیستم')
        DataCell(
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                splashRadius: 25.0,
                icon: data[index].deletePatient,
                onPressed: (() {
                  PatientInfo.patID = data[index].patID;
                  PatientInfo.firstName = data[index].firstName;
                  PatientInfo.lastName = data[index].lastName;
                  onDeletePatient(context, onRefresh);
                }),
                color: Colors.blue,
                iconSize: 20.0,
              );
            },
          ),
        ),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}

class PatientData {
  final String firstName;
  final String lastName;
  final String age;
  final String sex;
  final String maritalStatus;
  final String phone;
  final int patID;
  final String regDate;
  final String bloodGroup;
  final String address;
  // final String service;
  final Icon patientDetail;
  final Icon editPatient;
  final Icon deletePatient;

  PatientData({
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.sex,
    required this.maritalStatus,
    required this.phone,
    required this.patID,
    required this.regDate,
    required this.bloodGroup,
    required this.address,
    /* this.service, */
    required this.patientDetail,
    required this.editPatient,
    required this.deletePatient,
  });
}

// Create this data model which is required for searchable dropdown of patients
class PatientDataModel {
  final int patientId;
  final String patientFName;
  final String patientLName;
  final String patientPhone;
  final int patientAge;
  final String patientGender;

  PatientDataModel({
    required this.patientId,
    required this.patientFName,
    required this.patientLName,
    required this.patientPhone,
    required this.patientAge,
    required this.patientGender,
  });
}

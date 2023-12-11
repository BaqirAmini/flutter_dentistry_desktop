import 'dart:io';

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
import 'package:provider/provider.dart';
import 'patient_info.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_dentistry/config/translations.dart';

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
      'type': 'Syrup',
      'piece': '150mg',
      'qty': '1',
      'dose': '1 x 1',
      'nameController': TextEditingController(),
      'descController': TextEditingController()
    }
  ];
  const regExOnlyAbc = "[a-zA-Z,، \u0600-\u06FFF]";

  // Set 1 - 100 for medicine quantity
  List<String> medicineQty = [];
  for (int i = 1; i <= 100; i++) {
    medicineQty.add('$i');
  }
  // Set 1 - 100 for new patient ages
  int defaultSelectedAge = 1;
  List<int> newPatAges = [];
  for (int i = 1; i <= 100; i++) {
    newPatAges.add(i);
  }
  // Set sex for new patient
  String defaultSelectedSex = 'مرد';
  List<String> newPatSex = ['مرد', 'زن'];

  bool isPatientSelected = false;

  final patientNameController = TextEditingController();

// Key for Form widget
  final formKeyPresc = GlobalKey<FormState>();
  final formKeyPrescNewPatient = GlobalKey<FormState>();
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
                            /* -------------------- Fetch patient info ---------------- */
                            final pResults = await conn.query(
                                'SELECT * FROM patients WHERE pat_ID = ?',
                                [defaultSelectedPatient]);
                            var pRow =
                                pResults.isNotEmpty ? pResults.first : null;
                            String pFirstName = pRow?['firstname'] ?? '';
                            String pLastName = pRow?['lastname'] ?? '';
                            String pSex = pRow?['sex'] ?? '';
                            String? pAge = pRow != null && pRow['age'] != null
                                ? pRow['age'].toString()
                                : '';
                            /* --------------------/. Fetch patient info ---------------- */
                            // Current date
                            DateTime now = DateTime.now();
                            String formattedDate =
                                intl.DateFormat('yyyy-MM-dd').format(now);

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
                                            'تاریخ: $formattedDate',
                                            style: pw.TextStyle(font: ttf),
                                          ),
                                          textDirection: pw.TextDirection.rtl),
                                      pw.Directionality(
                                          child: pw.Align(
                                            alignment: pw.Alignment.centerLeft,
                                            child: pFirstName.isEmpty
                                                ? pw.Text(
                                                    'سن: $defaultSelectedAge',
                                                    style:
                                                        pw.TextStyle(font: ttf),
                                                  )
                                                : pw.Text(
                                                    'سن: $pAge',
                                                    style:
                                                        pw.TextStyle(font: ttf),
                                                  ),
                                          ),
                                          textDirection: pw.TextDirection.rtl),
                                      pw.Directionality(
                                          child: pw.Align(
                                            alignment: pw.Alignment.centerLeft,
                                            child: pFirstName.isEmpty
                                                ? pw.Text(
                                                    'جنسیت: $defaultSelectedSex',
                                                    style:
                                                        pw.TextStyle(font: ttf),
                                                  )
                                                : pw.Text(
                                                    'جنسیت: $pSex',
                                                    style:
                                                        pw.TextStyle(font: ttf),
                                                  ),
                                          ),
                                          textDirection: pw.TextDirection.rtl),
                                      pw.Directionality(
                                          child: pw.Align(
                                            alignment: pw.Alignment.centerRight,
                                            child: pFirstName.isNotEmpty
                                                ? pw.Text(
                                                    'نام مریض: $pFirstName $pLastName',
                                                    style:
                                                        pw.TextStyle(font: ttf),
                                                  )
                                                : pw.Text(
                                                    'نام مریض: ${patientNameController.text}',
                                                    style:
                                                        pw.TextStyle(font: ttf),
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
                                                          '${medicine['type']}',
                                                          style: pw.TextStyle(
                                                              font: ttf)),
                                                      pw.Text(
                                                          '${medicine['nameController'].text}',
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
                            final fileName =
                                patientNameController.text.isNotEmpty
                                    ? '${patientNameController.text}.pdf'
                                    : pFirstName.isNotEmpty
                                        ? '$pFirstName.pdf'
                                        : 'prescription.pdf';
                            await Printing.sharePdf(
                                bytes: bytes, filename: fileName);
                            /*   // Print the PDF
                            await Printing.layoutPdf(
                              onLayout: (PdfPageFormat format) async => bytes,
                            ); */
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
                width: 500.0,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 150.0,
                            margin: const EdgeInsets.all(15.0),
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'انتخاب داکتر',
                                labelStyle: TextStyle(color: Colors.blueAccent),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15.0)),
                                    borderSide:
                                        BorderSide(color: Colors.blueAccent)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15.0)),
                                    borderSide: BorderSide(color: Colors.blue)),
                                errorBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15.0)),
                                    borderSide: BorderSide(color: Colors.red)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15.0)),
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
                          Tooltip(
                            message: 'مریض جدید',
                            child: Container(
                              width: 120,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.all(15.0),
                                      width: 150.0,
                                      height: 50,
                                      child: Builder(
                                        builder: (context) {
                                          return OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                              ),
                                              side: const BorderSide(
                                                color: Colors.blue,
                                              ),
                                            ),
                                            onPressed: () async {
                                              return showDialog(
                                                context: context,
                                                builder: ((context) {
                                                  return StatefulBuilder(
                                                    builder:
                                                        ((context, setState) {
                                                      return AlertDialog(
                                                        title:
                                                            const Directionality(
                                                          textDirection:
                                                              TextDirection.rtl,
                                                          child: Text(
                                                            'ثبت مریض جدید',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .blue),
                                                          ),
                                                        ),
                                                        content: Directionality(
                                                          textDirection:
                                                              TextDirection.rtl,
                                                          child: Form(
                                                            key:
                                                                formKeyPrescNewPatient,
                                                            child: SizedBox(
                                                              width: 500.0,
                                                              child:
                                                                  SingleChildScrollView(
                                                                reverse: false,
                                                                child: Column(
                                                                  children: [
                                                                    Container(
                                                                      margin: const EdgeInsets
                                                                          .all(
                                                                          10.0),
                                                                      child:
                                                                          TextFormField(
                                                                        controller:
                                                                            patientNameController,
                                                                        validator:
                                                                            (value) {
                                                                          if (value!
                                                                              .isEmpty) {
                                                                            return 'نام مریض الزامی میباشد.';
                                                                          } else if (value.length < 3 ||
                                                                              value.length > 15) {
                                                                            return 'نام مریض باید حداقل 3 و حداکثر 15 حرف باشد.';
                                                                          }
                                                                        },
                                                                        inputFormatters: [
                                                                          FilteringTextInputFormatter
                                                                              .allow(
                                                                            RegExp(regExOnlyAbc),
                                                                          ),
                                                                        ],
                                                                        decoration:
                                                                            const InputDecoration(
                                                                          border:
                                                                              OutlineInputBorder(),
                                                                          labelText:
                                                                              'نام',
                                                                          suffixIcon:
                                                                              Icon(Icons.numbers_outlined),
                                                                          enabledBorder: OutlineInputBorder(
                                                                              borderRadius: BorderRadius.all(Radius.circular(50.0)),
                                                                              borderSide: BorderSide(color: Colors.grey)),
                                                                          focusedBorder: OutlineInputBorder(
                                                                              borderRadius: BorderRadius.all(Radius.circular(50.0)),
                                                                              borderSide: BorderSide(color: Colors.blue)),
                                                                          errorBorder: OutlineInputBorder(
                                                                              borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                                                              borderSide: BorderSide(color: Colors.red)),
                                                                          focusedErrorBorder: OutlineInputBorder(
                                                                              borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                                                              borderSide: BorderSide(color: Colors.red, width: 1.5)),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      margin: const EdgeInsets
                                                                          .all(
                                                                          10.0),
                                                                      child:
                                                                          InputDecorator(
                                                                        decoration:
                                                                            const InputDecoration(
                                                                          border:
                                                                              OutlineInputBorder(),
                                                                          labelText:
                                                                              'جنسیت',
                                                                          enabledBorder: OutlineInputBorder(
                                                                              borderRadius: BorderRadius.all(Radius.circular(50.0)),
                                                                              borderSide: BorderSide(color: Colors.grey)),
                                                                          focusedBorder:
                                                                              OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.all(Radius.circular(50.0)),
                                                                            borderSide:
                                                                                BorderSide(color: Colors.blue),
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            DropdownButtonHideUnderline(
                                                                          child:
                                                                              SizedBox(
                                                                            height:
                                                                                26.0,
                                                                            child:
                                                                                DropdownButton(
                                                                              isExpanded: true,
                                                                              icon: const Icon(Icons.arrow_drop_down),
                                                                              value: defaultSelectedSex,
                                                                              items: newPatSex.map((String sexItems) {
                                                                                return DropdownMenuItem(
                                                                                  alignment: Alignment.centerRight,
                                                                                  value: sexItems,
                                                                                  child: Directionality(
                                                                                    textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
                                                                                    child: Text(sexItems),
                                                                                  ),
                                                                                );
                                                                              }).toList(),
                                                                              onChanged: (String? newValue) {
                                                                                setState(() {
                                                                                  defaultSelectedSex = newValue!;
                                                                                });
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      margin: const EdgeInsets
                                                                          .all(
                                                                          10.0),
                                                                      child:
                                                                          InputDecorator(
                                                                        decoration:
                                                                            const InputDecoration(
                                                                          border:
                                                                              OutlineInputBorder(),
                                                                          labelText:
                                                                              'سن',
                                                                          enabledBorder: OutlineInputBorder(
                                                                              borderRadius: BorderRadius.all(Radius.circular(50.0)),
                                                                              borderSide: BorderSide(color: Colors.grey)),
                                                                          focusedBorder:
                                                                              OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.all(Radius.circular(50.0)),
                                                                            borderSide:
                                                                                BorderSide(color: Colors.blue),
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            DropdownButtonHideUnderline(
                                                                          child:
                                                                              SizedBox(
                                                                            height:
                                                                                26.0,
                                                                            child:
                                                                                DropdownButton(
                                                                              isExpanded: true,
                                                                              icon: const Icon(Icons.arrow_drop_down),
                                                                              value: defaultSelectedAge,
                                                                              items: newPatAges.map((int ageItems) {
                                                                                return DropdownMenuItem(
                                                                                  alignment: Alignment.centerRight,
                                                                                  value: ageItems,
                                                                                  child: Directionality(
                                                                                    textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
                                                                                    child: Text('$ageItems سال '),
                                                                                  ),
                                                                                );
                                                                              }).toList(),
                                                                              onChanged: (int? newValue) {
                                                                                setState(() {
                                                                                  defaultSelectedAge = newValue!;
                                                                                });
                                                                              },
                                                                            ),
                                                                          ),
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
                                                            textDirection:
                                                                TextDirection
                                                                    .rtl,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    if (formKeyPrescNewPatient
                                                                        .currentState!
                                                                        .validate()) {
                                                                      showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          Future.delayed(
                                                                              const Duration(seconds: 2),
                                                                              () {
                                                                            Navigator.of(context).pop(); // This will pop the 'toast' dialog
                                                                            Navigator.of(context).pop(); // This will pop the original dialog
                                                                          });
                                                                          return Dialog(
                                                                            child:
                                                                                Container(
                                                                              color: Colors.green,
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Directionality(
                                                                                textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
                                                                                child: Text(
                                                                                  '${patientNameController.text} در نسخه ایجاد شد.',
                                                                                  style: const TextStyle(color: Colors.white),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                      );
                                                                    }
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                          'ثبت'),
                                                                ),
                                                                TextButton(
                                                                  onPressed: () => Navigator.of(
                                                                          context,
                                                                          rootNavigator:
                                                                              true)
                                                                      .pop(),
                                                                  child:
                                                                      const Text(
                                                                          'لغو'),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    }),
                                                  );
                                                }),
                                              );
                                            },
                                            child: const Icon(
                                                Icons.person_add_alt),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(15.0),
                            width: 150.0,
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'انتخاب مریض',
                                labelStyle: TextStyle(color: Colors.blueAccent),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15.0)),
                                    borderSide:
                                        BorderSide(color: Colors.blueAccent)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15.0)),
                                    borderSide: BorderSide(color: Colors.blue)),
                                errorBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15.0)),
                                    borderSide: BorderSide(color: Colors.red)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15.0)),
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 1.5)),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: Container(
                                  height: 18.0,
                                  child: DropdownButton(
                                    isExpanded: true,
                                    icon: const Icon(Icons.arrow_drop_down),
                                    value: defaultSelectedPatient,
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.black),
                                    items: patientsList.map((patient) {
                                      return DropdownMenuItem<String>(
                                        value: patient['pat_ID'],
                                        alignment: Alignment.centerRight,
                                        child: Text(patient['firstname']),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        defaultSelectedPatient = newValue;
                                        patientID = int.parse(newValue!);
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      ...medicines.map((medicine) {
                        return SizedBox(
                          width: 480.0,
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
                                          'Syrup',
                                          'Tablet',
                                          'Mouthwash'
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
                                    labelText: 'Dose',
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
                                'type': 'Syrup',
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

// Create the global key at the top level of your Dart file
final GlobalKey<ScaffoldMessengerState> _globalKeyPDelete =
    GlobalKey<ScaffoldMessengerState>();

// This is shows snackbar when called
void _onShowSnack(Color backColor, String msg) {
  _globalKeyPDelete.currentState?.showSnackBar(
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

class Patient extends StatefulWidget {
  const Patient({super.key});

  @override
  _PatientState createState() => _PatientState();
}

class _PatientState extends State<Patient> {
  // Fetch staff which will be needed later.
  Future<void> fetchStaff() async {
    // Fetch staff for purchased by fields
    var conn = await onConnToDb();
    var results =
        await conn.query('SELECT staff_ID, firstname, lastname FROM staff');
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ScaffoldMessenger(
        key: _globalKeyPDelete,
        child: Scaffold(
          body: Directionality(
            textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
            child: Scaffold(
                appBar: AppBar(
                  leading: Tooltip(
                    message: 'رفتن به داشبورد',
                    child: IconButton(
                      icon: const Icon(Icons.home_outlined),
                      onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Dashboard())),
                    ),
                  ),
                  title: Text(
                      translations[selectedLanguage]?['AllPatients'] ?? ''),
                ),
                body: const PatientDataTable()),
          ),
        ),
      ),
    );
  }
}

// This is to display an alert dialog to delete a patient
onDeletePatient(BuildContext context, Function onDelete) {
  int? patientId = PatientInfo.patID;
  String? fName = PatientInfo.firstName;
  String? lName = PatientInfo.lastName;

  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Directionality(
        textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
        child:
            Text('${translations[selectedLanguage]?['DeletePatientTitle'] ?? ''} $fName $lName'),
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
                      _onShowSnack(
                          Colors.green,
                          translations[selectedLanguage]?['DeleteSuccess'] ??
                              '');
                      onDelete();
                    } else {
                      _onShowSnack(Colors.red, 'متاسفم، مریض حذف نشد.');
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

// Data table widget is here
class PatientDataTable extends StatefulWidget {
  const PatientDataTable({super.key});

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
        deletePatient: const Icon(Icons.delete),
      );
    }).toList();
    _filteredData = List.from(_data);

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
                  },
                  child: Text(
                      translations[selectedLanguage]?['AddNewPatient'] ?? ''),
                ),
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
                  header: Text(
                      '${translations[selectedLanguage]?['AllPatients'] ?? ''} | '),
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
                            translations[selectedLanguage]?['Delete'] ?? '',
                            style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold)),
                      ),
                  ],
                  source: dataSource,
                  rowsPerPage:
                      _filteredData.length < 8 ? _filteredData.length : 8,
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
  Function onDelete;
  PatientDataSource(this.data, this.onDelete);

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
      DataCell(Text(data[index].age)),
      DataCell(Text(data[index].sex)),
      DataCell(Text(data[index].maritalStatus)),
      DataCell(Text(data[index].phone)),
      // DataCell(Text(data[index].service)),
      DataCell(
        Builder(builder: (BuildContext context) {
          return IconButton(
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
                      builder: ((context) => const PatientDetail())));
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
                icon: data[index].deletePatient,
                onPressed: (() {
                  PatientInfo.patID = data[index].patID;
                  PatientInfo.firstName = data[index].firstName;
                  PatientInfo.lastName = data[index].lastName;
                  onDeletePatient(context, onDelete);
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
    required this.deletePatient,
  });
}

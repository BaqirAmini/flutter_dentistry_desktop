import 'package:flutter/material.dart';
import 'package:flutter_dentistry/models/db_conn.dart';

class GlobalUsage {
  // A toast message to be used anywhere required
  static void showCustomToast(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
            label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  /* ------------------- CHARACTERS/DIGITS ALLOWED ---------------- */
  // 0-9 and + are allowed
  static const allowedDigits = "[0-9+۰-۹]";
  //  alphabetical letters both in English & Persian allowed including comma
  static const allowedEPChar = "[a-zA-Z,، \u0600-\u06FFF]";
  // 0-9 and period(.) are allowed
  static const allowedDigPeriod = "[0-9.]";
  /* -------------------/. CHARACTERS/DIGITS ALLOWED ---------------- */

//  This static variable specifies whether the appointment
//is created with creating a new patient or an existing patient (true = new patient created, false = patient already existing)
  static bool newPatientCreated = true;

  // Fetch staff which will be needed later.
  Future<List<Map<String, dynamic>>> fetchStaff() async {
    // Fetch staff for purchased by fields
    var conn = await onConnToDb();
    var results = await conn.query(
        'SELECT staff_ID, firstname, lastname FROM staff WHERE position = ?',
        ['داکتر دندان']);

    List<Map<String, dynamic>> staffList = results
        .map((result) => {
              'staff_ID': result[0].toString(),
              'firstname': result[1],
              'lastname': result[2] ?? ''
            })
        .toList();

    await conn.close();

    return staffList;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_dentistry/models/db_conn.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:windows_notification/notification_message.dart';
import 'package:windows_notification/windows_notification.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_dentistry/config/private/private.dart';

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

  static bool widgetVisible = false;
//  This static variable specifies whether the appointment
//is created with creating a new patient or an existing patient (true = new patient created, false = patient already existing)
  static bool newPatientCreated = true;

  // Fetch staff which will be needed later.
  Future<List<Map<String, dynamic>>> fetchStaff() async {
    try {
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
    } catch (e) {
      print('Error occured fetching staff (Global Usage): $e');
      return [];
    }
  }

// Declare this function to fetch services from services table to be used globally
  Future<List<Map<String, dynamic>>> fetchServices() async {
    var conn = await onConnToDb();
    var queryService =
        await conn.query('SELECT ser_ID, ser_name FROM services WHERE ser_ID');

    List<Map<String, dynamic>> services = queryService
        .map(
            (result) => {'ser_ID': result[0].toString(), 'ser_name': result[1]})
        .toList();

    await conn.close();
    return services;
  }

  // Create this function to make number of records responsive
  int calculateRowsPerPage(BuildContext context) {
    var minHeight = MediaQuery.of(context).size.height;
    int rowsPerPage = (minHeight / 50).floor();
    return rowsPerPage;
  }

  // This function is to give notifiction for users
  void alertUpcomingAppointment(
      int patId, String firstName, String? lastName, String notif) {
    final winNotifyPlugin = WindowsNotification(
        applicationId:
            r"{7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}\Dental Clinic System\flutter_dentistry.exe");
    NotificationMessage message = NotificationMessage.fromPluginTemplate(
        "appointment ($patId)",
        "Upcoming Appointment in $notif",
        "You have an appointment with $firstName $lastName");
    winNotifyPlugin.showNotificationPluginTemplate(message);
  }

// Create instance of Flutter Secure Store
  final storage = const FlutterSecureStorage();

  // Store the expiry date
  Future<void> storeExpiryDate(DateTime expiryDate) async {
    var formatter = intl.DateFormat('yyyy-MM-dd HH:mm');
    var formattedExpiryDate = formatter.format(expiryDate);
    await storage.write(key: 'expiryDate', value: formattedExpiryDate);
  }

// Get the expiry date
  Future<DateTime?> getExpiryDate() async {
    var formatter = intl.DateFormat('yyyy-MM-dd HH:mm');
    var formattedExpiryDate = await storage.read(key: 'expiryDate');
    return formattedExpiryDate != null
        ? formatter.parse(formattedExpiryDate)
        : null;
  }

  // Delete the expiry date
  Future<void> deleteExpiryDate() async {
    await storage.delete(key: 'expiryDate');
  }

// Check if the license key has expired
  Future<bool> hasLicenseKeyExpired() async {
    var expiryDate = await getExpiryDate();
    return expiryDate != null && DateTime.now().isAfter(expiryDate);
  }

/*-------------- For Developer -----------*/
  // XOR cipher
  String generateProductKey(DateTime expiryDate, String guid) {
    var formatter = intl.DateFormat('yyyy-MM-dd HH:mm');
    var formattedExpiryDate = formatter.format(expiryDate);
    var dataToEncrypt = guid + formattedExpiryDate;
    // Encrtypt value with XOR cipher
    var key = secretKey;
    var encryptedData = '';
    for (var i = 0; i < dataToEncrypt.length; i++) {
      var xorResult =
          dataToEncrypt.codeUnitAt(i) ^ key.codeUnitAt(i % key.length);
      encryptedData += xorResult.toRadixString(16).padLeft(2, '0');
    }
    return encryptedData;
  }
/*--------------/. For Developer -----------*/

/*----------------- For Users ----------*/
  String productKeyRelatedMsg =
      'Please enter the product key you have purchased and click \'Verify\' in below to activate the system or make a contact with the system owner.';
// Store the liscense key for a specific user
  Future<void> storeLicenseKey4User(String key) async {
    await storage.write(key: 'UserlicenseKey', value: key);
  }

  // Get the liscense key for a specific user
  Future<String?> getLicenseKey4User() async {
    return await storage.read(key: 'UserlicenseKey');
  }

// Delete the liscense for a specific user
  Future<void> deleteValue4User(String key) async {
    await storage.delete(key: key);
  }

  // Decrtype XOR Cypher
  String decryptProductKey(String encryptedData, String key) {
    var decryptedData = '';
    for (var i = 0; i < encryptedData.length; i += 2) {
      var hexValue = encryptedData.substring(i, i + 2);
      var xorResult = int.parse(hexValue, radix: 16);
      decryptedData += String.fromCharCode(
          xorResult ^ key.codeUnitAt(((i ~/ 2) % key.length)));
    }
    return decryptedData;
  }

/*-----------------/. For Users ----------*/
}

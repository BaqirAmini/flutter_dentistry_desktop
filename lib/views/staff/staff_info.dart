import 'dart:typed_data';

import 'package:flutter_dentistry/models/db_conn.dart';
import 'package:galileo_mysql/src/blob.dart';

class StaffInfo {
  static int? staffID;
  static String? staffRole;
  static String? firstName;
  static String? lastName;
  static double? salary;
  static String? position;
  static String? phone;
  static String? tazkira;
  static String? address;
  static Function? onUpdateProfile;
  static Blob? userPhoto;
  static Uint8List? contractFile;
  static String? fileType;

  // position types dropdown variables
  static String staffDefaultPosistion = 'داکتر دندان';
  static var staffPositionItems = [
    'داکتر دندان',
    'پروتیزین',
    'آشپز',
    'حسابدار',
    'کار آموز'
  ];

  static Uint8List? uint8list;
  // This function fetches staff photo
  static Future<void> onFetchStaffPhoto(int staffID) async {
    final conn = await onConnToDb();
    final result = await conn
        .query('SELECT photo FROM staff WHERE staff_ID = ?', [staffID]);

    Blob? staffPhoto =
        result.first['photo'] != null ? result.first['photo'] as Blob : null;

    // Convert image of BLOB type to binary first.
    uint8list =
        staffPhoto != null ? Uint8List.fromList(staffPhoto.toBytes()) : null;
    await conn.close();
  }
}

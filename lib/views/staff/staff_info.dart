import 'dart:typed_data';

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
}

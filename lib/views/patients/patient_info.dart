class PatientInfo {
  static int? patID;
  static String? firstName;
  static String? lastName;
  static String? phone;
  static String? sex;
  static int? age;
  static String? address;
  static String? maritalStatus;
  static String? bloodGroup;
  static String? regDate;

  // Declare a dropdown for ages
  static int ageDropDown = 0;
  static bool ageSelected = false;

  // This is used to hide/show a button in health_histories.dart
  static bool showElevatedBtn = false;
  // This is to show/hide the icon in the appbar of patient_history.dart
  static bool showHHistoryIcon = false;
  // Declare a method to add ages 1 - 100
  static List<int> getAges() {
    // Declare variables to contain from 1 - 100 for ages
    List<int> ages = [];
    for (int a = 1; a <= 100; a++) {
      ages.add(a);
    }
    return ages;
  }

  // Marital Status
  static String maritalStatusDD = 'مجرد';
  static var items = ['مجرد', 'متأهل'];
  // Blood group types
  static String? bloodDropDown = 'نامعلوم';
  static var bloodGroupItems = [
    'نامعلوم',
    'A+',
    'B+',
    'AB+',
    'O+',
    'A-',
    'B-',
    'AB-',
    'O-'
  ];

  static Function? onRefresh;
}

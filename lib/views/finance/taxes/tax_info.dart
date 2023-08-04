class TaxInfo {
  static int? taxPayID;
  static int? taxID;
  static int? staffID;
  static String? TIN;
  static double? annualIncomes;
  static double? taxRate;
  static double? paidTaxes;
  static String? paidDate;
  static double? annTotTaxes;
  static double? dueTaxes;
  static String? taxOfYear;
  static String? taxNotes;
  static String? firstName;
  static String? lastName;
  static Function? onAddTax;
  static Function? onFetchStaff;
  static List<Map<String, dynamic>>? StaffList;
  static String? selectedStaff;
}

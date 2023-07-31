import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../views/finance/taxes/tax_details.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_dentistry/models/db_conn.dart';

// Create the global key at the top level of your Dart file
final GlobalKey<ScaffoldMessengerState> _globalKeyForTaxes =
    GlobalKey<ScaffoldMessengerState>();

// This is shows snackbar when called
void _onShowSnack(Color backColor, String msg) {
  _globalKeyForTaxes.currentState?.showSnackBar(
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

class TaxData extends StatelessWidget {
  const TaxData({super.key});

  @override
  Widget build(BuildContext context) {
    return const TaxDataTable();
  }
}

// Data table widget is here
class TaxDataTable extends StatefulWidget {
  const TaxDataTable({super.key});

  @override
  TaxDataTableState createState() => TaxDataTableState();
}

class TaxDataTableState extends State<TaxDataTable> {
  // Fetch staff for purchased by fields
  String? selectedStaffId;
  List<Map<String, dynamic>> staffList = [];
  Future<void> fetchStaff() async {
    var conn = await onConnToDb();
    var results =
        await conn.query('SELECT staff_ID, firstname, lastname FROM staff');
    setState(() {
      staffList = results
          .map((result) => {
                'staff_ID': result[0].toString(),
                'firstname': result[1],
                'lastname': result[2]
              })
          .toList();
    });
    selectedStaffId = staffList.isNotEmpty ? staffList[0]['staff_ID'] : null;
    await conn.close();
  }

  // This dialog create a new tax
  onCreateNewTax(BuildContext context) {
    fetchStaff();
// The global for the form
    final formKeyNewTax = GlobalKey<FormState>();
// The text editing controllers for the TextFormFields
    // ignore: non_constant_identifier_names
    final TINController = TextEditingController();
    final taxOfYearController = TextEditingController();
    final taxRateController = TextEditingController();
    final taxTotalController = TextEditingController();
    final annualIncomeController = TextEditingController();
    final taxPaidController = TextEditingController();
    final taxDueController = TextEditingController();
    final delByController = TextEditingController();
    final delDateCotnroller = TextEditingController();

    const regExOnlydigits = "[0-9]";
    const regExpDecimal = r'^\d+\.?\d{0,2}';
    const regExOnlyAbc = "[a-zA-Z,، \u0600-\u06FFF]";

    // Create a dropdown for financial years.
    int selectedYear = 1300;
    List<int> years = [];
    for (var i = 1300; i < 1500; i++) {
      years.add(i);
    }

    double? totalTaxesofYear;
// Sets the total taxes into its related field
    void _onSetTotalTax(String text) {
      double taxRate = taxRateController.text.isEmpty
          ? 0
          : double.parse(taxRateController.text);
      double unitPrice = annualIncomeController.text.isEmpty
          ? 0
          : double.parse(annualIncomeController.text);
      totalTaxesofYear = (taxRate * unitPrice) / 100;
      taxTotalController.text = '$totalTaxesofYear افغانی';
    }

    double? paidTaxes;
    double? dueTaxes;
    // ignore: no_leading_underscores_for_local_identifiers
    // Deduct the paid taxes amount from total taxes.
    void _onPaidTaxes(String text) {
      paidTaxes = taxPaidController.text.isNotEmpty
          ? double.parse(taxPaidController.text)
          : 0;
      dueTaxes =
          paidTaxes! <= totalTaxesofYear! ? totalTaxesofYear! - paidTaxes! : 0;
      taxDueController.text = '$dueTaxes افغانی';
    }

    return showDialog(
      context: context,
      builder: ((context) {
        return StatefulBuilder(
          builder: ((context, setState) {
            return AlertDialog(
              title: const Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  'ایجاد مالیات جدید',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              content: Directionality(
                textDirection: TextDirection.rtl,
                child: Form(
                  key: formKeyNewTax,
                  child: SizedBox(
                    width: 500.0,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 20.0),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                                top: 10.0,
                                bottom: 10.0),
                            child: TextFormField(
                              controller: TINController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'TIN الزامی میباشد.';
                                } else if (value.length < 10 ||
                                    value.length > 10) {
                                  return 'TIN باید 10 عدد باشد.';
                                }
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(regExOnlydigits),
                                ),
                              ],
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'نمبر تشخیصیه مالیه دهنده (TIN)',
                                suffixIcon: Icon(Icons.numbers_outlined),
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
                                left: 20.0,
                                right: 20.0,
                                top: 10.0,
                                bottom: 10.0),
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'مالیه سال',
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
                              child: DropdownButtonHideUnderline(
                                child: SizedBox(
                                  height: 26.0,
                                  child: DropdownButton(
                                    isExpanded: true,
                                    icon: const Icon(Icons.arrow_drop_down),
                                    value: selectedYear,
                                    items: years.map((int year) {
                                      return DropdownMenuItem(
                                        alignment: Alignment.centerRight,
                                        value: year,
                                        child: Text(year.toString()),
                                      );
                                    }).toList(),
                                    onChanged: (int? newValue) {
                                      setState(() {
                                        selectedYear = newValue!;
                                      });
                                    },
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
                              controller: taxRateController,
                              validator: (value) {
                                double taxPercentage =
                                    taxRateController.text.isNotEmpty
                                        ? double.parse(taxRateController.text)
                                        : 0;
                                if (value!.isEmpty) {
                                  return 'فیصدی مالیات الزامی میباشد.';
                                } else if (taxPercentage < 0 ||
                                    taxPercentage > 50) {
                                  return 'فیصدی مالیات نا معتبر است.';
                                }
                              },
                              onChanged: _onSetTotalTax,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(regExpDecimal)),
                                LengthLimitingTextInputFormatter(4)
                              ],
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'فیصدی مالیات',
                                suffixIcon: Icon(Icons.percent_outlined),
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
                                left: 20.0,
                                right: 20.0,
                                top: 10.0,
                                bottom: 10.0),
                            child: TextFormField(
                              controller: annualIncomeController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'مجموع عاید سال الزامی میباشد.';
                                }
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(regExpDecimal))
                              ],
                              onChanged: _onSetTotalTax,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText:
                                    'مجموع عاید سال ${selectedYear.toString()}',
                                suffixIcon:
                                    const Icon(Icons.money_off_csred_outlined),
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
                                    borderSide: BorderSide(color: Colors.red)),
                                focusedErrorBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50.0)),
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
                            child: TextFormField(
                              controller: taxTotalController,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(regExOnlydigits))
                              ],
                              readOnly: true,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'مجموع مالیات',
                                suffixIcon:
                                    Icon(Icons.money_off_csred_outlined),
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
                                left: 20.0,
                                right: 20.0,
                                top: 10.0,
                                bottom: 10.0),
                            child: TextFormField(
                              controller: taxPaidController,
                              validator: (value) {
                                double taxPaid =
                                    taxPaidController.text.isNotEmpty
                                        ? double.parse(taxPaidController.text)
                                        : 0;
                                if (value!.isEmpty) {
                                  return 'مالیات تحویل شده الزامی میباشد.';
                                } else if (taxPaid > totalTaxesofYear!) {
                                  return 'مالیات تحویل شده نمی تواند بیشتر از کل مالیات باشد.';
                                }
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(regExpDecimal))
                              ],
                              onChanged: _onPaidTaxes,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'مالیات تحویل شده',
                                suffixIcon:
                                    Icon(Icons.money_off_csred_outlined),
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
                                left: 20.0,
                                right: 20.0,
                                top: 10.0,
                                bottom: 10.0),
                            child: TextFormField(
                              controller: taxDueController,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(regExpDecimal))
                              ],
                              readOnly: true,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'مالیات باقی',
                                suffixIcon: Icon(Icons.attach_money_outlined),
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
                                left: 20.0,
                                right: 20.0,
                                top: 10.0,
                                bottom: 10.0),
                            child: TextFormField(
                              controller: delDateCotnroller,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'تاریخ تحویلی الزامی میباشد.';
                                }
                              },
                              onTap: () async {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                final DateTime? dateTime = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100));
                                if (dateTime != null) {
                                  final intl.DateFormat formatter =
                                      intl.DateFormat('yyyy-MM-dd');
                                  final String formattedDate =
                                      formatter.format(dateTime);
                                  delDateCotnroller.text = formattedDate;
                                }
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(regExpDecimal))
                              ],
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'تاریخ تحویل دهی',
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
                          Container(
                            margin: const EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                                top: 10.0,
                                bottom: 10.0),
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'خریداری شده توسط',
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
                              child: DropdownButtonHideUnderline(
                                child: Container(
                                  height: 26.0,
                                  child: DropdownButton(
                                    isExpanded: true,
                                    icon: const Icon(Icons.arrow_drop_down),
                                    value: selectedStaffId,
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
                                        selectedStaffId = newValue;
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
                    textDirection: TextDirection.rtl,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('لغو')),
                        ElevatedButton(
                          onPressed: () async {
                            if (formKeyNewTax.currentState!.validate()) {
                              double annualIncome =
                                  double.parse(annualIncomeController.text);
                              String tin = TINController.text;
                              double taxRate =
                                  double.parse(taxRateController.text);
                              double totalAnnualTax = totalTaxesofYear!;
                              double deliAmount =
                                  double.parse(taxPaidController.text);
                              double dueAmount = dueTaxes!;
                              String deliDate = delDateCotnroller.text;
                              int taxYear = selectedYear;
                              int staffID = int.parse(selectedStaffId!);
                              final conn = await onConnToDb();
                              var results1 = await conn.query(
                                  'SELECT * FROM taxes WHERE TIN = ? AND tax_for_year = ?',
                                  [tin, taxYear]);
                              if (results1.isNotEmpty) {
                                _onShowSnack(Colors.red,
                                    'متاسفم، مالیات با این مشخصات قبلاً در سیستم وجود دارد.');
                              } else {
                                var results2 = await conn.query(
                                    'INSERT INTO taxes (annual_income, tax_rate, total_annual_tax, delivered_amount, due_amount, TIN, delivery_date, tax_for_year, delivered_by) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)',
                                    [
                                      annualIncome,
                                      taxRate,
                                      totalAnnualTax,
                                      deliAmount,
                                      dueAmount,
                                      tin,
                                      deliDate,
                                      taxYear,
                                      staffID
                                    ]);
                                if (results2.affectedRows! > 0) {
                                  _onShowSnack(
                                      Colors.green, 'مالیات موفقانه ثبت شد.');
                                } else {
                                  _onShowSnack(Colors.red,
                                      'متاسفم، ثبت مالیات ناکام شد.');
                                }
                              }
                              Navigator.pop(context);
                            }
                          },
                          child: const Text('ثبت کردن'),
                        ),
                      ],
                    ))
              ],
            );
          }),
        );
      }),
    );
  }

  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  // The original data source
  final List<MyData> _data = [
    MyData('8008319499', '1398', '12%', const Icon(Icons.list),
        const Icon(Icons.edit), const Icon(Icons.delete)),
    MyData('8008319499', '1398', '15%', const Icon(Icons.list),
        const Icon(Icons.edit), const Icon(Icons.delete)),
    MyData('8008319499', '1397', '20%', const Icon(Icons.list),
        const Icon(Icons.edit), const Icon(Icons.delete)),
    MyData('8008319499', '1402', '30%', const Icon(Icons.list),
        const Icon(Icons.edit), const Icon(Icons.delete)),
    MyData('8008319497', '1400', '25%', const Icon(Icons.list),
        const Icon(Icons.edit), const Icon(Icons.delete)),
    MyData('8008319497', '1400', '25%', const Icon(Icons.list),
        const Icon(Icons.edit), const Icon(Icons.delete)),
    MyData('8008319497', '1401', '15%', const Icon(Icons.list),
        const Icon(Icons.edit), const Icon(Icons.delete)),
    MyData('8008319497', '1402', '15%', const Icon(Icons.list),
        const Icon(Icons.edit), const Icon(Icons.delete)),
    MyData('8008319496', '1399', '15%', const Icon(Icons.list),
        const Icon(Icons.edit), const Icon(Icons.delete)),
    MyData('8008319496', '1396', '15%', const Icon(Icons.list),
        const Icon(Icons.edit), const Icon(Icons.delete)),
    MyData('8008319496', '1395', '12%', const Icon(Icons.list),
        const Icon(Icons.edit), const Icon(Icons.delete)),
    MyData('8008319496', '1394', '12%', const Icon(Icons.list),
        const Icon(Icons.edit), const Icon(Icons.delete)),
  ];

// The filtered data source
  late List<MyData> _filteredData;

// The text editing controller for the search TextField
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
// Set the filtered data to the original data at first
    _filteredData = _data;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _globalKeyForTaxes,
      child: Scaffold(
        body: ListView(
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
                        labelText: 'جستجو...',
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0)),
                            borderSide: BorderSide(color: Colors.grey)),
                        focusedBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0)),
                            borderSide: BorderSide(color: Colors.blue)),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _filteredData = _data
                              .where((element) => element.taxTin
                                  .toLowerCase()
                                  .contains(value.toLowerCase()))
                              .toList();
                        });
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.print),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      onCreateNewTax(context);
                    },
                    child: const Text('افزودن مالیات جدید'),
                  ),
                ],
              ),
            ),
            PaginatedDataTable(
              sortAscending: _sortAscending,
              sortColumnIndex: _sortColumnIndex,
              header: const Text("همه مالیات |"),
              columns: [
                DataColumn(
                  label: const Text(
                    "ن.ت. مالیه دهنده (TIN)",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      _sortColumnIndex = columnIndex;
                      _sortAscending = ascending;
                      _filteredData
                          .sort((a, b) => a.taxTin.compareTo(b.taxTin));
                      if (!ascending) {
                        _filteredData = _filteredData.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(
                  label: const Text(
                    "مالیات سال",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      _sortColumnIndex = columnIndex;
                      _sortAscending = ascending;
                      _filteredData
                          .sort(((a, b) => a.taxOfYear.compareTo(b.taxOfYear)));
                      if (!ascending) {
                        _filteredData = _filteredData.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(
                  label: const Text(
                    "فیصدی مالیات (%)",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      _sortColumnIndex = columnIndex;
                      _sortAscending = ascending;
                      _filteredData
                          .sort(((a, b) => a.taxRate.compareTo(b.taxRate)));
                      if (!ascending) {
                        _filteredData = _filteredData.reversed.toList();
                      }
                    });
                  },
                ),
                const DataColumn(
                  label: Text(
                    "شرح",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
                const DataColumn(
                    label: Text("تغییر",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold))),
                const DataColumn(
                    label: Text("حذف",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold))),
              ],
              source: MyDataSource(_filteredData),
              rowsPerPage: _filteredData.length < 5 ? _filteredData.length : 5,
            )
          ],
        ),
      ),
    );
  }
}

class MyDataSource extends DataTableSource {
  List<MyData> data;

  MyDataSource(this.data);

  void sort(Comparator<MyData> compare, bool ascending) {
    data.sort(compare);
    if (!ascending) {
      data = data.reversed.toList();
    }
    notifyListeners();
  }

  @override
  DataRow getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(data[index].taxTin)),
      DataCell(Text(data[index].taxOfYear)),
      DataCell(Text(data[index].taxRate)),
      DataCell(
        Builder(builder: (BuildContext context) {
          return IconButton(
            icon: data[index].taxDetail,
            onPressed: (() => onShowTaxDetails(context)),
            color: Colors.blue,
            iconSize: 20.0,
          );
        }),
      ),
      DataCell(
        Builder(builder: (BuildContext context) {
          return IconButton(
            icon: data[index].editTax,
            onPressed: (() {
              onEditTax(context);
            }),
            color: Colors.blue,
            iconSize: 20.0,
          );
        }),
      ),
      DataCell(
        Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: data[index].deleteTax,
              onPressed: (() {
                onDeleteTax(context);
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

// This is to display an alert dialog to delete taxes
onDeleteTax(BuildContext context) {
  return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
            title: const Directionality(
              textDirection: TextDirection.rtl,
              child: Text('حذف مالیات'),
            ),
            content: const Directionality(
              textDirection: TextDirection.rtl,
              child: Text('آیا میخواهید این مالیه را حذف کنید؟'),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('لغو')),
              TextButton(onPressed: () {}, child: const Text('حذف')),
            ],
          ));
}

// This dialog edits a tax
onEditTax(BuildContext context) {
// The global for the form
  final formKey = GlobalKey<FormState>();
// The text editing controllers for the TextFormFields
  // ignore: non_constant_identifier_names
  final TINController = TextEditingController();
  final taxOfYearController = TextEditingController();
  final taxRateController = TextEditingController();
  final taxTotalController = TextEditingController();
  final taxDueController = TextEditingController();
  final delByController = TextEditingController();
  final delDateCotnroller = TextEditingController();

  return showDialog(
    context: context,
    builder: ((context) {
      return StatefulBuilder(
        builder: ((context, setState) {
          return AlertDialog(
            title: const Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                'تغییر مالیات  ',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            content: Directionality(
              textDirection: TextDirection.rtl,
              child: Form(
                key: formKey,
                child: SizedBox(
                  width: 500.0,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 20.0),
                        ),
                        Container(
                          margin: const EdgeInsets.all(20.0),
                          child: TextFormField(
                            controller: TINController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'نمبر تشخیصیه مالیه دهنده (TIN)',
                              suffixIcon: Icon(Icons.numbers_outlined),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.blue)),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(20.0),
                          child: TextFormField(
                            controller: taxOfYearController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'مالیه سال',
                              suffixIcon: Icon(Icons.date_range_outlined),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.blue)),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(20.0),
                          child: TextFormField(
                            controller: taxRateController,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'فیصدی مالیات',
                              suffixIcon: Icon(Icons.percent_outlined),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.blue)),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(20.0),
                          child: TextFormField(
                            controller: taxTotalController,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9.]'))
                            ],
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'مجموع مالیات',
                              suffixIcon: Icon(Icons.money_sharp),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.blue)),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(20.0),
                          child: TextFormField(
                            controller: taxDueController,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9.]'))
                            ],
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'مالیات باقی',
                              suffixIcon: Icon(Icons.attach_money_outlined),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.blue)),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(20.0),
                          child: TextFormField(
                            controller: delDateCotnroller,
                            onTap: () async {
                              FocusScope.of(context).requestFocus(FocusNode());
                              final DateTime? dateTime = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(2100));
                              if (dateTime != null) {
                                final intl.DateFormat formatter =
                                    intl.DateFormat('yyyy-MM-dd');
                                final String formattedDate =
                                    formatter.format(dateTime);
                                delDateCotnroller.text = formattedDate;
                              }
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9.]'))
                            ],
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'تاریخ تحویل دهی',
                              suffixIcon: Icon(Icons.calendar_month_outlined),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.blue)),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(20.0),
                          child: TextFormField(
                            controller: delByController,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'تحویل کننده مالیات',
                              suffixIcon: Icon(Icons.person),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide: BorderSide(color: Colors.blue)),
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
                  textDirection: TextDirection.rtl,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('لغو')),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('تغییر'),
                      ),
                    ],
                  ))
            ],
          );
        }),
      );
    }),
  );
}

// This is to display an alert dialog to expenses details
onShowTaxDetails(BuildContext context) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Directionality(
        textDirection: TextDirection.rtl,
        child: Text(
          'جزییات مالیات',
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
      ),
      content: const Directionality(
        textDirection: TextDirection.rtl,
        child: Directionality(
            textDirection: TextDirection.rtl, child: TaxDetails()),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('تایید'),
        ),
      ],
      actionsAlignment: MainAxisAlignment.start,
    ),
  );
}

class MyData {
  final String taxTin;
  final String taxOfYear;
  final String taxRate;
  final Icon taxDetail;
  final Icon editTax;
  final Icon deleteTax;

  MyData(this.taxTin, this.taxOfYear, this.taxRate, this.taxDetail,
      this.editTax, this.deleteTax);
}

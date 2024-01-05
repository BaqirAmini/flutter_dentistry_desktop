import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../views/finance/taxes/tax_details.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_dentistry/models/db_conn.dart';
import 'package:flutter_dentistry/views/finance/taxes/tax_info.dart';

// Create the global key at the top level of your Dart file
final GlobalKey<ScaffoldMessengerState> _globalKeyForTaxes =
    GlobalKey<ScaffoldMessengerState>();

const regExOnlydigits = "[0-9]";
const regExpDecimal = r'^\d+\.?\d{0,2}';
const regExOnlyAbc = "[a-zA-Z,، \u0600-\u06FFF]";

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
  const TaxData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const TaxDataTable();
  }
}

// Data table widget is here
class TaxDataTable extends StatefulWidget {
  const TaxDataTable({Key? key}) : super(key: key);

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
    TaxInfo.StaffList = staffList;
    TaxInfo.selectedStaff = selectedStaffId;
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
    final noteController = TextEditingController();
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

    bool checked = false;
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
                                    RegExp(regExpDecimal))
                              ],
                              readOnly: true,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'مجموع مالیات',
                                suffixIcon: Icon(Icons.money),
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
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 20.0,
                                      right: 20.0,
                                      top: 10.0,
                                      bottom: 10.0),
                                  child: TextFormField(
                                    controller: taxPaidController,
                                    validator: (value) {
                                      double taxPaid = taxPaidController
                                              .text.isNotEmpty
                                          ? double.parse(taxPaidController.text)
                                          : 0;
                                      if (value!.isEmpty) {
                                        return 'مالیات تحویل شده الزامی میباشد.';
                                      } else if (taxPaid > totalTaxesofYear!) {
                                        return 'مالیات تحویل شده نمی تواند بیشتر از کل مالیات باشد.';
                                      }
                                    },
                                    readOnly: checked ? true : false,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(regExpDecimal))
                                    ],
                                    onChanged:
                                        checked ? _onPaidTaxes : _onPaidTaxes,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'مالیات تحویل شده',
                                      suffixIcon:
                                          Icon(Icons.money_off_csred_outlined),
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
                              ),
                              Expanded(
                                flex: 1,
                                child: CheckboxListTile(
                                  value: checked,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      checked = value!;
                                      if (checked) {
                                        dueTaxes = 0;
                                        paidTaxes = totalTaxesofYear;
                                        taxPaidController.text =
                                            paidTaxes.toString();
                                        taxDueController.text =
                                            dueTaxes.toString();
                                      }
                                    });
                                  },
                                  title: const Text('پرداخت همه'),
                                ),
                              ),
                            ],
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
                            child: TextFormField(
                              controller: noteController,
                              validator: (value) {
                                if (value!.isNotEmpty) {
                                  if (value.length > 40 || value.length < 10) {
                                    return 'توضیحات باید حداقل 10 و حداکثر 40 حرف باشد.';
                                  }
                                }
                                return null;
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(regExOnlyAbc),
                                ),
                              ],
                              maxLines: 3,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'توضیحات',
                                suffixIcon: Icon(Icons.note_alt_outlined),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30.0)),
                                    borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30.0)),
                                    borderSide: BorderSide(color: Colors.blue)),
                                errorBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30.0)),
                                    borderSide: BorderSide(color: Colors.red)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30.0)),
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
                              double paidAmount =
                                  double.parse(taxPaidController.text);
                              double dueAmount = dueTaxes!;
                              String paidDate = delDateCotnroller.text;
                              int taxYear = selectedYear;
                              int staffID = int.parse(selectedStaffId!);
                              String note = noteController.text;
                              final conn = await onConnToDb();

                              // First ensure not to add duplicate years
                              var results1 = await conn.query(
                                  'SELECT * FROM taxes WHERE tax_for_year = ?',
                                  [taxYear]);
                              if (results1.isNotEmpty) {
                                _onShowSnack(Colors.red,
                                    'متاسفم، مالیات سال $taxYear ه.ش قبلا در سیستم وجود دارد.');
                              } else {
                                // Secondly add a record into taxes first
                                var results2 = await conn.query(
                                    'INSERT INTO taxes (annual_income, tax_rate, total_annual_tax, TIN, tax_for_year) VALUES(?, ?, ?, ?, ?)',
                                    [
                                      annualIncome,
                                      taxRate,
                                      totalAnnualTax,
                                      tin,
                                      taxYear
                                    ]);
                                if (results2.affectedRows! > 0) {
                                  // Fetch tax ID to insert details of it into tax_payments
                                  var results3 = await conn.query(
                                      'SELECT * FROM taxes WHERE tax_for_year = ?',
                                      [taxYear]);
                                  var row = results3.first;
                                  int taxID = row['tax_ID'];

                                  var results4 = await conn.query(
                                      'INSERT INTO tax_payments (tax_ID, paid_date, paid_by, paid_amount, due_amount, note) VALUES (?, ?, ?, ?, ?, ?)',
                                      [
                                        taxID,
                                        paidDate,
                                        staffID,
                                        paidAmount,
                                        dueAmount,
                                        note
                                      ]);
                                  if (results4.affectedRows! > 0) {
                                    _onShowSnack(Colors.green,
                                        'مالیات موفقانه افزوده شد.');
                                    TaxInfo.onAddTax!();
                                  } else {
                                    _onShowSnack(Colors.red,
                                        'متاسفم، افزودن مالیات ناکام شد.');
                                  }
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

  // The filtered data source
  List<Tax> _filteredData = [];

  List<Tax> _data = [];

// Fetch expenses records from the database
  Future<void> _fetchData() async {
    final conn = await onConnToDb();
    // if expFilterValue = 'همه' then it should not use WHERE to filter.
    final results = await conn.query(
        'SELECT A.tax_ID, A.annual_income, A.tax_rate, A.total_annual_tax, B.paid_amount, B.due_amount, A.TIN, DATE_FORMAT(B.paid_date, "%Y-%m-%d"), A.tax_for_year, B.paid_by, C.firstname, C.lastname, B.note, B.tax_pay_ID FROM taxes A INNER JOIN tax_payments B ON A.tax_ID = B.tax_ID INNER JOIN staff C ON B.paid_by = C.staff_ID ORDER BY B.modified_at DESC');

    _data = results.map((row) {
      return Tax(
        taxID: row[0],
        annualIncom: row[1],
        taxRate: row[2],
        annualTaxes: row[3],
        deliveredTax: row[4],
        dueTax: row[5],
        taxTin: row[6],
        deliverDate: row[7].toString(),
        taxOfYear: row[8].toString(),
        staffID: row[9],
        firstName: row[10],
        lastName: row[11],
        notes: row[12].toString(),
        taxPayID: row[13],
        taxDetail: const Icon(Icons.list),
        editTax: const Icon(Icons.edit),
        deleteTax: const Icon(Icons.delete),
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

  @override
  Widget build(BuildContext context) {
    TaxInfo.onAddTax = _fetchData;
    TaxInfo.onUpdateDueTax = _fetchData;
    // Assign fetchStaff to static function and immediatly call it here since when onEditTax() is called the staff dropdown is initially blank.
    TaxInfo.onFetchStaff = fetchStaff;
    TaxInfo.onFetchStaff!();
    final dataSource = MyDataSource(_filteredData, _fetchData, _fetchData);
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
                              .where((element) =>
                                  element.taxOfYear
                                      .toLowerCase()
                                      .contains(value.toLowerCase()) ||
                                  element.annualIncom
                                      .toString()
                                      .toLowerCase()
                                      .contains(value.toLowerCase()) ||
                                  element.taxRate
                                      .toString()
                                      .toLowerCase()
                                      .contains(value.toLowerCase()) ||
                                  element.annualTaxes
                                      .toString()
                                      .toLowerCase()
                                      .contains(value.toLowerCase()) ||
                                  element.deliverDate
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
            if (_filteredData.isEmpty)
              const SizedBox(
                width: 200,
                height: 200,
                child:
                    Center(child: Text('هیچ ریکاردی مربوط مالیات یافت نشد.')),
              )
            else
              PaginatedDataTable(
                sortAscending: _sortAscending,
                sortColumnIndex: _sortColumnIndex,
                header: const Text("همه مالیات |"),
                columns: [
                  DataColumn(
                    label: const Text(
                      "سالهای مالی",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                    onSort: (columnIndex, ascending) {
                      setState(() {
                        _sortColumnIndex = columnIndex;
                        _sortAscending = ascending;
                        _filteredData
                            .sort((a, b) => a.taxOfYear.compareTo(b.taxOfYear));
                        if (!ascending) {
                          _filteredData = _filteredData.reversed.toList();
                        }
                      });
                    },
                  ),
                  DataColumn(
                    label: const Text(
                      "عواید سالانه",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                    onSort: (columnIndex, ascending) {
                      setState(() {
                        _sortColumnIndex = columnIndex;
                        _sortAscending = ascending;
                        _filteredData.sort(
                            (a, b) => a.annualIncom.compareTo(b.annualIncom));
                        if (!ascending) {
                          _filteredData = _filteredData.reversed.toList();
                        }
                      });
                    },
                  ),
                  DataColumn(
                    label: const Text(
                      "فیصدی مالیات",
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
                  DataColumn(
                    label: const Text(
                      "مجموع مالیات سالانه",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                    onSort: (columnIndex, ascending) {
                      setState(() {
                        _sortColumnIndex = columnIndex;
                        _sortAscending = ascending;
                        _filteredData.sort(
                            ((a, b) => a.annualTaxes.compareTo(b.annualTaxes)));
                        if (!ascending) {
                          _filteredData = _filteredData.reversed.toList();
                        }
                      });
                    },
                  ),
                  DataColumn(
                    label: const Text(
                      "مالیات پرداخت شده",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                    onSort: (columnIndex, ascending) {
                      setState(() {
                        _sortColumnIndex = columnIndex;
                        _sortAscending = ascending;
                        _filteredData.sort(((a, b) =>
                            a.deliveredTax.compareTo(b.deliveredTax)));
                        if (!ascending) {
                          _filteredData = _filteredData.reversed.toList();
                        }
                      });
                    },
                  ),
                  DataColumn(
                    label: const Text(
                      "تاریخ پرداخت",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                    onSort: (columnIndex, ascending) {
                      setState(() {
                        _sortColumnIndex = columnIndex;
                        _sortAscending = ascending;
                        _filteredData.sort(
                            ((a, b) => a.deliverDate.compareTo(b.deliverDate)));
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
                              color: Colors.blue,
                              fontWeight: FontWeight.bold))),
                  const DataColumn(
                      label: Text("حذف",
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold))),
                ],
                source: dataSource,
                rowsPerPage:
                    _filteredData.length < 8 ? _filteredData.length : 8,
              )
          ],
        ),
      ),
    );
  }
}

class MyDataSource extends DataTableSource {
  List<Tax> data;
  Function onUpdate;
  Function onDelete;
  MyDataSource(this.data, this.onUpdate, this.onDelete);
  void sort(Comparator<Tax> compare, bool ascending) {
    data.sort(compare);
    if (!ascending) {
      data = data.reversed.toList();
    }
    notifyListeners();
  }

  @override
  DataRow getRow(int index) {
    return DataRow(cells: [
      DataCell(Text('${data[index].taxOfYear} ه.ش')),
      DataCell(Text('${data[index].annualIncom} افغانی')),
      DataCell(Text('${data[index].taxRate}%')),
      DataCell(Text('${data[index].annualTaxes} افغانی')),
      DataCell(Text('${data[index].deliveredTax} افغانی')),
      DataCell(Text(data[index].deliverDate.toString())),
      DataCell(
        Builder(builder: (BuildContext context) {
          return IconButton(
            icon: data[index].taxDetail,
            onPressed: (() async {
              // Assign values into static class members for later use
              TaxInfo.TIN = data[index].taxTin;
              TaxInfo.taxID = data[index].taxID;
              TaxInfo.annualIncomes = data[index].annualIncom;
              TaxInfo.annTotTaxes = data[index].annualTaxes;
              TaxInfo.paidTaxes = data[index].deliveredTax;
              TaxInfo.dueTaxes = data[index].dueTax;
              TaxInfo.paidDate = data[index].deliverDate;
              TaxInfo.taxRate = data[index].taxRate;
              TaxInfo.staffID = data[index].staffID;
              TaxInfo.taxOfYear = data[index].taxOfYear;
              TaxInfo.firstName = data[index].firstName;
              TaxInfo.lastName = data[index].lastName;
// This is find out if there are due taxes (due tax is not get zero)
              final conn = await onConnToDb();
              var dueResult = await conn.query(
                  'SELECT * FROM tax_payments WHERE tax_ID = ? ORDER BY modified_at DESC',
                  [TaxInfo.taxID]);
              var row = dueResult.first;
              double dueTax = row["due_amount"];
              if (dueTax <= 0) {
                TaxInfo.isDueTax = false;
              } else {
                TaxInfo.isDueTax = true;
              }
              onShowTaxDetails(context);
            }),
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
              // Assign values into static class members for later use
              TaxInfo.TIN = data[index].taxTin;
              TaxInfo.taxID = data[index].taxID;
              TaxInfo.taxPayID = data[index].taxPayID;
              TaxInfo.annualIncomes = data[index].annualIncom;
              TaxInfo.annTotTaxes = data[index].annualTaxes;
              TaxInfo.dueTaxes = data[index].dueTax;
              TaxInfo.paidTaxes = data[index].deliveredTax;
              TaxInfo.paidDate = data[index].deliverDate;
              TaxInfo.taxRate = data[index].taxRate;
              TaxInfo.staffID = data[index].staffID;
              TaxInfo.taxOfYear = data[index].taxOfYear;
              TaxInfo.taxNotes = data[index].notes;
              TaxInfo.firstName = data[index].firstName;
              TaxInfo.lastName = data[index].lastName;
              TaxInfo.onFetchStaff!();
              onEditTax(context, onUpdate);
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
                TaxInfo.taxID = data[index].taxID;
                TaxInfo.taxOfYear = data[index].taxOfYear;
                onDeleteTax(context, onDelete);
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
onDeleteTax(BuildContext context, Function onDelete) {
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
                  onPressed: () =>
                      Navigator.of(context, rootNavigator: true).pop(),
                  child: const Text('لغو')),
              TextButton(
                  onPressed: () async {
                    final conn = await onConnToDb();
                    final results = await conn.query(
                        'DELETE FROM taxes WHERE tax_ID = ?', [TaxInfo.taxID]);
                    if (results.affectedRows! > 0) {
                      // ignore: use_build_context_synchronously
                      Navigator.of(context, rootNavigator: true).pop();
                      _onShowSnack(Colors.green,
                          'مالیات سال ${TaxInfo.taxOfYear} ه.ش موفقانه حذف شد.');
                      // Refresh the screen
                      onDelete();
                    }
                    await conn.close();
                  },
                  child: const Text('حذف')),
            ],
          ));
}

// This dialog edits a tax
onEditTax(BuildContext context, Function onUpdate) {
// The global for the form
  final formKey = GlobalKey<FormState>();
  TaxInfo.onFetchStaff!();
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
  final noteController = TextEditingController();
  // Create a dropdown for financial years.
  int selectedYear = 1300;
  List<int> years = [];
  for (var i = 1300; i < 1500; i++) {
    years.add(i);
  }

  int selectedStaff = int.parse(TaxInfo.selectedStaff!);
  double totalTaxesofYear = TaxInfo.annTotTaxes!;
// Sets the total taxes into its related field
  void _onSetTotalTax(String text) {
    double taxRate = taxRateController.text.isEmpty
        ? 0
        : double.parse(taxRateController.text);
    double annualIncome = annualIncomeController.text.isEmpty
        ? 0
        : double.parse(annualIncomeController.text);
    totalTaxesofYear = (taxRate * annualIncome) / 100;
    taxTotalController.text = '$totalTaxesofYear افغانی';
  }

  bool checked = false;
  double paidTaxes = TaxInfo.paidTaxes!;
  double dueTaxes = TaxInfo.dueTaxes!;
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

// Set values into textfields through static members of TaxInfo class.
  TINController.text = TaxInfo.TIN!;
  selectedYear = int.parse(TaxInfo.taxOfYear!);
  taxRateController.text = TaxInfo.taxRate.toString();
  annualIncomeController.text = TaxInfo.annualIncomes.toString();
  taxTotalController.text = TaxInfo.annTotTaxes.toString();
  taxPaidController.text = TaxInfo.paidTaxes.toString();
  taxDueController.text = TaxInfo.dueTaxes.toString();
  delDateCotnroller.text = TaxInfo.paidDate!;
  noteController.text = TaxInfo.taxNotes!;

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
                    reverse: false,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 20.0),
                        ),
                        Container(
                          margin: const EdgeInsets.all(20.0),
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
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide: BorderSide(color: Colors.red)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide: BorderSide(
                                      color: Colors.red, width: 1.5)),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'مالیه سال (هجری شمسی)',
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
                          margin: const EdgeInsets.all(20.0),
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
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide: BorderSide(color: Colors.red)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide: BorderSide(
                                      color: Colors.red, width: 1.5)),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
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
                          margin: const EdgeInsets.all(20.0),
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
                              suffixIcon: Icon(Icons.money_sharp),
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
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide: BorderSide(color: Colors.red)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide: BorderSide(
                                      color: Colors.red, width: 1.5)),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Container(
                                margin: const EdgeInsets.only(
                                    left: 20.0,
                                    right: 20.0,
                                    top: 10.0,
                                    bottom: 10.0),
                                child: TextFormField(
                                  controller: taxPaidController,
                                  validator: (value) {
                                    double taxPaid = taxPaidController
                                            .text.isNotEmpty
                                        ? double.parse(taxPaidController.text)
                                        : 0;
                                    if (value!.isEmpty) {
                                      return 'مالیات تحویل شده الزامی میباشد.';
                                    } else if (taxPaid > totalTaxesofYear!) {
                                      return 'مالیات تحویل شده نمی تواند بیشتر از کل مالیات باشد.';
                                    }
                                  },
                                  readOnly: checked ? true : false,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(regExpDecimal))
                                  ],
                                  onChanged:
                                      checked ? _onPaidTaxes : _onPaidTaxes,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'مالیات تحویل شده',
                                    suffixIcon:
                                        Icon(Icons.money_off_csred_outlined),
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
                            ),
                            Expanded(
                              flex: 1,
                              child: CheckboxListTile(
                                value: checked,
                                onChanged: taxTotalController.text.isEmpty
                                    ? null
                                    : (bool? value) {
                                        setState(() {
                                          checked = value!;
                                          if (checked) {
                                            dueTaxes = 0;
                                            paidTaxes = totalTaxesofYear;
                                            taxPaidController.text =
                                                paidTaxes.toString();
                                            taxDueController.text =
                                                dueTaxes.toString();
                                          }
                                        });
                                      },
                                title: const Text('پرداخت همه'),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.all(20.0),
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
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide: BorderSide(color: Colors.red)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide: BorderSide(
                                      color: Colors.red, width: 1.5)),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(20.0),
                          child: TextFormField(
                            controller: delDateCotnroller,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'تاریخ تحویلی الزامی میباشد.';
                              }
                            },
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
                              errorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide: BorderSide(color: Colors.red)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide: BorderSide(
                                      color: Colors.red, width: 1.5)),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                          child: TextFormField(
                            controller: noteController,
                            validator: (value) {
                              if (value!.isNotEmpty) {
                                if (value.length > 40 || value.length < 10) {
                                  return 'توضیحات باید حداقل 10 و حداکثر 40 حرف باشد.';
                                }
                              }
                              return null;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(regExOnlyAbc),
                              ),
                            ],
                            maxLines: 3,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'توضیحات',
                              suffixIcon: Icon(Icons.note_alt_outlined),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide: BorderSide(color: Colors.blue)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide: BorderSide(color: Colors.red)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide: BorderSide(
                                      color: Colors.red, width: 1.5)),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'تحویل کننده',
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
                                  value: TaxInfo.selectedStaff,
                                  items: TaxInfo.StaffList?.map((staff) {
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
                                      TaxInfo.selectedStaff = newValue;
                                      selectedStaff = int.parse(newValue!);
                                      print(
                                          'Selected Staff...> $selectedStaff');
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
                          if (formKey.currentState!.validate()) {
                            double editTaxRate =
                                double.parse(taxRateController.text);
                            double editAnnIncome =
                                double.parse(annualIncomeController.text);
                            double editTotAnnTax = totalTaxesofYear!;
                            String editTIN = TINController.text;
                            int editTaxYear = selectedYear;
                            String editPaidDate = delDateCotnroller.text;
                            int editStaffId = selectedStaff;
                            double editPaidAmount = paidTaxes;
                            double editDueAmount = dueTaxes;
                            String editNotes = noteController.text;

                            final conn = await onConnToDb();
                            // First update taxes table (parent table)
                            var editResult1 = await conn.query(
                                'UPDATE taxes SET annual_income = ?, tax_rate = ?, total_annual_tax = ?, TIN = ?, tax_for_year = ? WHERE tax_ID = ?',
                                [
                                  editAnnIncome,
                                  editTaxRate,
                                  editTotAnnTax,
                                  editTIN,
                                  editTaxYear,
                                  TaxInfo.taxID
                                ]);
                            // Then update tax_payments table (the child table)
                            var editResult2 = await conn.query(
                                'UPDATE tax_payments SET paid_date = ?, paid_by = ?, paid_amount = ?, due_amount = ?, note = ? WHERE tax_pay_ID = ?',
                                [
                                  editPaidDate,
                                  editStaffId,
                                  editPaidAmount,
                                  editDueAmount,
                                  editNotes,
                                  TaxInfo.taxPayID
                                ]);
                            if (editResult1.affectedRows! > 0 ||
                                editResult2.affectedRows! > 0) {
                              _onShowSnack(
                                  Colors.green, 'مالیات موفقانه تغییر کرد.');
                              onUpdate();
                            } else {
                              _onShowSnack(Colors.red,
                                  'متاسفم، شما هیچ تغییراتی نیاوردید.');
                            }
                            await conn.close();
                            Navigator.pop(context);
                          }
                        },
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

// This function is to pay the due taxes
onPayDueTaxes(BuildContext context) {
// The global for the form
  final formKeyDueTax = GlobalKey<FormState>();

// The text editing controllers for the TextFormFields
// ignore: non_constant_identifier_names
  final taxPaidController = TextEditingController();
  final taxDueController = TextEditingController();
  final paidDateController = TextEditingController();
  final noteController = TextEditingController();

// Assign selected staff here.
  String selectedStaffForTax = TaxInfo.selectedStaff!;

  // Assign paid amount taxes and due amount taxes
  taxPaidController.text = '${TaxInfo.paidTaxes} افغانی';
  taxDueController.text = '${TaxInfo.dueTaxes} افغانی';

  return showDialog(
    context: context,
    builder: ((context) {
      return StatefulBuilder(
        builder: ((context, setState) {
          return AlertDialog(
            title: const Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                'پرداخت بقیه مالیات',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            content: Directionality(
              textDirection: TextDirection.rtl,
              child: Form(
                key: formKeyDueTax,
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
                              left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                          child: TextFormField(
                            controller: taxPaidController,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(regExpDecimal))
                            ],
                            readOnly: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'مالیات تحویل شده',
                              suffixIcon: Icon(Icons.money_off_csred_outlined),
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
                              left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
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
                              left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                          child: TextFormField(
                            controller: paidDateController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'تاریخ تحویلی الزامی میباشد.';
                              }
                            },
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
                                paidDateController.text = formattedDate;
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
                              left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                          child: TextFormField(
                            controller: noteController,
                            validator: (value) {
                              if (value!.isNotEmpty) {
                                if (value.length > 40 || value.length < 10) {
                                  return 'توضیحات باید حداقل 10 و حداکثر 40 حرف باشد.';
                                }
                              }
                              return null;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(regExOnlyAbc),
                              ),
                            ],
                            maxLines: 3,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'توضیحات',
                              suffixIcon: Icon(Icons.note_alt_outlined),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide: BorderSide(color: Colors.blue)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide: BorderSide(color: Colors.red)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide: BorderSide(
                                      color: Colors.red, width: 1.5)),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
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
                                  value: selectedStaffForTax,
                                  items: TaxInfo.StaffList!.map((staff) {
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
                                      selectedStaffForTax = newValue!;
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
                          if (formKeyDueTax.currentState!.validate()) {
                            int taxId = TaxInfo.taxID!;
                            String paidDate = paidDateController.text;
                            double paidAmount = TaxInfo.dueTaxes!;
                            double dueAmount = 0;
                            String notes = noteController.text;
// Insert tax_payments table to make the due taxes zero.
                            final conn = await onConnToDb();
                            var dueResults = await conn.query(
                                'INSERT INTO tax_payments (tax_ID, paid_date, paid_by, paid_amount, due_amount, note) VALUES (?, ?, ?, ?, ?, ?)',
                                [
                                  taxId,
                                  paidDate,
                                  selectedStaffForTax,
                                  paidAmount,
                                  dueAmount,
                                  notes
                                ]);

                            if (dueResults.affectedRows! > 0) {
                              _onShowSnack(
                                  Colors.green, 'بقیه مالیات نیز تصفیه شد.');
                              TaxInfo.onUpdateDueTax!();
                            } else {
                              _onShowSnack(Colors.green,
                                  'متاسفم، تصفیه مالیات ناکام شد.');
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

// This is to display an alert dialog to expenses details
onShowTaxDetails(BuildContext context) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          children: [
            const Expanded(
              flex: 2,
              child: Text(
                'جزییات مالیات',
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            ),
            if (TaxInfo.isDueTax!)
              ElevatedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  side: const BorderSide(
                    color: Colors.blue,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  onPayDueTaxes(context);
                },
                child: const Text('تصفیه مالیاتی'),
              ),
          ],
        ),
      ),
      content: const Directionality(
        textDirection: TextDirection.rtl,
        child: Directionality(
            textDirection: TextDirection.rtl, child: TaxDetails()),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          child: const Text('تایید'),
        ),
      ],
      actionsAlignment: MainAxisAlignment.start,
    ),
  );
}

class Tax {
  final int taxID;
  final int taxPayID;
  final String taxTin;
  final double annualIncom;
  final double annualTaxes;
  final double deliveredTax;
  final double dueTax;
  final String deliverDate;
  final int staffID;
  final String taxOfYear;
  final double taxRate;
  final String? notes;
  final String firstName;
  final String lastName;
  final Icon taxDetail;
  final Icon editTax;
  final Icon deleteTax;

  Tax(
      {required this.taxID,
      required this.taxPayID,
      required this.taxTin,
      required this.annualIncom,
      required this.annualTaxes,
      required this.deliveredTax,
      required this.dueTax,
      required this.deliverDate,
      required this.staffID,
      required this.taxOfYear,
      required this.taxRate,
      this.notes,
      required this.firstName,
      required this.lastName,
      required this.taxDetail,
      required this.editTax,
      required this.deleteTax});
}

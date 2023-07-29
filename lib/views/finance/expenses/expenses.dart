import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dentistry/models/db_conn.dart';
import 'package:flutter_dentistry/models/expense_data_model.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' as intl;
import '../../main/dashboard.dart';
import '/views/finance/expenses/expense_info.dart';

// Create the global key at the top level of your Dart file
final GlobalKey<ScaffoldMessengerState> _globalKey1 =
    GlobalKey<ScaffoldMessengerState>();

// This is shows snackbar when called
void _onShowSnack(Color backColor, String msg) {
  _globalKey1.currentState?.showSnackBar(
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

void main() => runApp(const ExpenseList());

class ExpenseList extends StatefulWidget {
  const ExpenseList({Key? key}) : super(key: key);

  @override
  State<ExpenseList> createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ScaffoldMessenger(
        key: _globalKey1,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              actions: [
                Builder(builder: (context) {
                  return Tooltip(
                    message: 'افزودن اقلام مصارف',
                    child: IconButton(
                      onPressed: () async {
                        await fetchExpenseTypes();
                        await fetchStaff();
                        // ignore: use_build_context_synchronously
                        await onCreateExpenseItem(context);
                      },
                      icon: const Icon(Icons.monetization_on_outlined),
                    ),
                  );
                }),
                const SizedBox(
                  width: 10.0,
                ),
                Builder(builder: (context) {
                  return Tooltip(
                    message: 'افزودن نوعیت مصارف',
                    child: IconButton(
                      onPressed: () {
                        onCreateExpenseType(context);
                      },
                      icon: const Icon(Icons.category_outlined),
                    ),
                  );
                }),
              ],
              leading: Tooltip(
                message: 'رفتن به داشبورد',
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.home_outlined),
                ),
              ),
              title: const Text('مصارف داخلی کلینک'),
            ),
            body: const ExpenseData(),
          ),
        ),
      ),
    );
  }

  String? selectedExpType;
  List<Map<String, dynamic>> expenseTypes = [];
  Future<void> fetchExpenseTypes() async {
    var conn = await onConnToDb();
    var results = await conn.query('SELECT exp_ID, exp_name FROM expenses');
    setState(() {
      expenseTypes = results
          .map((result) =>
              {'exp_ID': result[0].toString(), 'exp_name': result[1]})
          .toList();
    });
    selectedExpType =
        expenseTypes.isNotEmpty ? expenseTypes[0]['exp_ID'] : null;
    await conn.close();
  }

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

// The text editing controllers for the TextFormFields
  final itemNameController = TextEditingController();
  final quantityController = TextEditingController();
  final unitPriceController = TextEditingController();
  final purchaseDateController = TextEditingController();
  final totalPriceController = TextEditingController();
  final descriptionController = TextEditingController();

  double? totalPrice;
// Sets the total price into its related field
  void _onSetTotalPrice(String text) {
    double qty = quantityController.text.isEmpty
        ? 0
        : double.parse(quantityController.text);
    double unitPrice = unitPriceController.text.isEmpty
        ? 0
        : double.parse(unitPriceController.text);
    totalPrice = qty * unitPrice;
    totalPriceController.text = '$totalPrice افغانی';
  }

// This dialog creates a new Expense
  onCreateExpenseItem(BuildContext context) {
// The global for the form
    final formKey2 = GlobalKey<FormState>();

    // Set a dropdown for units
    String selectedUnit = 'گرام';
    var unitsItems = [
      'گرام',
      'کیلوگرام',
      'عدد',
      'قرص',
      'متر',
      'سانتی متر',
      'cc',
      'خوراک',
      'ست',
    ];

    return showDialog(
      context: context,
      builder: ((context) {
        return StatefulBuilder(
          builder: ((context, setState) {
            return AlertDialog(
              title: const Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  'افزودن اقلام مصارف  ',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              content: Directionality(
                textDirection: TextDirection.rtl,
                child: Form(
                  key: formKey2,
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
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'نوعیت جنس خریداری شده',
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
                                    value: selectedExpType,
                                    items: expenseTypes.map((expense) {
                                      return DropdownMenuItem<String>(
                                        value: expense['exp_ID'],
                                        alignment: Alignment.centerRight,
                                        child: Text(expense['exp_name']),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedExpType = newValue;
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
                              controller: itemNameController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'نام جنس نمی تواند خالی باشد.';
                                } else if (value.length < 3 ||
                                    value.length > 10) {
                                  return 'نام جنس باید بین 3 و 10 حرف باشد.';
                                }
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'نام جنس',
                                suffixIcon: Icon(Icons.bakery_dining_outlined),
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
                                flex: 2,
                                child: Container(
                                  margin: const EdgeInsets.all(20.0),
                                  child: TextFormField(
                                    controller: quantityController,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9.]'))
                                    ],
                                    validator: (value) {
                                      if (value!.isNotEmpty) {
                                        final qty = double.tryParse(value!);
                                        if (qty! < 1 || qty > 100) {
                                          return 'تعداد/مقدار باید بین 1 و 100 واحد باشد.';
                                        }
                                      } else if (value.isEmpty) {
                                        return 'تعداد/مقدار نمی تواند خالی باشد.';
                                      }
                                    },
                                    onChanged: _onSetTotalPrice,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'تعداد/مقدار واحد',
                                      suffixIcon: Icon(Icons
                                          .production_quantity_limits_outlined),
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
                                child: Container(
                                  margin: const EdgeInsets.all(20.0),
                                  child: InputDecorator(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'واحد',
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
                                    child: DropdownButtonHideUnderline(
                                      child: Container(
                                        height: 26.0,
                                        child: DropdownButton(
                                          isExpanded: true,
                                          icon:
                                              const Icon(Icons.arrow_drop_down),
                                          value: selectedUnit,
                                          items: unitsItems
                                              .map((String positionItems) {
                                            return DropdownMenuItem(
                                              value: positionItems,
                                              alignment: Alignment.centerRight,
                                              child: Text(positionItems),
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedUnit = newValue!;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.all(20.0),
                            child: TextFormField(
                              controller: unitPriceController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'قیمت نمی تواند خالی باشد.';
                                }
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              onChanged: _onSetTotalPrice,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'قیمت فی واحد جنس',
                                suffixIcon: Icon(Icons.price_change_outlined),
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
                            margin: const EdgeInsets.all(20.0),
                            child: TextFormField(
                              readOnly: true,
                              controller: totalPriceController,
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9.]'))
                              ],
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'جمله / مجموعه پول پرداخت شده',
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
                          Container(
                            margin: const EdgeInsets.all(20.0),
                            child: TextFormField(
                              controller: descriptionController,
                              validator: (value) {
                                if (value!.isNotEmpty) {
                                  if (value.length < 5 || value.length > 30) {
                                    return 'توضیحات باید بین 5 و 30 حرف باشد.';
                                  }
                                }
                              },
                              maxLines: 3,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'توضیحات',
                                suffixIcon: Icon(Icons.description_outlined),
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
                            margin: const EdgeInsets.all(20.0),
                            child: TextFormField(
                              controller: purchaseDateController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'تاریخ خرید نمی تواند خالی باشد.';
                                }
                              },
                              onTap: () async {
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
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
                                  purchaseDateController.text = formattedDate;
                                }
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9.]'))
                              ],
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'تاریخ خرید جنس',
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
                            margin: const EdgeInsets.all(20.0),
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
                            if (formKey2.currentState!.validate()) {
                              int expID = int.parse(selectedExpType!);
                              int staffID = int.parse(selectedStaffId!);
                              String itemName = itemNameController.text;
                              double itemQty =
                                  double.parse(quantityController.text);
                              double unitPrice =
                                  double.parse(unitPriceController.text);
                              String datePurchased =
                                  purchaseDateController.text;
                              String notes = descriptionController.text;
                              // Do connection with the database
                              var conn = await onConnToDb();
                              // Insert the item into expense_detail table
                              var result = await conn.query(
                                  'INSERT INTO expense_detail (exp_ID, purchased_by, item_name, quantity, qty_unit, unit_price, total, purchase_date, note) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
                                  [
                                    expID,
                                    staffID,
                                    itemName,
                                    itemQty,
                                    selectedUnit,
                                    unitPrice,
                                    totalPrice,
                                    datePurchased,
                                    notes
                                  ]);
                              if (result.affectedRows! > 0) {
                                _onShowSnack(Colors.green,
                                    'این جنس مورد مصرف موفقانه افزوده شد.');
                                ExpenseInfo.onAddExpense!();

                                itemNameController.clear();
                                quantityController.clear();
                                unitPriceController.clear();
                                purchaseDateController.clear();
                                totalPriceController.clear();
                                descriptionController.clear();
                              } else {
                                _onShowSnack(
                                    Colors.red, 'متاسفم، جنس مصرفی اضافه نشد.');
                              }
                              await conn.close();
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context);
                            }
                          },
                          child: const Text('افزودن'),
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
}

// This dialog creates a new expense type
onCreateExpenseType(BuildContext context) {
// The global for the form
  final formKey1 = GlobalKey<FormState>();
// The text editing controllers for the TextFormFields
  final itemNameController = TextEditingController();

  return showDialog(
    context: context,
    builder: ((context) {
      return StatefulBuilder(
        builder: ((context, setState) {
          return AlertDialog(
            title: const Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                'افزودن نوعیت (کتگوری) مصارف',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            content: Directionality(
              textDirection: TextDirection.rtl,
              child: Form(
                key: formKey1,
                child: SizedBox(
                  width: 500.0,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(20.0),
                          child: TextFormField(
                            controller: itemNameController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'نام کتگوری مصرف نمی تواند خالی باشد.';
                              } else if (value.length < 3 ||
                                  value.length > 20) {
                                return 'نام کتگوری مصرف باید بین 3 و 20 حرف باشد.';
                              }
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'نام نوعیت (کتگوری)',
                              suffixIcon: Icon(Icons.category),
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
                          if (formKey1.currentState!.validate()) {
                            String expName = itemNameController.text;
                            var conn = await onConnToDb();
                            // Avoid duplicate entry of expenses category
                            var results1 = await conn.query(
                                'SELECT * FROM expenses WHERE exp_name = ?',
                                [expName]);
                            if (results1.isNotEmpty) {
                              _onShowSnack(Colors.red,
                                  'متاسفم، این کتگوری مصارف قبلاً موجود است.');
                              Navigator.pop(context);
                            } else {
                              // Insert into expenses
                              var result2 = await conn.query(
                                  'INSERT INTO expenses (exp_name) VALUES (?)',
                                  [expName]);
                              if (result2.affectedRows! > 0) {
                                _onShowSnack(Colors.green,
                                    'نوعیت مصرف موفقانه افزوده شد.');
                                Navigator.pop(context);
                              } else {
                                _onShowSnack(
                                    Colors.red, 'متاسفم، عملیه انجام نشد.');
                                Navigator.pop(context);
                              }
                              await conn.close();
                            }
                          }
                        },
                        child: const Text('افزودن'),
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

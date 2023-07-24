import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dentistry/models/db_conn.dart';
import 'package:flutter_dentistry/models/expense_data_model.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' as intl;
import '../../main/dashboard.dart';

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
  const ExpenseList({Key? key}): super(key: key);

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
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Dashboard(),
                    ),
                  ),
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

// This dialog creates a new Expense
  onCreateExpenseItem(BuildContext context) {
// The global for the form
    final formKey2 = GlobalKey<FormState>();
// The text editing controllers for the TextFormFields
    final itemNameController = TextEditingController();
    final quantityController = TextEditingController();
    final unitPriceController = TextEditingController();
    final purchaseDateController = TextEditingController();
    final totalPriceController = TextEditingController();
    final descriptionController = TextEditingController();

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
                              ),
                            ),
                          ),
                          Container(
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
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'تعداد / مقدار',
                                suffixIcon: Icon(
                                    Icons.production_quantity_limits_outlined),
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
                              controller: unitPriceController,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
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
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(20.0),
                            child: TextFormField(
                              controller: totalPriceController,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9.]'))
                              ],
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'جمله / مجموعه پرداخت',
                                suffixIcon: Icon(Icons.money),
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
                              controller: descriptionController,
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
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(20.0),
                            child: TextFormField(
                              controller: purchaseDateController,
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
                          onPressed: () {
                            if (formKey2.currentState!.validate()) {}
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

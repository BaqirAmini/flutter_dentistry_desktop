import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dentistry/config/global_usage.dart';
import 'package:flutter_dentistry/config/language_provider.dart';
import 'package:provider/provider.dart';

// Set global variables which are needed later.
var selectedLanguage;
var isEnglish;

class FeeForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  const FeeForm({required this.formKey});

  @override
  State<FeeForm> createState() => _FeeFormState();
}

class _FeeFormState extends State<FeeForm> {
  // Declare controllers for textfields
  final _feeController = TextEditingController();
  final _recievableController = TextEditingController();

  // Declare for discount.
  bool _isVisibleForPayment = false;
  int _defaultDiscountRate = 0;
  final List<int> _discountItems = [2, 5, 10, 15, 20, 30, 50];
  double _feeWithDiscount = 0;
  double _dueAmount = 0;
  // Create a function for setting discount
  void _setDiscount(String text) {
    double totalFee =
        _feeController.text.isEmpty ? 0 : double.parse(_feeController.text);

    setState(() {
      if (_defaultDiscountRate == 0) {
        _feeWithDiscount = totalFee;
      } else {
        double discountAmt = (_defaultDiscountRate * totalFee) / 100;
        _feeWithDiscount = totalFee - discountAmt;
      }
    });
  }

  // Declare variables for installment rates.
  int _defaultInstallment = 0;
  final List<int> _installmentItems = [2, 3, 4, 5, 6, 7, 8, 9, 10];

  // This function deducts installments
  void _setInstallment(String text) {
    double receivable = _recievableController.text.isEmpty
        ? 0
        : double.parse(_recievableController.text);
    setState(() {
      _dueAmount = _feeWithDiscount - receivable;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Fetch translations keys based on the selected language.
    var languageProvider = Provider.of<LanguageProvider>(context);
    selectedLanguage = languageProvider.selectedLanguage;
    isEnglish = selectedLanguage == 'English';

// Assign the outputs into static class members for reusability.
    FeeInfo.fee = _feeWithDiscount;
    FeeInfo.dueAmount = _dueAmount;
    FeeInfo.discountRate = _defaultDiscountRate;
    FeeInfo.installment = _defaultInstallment;
    FeeInfo.receivedAmount = _recievableController.text.isEmpty
        ? 0
        : double.parse(_recievableController.text);

    return Form(
      key: widget.formKey,
      child: SizedBox(
        width: 500.0,
        child: Column(
          children: [
            const Text('لطفاً هزینه و اقساط را در خانه های ذیل انتخاب نمایید.'),
            Row(
              children: [
                const Text(
                  '*',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.360,
                  margin: const EdgeInsets.only(
                      left: 20.0, right: 10.0, top: 10.0, bottom: 10.0),
                  child: TextFormField(
                    controller: _feeController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'فیس نمیتواند خالی باشد.';
                      }
                      return null;
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(GlobalUsage.allowedDigPeriod),
                      ),
                    ],
                    onChanged: _setDiscount,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'فیس',
                      suffixIcon: Icon(Icons.money_rounded),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                          borderSide: BorderSide(color: Colors.blue)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                          borderSide: BorderSide(color: Colors.red)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                          borderSide:
                              BorderSide(color: Colors.red, width: 1.5)),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(
                  left: 20.0, right: 15.0, top: 10.0, bottom: 10.0),
              child: InputDecorator(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'فیصدی تخفیف',
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      borderSide: BorderSide(color: Colors.blue)),
                ),
                child: DropdownButtonHideUnderline(
                  child: SizedBox(
                    height: 26.0,
                    child: DropdownButton(
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down),
                      value: _defaultDiscountRate,
                      items: <DropdownMenuItem<int>>[
                        const DropdownMenuItem(
                          value: 0,
                          child: Text('No Discount'),
                        ),
                        ..._discountItems.map((int item) {
                          return DropdownMenuItem(
                            alignment: Alignment.centerRight,
                            value: item,
                            child: Directionality(
                              textDirection: isEnglish
                                  ? TextDirection.ltr
                                  : TextDirection.rtl,
                              child: Text('$item%'),
                            ),
                          );
                        }).toList(),
                      ],
                      onChanged: (int? newValue) {
                        setState(() {
                          _defaultDiscountRate = newValue!;
                        });
                        _setDiscount(_defaultDiscountRate.toString());
                      },
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                  left: 20.0, right: 15.0, top: 10.0, bottom: 10.0),
              child: InputDecorator(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'نوعیت پرداخت',
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      borderSide: BorderSide(color: Colors.blue)),
                ),
                child: DropdownButtonHideUnderline(
                  child: SizedBox(
                    height: 26.0,
                    child: DropdownButton<int>(
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down),
                      value: _defaultInstallment,
                      items: [
                        const DropdownMenuItem(
                          value: 0,
                          child: Text('تکمیل'),
                        ),
                        ..._installmentItems.map((int item) {
                          return DropdownMenuItem(
                            alignment: Alignment.centerRight,
                            value: item,
                            child: Directionality(
                              textDirection: isEnglish
                                  ? TextDirection.ltr
                                  : TextDirection.rtl,
                              child: Text('$item قسط'),
                            ),
                          );
                        }).toList(),
                      ],
                      onChanged: (int? newValue) {
                        setState(() {
                          _defaultInstallment = newValue!;
                          if (_defaultInstallment != 0) {
                            _isVisibleForPayment = true;
                            // If change the dropdown, it should display the due amount not zero
                            _dueAmount = _feeWithDiscount;
                          } else {
                            _isVisibleForPayment = false;
                            // Clear the form and assign zero to _dueAmount to reset them.
                            _recievableController.clear();
                            _dueAmount = 0;
                          }
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: _isVisibleForPayment,
              child: Row(
                children: [
                  const Text(
                    '*',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.360,
                    margin: const EdgeInsets.only(
                        left: 20.0, right: 10.0, top: 10.0, bottom: 10.0),
                    child: TextFormField(
                      controller: _recievableController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(GlobalUsage.allowedDigPeriod),
                        ),
                      ],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'مبلغ رسید نمی تواند خالی باشد.';
                        } else if (double.parse(value) > _feeWithDiscount) {
                          return 'مبلغ رسید باید کمتر از مبلغ قابل دریافت باشد.';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          if (value.isEmpty) {
                            _dueAmount = _feeWithDiscount;
                          } else {
                            _setInstallment(value.toString());
                          }
                        });
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'مبلغ رسید',
                        suffixIcon: Icon(Icons.money_rounded),
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
                            borderSide:
                                BorderSide(color: Colors.red, width: 1.5)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 215.0,
                  margin: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                      border: Border(
                    top: BorderSide(width: 1, color: Colors.grey),
                    bottom: BorderSide(width: 1, color: Colors.grey),
                  )),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        labelText: 'مجموع فیس',
                        floatingLabelAlignment: FloatingLabelAlignment.center),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Center(
                        child: Text(
                          '$_feeWithDiscount افغانی',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(5),
                  width: 215.0,
                  decoration: const BoxDecoration(
                      border: Border(
                    top: BorderSide(width: 1, color: Colors.grey),
                    bottom: BorderSide(width: 1, color: Colors.grey),
                  )),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        labelText: 'باقی مبلغ',
                        floatingLabelAlignment: FloatingLabelAlignment.center),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Center(
                        child: _defaultInstallment == 0
                            ? const Text(
                                '${0.0} افغانی',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue),
                              )
                            : Text(
                                '$_dueAmount افغانی',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FeeInfo {
  static double fee = 0;
  static int installment = 0;
  static double receivedAmount = 0;
  static double dueAmount = 0;
  static int? discountRate;
}

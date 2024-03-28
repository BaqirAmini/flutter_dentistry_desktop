import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dentistry/config/global_usage.dart';
import 'package:flutter_dentistry/config/language_provider.dart';
import 'package:flutter_dentistry/config/translations.dart';
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
    // _defaultInstallment == 0 means whole fee is paid by a patient. So, no due amount is remaining.
    FeeInfo.receivedAmount = (_defaultInstallment == 0)
        ? _feeWithDiscount
        : _recievableController.text.isEmpty
            ? 0
            : double.parse(_recievableController.text);

    return Directionality(
      textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.width * 0.04,
        ),
        width: MediaQuery.of(context).size.width * 0.5,
        child: Form(
          key: widget.formKey,
          child: Column(
            children: [
              Text(translations[selectedLanguage]?['FeeMessage'] ?? ''),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '*',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    margin: const EdgeInsets.only(
                        left: 20.0, right: 10.0, top: 10.0, bottom: 10.0),
                    child: TextFormField(
                      controller: _feeController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return translations[selectedLanguage]
                                  ?['FeeRequired'] ??
                              '';
                        }
                        return null;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(GlobalUsage.allowedDigPeriod),
                        ),
                      ],
                      onChanged: _setDiscount,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: translations[selectedLanguage]
                                ?['َServiceFee'] ??
                            '',
                        suffixIcon: const Icon(Icons.money_rounded),
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
                            borderSide:
                                BorderSide(color: Colors.red, width: 1.5)),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.3,
                margin: const EdgeInsets.only(
                    left: 20.0, right: 15.0, top: 10.0, bottom: 10.0),
                child: InputDecorator(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText:
                        translations[selectedLanguage]?['DiscountRate'] ?? '',
                    enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: const OutlineInputBorder(
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
                          DropdownMenuItem(
                            value: 0,
                            child: Text(translations[selectedLanguage]
                                    ?['NoDiscount'] ??
                                ''),
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
                width: MediaQuery.of(context).size.width * 0.3,
                margin: const EdgeInsets.only(
                    left: 20.0, right: 15.0, top: 10.0, bottom: 10.0),
                child: InputDecorator(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText:
                        translations[selectedLanguage]?['PaymentType'] ?? '',
                    enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: const OutlineInputBorder(
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
                          DropdownMenuItem(
                            value: 0,
                            child: Text(translations[selectedLanguage]
                                    ?['PayWhole'] ??
                                ''),
                          ),
                          ..._installmentItems.map((int item) {
                            return DropdownMenuItem(
                              alignment: Alignment.centerRight,
                              value: item,
                              child: Directionality(
                                textDirection: isEnglish
                                    ? TextDirection.ltr
                                    : TextDirection.rtl,
                                child: Text(
                                    '$item ${translations[selectedLanguage]?['Installment'] ?? ''}'),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '*',
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
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
                            return translations[selectedLanguage]
                                    ?['PayAmountRequired'] ??
                                '';
                          } else if (double.parse(value) > _feeWithDiscount) {
                            return translations[selectedLanguage]
                                    ?['PayAmountValid'] ??
                                '';
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
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: translations[selectedLanguage]
                                  ?['PayAmount'] ??
                              '',
                          suffixIcon: const Icon(Icons.money_rounded),
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
                    width: MediaQuery.of(context).size.width * 0.14,
                    margin: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                        border: Border(
                      top: BorderSide(width: 1, color: Colors.grey),
                      bottom: BorderSide(width: 1, color: Colors.grey),
                    )),
                    child: InputDecorator(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText:
                              translations[selectedLanguage]?['TotalFee'] ?? '',
                          floatingLabelAlignment:
                              FloatingLabelAlignment.center),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Center(
                          child: Text(
                            '$_feeWithDiscount ${translations[selectedLanguage]?['Afn'] ?? ''}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(5),
                    width: MediaQuery.of(context).size.width * 0.14,
                    decoration: const BoxDecoration(
                        border: Border(
                      top: BorderSide(width: 1, color: Colors.grey),
                      bottom: BorderSide(width: 1, color: Colors.grey),
                    )),
                    child: InputDecorator(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: translations[selectedLanguage]
                                  ?['ReceivableFee'] ??
                              '',
                          floatingLabelAlignment:
                              FloatingLabelAlignment.center),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Center(
                          child: _defaultInstallment == 0
                              ? Text(
                                  '${0.0} ${translations[selectedLanguage]?['Afn'] ?? ''}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue),
                                )
                              : Text(
                                  '$_dueAmount ${translations[selectedLanguage]?['Afn'] ?? ''}',
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

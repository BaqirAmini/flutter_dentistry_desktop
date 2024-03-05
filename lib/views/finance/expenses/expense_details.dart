// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_dentistry/config/language_provider.dart';
import 'package:flutter_dentistry/config/translations.dart';
import 'package:provider/provider.dart';
import '/views/finance/expenses/expense_info.dart';

class ExpenseDetails extends StatelessWidget {
  ExpenseDetails({Key? key}) : super(key: key);

// ignore: prefer_typing_uninitialized_variables
  var selectedLanguage;
// ignore: prefer_typing_uninitialized_variables
  var isEnglish;

  @override
  Widget build(BuildContext context) {
    // Fetch translations keys based on the selected language.
    var languageProvider = Provider.of<LanguageProvider>(context);
    selectedLanguage = languageProvider.selectedLanguage;
    isEnglish = selectedLanguage == 'English';
    // Get expenses info to later use
    String? expCtg = ExpenseInfo.expenseCategory;
    String? itemName = ExpenseInfo.itemName;
    String? purchasedBy = ExpenseInfo.purchasedBy;
    String? descrip = ExpenseInfo.description;
    double? itemQty = ExpenseInfo.qty;
    String? qtyUnit = ExpenseInfo.qtyUnit;
    double? uPrice = ExpenseInfo.unitPrice;

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      height: MediaQuery.of(context).size.height * 0.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            color: const Color.fromARGB(255, 240, 239, 239),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  translations[selectedLanguage]?['ExpenseType'] ?? '',
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Color.fromARGB(255, 118, 116, 116),
                  ),
                ),
                Text('$expCtg'),
              ],
            ),
          ),
          const SizedBox(
            height: 15.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 240.0,
                padding: const EdgeInsets.all(10.0),
                color: const Color.fromARGB(255, 240, 239, 239),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      translations[selectedLanguage]?['Item'] ?? '',
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Color.fromARGB(255, 118, 116, 116),
                      ),
                    ),
                    Text('$itemName'),
                  ],
                ),
              ),
              Container(
                width: 240.0,
                padding: const EdgeInsets.all(10.0),
                color: const Color.fromARGB(255, 240, 239, 239),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      translations[selectedLanguage]?['QtyAmount'] ?? '',
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Color.fromARGB(255, 118, 116, 116),
                      ),
                    ),
                    Text('$itemQty $qtyUnit'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 240.0,
                padding: const EdgeInsets.all(10.0),
                color: const Color.fromARGB(255, 240, 239, 239),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      translations[selectedLanguage]?['PurchasedBy'] ?? '',
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Color.fromARGB(255, 118, 116, 116),
                      ),
                    ),
                    Text('$purchasedBy'),
                  ],
                ),
              ),
              Container(
                width: 240.0,
                padding: const EdgeInsets.all(10.0),
                color: const Color.fromARGB(255, 240, 239, 239),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      translations[selectedLanguage]?['UnitPrice'] ?? '',
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Color.fromARGB(255, 118, 116, 116),
                      ),
                    ),
                    Text(
                        '$uPrice ${translations[selectedLanguage]?['Afn'] ?? ''}'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15.0,
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            color: const Color.fromARGB(255, 240, 239, 239),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  translations[selectedLanguage]?['RetDetails'] ?? '',
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Color.fromARGB(255, 118, 116, 116),
                  ),
                ),
                Text('$descrip'),
              ],
            ),
          ),
          const SizedBox(
            height: 15.0,
          ),
          Expanded(
            child: InkWell(
              onTap: () => print('Invoice Clicked.'),
              child: Image.asset(
                'assets/graphics/login_img1.png',
                width: 400.0,
                height: 400.0,
              ),
            ),
          )
        ],
      ),
    );
  }
}

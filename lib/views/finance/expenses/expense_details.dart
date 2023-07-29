import 'package:flutter/material.dart';
import '/views/finance/expenses/expense_info.dart';

class ExpenseDetails extends StatelessWidget {
  const ExpenseDetails({super.key});

  @override
  Widget build(BuildContext context) {
    // Get expenses info to later use
    String? expCtg = ExpenseInfo.expenseCategory;
    String? itemName = ExpenseInfo.itemName;
    String? purchasedBy = ExpenseInfo.purchasedBy;
    String? descrip = ExpenseInfo.description;
    double? itemQty = ExpenseInfo.qty;
    String? qtyUnit = ExpenseInfo.qtyUnit;
    double? uPrice = ExpenseInfo.unitPrice;

    return SizedBox(
      width: 600.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            color: const Color.fromARGB(255, 240, 239, 239),
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'نوعیت مصرف',
                  style: TextStyle(
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
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'نام جنس',
                      style: TextStyle(
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
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'تعداد / مقدار',
                      style: TextStyle(
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
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'خرید توسط',
                      style: TextStyle(
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
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'قیمت فی واحد',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Color.fromARGB(255, 118, 116, 116),
                      ),
                    ),
                    Text('$uPrice افغانی'),
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
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'توضیحات',
                  style: TextStyle(
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
              ),
            ),
          )
        ],
      ),
    );
  }
}

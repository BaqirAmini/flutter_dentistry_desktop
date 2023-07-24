import 'package:flutter/material.dart';

class ExpenseDetails extends StatelessWidget {
  const ExpenseDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 600.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            color: const Color.fromARGB(255, 240, 239, 239),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'نوعیت مصرف',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Color.fromARGB(255, 118, 116, 116),
                  ),
                ),
                Text('مواد مورد نیاز دندان'),
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
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'نام جنس',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Color.fromARGB(255, 118, 116, 116),
                      ),
                    ),
                    Text('نقره'),
                  ],
                ),
              ),
              Container(
                width: 240.0,
                padding: const EdgeInsets.all(10.0),
                color: const Color.fromARGB(255, 240, 239, 239),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'تعداد / مقدار',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Color.fromARGB(255, 118, 116, 116),
                      ),
                    ),
                    Text('500 گرام'),
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
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'تاریخ خرید',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Color.fromARGB(255, 118, 116, 116),
                      ),
                    ),
                    Text('2022/06/06'),
                  ],
                ),
              ),
              Container(
                width: 240.0,
                padding: const EdgeInsets.all(10.0),
                color: const Color.fromARGB(255, 240, 239, 239),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'قیمت فی واحد',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Color.fromARGB(255, 118, 116, 116),
                      ),
                    ),
                    Text('1000 افغانی'),
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
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'مجموع قیمت',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Color.fromARGB(255, 118, 116, 116),
                  ),
                ),
                Text('500,000 افغانی'),
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

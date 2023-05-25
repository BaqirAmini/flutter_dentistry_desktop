import 'package:flutter/material.dart';

void main() {
  return runApp(const PatientDetail());
}

final items = ['Item 1', 'Item 2', 'Item 3', 'Item 4', 'Item 5'];

class PatientDetail extends StatelessWidget {
  const PatientDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('جزییات مریض'),
            actions: [
              Tooltip(
                message: 'رفتن به داشبورد',
                child: IconButton(
                  icon: const Icon(Icons.home),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              Container(
                  height: 200.0,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Card(
                        child: SizedBox(
                          width: 200.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              CircleAvatar(
                                radius: 40.0,
                                backgroundImage:
                                    AssetImage('assets/graphics/patient.png'),
                                backgroundColor: Colors.transparent,
                              ),
                              Text(
                                'احمد احمدی',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '0744232325',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        child: SizedBox(
                          height: 300.0,
                          width: 400.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 20.0, bottom: 20.0),
                                    child: Column(
                                      children: const [
                                        Text(
                                          'جنیست',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12.0),
                                        ),
                                        Text('مرد'),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 20.0, bottom: 20.0),
                                    child: Column(
                                      children: const [
                                        Text('حالت مدنی',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12.0)),
                                        Text('مجرد'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 20.0, bottom: 20.0),
                                    child: Column(
                                      children: const [
                                        Text('سن',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12.0)),
                                        Text('25'),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 20.0, bottom: 20.0),
                                    child: Column(
                                      children: const [
                                        Text('گروپ خون',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12.0)),
                                        Text('B+'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 20.0, bottom: 20.0),
                                    child: Column(
                                      children: const [
                                        Text('آدرس',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12.0)),
                                        Text('کابل، کوته سنگی'),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 20.0, bottom: 20.0),
                                    child: Column(
                                      children: const [
                                        Text('تاریخ ثبت',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12.0)),
                                        Text('2023-03-03'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          child: Card(
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: const Text('هزینه ها', style: TextStyle(color: Colors.blue, fontSize: 14.0, fontWeight: FontWeight.bold),),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Table(
                                    border: const TableBorder(
                                        horizontalInside: BorderSide(
                                            color: Colors.grey,
                                            style: BorderStyle.solid,
                                            width: 0.5)),
                                    columnWidths: const {
                                      0: FixedColumnWidth(120),
                                      1: FixedColumnWidth(80),
                                      2: FixedColumnWidth(100),
                                      3: FixedColumnWidth(100),
                                      4: FixedColumnWidth(100),
                                    },
                                    children: const [
                                      // add your table rows here
                                      TableRow(
                                        children: [
                                          Padding(
                                          padding: EdgeInsets.all(5.0),
                                          child: Text(
                                            'سرویس',
                                            style: TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.grey),
                                          ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(5.0),
                                            child: Text(
                                              'جلسه',
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.grey),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(5.0),
                                            child: Text(
                                              'مبلغ کل',
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.grey),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(5.0),
                                            child: Text(
                                              'دریافت شده',
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.grey),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(5.0),
                                            child: Text(
                                              'باقی',
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.grey),
                                            ),
                                          ),
                                        ],
                                      ),
                                      // more rows ...
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SingleChildScrollView(
                                    child: Table(
                                      border: const TableBorder(
                                          horizontalInside: BorderSide(
                                              color: Colors.grey,
                                              style: BorderStyle.solid,
                                              width: 0.5)),
                                      columnWidths: const {
                                        0: FixedColumnWidth(120),
                                        1: FixedColumnWidth(80),
                                        2: FixedColumnWidth(100),
                                        3: FixedColumnWidth(100),
                                        4: FixedColumnWidth(100),
                                      },
                                      children: const [
                                        // add your table rows here
                                        TableRow(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('پرکاری دندان'),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('1'),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('3000 افغانی'),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('2000'),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('1000'),
                                            ),
                                          ],
                                        ),
                                        TableRow(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('پرکاری دندان'),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('2'),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('3000 افغانی'),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('2000'),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('1000'),
                                            ),
                                          ],
                                        ),
                                        TableRow(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('پرکاری دندان'),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('2'),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('3000 افغانی'),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('2000'),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('1000'),
                                            ),
                                          ],
                                        ),
                                        // more rows ...
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
              Expanded(
                  child: SizedBox(
                width: 1250.0,
                height: 380.0,
                child: Card(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: const Text('دفعات مراجعه بیمار', style: TextStyle(color: Colors.blue, fontSize: 14.0, fontWeight: FontWeight.bold),),
                      ),
                      Container(
                        width: 1000.0,
                        padding: const EdgeInsets.all(8.0),
                        child: Table(
                          border: const TableBorder(
                              horizontalInside: BorderSide(
                                  color: Colors.grey,
                                  style: BorderStyle.solid,
                                  width: 0.5)),
                          columnWidths: const {
                            0: FixedColumnWidth(120),
                            1: FixedColumnWidth(100),
                            2: FixedColumnWidth(100),
                            3: FixedColumnWidth(100),
                            4: FixedColumnWidth(200),
                            5: FixedColumnWidth(100),
                            7: FixedColumnWidth(50),
                            8: FixedColumnWidth(50),
                            9: FixedColumnWidth(50),
                          },
                          children: const [
                            // add your table rows here
                            TableRow(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    'سرویس',
                                    style: TextStyle(
                                        fontSize: 12.0, color: Colors.grey),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    'تاریخ مراجعه',
                                    style: TextStyle(
                                        fontSize: 12.0, color: Colors.grey),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    'فک / بیره',
                                    style: TextStyle(
                                        fontSize: 12.0, color: Colors.grey),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    'نوعیت دندان',
                                    style: TextStyle(
                                        fontSize: 12.0, color: Colors.grey),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    'توضیحات',
                                    style: TextStyle(
                                        fontSize: 12.0, color: Colors.grey),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    'جلسه / نوبت',
                                    style: TextStyle(
                                        fontSize: 12.0, color: Colors.grey),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    'داکتر',
                                    style: TextStyle(
                                        fontSize: 12.0, color: Colors.grey),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    'ویرایش',
                                    style: TextStyle(
                                        fontSize: 12.0, color: Colors.grey),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    'حذف',
                                    style: TextStyle(
                                        fontSize: 12.0, color: Colors.grey),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    'عکس',
                                    style: TextStyle(
                                        fontSize: 12.0, color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                            // more rows ...
                          ],
                        ),
                      ),
                      Container(
                        width: 1000.0,
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                          child: Table(
                            border: const TableBorder(
                                horizontalInside: BorderSide(
                                    color: Colors.grey,
                                    style: BorderStyle.solid,
                                    width: 0.5)),
                            columnWidths: const {
                              0: FixedColumnWidth(120),
                              1: FixedColumnWidth(100),
                              2: FixedColumnWidth(100),
                              3: FixedColumnWidth(100),
                              4: FixedColumnWidth(200),
                              5: FixedColumnWidth(100),
                              7: FixedColumnWidth(50),
                              8: FixedColumnWidth(50),
                              9: FixedColumnWidth(50),
                            },
                            children:  [
                              // add your table rows here
                              TableRow(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('پرکاری دندان'),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('2023-03-03'),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('بالا'),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('سوم'),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('در اثر سوراخی دندان از مواد زرگونیم...'),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('1'),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('حامد کریمی'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: IconButton(onPressed: () {}, icon: const Icon(Icons.edit, color: Colors.blue, size: 20.0),),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: IconButton(onPressed: () {}, icon: const Icon(Icons.delete, color: Colors.blue, size: 20.0),),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: IconButton(onPressed: () {}, icon: const Icon(Icons.image, color: Colors.blue, size: 20.0),),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('پرکاری دندان'),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('2023-03-03'),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('بالا'),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('سوم'),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('در اثر سوراخی دندان از مواد زرگونیم...'),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('1'),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('حامد کریمی'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: IconButton(onPressed: () {}, icon: const Icon(Icons.edit, color: Colors.blue, size: 20.0),),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: IconButton(onPressed: () {}, icon: const Icon(Icons.delete, color: Colors.blue, size: 20.0),),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: IconButton(onPressed: () {}, icon: const Icon(Icons.image, color: Colors.blue, size: 20.0),),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('پرکاری دندان'),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('2023-03-03'),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('بالا'),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('سوم'),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('در اثر سوراخی دندان از مواد زرگونیم...'),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('1'),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('حامد کریمی'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: IconButton(onPressed: () {}, icon: const Icon(Icons.edit, color: Colors.blue, size: 20.0),),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: IconButton(onPressed: () {}, icon: const Icon(Icons.delete, color: Colors.blue, size: 20.0),),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: IconButton(onPressed: () {}, icon: const Icon(Icons.image, color: Colors.blue, size: 20.0),),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),),
            ],
          ),
        ),
      ),
    );
  }
}

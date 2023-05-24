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
                      Column(
                        children: [
                          SizedBox(
                            height: 50.0,
                            width: 600.0,
                            child: Expanded(
                                flex: 1,
                                child: Card(
                                  margin: const EdgeInsets.only(top: 5.0),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Text('هزینه ها'),
                                        Table(
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
                                        )
                                      ],
                                    ),
                                  ),
                                )),
                          ),
                          SizedBox(
                            width: 600.0,
                            height: 150.0,
                            child: Expanded(
                              flex: 1,
                              child: Card(
                                margin: EdgeInsets.zero,
                                child: Center(
                                  child: Expanded(
                                    flex: 1,
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
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
              Container(
                height: 200.0,
                  child: Card(
                child: SizedBox(
                  child: Text('Appointment'),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}

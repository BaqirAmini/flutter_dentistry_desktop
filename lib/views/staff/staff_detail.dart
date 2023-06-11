import 'package:flutter/material.dart';
import 'package:flutter_dentistry/views/staff/details_tabs.dart';
import 'package:flutter_dentistry/views/staff/staff.dart';

void main() => runApp(const StaffDetail());

class StaffDetail extends StatefulWidget {
  const StaffDetail({super.key});

  @override
  State<StaffDetail> createState() => _StaffDetailState();
}

class _StaffDetailState extends State<StaffDetail> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            leading: Tooltip(
              message: 'رفتن به صفحه قبلی',
              child: IconButton(
                onPressed: () => const Staff(),
                icon: const BackButton(),
              ),
            ),
            title: const Text('جزییات کارمند'),
          ),
          body: Row(
            children: [
              SizedBox(
                width: 200.0,
                child: Card(
                  child: Stack(
                    children: [
                      Positioned(
                        top: 8.0,
                        left: 8.0,
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.edit),
                        ),
                      ),
                      Center(
                        child: Column(
                          children: [
                            const CircleAvatar(
                              radius: 50.0,
                              backgroundImage:
                                  AssetImage('assets/graphics/patient.png'),
                            ),
                            const Text('Ali Ahmadi'),
                            const Text('Dentist'),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Column(
                              children: const [
                                Text('نام'),
                                Text('علی'),
                              ],
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Column(
                              children: const [
                                Text('نمبر تذکره'),
                                Text('1399-1205-56273'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 5.0, left: 5.0, bottom: .0),
                  constraints: const BoxConstraints(maxWidth: 500.0),
                  child: const StaffDetailTabs(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

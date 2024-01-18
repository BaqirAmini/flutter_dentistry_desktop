import 'package:flutter/material.dart';
import 'package:flutter_dentistry/views/main/dashboard.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_dentistry/views/patients/patient_info.dart';

void main() {
  runApp(const StaffDetail());
}

class StaffDetail extends StatelessWidget {
  const StaffDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('سوابق کارمند'),
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const BackButtonIcon(),
            ),
            actions: [
              IconButton(
                // onPressed: () {},
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Dashboard(),
                )),
                icon: const Icon(Icons.home_outlined),
                tooltip: 'Dashboard',
                padding: const EdgeInsets.all(3.0),
                splashRadius: 30.0,
              ),
              const SizedBox(width: 15.0)
            ],
          ),
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width * 0.23,
                  child: const _StaffProfile(),
                ),
                _StaffMoreDetail(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StaffProfile extends StatelessWidget {
  const _StaffProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  const CircleAvatar(
                    radius: 30.0,
                    backgroundImage:
                        AssetImage('assets/graphics/user_profile2.jpg'),
                    backgroundColor: Colors.transparent,
                  ),
                  Positioned(
                    top: -5.0,
                    right: -5.0,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: Card(
                        shape: const CircleBorder(),
                        child: Center(
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            child: const Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Icon(Icons.edit,
                                  size: 12.0,
                                  color: Color.fromARGB(255, 123, 123, 123)),
                            ),
                            onTap: () {},
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // const SizedBox(width: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.1,
                child: Column(
                  children: [
                    Text('Ahmad Karimi',
                        style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 10.0),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              MediaQuery.of(context).size.width * 0.017),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.phone_android,
                              color: Colors.grey, size: 14),
                          SizedBox(width: 5.0),
                          Expanded(
                            child: Text(
                              '+93744117120',
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 14.0),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          /*  SizedBox(
            width: 260,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.phone_android,
                        color: Colors.grey, size: 14),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        '${PatientInfo.phone}',
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 14.0),
                      ),
                    )
                  ],
                ),
                /*   const SizedBox(height: 5.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.home, color: Colors.grey, size: 14),
                    const SizedBox(width: 8.0),
                    SizedBox(
                      width: 150,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          '${PatientInfo.address}',
                          style: const TextStyle(onEditStaffInfo
                              color: Colors.grey, fontSize: 12.0),
                        ),
                      ),
                    ),
                  ],
                ), */
              ],
            ),
          ),
 */
        ],
      ),
    );
  }
}

class _StaffMoreDetail extends StatefulWidget {
  @override
  State<_StaffMoreDetail> createState() => _StaffMoreDetailState();
}

class _StaffMoreDetailState extends State<_StaffMoreDetail> {
// This function edits patient's personal info
  onEditStaffInfo(BuildContext context) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Directionality(
          textDirection: TextDirection.rtl,
          child: Text('تغییر معلومات شخصی مریض'),
        ),
        content: const Directionality(
          textDirection: TextDirection.rtl,
          child: Text('آیا کاملاً مطمیین هستید در قسمت خانه پری این صفحه؟'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
              child: const Text('لغو')),
          ElevatedButton(
              onPressed: () {
                setState(() {});
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: const Text('تغییر')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width * 0.52,
          child: Card(
            elevation: 0.5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 20.0, bottom: 20.0),
                          child: const Column(
                            children: [
                              Text(
                                'تاریخ استخدام',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 12.0),
                              ),
                              Text('2023-10-23'),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 20.0, bottom: 20.0),
                          child: const Column(
                            children: [
                              Text('بست',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12.0)),
                              Text('داکتر دندان'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 20.0, bottom: 20.0),
                          child: const Column(
                            children: [
                              Text('معاش',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12.0)),
                              Text('60000 افغانی'),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 20.0, bottom: 20.0),
                          child: const Column(
                            children: [
                              Text('مقدار پول ضمانت',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12.0)),
                              Text('7000 افغانی'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 20.0, bottom: 20.0),
                          child: const SizedBox(
                            width: 220,
                            child: Column(
                              children: [
                                Text('نمبر تماس عضو فامیل 1',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12.0)),
                                Text('+93771020230'),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 20.0, bottom: 20.0),
                          child: const Column(
                              children: [
                                Text('نمبر تماس عضو فامیل 2',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12.0)),
                                Text('+93771020231'),
                              ],
                            ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 20.0, bottom: 20.0),
                          child: const Column(
                            children: [
                              Text(
                                'نمبر تذکره',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 12.0),
                              ),
                              Text('1399-1205-55102'),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 20.0, bottom: 20.0),
                          child: const Column(
                            children: [
                              Text('آدرس',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12.0)),
                              Text('کابل، خیر خانه'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 20.0, bottom: 20.0),
                          child: const Text('قرارداد خط',
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 12.0)),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 20.0, bottom: 20.0),
                          child: IconButton(onPressed: () {
                            
                          }, icon: Icon(Icons.file_present_outlined)),
                        ),
                      ],
                    ),
                                     ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 8.0,
          left: 8.0,
          child: Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.edit,
                      size: 16.0, color: Color.fromARGB(255, 123, 123, 123)),
                ),
                onTap: () => onEditStaffInfo(context),
              )),
        ),
      ],
    );
  }
}

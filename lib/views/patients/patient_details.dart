import 'package:flutter/material.dart';
import 'package:flutter_dentistry/views/main/dashboard.dart';
import 'package:flutter_dentistry/views/patients/appointments.dart';
import 'package:flutter_dentistry/views/patients/patient_history.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_dentistry/views/patients/patient_info.dart';

void main() {
  runApp(const PatientDetail());
}

class PatientDetail extends StatelessWidget {
  const PatientDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('سوابق مریض'),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.height * 0.5,
                      child: const _PatientProfile(),
                    ),
                    _PatientMoreDetail(),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.height * 1.49,
                  child: Card(
                      elevation: 0.5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: const _NavigationArea()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PatientProfile extends StatelessWidget {
  const _PatientProfile({Key? key}) : super(key: key);

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
                      width: 30.0,
                      height: 30.0,
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
              const SizedBox(width: 10),
              SizedBox(
                width: 150,
                child: Column(
                  children: [
                    Text('${PatientInfo.firstName} ${PatientInfo.lastName}',
                        style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 5.0),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.phone_android,
                              color: Colors.grey, size: 14),
                          const SizedBox(width: 5.0),
                          Expanded(
                            child: Text(
                              '${PatientInfo.phone}',
                              style: const TextStyle(
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
                          style: const TextStyle(
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

class _NavigationArea extends StatelessWidget {
  const _NavigationArea({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.height * 0.7,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: HoverCard(
                  title: Row(
                    children: [
                      const Icon(FontAwesomeIcons.userDoctor),
                      const SizedBox(width: 10.0),
                      Text('جلسات',
                          style: Theme.of(context).textTheme.bodyLarge),
                    ],
                  ),
                  indexNum: 100,
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.height * 0.7,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: HoverCard(
                  title: const Row(
                    children: [
                      Icon(FontAwesomeIcons.moneyBill1),
                      SizedBox(width: 10.0),
                      Text('فیس / اقساط'),
                    ],
                  ),
                  indexNum: 101,
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.height * 0.7,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: HoverCard(
                  title: const Row(
                    children: [
                      Icon(FontAwesomeIcons.heartPulse),
                      SizedBox(width: 10.0),
                      Text('تاریخچه صحی مریض'),
                    ],
                  ),
                  indexNum: 102,
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.height * 0.7,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: HoverCard(
                  title: const Row(
                    children: [
                      Icon(FontAwesomeIcons.fileImage),
                      SizedBox(width: 10.0),
                      Text('X-Rays / Files'),
                    ],
                  ),
                  indexNum: 103,
                ),
              ),
            ),
          ],
        ),
        // Add more cards here for each setting
      ],
    );
  }
}

class HoverCard extends StatefulWidget {
  final Widget title;
  final int indexNum;

  HoverCard({required this.title, required this.indexNum});

  @override
  _HoverCardState createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => setState(() => _isHovering = true),
      onExit: (event) => setState(() => _isHovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
        transform: _isHovering
            ? Matrix4.translationValues(10, 0, 0)
            : Matrix4
                .identity(), // Move the card to the left/right when hovering
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.2),
            border: Border.all(color: Colors.grey, width: 0.5),
          ),
          child: Center(
            child: ListTile(
              title: widget.title,
              trailing: const Icon(Icons.arrow_forward_ios_sharp),
              onTap: () {
                if (widget.indexNum == 100) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Appointment()));
                } else if (widget.indexNum == 102) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PatientHistory()));
                } else {
                  print('Other cards clicked.');
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _PatientMoreDetail extends StatefulWidget {
  @override
  State<_PatientMoreDetail> createState() => _PatientMoreDetailState();
}

class _PatientMoreDetailState extends State<_PatientMoreDetail> {
// This function edits patient's personal info
  onEditPatientInfo(BuildContext context) {
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
          height: MediaQuery.of(context).size.height * 0.3,
          width: MediaQuery.of(context).size.width * 0.5,
          child: Card(
            elevation: 0.5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 20.0, bottom: 20.0),
                      child: Column(
                        children: [
                          const Text(
                            'جنسیت',
                            style:
                                TextStyle(color: Colors.grey, fontSize: 12.0),
                          ),
                          Text('${PatientInfo.sex}'),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20.0, bottom: 20.0),
                      child: Column(
                        children: [
                          const Text('حالت مدنی',
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 12.0)),
                          Text('${PatientInfo.maritalStatus}'),
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
                      child: Column(
                        children: [
                          const Text('سن',
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 12.0)),
                          Text('${PatientInfo.age} سال'),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20.0, bottom: 20.0),
                      child: Column(
                        children: [
                          const Text('گروپ خون',
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 12.0)),
                          Text('${PatientInfo.bloodGroup}'),
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
                      child: SizedBox(
                        width: 220,
                        child: Column(
                          children: [
                            const Text('آدرس',
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 12.0)),
                            Text('${PatientInfo.address}'),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20.0, bottom: 20.0),
                      child: Column(
                        children: [
                          const Text('تاریخ ثبت',
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 12.0)),
                          Text('${PatientInfo.regDate}'),
                        ],
                      ),
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
                onTap: () => onEditPatientInfo(context),
              )),
        ),
      ],
    );
  }
}

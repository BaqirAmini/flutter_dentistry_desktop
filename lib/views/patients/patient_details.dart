import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('سوابق مریض'),
          ),
          body: Card(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  child: const _PatientProfile(),
                ),
                _SectionDetail(),
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.2),
        border: Border.all(color: Colors.grey, width: 0.5),
      ),
      margin: const EdgeInsets.all(10.0),
      width: MediaQuery.of(context).size.width * 0.2,
      height: MediaQuery.of(context).size.height * 0.4,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30.0,
                backgroundImage:
                    AssetImage('assets/graphics/user_profile2.jpg'),
                backgroundColor: Colors.transparent,
              ),
              SizedBox(width: 10),
              Text(
                'Hussain Ehsani',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 15),
          SizedBox(
            height: 100,
            width: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.phone_android),
                   Expanded(child:  Text('0744375177'),)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.home),
                    Expanded(
                      child: Text('، ناحیه سیسیسسسسسسسسکابل، دشت برچی'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ClickableWidgets extends StatelessWidget {
  const ClickableWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Tooltip(
          message: 'تاریخچه صحی جدید',
          child: InkWell(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue, width: 2.0),
              ),
              child: const Padding(
                padding: EdgeInsets.all(5.0),
                child: Icon(
                  Icons.add,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ),
        Tooltip(
          message: 'تاریخچه صحی جدید',
          child: InkWell(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue, width: 2.0),
              ),
              child: const Padding(
                padding: EdgeInsets.all(5.0),
                child: Icon(
                  Icons.add_a_photo_outlined,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ),
        Tooltip(
          message: 'تاریخچه صحی جدید',
          child: InkWell(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue, width: 2.0),
              ),
              child: const Padding(
                padding: EdgeInsets.all(5.0),
                child: Icon(
                  Icons.access_alarm,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class NavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('Home'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('System'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Network & devices'),
            onTap: () {},
          ),
          // Add more list tiles here for each navigation item
        ],
      ),
    );
  }
}

class ContentArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        // Text('جزییات', style: Theme.of(context).textTheme.headlineMedium),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: HoverCard(
            title: const Row(
              children: [
                Icon(Icons.info_outline),
                SizedBox(width: 10.0),
                Text('درباره مریض'),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: HoverCard(
            title: const Row(
              children: [
                Icon(Icons.contact_phone_outlined),
                SizedBox(width: 10.0),
                Text('جلسات'),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: HoverCard(
            title: const Row(
              children: [
                Icon(Icons.health_and_safety_outlined),
                SizedBox(width: 10.0),
                Text('تاریخچه صحی مریض'),
              ],
            ),
          ),
        ),
        // Add more cards here for each setting
      ],
    );
  }
}

class HoverCard extends StatefulWidget {
  final Widget title;

  HoverCard({required this.title});

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
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.2),
            border: Border.all(color: Colors.grey, width: 0.5),
          ),
          child: Center(
            child: ListTile(
              title: widget.title,
              trailing: const Icon(Icons.arrow_forward_ios_sharp),
              onTap: () {
                // Handle your onTap here
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.2),
            border: Border.all(color: Colors.grey, width: 0.5),
          ),
          margin: const EdgeInsets.all(10.0),
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width * 0.3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 20.0, bottom: 20.0),
                    child: const Column(
                      children: [
                        Text(
                          'جنسیت',
                          style: TextStyle(color: Colors.grey, fontSize: 12.0),
                        ),
                        // Text('${PatientInfo.sex}'),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20.0, bottom: 20.0),
                    child: const Column(
                      children: [
                        Text('حالت مدنی',
                            style:
                                TextStyle(color: Colors.grey, fontSize: 12.0)),
                        // Text('${PatientInfo.maritalStatus}'),
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
                        Text('سن',
                            style:
                                TextStyle(color: Colors.grey, fontSize: 12.0)),
                        // Text('${PatientInfo.age} سال'),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20.0, bottom: 20.0),
                    child: const Column(
                      children: [
                        Text('گروپ خون',
                            style:
                                TextStyle(color: Colors.grey, fontSize: 12.0)),
                        // Text('${PatientInfo.bloodGroup}'),
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
                        Text('آدرس',
                            style:
                                TextStyle(color: Colors.grey, fontSize: 12.0)),
                        // Text('${PatientInfo.address}'),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20.0, bottom: 20.0),
                    child: const Column(
                      children: [
                        Text('تاریخ ثبت',
                            style:
                                TextStyle(color: Colors.grey, fontSize: 12.0)),
                        // Text('${PatientInfo.regDate}'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.2),
            border: Border.all(color: Colors.grey, width: 0.5),
          ),
          margin: const EdgeInsets.all(10.0),
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width * 0.4,
          child: Center(child: ContentArea()),
        ),
      ],
    );
  }
}

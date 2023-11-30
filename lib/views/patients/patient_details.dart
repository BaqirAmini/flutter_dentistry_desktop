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
          body: const Card(
            child: Row(
              children: [
                SizedBox(
                  height: 200.0,
                  child: UserProfile(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UserProfile extends StatelessWidget {
  const UserProfile({Key? key}) : super(key: key);

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
          width: MediaQuery.of(context).size.width * 0.3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Row(
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
              SizedBox(
                height: 100,
                width: 200,
                child: ListView(
                  children: const [
                    ListTile(
                      leading: const Icon(Icons.phone_android),
                      title: Text('0744375177'),
                      // contentPadding: EdgeInsets.all(0)
                    ),
                    ListTile(
                      leading: const Icon(Icons.home),
                      title: Text('کابل، دشت برچی'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
           decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.2),
            border: Border.all(color: Colors.grey, width: 0.5),
          ),
          margin: const EdgeInsets.all(10.0),
          height: 300.0,
          width: MediaQuery.of(context).size.width * 0.5,
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
      ],
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
        Text('جزییات', style: Theme.of(context).textTheme.headlineMedium),
        HoverCard(
          title: const Row(
            children: [
              Icon(Icons.info_outline),
              SizedBox(width: 10.0),
              Text('درباره مریض'),
            ],
          ),
          child: const ListTile(
            title: Text('Connected'),
          ),
        ),
        HoverCard(
          title: const Row(
            children: [
              Icon(Icons.contact_phone_outlined),
              SizedBox(width: 10.0),
              Text('جلسات'),
            ],
          ),
          child: const ListTile(
            title: Text('Not connected'),
          ),
        ),
        HoverCard(
          title: const Row(
            children: [
              Icon(Icons.health_and_safety_outlined),
              SizedBox(width: 10.0),
              Text('تاریخچه صحی مریض'),
            ],
          ),
          child: const ListTile(
            title: Text('Off'),
          ),
        ),
        // Add more cards here for each setting
      ],
    );
  }
}

class HoverCard extends StatefulWidget {
  final Widget title;
  final Widget child;

  HoverCard({required this.title, required this.child});

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
        child: Card(
          child: ExpansionTile(
            title: widget.title,
            children: <Widget>[
              widget.child,
            ],
          ),
        ),
      ),
    );
  }
}

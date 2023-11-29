import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Settings Page Example'),
        ),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              const SizedBox(height: 10),
              // const ClickableWidgets(),
              UserProfile(),
              const SizedBox(height: 10),
              Expanded(
                child: Row(
                  children: [
                    NavigationBar(),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width *
                                0.05), // Adjust the multiplier to change the margin size
                        child: ContentArea(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
    return const ListTile(
      leading: CircleAvatar(
        radius: 50.0,
        backgroundImage: AssetImage('assets/graphics/patient.png'),
        backgroundColor: Colors.transparent,
      ),
      title: Text('حسین احمدی', style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('bamini@firstrate.com'),
          Text('آدمین'),
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

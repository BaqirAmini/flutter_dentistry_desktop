import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Settings Page Example'),
        ),
        body: Directionality(
          textDirection: TextDirection.ltr,
          child: Column(
            children: [
              const UserProfile(),
              const SizedBox(height: 10),
              ClickableWidgets(),
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
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey,
        child: Icon(Icons.person, color: Colors.white),
      ),
      title: Text('Baqir Amini', style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('bamini@firstrate.com'),
          Text('Administrator'),
        ],
      ),
    );
  }
}

class ClickableWidgets extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.monetization_on_outlined),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.health_and_safety_outlined),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.propane_tank_outlined),
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
        children: const <Widget>[
          ListTile(title: Text('Home')),
          ListTile(title: Text('System')),
          ListTile(title: Text('Network & devices')),
          // Add more list tiles here for each navigation item
        ],
      ),
    );
  }
}

class ContentArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: <Widget>[
          Text('Network & Internet',
              style: Theme.of(context).textTheme.headline4),
          HoverCard(
            title: const Text('Ethernet'),
            child: const ListTile(
              title: Text('Connected'),
            ),
          ),
          HoverCard(
            title: const Text('VPN'),
            child: const ListTile(
              title: Text('Not connected'),
            ),
          ),
          HoverCard(
            title: const Text('Mobile hotspot'),
            child: const ListTile(
              title: Text('Off'),
            ),
          ),
          HoverCard(
            title: const Text('Airplane mode'),
            child: const ListTile(
              title: Text('Off'),
            ),
          ),
          // Add more cards here for each setting
        ],
      ),
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
            : Matrix4.identity(), // Move the card to the left/right when hovering
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

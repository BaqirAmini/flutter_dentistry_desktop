import 'package:flutter/material.dart';

void main() {
  runApp(const Appointment());
}

class Appointment extends StatelessWidget {
  const Appointment({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Appointment'),
          leading: IconButton(onPressed: () {}, icon: BackButtonIcon()),
          actions: [
            Tooltip(
              message: 'افزودن جلسه جدید',
              child: InkWell(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.0),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 15)
          ],
        ),
        body: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: ContentArea(),
          ),
        ),
      ),
    );
  }
}

class ContentArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        HoverCard(
          title: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(
                  Icons.date_range_outlined,
                  color: Colors.green,
                ),
                SizedBox(width: 10.0),
                Text(
                  '2023-10-10',
                  style: TextStyle(color: Colors.green, fontSize: 18.0),
                ),
              ],
            ),
          ),
          child: ListTile(
            title: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Round',
                          style: Theme.of(context).textTheme.labelLarge),
                      const SizedBox(width: 15.0),
                      const Expanded(
                        child: Text(
                          '1',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color: Color.fromARGB(255, 112, 112, 112)),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text('Description',
                          style: Theme.of(context).textTheme.labelLarge),
                      const SizedBox(width: 15.0),
                      const Expanded(
                        child: Text(
                          'Some text for description sdsddddddddddddddddddddd',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color: Color.fromARGB(255, 112, 112, 112)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
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

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(const PatientHistory());
}

class PatientHistory extends StatelessWidget {
  const PatientHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Patient Health History'),
            leading: IconButton(onPressed: () => Navigator.pop(context), icon: const BackButtonIcon()),
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
              const SizedBox(width: 15)
            ],
          ),
          body: Center(
            child: Container(
              margin: const EdgeInsets.only(top: 15),
              width: MediaQuery.of(context).size.width * 0.9,
              child: _HistoryContent(),
            ),
          ),
        ),
      ),
    );
  }
}

class _HistoryContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '3 نتیجه مثبت',
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),
        HoverCard(
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 34, 145, 38),
                        shape: BoxShape.circle,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          FontAwesomeIcons.heartPulse,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Text(
                      'آیا دچار افت فشار خون و یا بلند رفتن فشار خون که موجب بعضی علایم یا مشکلات گردد، هستید؟',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Icon(
                          FontAwesomeIcons.plus,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                /* SizedBox(
                  width: 100,
                  child: PopupMenuButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.more_horiz,
                      color: Colors.blue,
                    ),
                    tooltip: 'نمایش مینو',
                    itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                      PopupMenuItem(
                        child: ListTile(
                          leading: const Icon(
                            Icons.list,
                            size: 20.0,
                          ),
                          title: Text(
                            'Edit',
                            style: const TextStyle(fontSize: 15.0),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                    onSelected: null,
                  ),
                ),
 */
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
                      Text('Diagnosis Date',
                          style: Theme.of(context).textTheme.labelLarge),
                      const SizedBox(width: 15.0),
                      const Expanded(
                        child: Text(
                          '2023-06-08',
                          textAlign: TextAlign.end,
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
                      Text('Severty',
                          style: Theme.of(context).textTheme.labelLarge),
                      const SizedBox(width: 15.0),
                      const Expanded(
                        child: Text(
                          'Medium',
                          textAlign: TextAlign.end,
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
                      Text('Duration',
                          style: Theme.of(context).textTheme.labelLarge),
                      const SizedBox(width: 15.0),
                      const Expanded(
                        child: Text(
                          '2 Months',
                          textAlign: TextAlign.end,
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
                          'Some text here to describe it',
                          textAlign: TextAlign.end,
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

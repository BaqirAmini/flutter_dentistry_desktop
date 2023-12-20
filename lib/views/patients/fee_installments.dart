import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() => runApp(const FeeRecord());

class FeeRecord extends StatelessWidget {
  const FeeRecord({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fee Management'),
        ),
        body: Center(
          child: Container(
            margin: const EdgeInsets.only(top: 15),
            width: MediaQuery.of(context).size.width * 0.9,
            child: const FeeContent(),
          ),
        ),
      ),
    );
  }
}

class FeeContent extends StatefulWidget {
  const FeeContent({super.key});

  @override
  State<FeeContent> createState() => _FeeContentState();
}

class _FeeContentState extends State<FeeContent> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Card(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    color: Colors.grey[200],
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 5.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Text(
                          'Crown',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 400.0),
                          child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                              elevation: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text('Installments: 1/6',
                                    style:
                                        Theme.of(context).textTheme.labelSmall),
                              )),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    top: 3.0,
                    right: 8.0,
                    child: Material(
                      shadowColor: Colors.transparent,
                      color: Colors.transparent,
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder:
                            CircleBorder(), // This makes the hover effect circular

                        onTap: () {},
                        child: PopupMenuButton<String>(
                          onSelected: (String result) {
                            print('You selected: $result');
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'Option 1',
                              child: Text('Option 1'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'Option 2',
                              child: Text('Option 2'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  NonExpandableCard(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.green[400],
                                shape: BoxShape.circle,
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.currency_exchange,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Dec 15, 2023',
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                Text(
                                  'تحت نظر: ',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12.0),
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 100.0,
                          height: 100.0,
                          child: SfCircularChart(
                            tooltipBehavior: TooltipBehavior(enable: true),
                            series: <PieSeries<FeeData, String>>[
                              PieSeries<FeeData, String>(
                                dataSource: <FeeData>[
                                  FeeData('Paid', 1000, Colors.green),
                                  FeeData('Due', 3700, Colors.red),
                                ],
                                xValueMapper: (FeeData data, _) =>
                                    data.category,
                                yValueMapper: (FeeData data, _) => data.amount,
                                dataLabelSettings: const DataLabelSettings(
                                  isVisible: true,
                                  textStyle: TextStyle(fontSize: 8.0),
                                ),
                              ),
                            ],
                          ),
                        )
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

// This widget shapes the expandable area of the card when clicked.
class NonExpandableCard extends StatelessWidget {
  final Widget title;

  const NonExpandableCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: title,
    );
  }
}

class FeeData {
  FeeData(this.category, this.amount, [MaterialColor? green]);
  final String category;
  final double amount;
}

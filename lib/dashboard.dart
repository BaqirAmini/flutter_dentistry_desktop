import 'package:flutter/material.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:flutter_dentistry/sidebar.dart';

void main() {
  return runApp(const Dashboard());
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  PageController page = PageController();
  List<_SalesData> data = [
    _SalesData('Jan', 10),
    _SalesData('Feb', 20),
    _SalesData('Mar', 20),
    _SalesData('Apr', 50),
    _SalesData('May', 40),
    _SalesData('Jun', 35)
  ];

  List<_PieData> pieData = [
    _PieData('Jan', 9000, 'خوراک'),
    _PieData('Feb', 15000, 'آب'),
    _PieData('Mar', 100000, 'مالیات'),
  ];

  SideMenuController sideMenu = SideMenuController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'کلینیک دندان درمان',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            // backgroundColor: Colors.white,
          ),
          drawer: const Sidebar(),
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 150),
              ),
              Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Card(
                          color: Colors.blue,
                          child: Expanded(
                            child: SizedBox(
                              height: 120,
                              width: 270.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.blue[400],
                                    child: const Icon(
                                        Icons.supervised_user_circle,
                                        color: Colors.white),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 0.0,
                                        top: 0.0,
                                        right: 15.0,
                                        bottom: 0.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text('بیماران امروز',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.white)),
                                        Text('20',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Card(
                          color: Colors.orange,
                          child: Expanded(
                            child: SizedBox(
                              height: 120,
                              width: 270.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.orange[400],
                                    child: const Icon(
                                        Icons.attach_money_rounded,
                                        color: Colors.white),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 0.0,
                                        top: 0.0,
                                        right: 15.0,
                                        bottom: 0.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text('مصارف ماه جاری',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.white)),
                                        Text('20',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Card(
                          color: Colors.green,
                          child: Expanded(
                            child: SizedBox(
                              height: 120,
                              width: 270.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.green[400],
                                    child: const Icon(
                                        Icons.money_off_csred_outlined,
                                        color: Colors.white),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 0.0,
                                        top: 0.0,
                                        right: 15.0,
                                        bottom: 0.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text('مالیات امسال',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.white)),
                                        Text('20',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Card(
                          color: Colors.brown,
                          child: Expanded(
                            child: SizedBox(
                              height: 120,
                              width: 270.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.brown[400],
                                    child: const Icon(
                                        Icons.people_outline,
                                        color: Colors.white),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 0.0,
                                        top: 0.0,
                                        right: 15.0,
                                        bottom: 0.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text('همه مریض ها',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.white)),
                                        Text('1050',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      children: [
                        Card(
                          child: Expanded(
                            child: SizedBox(
                              height: 350,
                              width: 800.0,
                              child: Column(
                                children: [
                                  SfCartesianChart(
                                      primaryXAxis: CategoryAxis(),
                                      // Chart title
                                      title: ChartTitle(
                                          text:
                                              'مراجعه بیماران در شش ماه گذشته'),
                                      // Enable legend
                                      legend: Legend(isVisible: true),
                                      // Enable tooltip
                                      tooltipBehavior:
                                          TooltipBehavior(enable: true),
                                      series: <ChartSeries<_SalesData, String>>[
                                        LineSeries<_SalesData, String>(
                                            dataSource: data,
                                            xValueMapper:
                                                (_SalesData sales, _) =>
                                                    sales.year,
                                            yValueMapper:
                                                (_SalesData sales, _) =>
                                                    sales.sales,
                                            name: 'بیماران',
                                            // Enable data label
                                            dataLabelSettings:
                                                const DataLabelSettings(
                                                    isVisible: true))
                                      ]),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Card(
                          child: Expanded(
                            child: SizedBox(
                              height: 350.0,
                              width: 300.0,
                              child: Column(
                                children: [
                                  SfCircularChart(
                                      title:
                                          ChartTitle(text: 'مصارف سه ماه اخیر'),
                                      // Enable legend
                                      legend: Legend(isVisible: true),
                                      // Enable tooltip
                                      tooltipBehavior:
                                          TooltipBehavior(enable: true),
                                      series: <PieSeries<_PieData, String>>[
                                        PieSeries<_PieData, String>(
                                            explode: true,
                                            explodeIndex: 0,
                                            dataSource: pieData,
                                            xValueMapper: (_PieData data, _) =>
                                                data.xData,
                                            yValueMapper: (_PieData data, _) =>
                                                data.yData,
                                            dataLabelMapper:
                                                (_PieData data, _) => data.text,
                                            dataLabelSettings:
                                                DataLabelSettings(
                                                    isVisible: true)),
                                      ])
                                  /*Expanded(
                                 child: Padding(
                                   padding: const EdgeInsets.all(8.0),
                                   //Initialize the spark charts widget
                                   child: SfSparkLineChart.custom(
                                     //Enable the trackball
                                     trackball: SparkChartTrackball(
                                         activationMode: SparkChartActivationMode.tap),
                                     //Enable marker
                                     marker: SparkChartMarker(
                                         displayMode: SparkChartMarkerDisplayMode.all),
                                     //Enable data label
                                     labelDisplayMode: SparkChartLabelDisplayMode.all,
                                     xValueMapper: (int index) => data[index].year,
                                     yValueMapper: (int index) => data[index].sales,
                                     dataCount: 5,
                                   ),
                                 ),
                               )*/
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}

class _PieData {
  _PieData(this.xData, this.yData, [this.text]);

  final String xData;
  final num yData;
  final String? text;
}

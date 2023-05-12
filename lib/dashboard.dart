import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

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
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.white,
          ),
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 150),
              ),
              const Divider(
                indent: 8.0,
                endIndent: 8.0,
              ),

              // Any menu items listed from here...
              SideMenu(
                  title: Image.asset(
                    'assets/graphics/login_img2.png',
                    width: 150.0,
                    height: 150.0,
                  ),
                  // showToggle: true,
                  style: SideMenuStyle(
                    backgroundColor: Colors.white,
                    hoverColor: Colors.grey[200],
                  ),
                  items: [
                    SideMenuItem(
                      priority: 0,
                      title: 'داشبورد',
                      onTap: (page, _) {
                        sideMenu.changePage(page);
                      },
                      icon: const Icon(Icons.dashboard),
                      /* badgeContent: const Text(
                    '3',
                    style: TextStyle(color: Colors.white),
                  ),*/
                      tooltipContent: 'رفتن به داشبورد',
                    ),
                    SideMenuItem(
                      priority: 1,
                      title: 'بیماران',
                      onTap: (page, _) {
                        sideMenu.changePage(page);
                      },
                      icon: const Icon(Icons.supervised_user_circle),
                      tooltipContent: 'رفتن به داشبورد',
                    ),
                    SideMenuItem(
                      priority: 2,
                      title: 'داکتران',
                      onTap: (page, _) {
                        sideMenu.changePage(page);
                      },
                      icon: const Icon(Icons.people_alt),
                      tooltipContent: 'رفتن به داشبورد',
                    ),
                    SideMenuItem(
                      priority: 3,
                      title: 'خدمات',
                      onTap: (page, _) {
                        sideMenu.changePage(page);
                      },
                      icon: const Icon(Icons.medical_services_outlined),
                      tooltipContent: 'رفتن به داشبورد',
                    ),
                    SideMenuItem(
                      priority: 4,
                      title: 'مراجعه و ملاقات',
                      onTap: (page, _) {
                        sideMenu.changePage(page);
                      },
                      icon: const Icon(Icons.more_time),
                      tooltipContent: 'رفتن به داشبورد',
                    ),
                    SideMenuItem(
                      priority: 5,
                      title: 'پرداخت فیس',
                      onTap: (page, _) {
                        sideMenu.changePage(page);
                      },
                      icon: const Icon(Icons.currency_exchange),
                      tooltipContent: 'رفتن به داشبورد',
                    ),
                    SideMenuItem(
                      priority: 6,
                      title: 'مصارف',
                      onTap: (page, _) {
                        sideMenu.changePage(page);
                      },
                      icon: const Icon(Icons.payments_outlined),
                      tooltipContent: 'رفتن به داشبورد',
                    ),
                    SideMenuItem(
                      priority: 7,
                      title: 'مالیات',
                      onTap: (page, _) {
                        sideMenu.changePage(page);
                      },
                      icon: const Icon(Icons.money_off_csred_rounded),
                      tooltipContent: 'رفتن به داشبورد',
                    ),
                    SideMenuItem(
                      priority: 8,
                      title: 'تنظیمات',
                      onTap: (page, _) {
                        sideMenu.changePage(page);
                      },
                      icon: const Icon(Icons.settings),
                      tooltipContent: 'رفتن به داشبورد',
                    ),
                    SideMenuItem(
                      priority: 9,
                      title: 'خروج',
                      onTap: (page, _) {
                        sideMenu.changePage(page);
                      },
                      icon: const Icon(Icons.exit_to_app),
                    ),
                  ],
                  controller: sideMenu),
              Column(
                children: [
                 Container(
                   margin: const EdgeInsets.only(top: 50.0),
                   child:  Row(
                     children: [
                       Card(
                         margin: const EdgeInsets.only(
                             left: 20.0, right: 10),
                         color: Colors.blue,
                         child: SizedBox(
                           height: 120,
                           width: 250,
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               CircleAvatar(
                                 backgroundColor: Colors.grey[10],
                                 child: const Icon(Icons.people_alt_outlined,
                                     color: Colors.white),
                               ),
                               Container(
                                 margin: const EdgeInsets.only(
                                     left: 0.0,
                                     top: 0.0,
                                     right: 15.0,
                                     bottom: 0.0),
                                 child: Column(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   children: const [
                                     Text('مراجعین',
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
                       Card(
                         color: Colors.orange,
                         margin: const EdgeInsets.only(
                             left: 20.0, right: 10),
                         child: SizedBox(
                           height: 120,
                           width: 250,
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               CircleAvatar(
                                 backgroundColor: Colors.orange[10],
                                 child: const Icon(Icons.people_alt_outlined,
                                     color: Colors.white),
                               ),
                               Container(
                                 margin: const EdgeInsets.only(
                                     left: 0.0,
                                     top: 0.0,
                                     right: 15.0,
                                     bottom: 0.0),
                                 child: Column(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   children: const [
                                     Text('مراجعین',
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
                       Card(
                         color: Colors.green,
                         child: SizedBox(
                           height: 120,
                           width: 250,
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               const CircleAvatar(
                                 backgroundColor: Colors.lightGreenAccent,
                                 child: Icon(Icons.people_alt_outlined,
                                     color: Colors.white),
                               ),
                               Container(
                                 margin: const EdgeInsets.only(
                                     left: 0.0,
                                     top: 0.0,
                                     right: 15.0,
                                     bottom: 0.0),
                                 child: Column(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   children: const [
                                     Text('مراجعین',
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
                     ],
                   ),
                 ),
                 Container(
                   margin: const EdgeInsets.only(top: 10.0),
                   child:  Row(
                     children: const [
                       Card(
                         margin: EdgeInsets.only(
                             left: 20.0),
                         child: SizedBox(
                           height: 350,
                           width: 550,
                           /*child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.grey[10],
                              child: const Icon(Icons.people_alt_outlined,
                                  color: Colors.white),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 0.0,
                                  top: 0.0,
                                  right: 15.0,
                                  bottom: 0.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text('مراجعین',
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
                        ),*/
                         ),
                       ),
                       Card(
                         child: SizedBox(
                           height: 350,
                           width: 220,
                           /*child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.grey[10],
                              child: const Icon(Icons.people_alt_outlined,
                                  color: Colors.white),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 0.0,
                                  top: 0.0,
                                  right: 15.0,
                                  bottom: 0.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text('مراجعین',
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
                        ),*/
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

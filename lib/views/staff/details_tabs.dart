import 'package:flutter/material.dart';

void main() => runApp(
      const StaffDetailTabs(),
    );

class StaffDetailTabs extends StatelessWidget {
  const StaffDetailTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.white),
      home: Scaffold(
        body: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              bottom:  const TabBar(
                tabs: [
                  Tab(text: 'ایجاد یوزر جدید', icon: Icon(Icons.person_add_alt_outlined),),
                  Tab(text: 'اسناد', icon: Icon(Icons.note_alt_outlined),),
                  Tab(text: 'معلومات شخصی', icon: Icon(Icons.person_pin_outlined),),
                ],
              ),
            ),
            body: const TabBarView(
              children: [
                Icon(Icons.directions_car),
                Icon(Icons.directions_transit),
                Text('معلومات شخصی')
              ],
            ),
          ),
        ),
      ),
    );
  }
}

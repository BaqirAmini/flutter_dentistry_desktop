import 'package:flutter/material.dart';
import 'package:flutter_dentistry/views/staff/new_user.dart';
import 'package:flutter_dentistry/views/staff/staff_more_detail.dart';

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
               Directionality(textDirection: TextDirection.rtl, child:  NewUser()),
                Icon(Icons.directions_transit),
                StaffMoreDetail()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

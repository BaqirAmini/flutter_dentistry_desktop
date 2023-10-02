import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_dentistry/views/finance/expenses/expenses.dart';
import 'package:flutter_dentistry/views/patients/xrays.dart';
import 'package:flutter_dentistry/views/services/services.dart';
import 'package:flutter_dentistry/views/settings/settings.dart';
import 'package:flutter_dentistry/views/staff/staff.dart';
import 'package:flutter_dentistry/views/finance/taxes/taxes.dart';
import 'package:flutter_dentistry/views/staff/staff_info.dart';
import 'login.dart';
import 'package:flutter_dentistry/views/patients/patients.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Sidebar extends StatefulWidget {
  Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  // Sign out from system
  void onLogOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content: const Directionality(
          textDirection: TextDirection.rtl,
          child: Text('آیا میخواهید از سیستم خارج شوید؟'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            child: const Text('لغو'),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Login(),
                ),
              );

              Navigator.of(context, rootNavigator: true).pop();
            },
            child: const Text('خروج'),
          ),
        ],
      ),
    );
  }

// Convert image of BLOB type to binary first.
  Uint8List? uint8list = StaffInfo.userPhoto != null
      ? Uint8List.fromList(StaffInfo.userPhoto!.toBytes())
      : null;

// Use this function to update user profile photo
  onUpdatePhoto() {
    _image = (uint8list != null)
        ? MemoryImage(uint8list!)
        : const AssetImage('assets/graphics/user_profile2.jpg')
            as ImageProvider;
    return _image;
  }

  late ImageProvider _image;
  @override
  void initState() {
    super.initState();
    // Clear image caching since Flutter by default does.
    imageCache.clear();
    imageCache.clearLiveImages();
    onUpdatePhoto();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Clear image caching since Flutter by default does.
    imageCache.clear();
    imageCache.clearLiveImages();
    setState(() {
      onUpdatePhoto();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('${StaffInfo.firstName} ${StaffInfo.lastName}'),
            accountEmail: Text('${StaffInfo.position}'),
            currentAccountPicture: InkWell(
              child: CircleAvatar(
                backgroundImage: _image,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Settings(),
                  ),
                ).then((_) {
                  onUpdatePhoto();
                });
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('داشبورد'),
            onTap: () {
              Navigator.pop(context);
              print('This menu clicked.');
            },
          ),
          ListTile(
            leading: const Icon(Icons.people_outline),
            title: const Text('مریض ها'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Patient()));
            },
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.xRay),
            title: const Text('اکسری (X-Ray)'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const XRayUploadScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('کارمندان'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Staff()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.medical_services),
            title: const Text('خدمات'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Service(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.payments_outlined),
            title: const Text('مصارف'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ExpenseList(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.money_off_csred_outlined),
            title: const Text('مالیات'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TaxList(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('تنظیمات'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Settings(),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('خروج'),
              onTap: () => onLogOut(context)),
        ],
      ),
    );
  }
}

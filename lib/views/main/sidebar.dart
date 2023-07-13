import 'package:flutter/material.dart';
import 'package:flutter_dentistry/views/finance/expenses/expenses.dart';
import 'package:flutter_dentistry/views/services/services.dart';
import 'package:flutter_dentistry/views/settings/settings.dart';
import 'package:flutter_dentistry/views/staff/staff.dart';
import 'package:flutter_dentistry/views/finance/taxes/taxes.dart';
import 'login.dart';
import 'package:flutter_dentistry/views/patients/patients.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text('احمد احمدی'),
            accountEmail: Text('ahmad.ahmadi@gmail.com'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/graphics/patient.png'),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('داشبورد'),
            onTap: () {
              print('This menu clicked.');
            },
          ),
          ListTile(
            leading: const Icon(Icons.people_outline),
            title: const Text('مریض ها'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Patient()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('کارمندان'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Staff()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.medical_services),
            title: const Text('خدمات'),
            onTap: () {
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Settings(),
                ),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('خروج'),
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  content: const Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text('آیا میخواهید از سیستم خارج شوید؟'),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () =>
                            Navigator.of(context, rootNavigator: true).pop(),
                        child: const Text('لغو')),
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
                        child: const Text('خروج')),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

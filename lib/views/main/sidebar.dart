import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_dentistry/views/finance/expenses/expenses.dart';
import 'package:flutter_dentistry/views/patients/xrays.dart';
import 'package:flutter_dentistry/views/reports/financial_report.dart';
import 'package:flutter_dentistry/views/reports/production_report.dart';
import 'package:flutter_dentistry/views/services/services.dart';
import 'package:flutter_dentistry/views/settings/settings.dart';
import 'package:flutter_dentistry/views/sf_calendar/appointment_sfcalendar.dart';
import 'package:flutter_dentistry/views/staff/staff.dart';
import 'package:flutter_dentistry/views/finance/taxes/taxes.dart';
import 'package:flutter_dentistry/views/staff/staff_info.dart';
import 'package:provider/provider.dart';
import 'login.dart';
import 'package:flutter_dentistry/views/patients/patients.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_dentistry/config/translations.dart';
import 'package:flutter_dentistry/config/language_provider.dart';

class Sidebar extends StatefulWidget {
  Sidebar({Key? key}) : super(key: key);

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  // ignore: prefer_typing_uninitialized_variables
  var selectedLanguage;
  // ignore: prefer_typing_uninitialized_variables
  var isEnglish;
  // Sign out from system
  void onLogOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Directionality(
          textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
          child: Text(
              translations[selectedLanguage]?['ConfirmMsg'] ?? ''.toString()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            child: Text(
                translations[selectedLanguage]?['CancelBtn'] ?? ''.toString()),
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
            child: Text(
                translations[selectedLanguage]?['ConfirmBtn'] ?? ''.toString()),
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
    // Fetch translations keys based on the selected language.
    var languageProvider = Provider.of<LanguageProvider>(context);
    selectedLanguage = languageProvider.selectedLanguage;
    isEnglish = selectedLanguage == 'English';

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
            title: Text(
              (translations[selectedLanguage]?['Dashboard'] ?? '').toString(),
            ),
            onTap: () {
              Navigator.pop(context);
              print('This menu clicked.');
            },
          ),
          ListTile(
            leading: const Icon(Icons.people_outline),
            title: Text(
              (translations[selectedLanguage]?['Patients'] ?? '').toString(),
            ),
            onTap: () =>  Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Patient())),
          ),
          /* ListTile(
            leading: const Icon(FontAwesomeIcons.xRay),
            title: const Text('X-Ray'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => XRayUploadScreen()));
            },
          ), */
          ListTile(
            leading: const Icon(Icons.people),
            title: Text(
              (translations[selectedLanguage]?['Staff'] ?? '').toString(),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Staff()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.medical_services),
            title: Text(
              (translations[selectedLanguage]?['Services'] ?? '').toString(),
            ),
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
            leading: const Icon(Icons.more_time_rounded),
            title: Text((translations[selectedLanguage]?['UpcomingAppt'] ?? '')
                .toString()),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CalendarApp(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.payments_outlined),
            title: Text(
              (translations[selectedLanguage]?['Expenses'] ?? '').toString(),
            ),
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
            title: Text(
              (translations[selectedLanguage]?['Taxes'] ?? '').toString(),
            ),
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
          ExpansionTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text('Reports'),
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.pie_chart_outline),
                title: const Text('Production Report'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProductionReport(),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.line_axis),
                title: const Text('Write-offs Report'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FinancialSummaryReport(),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.area_chart),
                title: const Text('Collections Report'),
                onTap: () {
                  // Navigate to the Collections Report screen
                },
              ),
              ListTile(
                leading: const Icon(Icons.show_chart),
                title: const Text('Accounts Receivable Report'),
                onTap: () {
                  // Navigate to the Accounts Receivable Report screen
                },
              ),
              ListTile(
                leading: const Icon(Icons.insert_chart_outlined_sharp),
                title: const Text('Daily Deposit Report'),
                onTap: () {
                  // Navigate to the Daily Deposit Report screen
                },
              ),
            ],
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(
              (translations[selectedLanguage]?['Settings'] ?? '').toString(),
            ),
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
              title: Text(
                (translations[selectedLanguage]?['Logout'] ?? '').toString(),
              ),
              onTap: () => onLogOut(context)),
        ],
      ),
    );
  }
}

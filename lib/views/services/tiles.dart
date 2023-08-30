import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dentistry/models/db_conn.dart';

class ServicesTile extends StatefulWidget {
  const ServicesTile({super.key});

  @override
  State<ServicesTile> createState() => _ServicesTileState();
}

class _ServicesTileState extends State<ServicesTile> {
  // Fetch services from services table
  Future<List<Service>> getServices() async {
    final conn = await onConnToDb();
    final results =
        await conn.query('SELECT ser_ID, ser_name, ser_fee FROM services');
    final services = results
        .map((row) => Service(
              serviceID: row[0],
              serviceName: row[1],
              serviceFee: row[2] ?? 0,
            ))
        .toList();

    return services;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      primary: false,
      slivers: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: FutureBuilder(
            future: getServices(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final services = snapshot.data;
                return Row(
                  children: <Widget>[
                    for (var service in services!)
                      SizedBox(
                        height: 80.0,
                        width: 80.0,
                        child: Card(
                          child: Stack(
                            children: [
                              Center(
                                child: onSetTileContent(Icons.light_mode,
                                    service.serviceName, 1000),
                              ),
                              Positioned(
                                top: 8.0,
                                left: 8.0,
                                child: PopupMenuButton(
                                    itemBuilder: (BuildContext context) =>
                                        <PopupMenuEntry>[
                                          const PopupMenuItem(
                                            child: Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: ListTile(
                                                leading: Icon(Icons.list),
                                                title: Text('جزییات'),
                                              ),
                                            ),
                                          ),
                                          PopupMenuItem(
                                            child: Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: Builder(builder:
                                                  (BuildContext context) {
                                                return ListTile(
                                                  leading:
                                                      const Icon(Icons.edit),
                                                  title:
                                                      const Text('تغییر دادن'),
                                                  onTap: () {
                                                    onEditDentalService(
                                                        context);
                                                  },
                                                );
                                              }),
                                            ),
                                          ),
                                          PopupMenuItem(
                                            child: Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: ListTile(
                                                leading:
                                                    const Icon(Icons.delete),
                                                title: const Text('حذف کردن'),
                                                onTap: () =>
                                                    onDeleteDentalService(
                                                        context),
                                              ),
                                            ),
                                          ),
                                        ]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    /* SizedBox(
                    height: 80.0,
                    width: 80.0,
                    child: Card(
                      child: Stack(
                        children: [
                          Center(
                            child: onSetTileContent(
                                Icons.light_mode, 'معاینه دهن', 1000),
                          ),
                          Positioned(
                            top: 8.0,
                            left: 8.0,
                            child: PopupMenuButton(
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry>[
                                      const PopupMenuItem(
                                        child: Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: ListTile(
                                            leading: Icon(Icons.list),
                                            title: Text('جزییات'),
                                          ),
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        child: Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: ListTile(
                                            leading: Icon(Icons.edit),
                                            title: Text('تغییر دادن'),
                                          ),
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        child: Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: ListTile(
                                            leading: Icon(Icons.delete),
                                            title: Text('حذف کردن'),
                                          ),
                                        ),
                                      ),
                                    ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 80.0,
                    width: 80.0,
                    child: Card(
                      child: Stack(
                        children: [
                          Center(
                            child: onSetTileContent(
                                Icons.light_mode, 'معاینه دهن', 1000),
                          ),
                          Positioned(
                            top: 8.0,
                            left: 8.0,
                            child: PopupMenuButton(
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry>[
                                      const PopupMenuItem(
                                        child: Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: ListTile(
                                            leading: Icon(Icons.list),
                                            title: Text('جزییات'),
                                          ),
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        child: Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: ListTile(
                                            leading: Icon(Icons.edit),
                                            title: Text('تغییر دادن'),
                                          ),
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        child: Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: ListTile(
                                            leading: Icon(Icons.delete),
                                            title: Text('حذف کردن'),
                                          ),
                                        ),
                                      ),
                                    ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 80.0,
                    width: 80.0,
                    child: Card(
                      child: Stack(
                        children: [
                          Center(
                            child: onSetTileContent(
                                Icons.light_mode, 'معاینه دهن', 1000),
                          ),
                          Positioned(
                            top: 8.0,
                            left: 8.0,
                            child: PopupMenuButton(
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry>[
                                      const PopupMenuItem(
                                        child: Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: ListTile(
                                            leading: Icon(Icons.list),
                                            title: Text('جزییات'),
                                          ),
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        child: Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: ListTile(
                                            leading: Icon(Icons.edit),
                                            title: Text('تغییر دادن'),
                                          ),
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        child: Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: ListTile(
                                            leading: Icon(Icons.delete),
                                            title: Text('حذف کردن'),
                                          ),
                                        ),
                                      ),
                                    ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 80.0,
                    width: 80.0,
                    child: Card(
                      child: Stack(
                        children: [
                          Center(
                            child: onSetTileContent(
                                Icons.light_mode, 'معاینه دهن', 1000),
                          ),
                          Positioned(
                            top: 8.0,
                            left: 8.0,
                            child: PopupMenuButton(
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry>[
                                      const PopupMenuItem(
                                        child: Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: ListTile(
                                            leading: Icon(Icons.list),
                                            title: Text('جزییات'),
                                          ),
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        child: Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: ListTile(
                                            leading: Icon(Icons.edit),
                                            title: Text('تغییر دادن'),
                                          ),
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        child: Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: ListTile(
                                            leading: Icon(Icons.delete),
                                            title: Text('حذف کردن'),
                                          ),
                                        ),
                                      ),
                                    ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 80.0,
                    width: 80.0,
                    child: Card(
                      child: Stack(
                        children: [
                          Center(
                            child: onSetTileContent(
                                Icons.light_mode, 'معاینه دهن', 1000),
                          ),
                          Positioned(
                            top: 8.0,
                            left: 8.0,
                            child: PopupMenuButton(
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry>[
                                      const PopupMenuItem(
                                        child: Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: ListTile(
                                            leading: Icon(Icons.list),
                                            title: Text('جزییات'),
                                          ),
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        child: Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: ListTile(
                                            leading: Icon(Icons.edit),
                                            title: Text('تغییر دادن'),
                                          ),
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        child: Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: ListTile(
                                            leading: Icon(Icons.delete),
                                            title: Text('حذف کردن'),
                                          ),
                                        ),
                                      ),
                                    ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 80.0,
                    width: 80.0,
                    child: Card(
                      child: Stack(
                        children: [
                          Center(
                            child: onSetTileContent(
                                Icons.light_mode, 'معاینه دهن', 1000),
                          ),
                          Positioned(
                            top: 8.0,
                            left: 8.0,
                            child: PopupMenuButton(
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry>[
                                      const PopupMenuItem(
                                        child: Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: ListTile(
                                            leading: Icon(Icons.list),
                                            title: Text('جزییات'),
                                          ),
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        child: Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: ListTile(
                                            leading: Icon(Icons.edit),
                                            title: Text('تغییر دادن'),
                                          ),
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        child: Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: ListTile(
                                            leading: Icon(Icons.delete),
                                            title: Text('حذف کردن'),
                                          ),
                                        ),
                                      ),
                                    ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 80.0,
                    width: 80.0,
                    child: Card(
                      child: Stack(
                        children: [
                          Center(
                            child: onSetTileContent(
                                Icons.light_mode, 'معاینه دهن', 1000),
                          ),
                          Positioned(
                            top: 8.0,
                            left: 8.0,
                            child: PopupMenuButton(
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry>[
                                      const PopupMenuItem(
                                        child: Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: ListTile(
                                            leading: Icon(Icons.list),
                                            title: Text('جزییات'),
                                          ),
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        child: Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: ListTile(
                                            leading: Icon(Icons.edit),
                                            title: Text('تغییر دادن'),
                                          ),
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        child: Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: ListTile(
                                            leading: Icon(Icons.delete),
                                            title: Text('حذف کردن'),
                                          ),
                                        ),
                                      ),
                                    ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 80.0,
                    width: 80.0,
                    child: Card(
                      child: Stack(
                        children: [
                          Center(
                            child: onSetTileContent(
                                Icons.light_mode, 'معاینه دهن', 1000),
                          ),
                          Positioned(
                            top: 8.0,
                            left: 8.0,
                            child: PopupMenuButton(
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry>[
                                      const PopupMenuItem(
                                        child: Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: ListTile(
                                            leading: Icon(Icons.list),
                                            title: Text('جزییات'),
                                          ),
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        child: Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: ListTile(
                                            leading: Icon(Icons.edit),
                                            title: Text('تغییر دادن'),
                                          ),
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        child: Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: ListTile(
                                            leading: Icon(Icons.delete),
                                            title: Text('حذف کردن'),
                                          ),
                                        ),
                                      ),
                                    ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 80.0,
                    width: 80.0,
                    child: Card(
                      child: Stack(
                        children: [
                          Center(
                            child: onSetTileContent(
                                Icons.light_mode, 'معاینه دهن', 1000),
                          ),
                          Positioned(
                            top: 8.0,
                            left: 8.0,
                            child: PopupMenuButton(
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry>[
                                      const PopupMenuItem(
                                        child: Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: ListTile(
                                            leading: Icon(Icons.list),
                                            title: Text('جزییات'),
                                          ),
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        child: Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: ListTile(
                                            leading: Icon(Icons.edit),
                                            title: Text('تغییر دادن'),
                                          ),
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        child: Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: ListTile(
                                            leading: Icon(Icons.delete),
                                            title: Text('حذف کردن'),
                                          ),
                                        ),
                                      ),
                                    ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                 */
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
      ],
    );
  }

// Set icon and text as contents of any tile.
  onSetTileContent(IconData myIcon, String myText, int price) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircleAvatar(
          radius: 25.0,
          backgroundColor: Colors.blue,
          child: Icon(Icons.light_mode, color: Colors.white),
        ),
        // SizedBox(height: 10.0,),
        Text(
          myText,
          style: const TextStyle(fontSize: 22.0),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          '$price افغانی',
          style: const TextStyle(
              fontSize: 14.0, color: Color.fromARGB(255, 105, 101, 101)),
        ),
      ],
    );
  }

  // This dialog edits a Service
  onEditDentalService(BuildContext context) {
// The global for the form
    final formKey = GlobalKey<FormState>();
// The text editing controllers for the TextFormFields
    final nameController = TextEditingController();
    final feeController = TextEditingController();

    return showDialog(
      context: context,
      builder: ((context) {
        return AlertDialog(
          title: const Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              'تغییر سرویس',
              style: TextStyle(color: Colors.blue),
            ),
          ),
          content: Directionality(
            textDirection: TextDirection.rtl,
            child: Form(
              key: formKey,
              child: SizedBox(
                width: 500.0,
                height: 190.0,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(20.0),
                      child: TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'نام سرویس (خدمات)',
                          suffixIcon: Icon(Icons.medical_services_sharp),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0)),
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0)),
                              borderSide: BorderSide(color: Colors.blue)),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(20.0),
                      child: TextFormField(
                        controller: feeController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                        ],
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'فیس تعیین شده',
                          suffixIcon: Icon(Icons.money),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0)),
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0)),
                              borderSide: BorderSide(color: Colors.blue)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('لغو')),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text(' تغییر دادن'),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

// This dialog is to delete a dental service
  onDeleteDentalService(BuildContext context) {
    return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Directionality(
                textDirection: TextDirection.rtl,
                child: Text('حذف سرویس'),
              ),
              content: const Directionality(
                textDirection: TextDirection.rtl,
                child: Text('آیا میخواهید این سرویس را حذف کنید؟'),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('لغو')),
                TextButton(onPressed: () {}, child: const Text('حذف')),
              ],
            ));
  }
}

// Data Model of services
class Service {
  final int serviceID;
  final String serviceName;
  final double serviceFee;

  // Calling the constructor
  Service(
      {required this.serviceID,
      required this.serviceName,
      required this.serviceFee});
}

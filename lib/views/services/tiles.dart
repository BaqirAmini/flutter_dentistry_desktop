import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dentistry/models/db_conn.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Create the global key at the top level of your Dart file
final GlobalKey<ScaffoldMessengerState> _globalKeyForService =
    GlobalKey<ScaffoldMessengerState>();

// This is shows snackbar when called
void _onShowSnack(Color backColor, String msg) {
  _globalKeyForService.currentState?.showSnackBar(
    SnackBar(
      backgroundColor: backColor,
      content: SizedBox(
        height: 20.0,
        child: Center(
          child: Text(msg),
        ),
      ),
    ),
  );
}

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
    return ScaffoldMessenger(
      key: _globalKeyForService,
      child: Scaffold(
        body: CustomScrollView(
          primary: false,
          slivers: <Widget>[
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: FutureBuilder(
                future: getServices(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final services = snapshot.data;
                    return SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        crossAxisCount: 5,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          final service = services![index];
                          return SizedBox(
                            height: 80.0,
                            width: 80.0,
                            child: Card(
                              child: Stack(
                                children: [
                                  Center(
                                    child: onSetTileContent(service.serviceName,
                                        service.serviceFee),
                                  ),
                                  Positioned(
                                    top: 8.0,
                                    left: 8.0,
                                    child: PopupMenuButton(
                                        itemBuilder: (BuildContext context) =>
                                            <PopupMenuEntry>[
                                              const PopupMenuItem(
                                                child: Directionality(
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  child: ListTile(
                                                    leading: Icon(Icons.list),
                                                    title: Text('جزییات'),
                                                  ),
                                                ),
                                              ),
                                              PopupMenuItem(
                                                child: Directionality(
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  child: Builder(builder:
                                                      (BuildContext context) {
                                                    return ListTile(
                                                      leading: const Icon(
                                                          Icons.edit),
                                                      title: const Text(
                                                          'تغییر دادن'),
                                                      onTap: () {
                                                        onEditDentalService(
                                                            context,
                                                            service.serviceID,
                                                            service.serviceName,
                                                            service.serviceFee);
                                                        Navigator.pop(context);
                                                      },
                                                    );
                                                  }),
                                                ),
                                              ),
                                              /*   PopupMenuItem(
                                                child: Directionality(
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  child: ListTile(
                                                      leading: const Icon(
                                                          Icons.delete),
                                                      title: const Text(
                                                          'حذف کردن'),
                                                      onTap: () {
                                                        onDeleteDentalService(
                                                            context);
                                                        Navigator.pop(context);
                                                      }),
                                                ),
                                              ), */
                                            ]),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        childCount: services!.length,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return SliverToBoxAdapter(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    return const SliverToBoxAdapter(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

// Set icon and text as contents of any tile.
  onSetTileContent(String myText, double price) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircleAvatar(
          radius: 25.0,
          backgroundColor: Colors.blue,
          child: Icon(FontAwesomeIcons.tooth, color: Colors.white),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          textAlign: TextAlign.center,
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
  onEditDentalService(BuildContext context, int serviceId, String serviceName,
      double serviceFee) {
// The global for the form
    final formKey = GlobalKey<FormState>();
// The text editing controllers for the TextFormFields
    final nameController = TextEditingController();
    final feeController = TextEditingController();

    nameController.text = serviceName;
    feeController.text = serviceFee.toString();
    const regExOnlyAbc = "[a-zA-Z,().، \u0600-\u06FFF]";

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
                      margin: const EdgeInsets.all(15.0),
                      child: TextFormField(
                        controller: nameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'نام سرویس الزامی میباشد.';
                          } else if (value.length < 5 || value.length > 30) {
                            return 'نام سرویس باید 5 الی 30 حرف شد.';
                          }
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(regExOnlyAbc),
                          ),
                        ],
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
                          errorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0)),
                              borderSide: BorderSide(color: Colors.red)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0)),
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1.5)),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(15.0),
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
                          errorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0)),
                              borderSide: BorderSide(color: Colors.red)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0)),
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1.5)),
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
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        String serName = nameController.text;
                        double serFee = feeController.text.isNotEmpty
                            ? double.parse(feeController.text)
                            : 0;
                        final conn = await onConnToDb();
                        final results = await conn.query(
                            'UPDATE services SET ser_name = ?, ser_fee = ? WHERE ser_ID = ?',
                            [serName, serFee, serviceId]);
                        if (results.affectedRows! > 0) {
                          _onShowSnack(
                              Colors.green, 'سرویس موفقانه تغییر کرد.');
                          setState(() {});
                        } else {
                          _onShowSnack(Colors.red,
                              'شما هیچ تغییراتی به این سرویس نیاوردید.');
                        }
                        // ignore: use_build_context_synchronously
                        Navigator.of(context, rootNavigator: true).pop();
                        await conn.close();
                      }
                    },
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
  /* onDeleteDentalService(BuildContext context) {
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
                    onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                    child: const Text('لغو')),
                TextButton(onPressed: () {}, child: const Text('حذف')),
              ],
            ));
  }
 */
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

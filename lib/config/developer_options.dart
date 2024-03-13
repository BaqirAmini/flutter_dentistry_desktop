import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart' as intl;

void main() => runApp(const DeveloperOptions());

class DeveloperOptions extends StatefulWidget {
  const DeveloperOptions({Key? key}) : super(key: key);

  @override
  State<DeveloperOptions> createState() => _DeveloperOptionsState();
}

class _DeveloperOptionsState extends State<DeveloperOptions> {
  // Keys for shared preferences
  final _genPresc = 'genPresc';
  final _upcomingAppt = 'upcomingAppt';
  final _manageXray = 'manageXray';
  final _createBackup = 'createBackup';
  final _restoreBackup = 'restoreBackup';
  String _liscenseKey = '';

  // Instantiate 'Features' class
  Features features = Features();

  // form controllers
  final TextEditingController _machineCodeController = TextEditingController();
  final TextEditingController _liscenseController = TextEditingController();
  final _liscenseFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    loadSwitchState(_genPresc, (bool value) {
      setState(() {
        features.genPrescription = value;
      });
    });
    loadSwitchState(_upcomingAppt, (bool value) {
      setState(() {
        features.genPrescription = value;
      });
    });
    loadSwitchState(_manageXray, (bool value) {
      setState(() {
        features.genPrescription = value;
      });
    });
    loadSwitchState(_createBackup, (bool value) {
      setState(() {
        features.genPrescription = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('System Features Managment'),
        actions: [
          IconButton(
            onPressed: () {
              _machineCodeController.text = generateGuid();
            },
            icon: const Icon(Icons.code),
          ),
        ],
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Premium Features',
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall!
                        .copyWith(fontSize: 20),
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        ListTile(
                          title: const Text('Generate Prescription'),
                          trailing: FutureBuilder(
                            future: getSwitchState(_genPresc),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else {
                                if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  return Switch(
                                    activeColor: Colors.green,
                                    value: snapshot.data!,
                                    onChanged: (bool value) {
                                      setState(() {
                                        features.genPrescription = value;
                                        saveSwitchState(_genPresc, value);
                                      });
                                    },
                                  );
                                }
                              }
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text('Upcoming Appointments'),
                          trailing: FutureBuilder(
                            future: getSwitchState(_upcomingAppt),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else {
                                if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  return Switch(
                                    activeColor: Colors.green,
                                    value: snapshot.data!,
                                    onChanged: (bool value) {
                                      setState(() {
                                        features.upcomingAppointment = value;
                                        saveSwitchState(_upcomingAppt, value);
                                      });
                                    },
                                  );
                                }
                              }
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text('X-Ray Management'),
                          trailing: FutureBuilder(
                            future: getSwitchState(_manageXray),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else {
                                if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  return Switch(
                                    activeColor: Colors.green,
                                    value: snapshot.data!,
                                    onChanged: (bool value) {
                                      setState(() {
                                        features.XRayManage = value;
                                        saveSwitchState(_manageXray, value);
                                      });
                                    },
                                  );
                                }
                              }
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text('Create Backup'),
                          trailing: FutureBuilder(
                            future: getSwitchState(_createBackup),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else {
                                if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  return Switch(
                                    activeColor: Colors.green,
                                    value: snapshot.data!,
                                    onChanged: (bool value) {
                                      setState(() {
                                        features.createBackup = value;
                                        saveSwitchState(_createBackup, value);
                                      });
                                    },
                                  );
                                }
                              }
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text('Restore Backup'),
                          trailing: FutureBuilder(
                            future: getSwitchState(_restoreBackup),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else {
                                if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  return Switch(
                                    activeColor: Colors.green,
                                    value: snapshot.data!,
                                    onChanged: (bool value) {
                                      setState(() {
                                        features.restoreBackup = value;
                                        saveSwitchState(_restoreBackup, value);
                                      });
                                    },
                                  );
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Column(
              children: [
                Form(
                  key: _liscenseFormKey,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Liscense Generation',
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(fontSize: 20),
                        ),
                        Container(
                          margin: const EdgeInsets.all(10.0),
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Builder(builder: (context) {
                            return TextFormField(
                              textDirection: TextDirection.ltr,
                              controller: _machineCodeController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Machine code required';
                                }
                                return null;
                              },
                              /*  inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(_regExUName),
                                ),
                              ], */
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(15.0),
                                border: OutlineInputBorder(),
                                labelText: 'Machine Code',
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
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 1.5)),
                              ),
                            );
                          }),
                        ),
                        Container(
                          margin: const EdgeInsets.all(10.0),
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Builder(
                            builder: (context) {
                              return TextFormField(
                                readOnly: true,
                                textDirection: TextDirection.ltr,
                                controller: _liscenseController,
                                /*  inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(_regExUName)),
                                ], */
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.all(15.0),
                                  border: OutlineInputBorder(),
                                  labelText: 'Liscense required',
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50.0)),
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50.0)),
                                      borderSide:
                                          BorderSide(color: Colors.blue)),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50.0)),
                                      borderSide:
                                          BorderSide(color: Colors.red)),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50.0)),
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 1.5)),
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(10.0),
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: 35.0,
                          child: Builder(
                            builder: (context) {
                              return OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  side: const BorderSide(
                                    color: Colors.blue,
                                  ),
                                ),
                                onPressed: () {
                                  if (_liscenseFormKey.currentState!
                                      .validate()) {
                                    final expireAt = DateTime.now()
                                        .add(const Duration(days: 365));
                                    _liscenseKey = generateLicenseKey(expireAt);
                                    _liscenseController.text =
                                        'The liscense key generated: $_liscenseKey';
                                  }
                                },
                                child: const Text('Generate Liscense'),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void saveSwitchState(String key, bool value) async {
    // Create a shared preferences variable
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

// Fetch switches values when called
  void loadSwitchState(String key, Function(bool) onLoaded) async {
    final prefs = await SharedPreferences.getInstance();
    bool value = prefs.getBool(key) ?? false;
    onLoaded(value);
  }

  Future<bool> getSwitchState(String key) async {
    final prefs = await SharedPreferences.getInstance();
    bool value = prefs.getBool(key) ?? false;
    return value;
  }

// Generate a 128-bit integer (16 bytes)
  String generateGuid() {
    // Create a new random number generator
    var rng = Random();

    // Generate a random 128-bit number
    var randomBytes = List<int>.generate(16, (i) => rng.nextInt(256));

    // Convert the random bytes to a hex string
    var guid = sha1.convert(randomBytes).toString();

    return guid;
  }

// This function create a liscense based on the random code
  String generateLicenseKey(DateTime expiryDate) {
    var formatter = intl.DateFormat('yyyy-MM-dd');
    var formattedExpiryDate = formatter.format(expiryDate);
    var guid = generateGuid();
    var dataToHash = guid + formattedExpiryDate;
    var bytes = utf8.encode(dataToHash); // data being hashed
    var digest = sha256.convert(bytes);
    return digest.toString();
  }
}

// This class contain all features flags - PRO & STANDARD features
class Features {
  static final Features _singleton = Features._internal();

  factory Features() {
    return _singleton;
  }

  Features._internal();

  bool genPrescription = false;
  bool upcomingAppointment = false;
  bool XRayManage = false;
  bool createBackup = false;
  bool restoreBackup = false;

  Future<void> loadFeatures() async {
    final prefs = await SharedPreferences.getInstance();
    genPrescription = prefs.getBool('genPresc') ?? false;
    upcomingAppointment = prefs.getBool('upcomingAppt') ?? false;
    XRayManage = prefs.getBool('manageXray') ?? false;
    createBackup = prefs.getBool('createBackup') ?? false;
    restoreBackup = prefs.getBool('restoreBackup') ?? false;
  }
}

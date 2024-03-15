import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart' as intl;
import 'package:win32/win32.dart';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() => runApp(const DeveloperOptions());

// Create instance of Flutter Secure Store
final storage = FlutterSecureStorage();

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
              _machineCodeController.text = getMachineGuid();
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
                                onPressed: () async {
                                  if (_liscenseFormKey.currentState!
                                      .validate()) {
                                    final expireAt = DateTime.now()
                                        .add(const Duration(days: 365));
                                    _liscenseKey = generateLicenseKey(expireAt);
                                    _liscenseController.text =
                                        'The liscense key generated: $_liscenseKey';

                                    print(
                                        'In Secure Storage: ${await getLicenseKey()}');
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

// This function saves switch state into a shared preference.
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

// This function create a liscense based on the machine code
  String generateLicenseKey(DateTime expiryDate) {
    var formatter = intl.DateFormat('yyyy-MM-dd');
    var formattedExpiryDate = formatter.format(expiryDate);
    var guid = getMachineGuid();
    var dataToHash = guid + formattedExpiryDate;
    var bytes = utf8.encode(dataToHash); // data being hashed
    var digest = sha256.convert(bytes);
    storeLicenseKey(digest.toString());
    return digest.toString();
  }

  String getMachineGuid() {
    final hKey = calloc<HKEY>();
    final lpcbData = calloc<DWORD>()..value = 256;
    final lpData = calloc<Uint16>(lpcbData.value);

    final strKeyPath = TEXT('SOFTWARE\\Microsoft\\Cryptography');
    final strValueName = TEXT('MachineGuid');

    var result =
        RegOpenKeyEx(HKEY_LOCAL_MACHINE, strKeyPath, 0, KEY_READ, hKey);
    if (result == ERROR_SUCCESS) {
      result = RegQueryValueEx(
          hKey.value, strValueName, nullptr, nullptr, lpData.cast(), lpcbData);
      if (result == ERROR_SUCCESS) {
        String machineGuid = lpData
            .cast<Utf16>()
            .toDartString(); // Use cast<Utf16>().toDartString() here
        calloc.free(hKey);
        calloc.free(lpcbData);
        calloc.free(lpData);
        return machineGuid;
      }
    }

    calloc.free(hKey);
    calloc.free(lpcbData);
    calloc.free(lpData);

    throw Exception('Failed to get MachineGuid');
  }

  Future<void> storeLicenseKey(String key) async {
    await storage.write(key: 'licenseKey', value: key);
  }

  Future<String?> getLicenseKey() async {
    return await storage.read(key: 'licenseKey');
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

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const DeveloperOptions());

class DeveloperOptions extends StatefulWidget {
  const DeveloperOptions({Key? key}) : super(key: key);

  @override
  State<DeveloperOptions> createState() => _DeveloperOptionsState();
}

class _DeveloperOptionsState extends State<DeveloperOptions> {
  // Keys for shared preferences
  final genPresc = 'genPresc';
  final upcomingAppt = 'upcomingAppt';
  final manageXray = 'manageXray';
  final createBackup = 'createBackup';
  final restoreBackup = 'restoreBackup';

  // Instantiate 'Features' class
  Features features = Features();

  @override
  void initState() {
    super.initState();
    loadSwitchState(genPresc, (bool value) {
      setState(() {
        features.genPrescription = value;
      });
    });
    loadSwitchState(upcomingAppt, (bool value) {
      setState(() {
        features.genPrescription = value;
      });
    });
    loadSwitchState(manageXray, (bool value) {
      setState(() {
        features.genPrescription = value;
      });
    });
    loadSwitchState(createBackup, (bool value) {
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
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 400,
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
                            future: getSwitchState(genPresc),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else {
                                if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  return Switch(
                                    value: snapshot.data!,
                                    onChanged: (bool value) {
                                      setState(() {
                                        features.genPrescription = value;
                                        saveSwitchState(genPresc, value);
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
                            future: getSwitchState(upcomingAppt),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else {
                                if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  return Switch(
                                    value: snapshot.data!,
                                    onChanged: (bool value) {
                                      setState(() {
                                        features.upcomingAppointment = value;
                                        saveSwitchState(upcomingAppt, value);
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
                            future: getSwitchState(manageXray),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else {
                                if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  return Switch(
                                    value: snapshot.data!,
                                    onChanged: (bool value) {
                                      setState(() {
                                        features.XRayManage = value;
                                        saveSwitchState(manageXray, value);
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
                            future: getSwitchState(createBackup),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else {
                                if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  return Switch(
                                    value: snapshot.data!,
                                    onChanged: (bool value) {
                                      setState(() {
                                        features.createBackup = value;
                                        saveSwitchState(createBackup, value);
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
                            future: getSwitchState(restoreBackup),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else {
                                if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  return Switch(
                                    value: snapshot.data!,
                                    onChanged: (bool value) {
                                      setState(() {
                                        features.restoreBackup = value;
                                        saveSwitchState(restoreBackup, value);
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
          /* SizedBox(
            width: 400,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Standard Features',
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
                          trailing: Switch(
                            value: features.genPrescription,
                            onChanged: (bool value) {
                              setState(() {
                                features.genPrescription = value;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text('Upcoming Appointments'),
                          trailing: Switch(
                            value: features.upcomingAppointment,
                            onChanged: (bool value) {
                              setState(() {
                                features.upcomingAppointment = value;
                              });
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
 */
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

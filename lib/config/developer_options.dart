import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dentistry/config/global_usage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:win32/win32.dart';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() => runApp(const DeveloperOptions());

// Create instance of Flutter Secure Store
const storage = FlutterSecureStorage();

class DeveloperOptions extends StatefulWidget {
  const DeveloperOptions({Key? key}) : super(key: key);

  @override
  State<DeveloperOptions> createState() => _DeveloperOptionsState();
}

class _DeveloperOptionsState extends State<DeveloperOptions> {
  String _liscenseKey = '';

  // Instantiate 'Features' class
  Features features = Features();

  // form controllers
  final TextEditingController _machineCodeController = TextEditingController();
  final TextEditingController _liscenseController = TextEditingController();
  final _liscenseFormKey = GlobalKey<FormState>();
  int _validDurationGroupValue = 15;
  bool _isLiscenseCopied = false;

  // Create instance to access its methods
  final GlobalUsage _globalUsage = GlobalUsage();
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
                          width: MediaQuery.of(context).size.width * 0.5,
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
                              onChanged: (value) {
                                setState(() {
                                  _isLiscenseCopied = false;
                                });
                              },
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
                          width: MediaQuery.of(context).size.width * 0.5,
                          margin: const EdgeInsets.all(10.0),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10.0),
                              border: OutlineInputBorder(),
                              labelText: 'Valid Duration',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50.0),
                                ),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50.0),
                                ),
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Theme(
                                    data: Theme.of(context).copyWith(
                                      listTileTheme: const ListTileThemeData(
                                          horizontalTitleGap: 0.5),
                                    ),
                                    child: RadioListTile<int>(
                                        title: const Text(
                                          '15 Days',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        value: 15,
                                        groupValue: _validDurationGroupValue,
                                        onChanged: (int? value) {
                                          setState(() {
                                            _validDurationGroupValue = value!;
                                          });
                                        }),
                                  ),
                                ),
                                Expanded(
                                  child: Theme(
                                    data: Theme.of(context).copyWith(
                                      listTileTheme: const ListTileThemeData(
                                          horizontalTitleGap: 0.5),
                                    ),
                                    child: RadioListTile<int>(
                                        title: const Text(
                                          '1 Month',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        value: 30,
                                        groupValue: _validDurationGroupValue,
                                        onChanged: (int? value) {
                                          setState(() {
                                            _validDurationGroupValue = value!;
                                          });
                                        }),
                                  ),
                                ),
                                Expanded(
                                  child: Theme(
                                    data: Theme.of(context).copyWith(
                                      listTileTheme: const ListTileThemeData(
                                          horizontalTitleGap: 0.5),
                                    ),
                                    child: RadioListTile<int>(
                                        title: const Text(
                                          '6 Month',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        value: 180,
                                        groupValue: _validDurationGroupValue,
                                        onChanged: (int? value) {
                                          setState(() {
                                            _validDurationGroupValue = value!;
                                          });
                                        }),
                                  ),
                                ),
                                Expanded(
                                  child: Theme(
                                    data: Theme.of(context).copyWith(
                                      listTileTheme: const ListTileThemeData(
                                          horizontalTitleGap: 0.5),
                                    ),
                                    child: RadioListTile<int>(
                                        title: const Text(
                                          '1 Year',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        value: 365,
                                        groupValue: _validDurationGroupValue,
                                        onChanged: (int? value) {
                                          setState(() {
                                            _validDurationGroupValue = value!;
                                          });
                                        }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(10.0),
                          width: MediaQuery.of(context).size.width * 0.5,
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

                                decoration: InputDecoration(
                                  suffixIcon: !_isLiscenseCopied
                                      ? IconButton(
                                          tooltip: 'Copy',
                                          splashRadius: 18.0,
                                          onPressed: _liscenseController
                                                  .text.isEmpty
                                              ? null
                                              : () async {
                                                  Clipboard.setData(
                                                    ClipboardData(
                                                        text:
                                                            _liscenseController
                                                                .text),
                                                  );

                                                  setState(() {
                                                    _isLiscenseCopied = true;
                                                  });
                                                },
                                          icon: const Icon(Icons.copy,
                                              size: 15.0),
                                        )
                                      : const Icon(Icons.done_rounded),
                                  contentPadding: const EdgeInsets.all(15.0),
                                  border: const OutlineInputBorder(),
                                  labelText: 'Product Key',
                                  enabledBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50.0)),
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                  focusedBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50.0)),
                                      borderSide:
                                          BorderSide(color: Colors.blue)),
                                  errorBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50.0)),
                                      borderSide:
                                          BorderSide(color: Colors.red)),
                                  focusedErrorBorder: const OutlineInputBorder(
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
                                    final expireAt = DateTime.now().add(
                                        Duration(
                                            days: _validDurationGroupValue));
                                    // Generate liscense key and assign it to a variable
                                    _liscenseKey =
                                        _globalUsage.generateLicenseKey(
                                            expireAt,
                                            _machineCodeController.text);
                                    // Assign the generated liscense to its field
                                    _liscenseController.text = _liscenseKey;
                                    setState(() {
                                      _isLiscenseCopied = false;
                                    });
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
}

// This class contain all features flags - PRO & STANDARD features
class Features {
  static bool genPrescription = false;
  static bool upcomingAppointment = false;
  static bool XRayManage = false;
  static bool createBackup = false;
  static bool restoreBackup = false;

// This function enables / disables the premium features based on the version type.
  static void setVersion(String version) {
    if (version == 'Premium') {
      genPrescription = true;
      upcomingAppointment = true;
      XRayManage = true;
      createBackup = true;
      restoreBackup = true;
    } else if (version == 'Standard') {
      genPrescription = false;
      upcomingAppointment = false;
      XRayManage = false;
      createBackup = false;
      restoreBackup = false;
    }
  }
}

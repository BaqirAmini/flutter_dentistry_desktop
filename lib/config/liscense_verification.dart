import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dentistry/config/global_usage.dart';
import 'package:flutter_dentistry/views/main/login.dart';
import 'package:win32/win32.dart';

void main() => runApp(const LiscenseVerification());

// Create the global key at the top level of your Dart file
final GlobalKey<ScaffoldMessengerState> _globalKeyLiscenseVerify =
    GlobalKey<ScaffoldMessengerState>();
// This is shows snackbar when called
void _onShowSnack(Color backColor, String msg) {
  _globalKeyLiscenseVerify.currentState?.showSnackBar(
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

class LiscenseVerification extends StatefulWidget {
  const LiscenseVerification({Key? key}) : super(key: key);

  @override
  State<LiscenseVerification> createState() => _LiscenseVerificationState();
}

class _LiscenseVerificationState extends State<LiscenseVerification> {
  // form controllers
  final TextEditingController _machineCodeController = TextEditingController();
  final TextEditingController _liscenseController = TextEditingController();
  final _liscenseVerifyFK = GlobalKey<FormState>();
  bool _isCoppied = false;

  // Create an instance of this class
  final GlobalUsage _globalUsage = GlobalUsage();

  @override
  void initState() {
    super.initState();
    _machineCodeController.text = getMachineGuid();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _globalKeyLiscenseVerify,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          body: Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                shape: BoxShape.rectangle,
                border: Border.all(color: Colors.grey, width: 1.5),
              ),
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.height * 0.7,
              child: Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Form(
                      key: _liscenseVerifyFK,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.vpn_key_outlined,
                                size: MediaQuery.of(context).size.width * 0.05,
                                color: Colors.blue),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01),
                            Text(
                              'Liscense Key Verification',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge!
                                  .copyWith(color: Colors.blue),
                            ),
                            const SizedBox(height: 10.0),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Text(_globalUsage.productKeyRelatedMsg,
                                  style:
                                      Theme.of(context).textTheme.labelLarge),
                            ),
                            const SizedBox(height: 50.0),
                            Container(
                              margin: const EdgeInsets.all(10.0),
                              width: MediaQuery.of(context).size.width * 0.41,
                              child: Builder(builder: (context) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Machine Code',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.35,
                                      child: TextFormField(
                                        readOnly: true,
                                        textDirection: TextDirection.ltr,
                                        controller: _machineCodeController,
                                        decoration: InputDecoration(
                                          suffixIcon: !_isCoppied
                                              ? IconButton(
                                                  tooltip: 'Copy',
                                                  splashRadius: 18.0,
                                                  onPressed:
                                                      _machineCodeController
                                                              .text.isEmpty
                                                          ? null
                                                          : () async {
                                                              Clipboard.setData(
                                                                ClipboardData(
                                                                    text: _machineCodeController
                                                                        .text),
                                                              );
                                                              _onShowSnack(
                                                                  Colors.green,
                                                                  'Machine code copied.');
                                                              setState(() {
                                                                _isCoppied =
                                                                    true;
                                                              });

                                                              /*   ClipboardData?
                                                                  clipboardData =
                                                                  await Clipboard
                                                                      .getData(
                                                                          Clipboard
                                                                              .kTextPlain);
                                                              String?
                                                                  copiedText =
                                                                  clipboardData
                                                                      ?.text;
                                                              print(
                                                                  'The copy value: $copiedText'); */
                                                            },
                                                  icon: const Icon(Icons.copy,
                                                      size: 15.0),
                                                )
                                              : const Icon(Icons.done_rounded),
                                          enabledBorder:
                                              const OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.grey),
                                          ),
                                          focusedBorder:
                                              const OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.blue),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.all(15.0),
                                          border: const OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ),
                            Container(
                              margin: const EdgeInsets.all(10.0),
                              width: MediaQuery.of(context).size.width * 0.41,
                              child: Builder(
                                builder: (context) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Product Key',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.35,
                                        child: TextFormField(
                                          textDirection: TextDirection.ltr,
                                          controller: _liscenseController,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Enter the product key.';
                                            }
                                            return null;
                                          },

                                          /*  inputFormatters: [
                                                                      FilteringTextInputFormatter.allow(
                                                                        RegExp(_regExUName),
                                                                      ),
                                                                    ], */
                                          decoration: const InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.blue),
                                            ),
                                            contentPadding:
                                                EdgeInsets.all(15.0),
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Builder(
                                  builder: (context) {
                                    return ElevatedButton.icon(
                                        onPressed: () async {
                                          if (_liscenseVerifyFK.currentState!
                                              .validate()) {
                                            if (_liscenseController.text ==
                                                await _globalUsage
                                                    .getLicenseKey()) {
                                              if (await _globalUsage
                                                  .hasLicenseKeyExpired()) {
                                                _onShowSnack(Colors.red,
                                                    'Sorry, this product key has expired. Please purchase the new one.');
                                                await _globalUsage
                                                    .deleteValue4User(
                                                        'UserlicenseKey');
                                              } else {
                                                await _globalUsage
                                                    .storeLicenseKey4User(
                                                        _liscenseController
                                                            .text);
                                                // ignore: use_build_context_synchronously
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const Login()));
                                              }
                                            } else {
                                              _onShowSnack(Colors.red,
                                                  'Sorry, this product key is not valid!');
                                              await _globalUsage
                                                  .deleteValue4User(
                                                      'UserlicenseKey');
                                            }
                                          }
                                        },
                                        icon: const Icon(Icons.verified),
                                        label: const Text('Verify'));
                                  },
                                ),
                                Builder(
                                  builder: (context) {
                                    return TextButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: const Text('Exit the System', style: TextStyle(color: Colors.blue)),
                                            content: const Text('Are you sure you want to exit the system?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: const Text(
                                                    'Cancel'),
                                              ),
                                              ElevatedButton(
                                                onPressed: () => exit(0),
                                                child: const Text('Exit'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      child: const Text('Cancel'),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

// This function fetches machine GUID.
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

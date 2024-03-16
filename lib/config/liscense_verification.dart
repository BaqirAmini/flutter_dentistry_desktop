import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                shape: BoxShape.rectangle,
                border: Border.all(color: Colors.grey, width: 2.0),
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
                            Text(
                              'Liscense Verification',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(fontSize: 20),
                            ),
                            const SizedBox(height: 50.0),
                            Container(
                              margin: const EdgeInsets.all(10.0),
                              width: MediaQuery.of(context).size.width * 0.45,
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
                                              : Icon(Icons.done_rounded),
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
                              width: MediaQuery.of(context).size.width * 0.45,
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
                                        onPressed: () {
                                          if (_liscenseVerifyFK.currentState!
                                              .validate()) {}
                                        },
                                        icon: const Icon(Icons.verified),
                                        label: const Text('Verify'));
                                  },
                                ),
                                Builder(
                                  builder: (context) {
                                    return TextButton(
                                      onPressed: () {},
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

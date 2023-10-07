// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter_dentistry/config/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dentistry/config/translations.dart';
import 'package:flutter_dentistry/models/db_conn.dart';
import 'package:flutter_dentistry/views/main/dashboard.dart';
import 'package:flutter_dentistry/views/staff/staff_info.dart';
import 'package:galileo_mysql/galileo_mysql.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:provider/provider.dart';

void main() {
  return runApp(
    ChangeNotifierProvider(
      create: (context) => LanguageProvider(),
      child: const Login(),
    ),
  );
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
// The global for the form
  final _loginFormKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _pwdController = TextEditingController();
  final _regExUName = '[a-zA-Z0-9-@]';

  bool _isLoggedIn = false;
  var isEnglish;
  var selectedLanguage;

// Show/Hide password using eye icons
  bool _isHidden = true;
  void _togglePwdView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  Future<void> _onPressLoginButton(BuildContext context) async {
    if (_loginFormKey.currentState!.validate()) {
      try {
        final conn = await onConnToDb();
        final userName = _userNameController.text;
        final pwd = _pwdController.text;
        var results = await conn.query(
            'SELECT * FROM staff_auth WHERE username = ? AND password = PASSWORD(?)',
            [userName, pwd]);

        if (results.isNotEmpty) {
          final row = results.first;
          final staffID = row["staff_ID"];
          final role = row["role"];

          var results2 = await conn
              .query('SELECT * FROM staff WHERE staff_ID = ?', [staffID]);
          final row2 = results2.first;
          String firstName = row2["firstname"];
          String lastName = row2["lastname"];
          String position = row2["position"];
          double salary = row2["salary"];
          String phone = row2["phone"];
          String tazkira = row2["tazkira_ID"];
          String addr = row2["address"];
          final userPhoto =
              row2['photo'] != null ? row2['photo'] as Blob : null;
          // Global variables to be assigned staff info
          StaffInfo.staffID = staffID;
          StaffInfo.staffRole = role;
          StaffInfo.firstName = firstName;
          StaffInfo.lastName = lastName;
          StaffInfo.position = position;
          StaffInfo.salary = salary;
          StaffInfo.phone = phone;
          StaffInfo.tazkira = tazkira;
          StaffInfo.address = addr;
          StaffInfo.userPhoto = userPhoto;

          /*  Map<String, String> userData = {
          "staffID": staffID.toString(),
          "role": role
        }; */
          // ignore: use_build_context_synchronously
          // Navigator.pushNamed(context, '/dashboard', arguments: userData);
          // ignore: use_build_context_synchronously
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Dashboard(),
            ),
          );
          setState(() {
            _isLoggedIn = false;
          });
        } else {
          setState(() {
            _isLoggedIn = false;
          });
          // ignore: avoid_single_cascade_in_expression_statements
          Flushbar(
            backgroundColor: Colors.redAccent,
            flushbarStyle: FlushbarStyle.GROUNDED,
            flushbarPosition: FlushbarPosition.TOP,
            messageText: Directionality(
              textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
              child: Text(
                translations[selectedLanguage]?['InvalidUP'] ?? ''.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            duration: const Duration(seconds: 3),
          )..show(context);

          _userNameController.clear();
          _pwdController.clear();
          setState(() {
            _isLoggedIn = false;
          });
        }
      } on SocketException catch (e) {
        // ignore: avoid_single_cascade_in_expression_statements
        Flushbar(
          backgroundColor: Colors.redAccent,
          flushbarStyle: FlushbarStyle.GROUNDED,
          flushbarPosition: FlushbarPosition.TOP,
          messageText: Directionality(
            textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
            child: const Text(
              "دیتابیس یافت نشد، لطفا با یک شخص مسلکی تماس بگیرید.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
          duration: const Duration(seconds: 3),
        )..show(context);
        setState(() {
          _isLoggedIn = false;
        });
      } catch (e) {
        print('Exception is $e');
      }
    } else {
      setState(() {
        _isLoggedIn = false;
      });
    }
  }

  final _userNameFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _btnLoginFocus = FocusNode();

  @override
  void dispose() {
    _userNameFocus.dispose();
    _passwordFocus.dispose();
    _btnLoginFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Fetch translations keys based on the selected language.
    var languageProvider = Provider.of<LanguageProvider>(context);
    selectedLanguage = languageProvider.selectedLanguage;
    isEnglish = selectedLanguage == 'English';

    return MaterialApp(
      // routes: {'/dashboard': (context) => const Dashboard()},
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
        child: Scaffold(
          body: Center(
            child: Card(
              elevation: 10.5,
              shadowColor: Colors.grey,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              child: SizedBox(
                width: 700.0,
                height: 500.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Form(
                      key: _loginFormKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            (translations[selectedLanguage]?['TopLabel'] ?? '')
                                .toString(),
                            style: const TextStyle(fontSize: 40.0),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                                top: 20.0,
                                bottom: 10.0),
                            width: 330.0,
                            child: Builder(builder: (context) {
                              return TextFormField(
                                focusNode: _userNameFocus,
                                textDirection: TextDirection.ltr,
                                controller: _userNameController,
                                onFieldSubmitted: (value) {
                                  _userNameFocus.unfocus();
                                  FocusScope.of(context)
                                      .requestFocus(_passwordFocus);
                                  _onPressLoginButton(context);
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return (translations[selectedLanguage]
                                                ?['BlankUsernameMsg'] ??
                                            '')
                                        .toString();
                                  }
                                  return null;
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(_regExUName),
                                  ),
                                ],
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(15.0),
                                  border: const OutlineInputBorder(),
                                  labelText: (translations[selectedLanguage]
                                              ?['UserName'] ??
                                          '')
                                      .toString(),
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
                            }),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                                top: 10.0,
                                bottom: 10.0),
                            width: 330.0,
                            child: Builder(
                              builder: (context) {
                                return TextFormField(
                                  focusNode: _passwordFocus,
                                  textDirection: TextDirection.ltr,
                                  controller: _pwdController,
                                  onFieldSubmitted: (value) {
                                    _passwordFocus.unfocus();
                                    _onPressLoginButton(context);
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return (translations[selectedLanguage]
                                                  ?['BlankPwdMsg'] ??
                                              '')
                                          .toString();
                                    }
                                    return null;
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(_regExUName)),
                                  ],
                                  obscureText: _isHidden,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(15.0),
                                    prefix: !isEnglish
                                        ? InkWell(
                                            onTap: _togglePwdView,
                                            child: Icon(
                                              _isHidden
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              color: Colors.blue,
                                              size: 18.0,
                                            ),
                                          )
                                        : null,
                                    suffix: isEnglish
                                        ? InkWell(
                                            onTap: _togglePwdView,
                                            child: Icon(
                                              _isHidden
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              color: Colors.blue,
                                              size: 18.0,
                                            ),
                                          )
                                        : null,
                                    border: const OutlineInputBorder(),
                                    labelText: (translations[selectedLanguage]
                                                ?['Password'] ??
                                            '')
                                        .toString(),
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
                                    focusedErrorBorder:
                                        const OutlineInputBorder(
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
                            margin: const EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                                top: 10.0,
                                bottom: 5.0),
                            width: 300.0,
                            height: 35.0,
                            child: Builder(
                              builder: (context) {
                                return OutlinedButton(
                                  focusNode: _btnLoginFocus,
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    side: const BorderSide(
                                      color: Colors.blue,
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isLoggedIn = true;
                                    });
                                    _onPressLoginButton(context);
                                  },
                                  child: _isLoggedIn
                                      ? const SizedBox(
                                          height: 18.0,
                                          width: 18.0,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 3.0,
                                          ),
                                        )
                                      : Text(
                                          (translations[selectedLanguage]
                                                      ?['LoginButton'] ??
                                                  '')
                                              .toString(),
                                        ),
                                );
                              },
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.grey,
                            ),
                            child: Text(translations[selectedLanguage]?['ForgotPwd'] ?? ''.toString(),),
                          ),
                        ],
                      ),
                    ),
                    const Image(
                      image: AssetImage('assets/graphics/login_img1.png'),
                      width: 300,
                      height: 300,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
            .copyWith(background: Colors.white),
      ),
    );
  }
}

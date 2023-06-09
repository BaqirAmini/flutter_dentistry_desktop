import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dentistry/models/db_conn.dart';
import 'package:flutter_dentistry/views/main/dashboard.dart';

void main() {
  runApp(const Login());
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
// The global for the form
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _pwdController = TextEditingController();
  final _regExUName = '[a-zA-Z0-9-@]';

// Show/Hide password using eye icons
  bool _isHidden = true;
  void _togglePwdView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/dashboard' : (context) => const Dashboard()
      },
        debugShowCheckedModeBanner: false,
        home: Directionality(
          textDirection: TextDirection.rtl,
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
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'خوش آمدید!',
                              style: TextStyle(fontSize: 40.0),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 20.0,
                                  right: 20.0,
                                  top: 20.0,
                                  bottom: 10.0),
                              width: 330.0,
                              child: TextFormField(
                                textDirection: TextDirection.ltr,
                                controller: _userNameController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'نام یوزر نمی تواند خالی باشد.';
                                  }
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(_regExUName),
                                  ),
                                ],
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.all(15.0),
                                  border: OutlineInputBorder(),
                                  labelText: 'نام یوزر (نام کاربری)',
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
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 20.0,
                                  right: 20.0,
                                  top: 10.0,
                                  bottom: 10.0),
                              width: 330.0,
                              child: TextFormField(
                                textDirection: TextDirection.ltr,
                                controller: _pwdController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'رمز عبور نمی تواند خالی باشد.';
                                  }
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(_regExUName)),
                                ],
                                obscureText: _isHidden,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(15.0),
                                  prefix: InkWell(
                                    onTap: _togglePwdView,
                                    child: Icon(
                                      _isHidden
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.blue,
                                      size: 18.0,
                                    ),
                                  ),
                                  border: const OutlineInputBorder(),
                                  labelText: 'رمز عبور',
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
                                    style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      side: const BorderSide(
                                        color: Colors.blue,
                                      ),
                                    ),
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        final userName =
                                            _userNameController.text;
                                        final pwd = _pwdController.text;
                                        var conn = await onConnToDb();
                                        var results = await conn.query(
                                            'SELECT * FROM staff_auth WHERE username = ? AND password = PASSWORD(?)',
                                            [userName, pwd]);

                                        if (results.isNotEmpty) {
                                          final row = results.first;
                                          final staffID = row["staff_ID"];
                                          final role = row["role"];
                                          Map<String, String> userData = {
                                            "staffID": staffID.toString(),
                                            "role": role
                                          };
                                          // ignore: use_build_context_synchronously
                                          Navigator.pushNamed(
                                              context, '/dashboard',
                                              arguments: userData);
                                          // ignore: use_build_context_synchronously
                                         /*  Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const Dashboard(),
                                            ),
                                          ); */
                                        } else {
                                          // ignore: use_build_context_synchronously
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              backgroundColor: Colors.redAccent,
                                              content: SizedBox(
                                                height: 20.0,
                                                child: Center(
                                                  child: Text(
                                                      'متاسفم، نام یوزر و یا رمز عبور تان نا معتبر است.'),
                                                ),
                                              ),
                                            ),
                                          );
                                          _userNameController.clear();
                                          _pwdController.clear();
                                        }
                                      }
                                    },
                                    child: const Text('ورود به سیستم'),
                                  );
                                },
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.grey,
                              ),
                              child: const Text('رمز فراموش تان شده؟'),
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
            primarySwatch: Colors.blue, backgroundColor: Colors.white));
  }
}

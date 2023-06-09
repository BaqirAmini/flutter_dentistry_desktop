import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children:  [
                          const Text(
                            'خوش آمدید!',
                            style: TextStyle(fontSize: 40.0),
                          ),
                          const SizedBox(
                            height: 40.0,
                          ),
                          const SizedBox(
                            width: 300.0,
                            child: TextField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  suffixIcon: Icon(Icons.person),
                                  labelText: 'یوزر نیم'),
                            ),
                          ),
                          const SizedBox(
                            height: 40.0,
                          ),
                          const SizedBox(
                            width: 300.0,
                            child: TextField(
                              obscureText: true,
                              decoration: InputDecoration(
                                suffixIcon: Icon(Icons.visibility_off),
                                  border: OutlineInputBorder(),
                                  labelText: 'رمز عبور'),
                            ),
                          ),
                          const SizedBox(
                            height: 40.0,
                          ),
                          SizedBox(
                            width: 300.0,
                            child:  ElevatedButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const Dashboard()));
                                },
                              style:  ElevatedButton.styleFrom(
                                backgroundColor: Colors.lightBlue,
                              ),
                                child: const Text('ورود به سیستم'),
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

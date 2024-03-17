import 'package:flutter/material.dart';
import 'package:flutter_dentistry/config/developer_options.dart';
import 'package:flutter_dentistry/config/global_usage.dart';
import 'package:flutter_dentistry/config/language_provider.dart';
import 'package:flutter_dentistry/config/liscense_verification.dart';
import 'package:flutter_dentistry/views/main/login.dart';
import 'package:provider/provider.dart';

void main() async {
  // These two lines are used to call singleton 'loadFeatures()' function to enable / disable premuim features.
  WidgetsFlutterBinding.ensureInitialized();
  await Features().loadFeatures();
  runApp(const CrownApp());
}

class CrownApp extends StatelessWidget {
  const CrownApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LanguageProvider>(
      create: (_) => LanguageProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My App',
        theme: ThemeData(
          useMaterial3: false,
          primarySwatch: Colors.blue,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Create an instance of this class
  final GlobalUsage _globalUsage = GlobalUsage();

  @override
  void initState() {
    super.initState();
    // Navigate to the login page after 3 seconds
    Future.delayed(const Duration(seconds: 3), () async {
      await _globalUsage.hasLicenseKeyExpired() ||
              await _globalUsage.getLicenseKey4User() == null
          // ignore: use_build_context_synchronously
          ? Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const LiscenseVerification()))
          // ignore: use_build_context_synchronously
          : Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const Login()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.1,
              height: MediaQuery.of(context).size.height * 0.1,
              child: Image.asset('assets/graphics/crown_logo_blue.png'),
            ), // Replace with your logo
            const SizedBox(height: 30),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.1,
              child: const LinearProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}

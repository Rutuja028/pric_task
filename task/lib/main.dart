import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task/homePage.dart';
import 'package:task/sign_up.dart';
import "dart:developer";

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDFUFKxeSLNwAz5lMMS71-ipWJd6RCBehM",
          appId: "1:546289290724:web:a7593a09dc405b45df8bf1",
          messagingSenderId: "546289290724",
          projectId: "task-52ecf"),
    );
  }

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  void checkLogin(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? email = sharedPreferences.getString("email");
    if (email == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) {
            return const SignUpPage();
          },
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) {
            return HomePage();
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    checkLogin(context);
    return const Scaffold();
  }
}

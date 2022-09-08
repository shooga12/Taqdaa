import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shahad/home_page.dart';
import 'package:shahad/login_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/login_page",
      routes: {
        
        "/login_page": (context) => const LoginPage(),
        "/home_page": (context) => HomePage(),
      },
      home: const LoginPage(),
    );
  }
}

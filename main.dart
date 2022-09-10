import 'package:flutter/material.dart'
    show BuildContext, Key, MaterialApp, StatelessWidget, Widget, runApp;
import 'package:flutter1_signup/pages/signup.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(routes: {
      "/signup-page": (context) => const Signup(),
    });
  }
}

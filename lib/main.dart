import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(
    title: 'Navigation Basics',
    home: MyApp(),
  ));
}

// child: ElevatedButton(
//   onPressed: () {
//     Navigator.pop(context);
//   },
//   child: const Text('Go back!'),
// ),

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
  int _currentIndex = 0;
  final List<Widget> _children = [
    HomePage(),
  ];
  // void signup() async {
  //   try {
  //     await firebaseAuth.createUserWithEmailAndPassword(
  //         email: "shooge@gmail.com", password: "12345");
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/background.png"),
                  fit: BoxFit.fill)),
        ),
        toolbarHeight: 170,
        //leading: BackButton(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _children[_currentIndex],
    );
    //   return MaterialApp(
    //     home: Scaffold(
    //       extendBodyBehindAppBar: true,
    //       appBar: AppBar(
    //         flexibleSpace: Container(
    //           decoration: BoxDecoration(
    //               image: DecorationImage(
    //                   image: AssetImage("assets/background.png"),
    //                   fit: BoxFit.fill)),
    //         ),
    //         toolbarHeight: 170,
    //         //leading: BackButton(),
    //         backgroundColor: Colors.transparent,
    //         elevation: 0,
    //       ),
    //       body: Center(
    //         child: ElevatedButton(
    //             child: const Text('Open route'),
    //             onPressed: () {
    //             }),
    //       ),
    //     ),
    //   );
  }
}

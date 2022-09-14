import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taqdaa_application/screens/list_of_stores.dart';
//import 'package:taqdaa_application/screens/storeDetails.dart';
import 'screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(
    title: 'Navigation Basics',
    home: MyApp(),
  ));
}

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/Vector.png"), fit: BoxFit.fill)),
        ),
        toolbarHeight: 170,
        //leading: BackButton(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _children[_currentIndex],
      //
      // bottomNavigationBar: BottomNavigationBar(
      //   onTap: (onTapTapped) {},
      //   currentIndex: _currentIndex,
      //   items: [
      //     BottomNavigationBarItem(
      //       label: Title(child: Text),
      //       icon: new Icon(Icons.home),
      //     ),
      //     BottomNavigationBarItem(
      //       icon: new Icon(Icons.explore),
      //     ),
      //     BottomNavigationBarItem(
      //       icon: new Icon(Icons.account_circle),
      //     )
      //   ],
      // ),
    );
  }
}

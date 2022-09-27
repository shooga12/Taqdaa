import 'package:either_dart/either.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taqdaa_application/screens/list_of_stores.dart';
//import 'package:taqdaa_application/screens/storeDetails.dart';
import '../methods/authentication_services.dart';
import '../screens/home_page.dart';
import 'package:flutter/foundation.dart';

import '../screens/login_page.dart';
import '../screens/register_page.dart';
import '../profile/homep_profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDrQ2UiNzImDzxToF5I5BaRREfkRWrUwN8",
            projectId: "taqdaa-10e41",
            storageBucket: "taqdaa-10e41.appspot.com",
            messagingSenderId: "782203884662",
            appId: "1:782203884662:android:92f455fd8e3958c27a7b57"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData) {
            return const MyHomePage();
          }

          return RegisterPage();
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  String getCurrentUser() {
    final User? user = auth.currentUser;
    final uid = user!.uid;
    return uid;
    // here you write the codes to input the data into firestore
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        //   Text(
        //     "Hey, Shoug",
        //     style: TextStyle(fontSize: 25),
        //   ),
        // ]),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/Vector.png"), fit: BoxFit.fill)),
        ),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuthMethods().signOut();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ));
            },
            icon: Icon(
              Icons.logout,
              size: 35,
              color: Color.fromARGB(255, 32, 7, 121),
            ),
          ),
        ],
        toolbarHeight: 170,
        //leading: BackButton(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: HomePage(),
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

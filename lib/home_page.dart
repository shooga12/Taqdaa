import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 17.0),
        child: Container(
          alignment: Alignment.topRight,
          child: GestureDetector(
            child: Image.asset('assets/images/LogoutSquare.png'),
            onTap: () {
              FirebaseAuth.instance.signOut().then((value) {
                print("signed out");
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              });
            },
          ),
        ),
      ),
    );
  }
}

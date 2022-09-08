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
      body: Center(
        child: ElevatedButton(
          child: Text("Logout"),
          onPressed: () {
            FirebaseAuth.instance.signOut().then((value) => 
            { print("signed out"),
              Navigator.push(
                context, MaterialPageRoute(builder: (context) => LoginPage()))
          });
            
          },
        ),
      ),
    );
  }
}

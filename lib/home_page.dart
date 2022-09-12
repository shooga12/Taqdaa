import 'package:firebase_auth/firebase_auth.dart';
import 'methods/authentication_services.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String errorMsg = '';
  //User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 17.0),
        child: Container(
          alignment: Alignment.topRight,
          child: GestureDetector(
            child: Image.asset('assets/images/LogoutSquare.png'),
            onTap: ()  {
              FirebaseAuthMethods().signOut();
                  Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginPage(),
                                  ));
              })
        ),
          ),
        );
  }
}

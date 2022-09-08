import 'dart:js';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:shahad/signup_page.dart';
import 'reusable_widget/reusable_widget.dart';

TextEditingController _emailController = TextEditingController();
TextEditingController _passController = TextEditingController();

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(
              children: <Widget>[
                cloudDcrWidget("asset/images/LoginGroup.png"),
                const SizedBox(
                  height: 36,
                ),
                reusableTextField(
                    "Enter Email Address", false, _emailController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField(
                    "Enter your password", false, _passController),
                const SizedBox(
                  height: 6,
                ),
                forgotPass(context),
                loginRegisterButton(context, true, () {
                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passController.text)
                      .then((value) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  }).onError((error, stackTrace) {
                    print("Error ${error.toString()}");
                  });
                }),
                notRegistered()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row notRegistered() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account?",
            style: TextStyle(color: Color.fromARGB(140, 255, 255, 255))),
        GestureDetector(
          onTap: () {
            //Navigator.push(context, MaterialPageRoute(builder:(context)=> RegisterPage()));
          },
          child: const Text(
            "Register",
            style: TextStyle(color: Color.fromARGB(255, 15, 53, 120) , fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
  Widget forgotPass(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 36,
      alignment: Alignment.bottomCenter,
      child: TextButton(
        child: const Text("Forgot Password? reset" , style: TextStyle( color: Color.fromARGB(255, 9, 44, 104)),
        textAlign: TextAlign.center,
        ),
        onPressed: () {
          
        },
      ),
    );
  }
}

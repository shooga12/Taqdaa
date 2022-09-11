//import 'dart:js';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loginlogout_resetpass/home_page.dart';
import 'package:loginlogout_resetpass/register_page.dart';
import 'reusable_widget/reusable_widget.dart';
import 'package:loginlogout_resetpass/reset_page.dart';

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
                20, MediaQuery.of(context).size.height * 0.1, 20, MediaQuery.of(context).size.height * 0.05),
            child: Column(
              children: <Widget>[
                cloudDcrWidget("assets/images/LoginGroup.png"),
                const SizedBox(
                  height: 36,
                ),
                reusableTextField(
                    "Enter Email Address", false, _emailController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField(
                    "Enter your password", true, _passController),
                const SizedBox(
                  height: 6,
                ),
                forgotPassword(context),

                ReusableButton(context, 'LOG IN', () {

                  FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passController.text).then((value) {
                            Navigator.push(context,
                            MaterialPageRoute(builder: (context) => HomePage()));
                  
                  });
                }),



                notRegistered(context)
                
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row notRegistered(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account?",
            style: TextStyle(color: Color.fromARGB(255, 15, 53, 120))),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder:(context)=> RegisterPage()));
          },
          child: const Text(
            "  Register",
            style: TextStyle(color: Color.fromARGB(255, 15, 53, 120) , fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }


  Row forgotPassword(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Forgot password?",
            style: TextStyle(color: Color.fromARGB(255, 15, 53, 120))),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder:(context)=> ResetPassPage()));
          },
          child: const Text(
            "  Reset Password",
            style: TextStyle(color: Color.fromARGB(255, 15, 53, 120) , fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
    } }
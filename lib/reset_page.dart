import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loginlogout_resetpass/reusable_widget/reusable_widget.dart';

class ResetPassPage extends StatefulWidget {
  const ResetPassPage({super.key});

  @override
  State<ResetPassPage> createState() => _ResetPassPageState();
}

class _ResetPassPageState extends State<ResetPassPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future resetPass() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text)
          .then((value) => Navigator.of(context).pop());
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(
                  'We have sent you an email with a password reset link, Check your inbox'),
            );
          });
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
                20,
                MediaQuery.of(context).size.height * 0.1,
                20,
                MediaQuery.of(context).size.height * 0.05),
            child: Text(
              'Enter tha email associated with your account and we will send you an email with a password reset link',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 15, 53, 120)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(17.0),
            child: reusableTextField(
                "Enter Email Address", false, _emailController),
          ),
          SizedBox(
            height: 17,
          ),
          MaterialButton(
            onPressed: () {
              resetPass();
            },
            //ButtonStyle: BorderRadius.circular(30),
            child: Text(
              "Reset Password",
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            color: Colors.orange,
          )

          //     ReusableButton(context, 'Reset Password', (){
          //       FirebaseAuth.instance
          //     .sendPasswordResetEmail(email: _emailController.text).then((value)=>Navigator.of(context).pop());
          // showDialog(
          //     context: context,
          //     builder: (context) {
          //       return AlertDialog(
          //         content: Text(
          //             'We have sent you an email with a password reset link, Check your inbox'),
          //       );
          //     });
          //     })
        ],
      ),
    );
  }
}

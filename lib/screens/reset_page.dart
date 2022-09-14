import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

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
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  )
                ]);
          });
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(content: Text(e.message.toString()), actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              )
            ]);
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reset Password',
          style: TextStyle(fontSize: 24), //TextStyle(fontFamily: 'Cairo'),
        ),
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
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
                20,
                MediaQuery.of(context).size.height * 0.1,
                20,
                MediaQuery.of(context).size.height * 0.05),
            child: Text(
              'Please enter your email to receive the password reset link : ',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 15, 53, 120)),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 5, right: 20, left: 20, bottom: 50),
            child: TextFormField(
              controller: _emailController,

              validator: MultiValidator([
                RequiredValidator(errorText: 'Required *'),
                EmailValidator(errorText: 'Not a valid Email *')
              ]),
              cursorColor: Color.fromARGB(255, 37, 43, 121),
              style: TextStyle(
                  color: Color.fromARGB(255, 15, 53, 120).withOpacity(0.9)),

              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide:
                        const BorderSide(color: Colors.orange, width: 2.0)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 15, 53, 120), width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide:
                      const BorderSide(color: Colors.orange, width: 2.0),
                ),
                prefixIcon: Icon(Icons.email),
                iconColor: Colors.white,
                labelText: "Enter your Email address",
                labelStyle: TextStyle(
                    color: Color.fromARGB(236, 113, 113, 117).withOpacity(0.9)),
                filled: true,

                fillColor: Colors.white.withOpacity(0.9),
                // border: OutlineInputBorder(
                //  borderRadius: BorderRadius.circular(30.0),),
              ),

              keyboardType: TextInputType.emailAddress,
              //--------------------------------------
            ),
          ),
          SizedBox(
            height: 17,
          ),
          ElevatedButton(
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
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.pressed)) {
                    return Colors.grey;
                  }
                  return Colors.orange;
                }),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)))),
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

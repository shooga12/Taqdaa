import 'methods/authentication_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loginlogout_resetpass/home_page.dart';
import 'package:loginlogout_resetpass/register_page.dart';
import 'reusable_widget/reusable_widget.dart';
import 'package:loginlogout_resetpass/reset_page.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  ///User? user = FirebaseAuth.instance.currentUser;
  String errorMsg = '';
  bool isLoading = false;

  String? validateEmail(String? formEmail) {
    if (formEmail == null || formEmail.isEmpty)
      return 'Email address is required.';

    String pattern = r'\w+@\w+\.\w+';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(formEmail)) return 'Invalid E-mail Address format.';

    return null;
  }

  String? validatePassword(String? formPassword) {
    if (formPassword == null || formPassword.isEmpty)
      return 'Password is required.';

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        //key: _key,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20,
                MediaQuery.of(context).size.height * 0.1,
                20,
                MediaQuery.of(context).size.height * 0.05),
            child: Column(
              children: <Widget>[
                cloudDcrWidget("assets/images/SignupGroup.png"),
                const SizedBox(
                  height: 36,
                ),
                // reusableTextField(
                //     "Enter Email Address", false, _emailController),
                TextFormField(
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
                    labelText: "Enter your Email address",
                    labelStyle: TextStyle(
                        color: Color.fromARGB(236, 113, 113, 117)
                            .withOpacity(0.9)),
                    filled: true,

                    fillColor: Colors.white.withOpacity(0.9),
                    // border: OutlineInputBorder(
                    //  borderRadius: BorderRadius.circular(30.0),),
                  ),

                  keyboardType: TextInputType.emailAddress,
                  //--------------------------------------
                ),
                const SizedBox(
                  height: 20,
                ),
                // reusableTextField("Enter your password", true, _passController),
                TextFormField(
                  controller: _passController,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'Requiered *'),
                  ]),
                  obscureText: true,
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
                    labelText: "Enter your password",
                    labelStyle: TextStyle(
                        color: Color.fromARGB(236, 113, 113, 117)
                            .withOpacity(0.9)),
                    filled: true,

                    fillColor: Colors.white.withOpacity(0.9),
                    // border: OutlineInputBorder(
                    //  borderRadius: BorderRadius.circular(30.0),),
                  ),
                  //keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 7,
                ),

                const SizedBox(
                  height: 13,
                ),
                
                const SizedBox(
                  height: 2,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    errorMsg,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: isLoading == true
                      ? Center(
                          child: CircularProgressIndicator(),
                        )

                      // ReusableButton(context, 'LOG IN', () {
                      //   FirebaseAuth.instance
                      //       .signInWithEmailAndPassword(
                      //           email: _emailController.text.trim(),
                      //           password: _passController.text)
                      //       .then((value) {
                      //     Navigator.push(context,
                      //         MaterialPageRoute(builder: (context) => HomePage()));
                      //   });
                      // }),

                      : ElevatedButton(
                          onPressed: () async {
                            // setState(() {
                            //   isLoading = true;
                            // });
                            register();
                            // final respone = await FirebaseAuthMethods().login(
                            //     _emailController.text.trim(),
                            //     _passController.text);
                            // respone.fold((left) {
                            //   setState(() {
                            //     errorMsg = left.message;
                            //   });
                            // }, (right) => print(right.user!.email));
                            // setState(() {
                            //   isLoading = false;
                            // });
                            // if (errorMsg=='') {
                            //   Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //         builder: (context) => HomePage(),
                            //       ));
                            // }

                            // try {
                            //   await FirebaseAuth.instance
                            //       .signInWithEmailAndPassword(
                            //           email: _emailController.text.trim(),
                            //           password: _passController.text);
                            //   setState(() {
                            //     Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //             builder: (context) => HomePage()));
                            //   });

                            //   errorMsg = '';
                            // } on FirebaseAuthException catch (error) {
                            //   errorMsg = error.message!;
                            // }
                            // setState(() {Navigator.push(context,
                            //      MaterialPageRoute(builder: (context) => HomePage()));});
                          },
                          child: Text(
                            'SIGN UP',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith((states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return Colors.grey;
                                }
                                return Colors.orange;
                              }),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30)))),
                        ),
                ),

                notRegistered(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

//------------------------------------------------------------------------------------------------------//
  Row notRegistered(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an account?",
            style: TextStyle(color: Color.fromARGB(255, 15, 53, 120))),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ));
          },
          child: const Text(
            "  Log in",
            style: TextStyle(
                color: Color.fromARGB(255, 15, 53, 120),
                fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  

  Future register() async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text, password: _passController.text)
          .then((value) => Navigator.of(context).pop());
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('Account created sucessfully'),
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
}

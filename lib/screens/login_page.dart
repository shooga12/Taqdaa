
import '../methods/authentication_services.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'register_page.dart';
import '../reusable_widget/reusable_widget.dart';
import 'reset_page.dart';
import 'package:form_field_validator/form_field_validator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  String errorMsg = '';
  bool isLoading = false;

  String? validateEmail(String? formEmail) {
    if (formEmail == null || formEmail.isEmpty)
      return 'البريد الالكتروني مطلوب';

    String pattern = r'\w+@\w+\.\w+';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(formEmail)) return 'صيغة البريد الالكتروني غير صحيحة';

    return null;
  }

  String? validatePassword(String? formPassword) {
    if (formPassword == null || formPassword.isEmpty)
      return "كلمة المرور مطلوبة";

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        //key: _key,
        //autovalidateMode: AutovalidateMode.onUserInteraction,

        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20,
                MediaQuery.of(context).size.height * 0.1,
                20,
                MediaQuery.of(context).size.height * 0.05),
            child: Column(
              children: <Widget>[
                LogincloudDcrWidget("assets/LoginGroup.png"),
                const SizedBox(
                  height: 36,
                ),
                // reusableTextField(
                //     "Enter Email Address", false, _emailController),
                TextFormField(
                  controller: _emailController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,

                  validator: MultiValidator([
                    RequiredValidator(errorText: 'مطلوب*'),
                    EmailValidator(errorText: 'البريد الالكتروني غير صالح*')
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
                    labelText: "أدخل بريدك الالكتروني",
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
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'مطلوب*'),
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
                    prefixIcon: Icon(Icons.lock),
                    iconColor: Colors.white,
                    labelText: "أدخل كلمة المرور",
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
                forgotPassword(context),
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
                      : SizedBox(
                          width: 200,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () async {
                              login();
                            },
                            child: Text(

                              'تسجيل الدخول',

                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
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
        const Text(" ليس لديك حساب؟",

            style: TextStyle(color: Color.fromARGB(255, 15, 53, 120))),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RegisterPage(),
                ));
          },
          child: const Text(

            "تسجيل جديد",

            style: TextStyle(
                decoration: TextDecoration.underline,
                color: Color.fromARGB(255, 15, 53, 120),
                fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  Row forgotPassword(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(" نسيت كلمة المرور؟ ",

            style: TextStyle(color: Color.fromARGB(255, 15, 53, 120))),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ResetPassPage()));
          },
          child: const Text(

            "إعادة تعيين كلمة المرور",

            style: TextStyle(
                decoration: TextDecoration.underline,
                color: Color.fromARGB(255, 15, 53, 120),
                fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  Future login() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailController.text, password: _passController.text)
          .then((value) => Navigator.of(context).pop());
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                content: Text('تم تسجيل الدخول بنجاح'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'حسنًا'),
                    child: const Text('حسنًا'),
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
                onPressed: () => Navigator.pop(context, 'حسنًا'),
                child: const Text('حسنًا'),
              )
            ]);
          });
    }
  }
}

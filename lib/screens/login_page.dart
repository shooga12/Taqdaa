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

  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20,
                MediaQuery.of(context).size.height * 0.1,
                20,
                MediaQuery.of(context).size.height * 0.05),
            child: Column(
              children: <Widget>[
                LogincloudDcrWidget("assets/Login.png"),
                const SizedBox(
                  height: 36,
                ),
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
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                            const BorderSide(color: Colors.orange, width: 1.0)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 15, 53, 120), width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide:
                          const BorderSide(color: Color(0x76909090), width: 1.0),
                    ),
                    prefixIcon: Icon(
                        Icons.email,
                      color: Color(0x8F909090),
                    ),
                    iconColor: Colors.white,
                    labelText: "البريد الالكتروني",
                    labelStyle: TextStyle(
                        color:  Color(0x8F909090)
                            .withOpacity(0.9),
                      fontFamily: 'Tajawal',
                    ),
                    hintText: 'email@address.com',
                    hintStyle: TextStyle(
                        color:  Color(0x8F909090)
                            .withOpacity(0.9),
                      fontFamily: 'Tajawal',
                    ),
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
                TextFormField(
                  controller: _passController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'مطلوب*'),
                  ]),
                  obscureText: isVisible,
                  cursorColor: Color.fromARGB(255, 37, 43, 121),
                  style: TextStyle(
                      color: Color.fromARGB(255, 15, 53, 120).withOpacity(0.9)),
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isVisible = !isVisible;
                        });
                      },
                      icon: isVisible
                          ? Icon(Icons.visibility)
                          : Icon(Icons.visibility_off),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                            const BorderSide(color: Color(0x76909090), width: 1.0)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 15, 53, 120), width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide:
                          const BorderSide(color:  Color(0x76909090), width: 1.0),
                    ),
                    prefixIcon: Icon(
                        Icons.lock,
                      color: Color(0x8F909090),
                    ),
                    iconColor: Colors.white,
                    labelText: "كلمة المرور",
                    labelStyle: TextStyle(
                        color: Color(0x8F909090)
                            .withOpacity(0.9),
                        fontFamily: 'Tajawal',
                    ),
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
                          width: double.infinity,
                          height: 45,
                          child: ElevatedButton(
                            onPressed: () async {
                              login();
                            },
                            child: Text(
                              'تسجيل الدخول',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                fontFamily: 'Tajawal',
                              ),
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
                                            BorderRadius.circular(8)))),
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
        SizedBox(height: 30,),
        const Text("ليس لديك حساب؟ ",
            style: TextStyle(
              color: Color.fromARGB(255, 106, 106, 106),
                fontFamily: 'Tajawal'
            ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RegisterPage(),
                ));
          },
          child: const Text(
            "انشئ حساب ",
            style: TextStyle(
                decoration: TextDecoration.underline,
                color: Color.fromARGB(255, 15, 53, 120),
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal'
            ),
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
            style: TextStyle(
                color: Color.fromARGB(255, 106, 106, 106),
                fontFamily: 'Tajawal'
            ),
        ),
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
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal'
            ),
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
                content: Container(
                  height: 280,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          "assets/successfull_payment.png",
                          height: 200,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "تم تسجيل الدخول بنجاح",
                          style: TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 98, 160, 100),
                              fontFamily: 'Tajawal'
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'حسنًا'),
                    child: const Text(
                        'حسنًا',
                      style: TextStyle(
                          fontFamily: 'Tajawal'
                      ),
                    ),
                  )
                ]);
          });
    } on FirebaseAuthException catch (e) {
      print(e);
      Map<String, String?> codeResponses = {
        // Re-auth responses
        "user-mismatch": 'المستخدم غير متطابق',
        "user-not-found": 'لم يتم العثور على المستخدم',
        "invalid-credential": 'invalid credential',
        "invalid-email": 'الايميل غير موجود',
        "wrong-password": 'كلمة المرور خاطئة',
        "invalid-verification-code": 'رمز التحقق غير صالح',
        "invalid-verification-id": 'معرّف التحقق غير صالح',
        "user-disabled": 'المستخدم لهذا الايميل معطّل',
        "too-many-requests": 'طلبات كثيرة',

        // Update password error codes
        "weak-password": 'كلمة المرور ليست قوية',
        "requires-recent-login": 'يتطلب تسجيل دخول حديث'
      };
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(content: Text(codeResponses[e.code]!), actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, 'حسنًا'),
                child: const Text(
                    'حسنًا',
                  style: TextStyle(
                      fontFamily: 'Tajawal'
                  ),
                ),
              )
            ]);
          });
    }
  }
}

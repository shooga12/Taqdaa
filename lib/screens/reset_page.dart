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
                    "تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني",
                  style: TextStyle(
                    fontFamily: 'Tajawal'
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'حسنًا'),
                    child: const Text('حسنًا',
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
        "wrong-password": 'كلمة المرور الحالية خاطئة',
        "invalid-verification-code": 'رمز التحقق غير صالح',
        "invalid-verification-id": 'معرّف التحقق غير صالح',
        "user-disabled": 'المستخدم لهذا الايميل معطّل',
        "too-many-requests": 'طلبات كثيرة',
        "operation-not-allowed":
            'تسجيل الدخول من خلال الايميل وكلمة المرور غير مسموح',
        // Update password error codes
        "weak-password": 'كلمة المرور غير قوية',
        "requires-recent-login": 'يتطلب تسجيل دخول حديث',
        '': e.message.toString()
      };
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(content: Text(codeResponses[e.code]!), actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, 'حسنًا'),
                child: const Text('حسنًا',
                  style: TextStyle(
                      fontFamily: 'Tajawal'
                  ),
                ),
              )
            ]);
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'إعادة تعيين كلمة المرور',
            style: TextStyle(
                fontSize: 24,
                fontFamily: 'Tajawal'
            ), //TextStyle(fontFamily: 'Cairo'),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/AppBar.png"), fit: BoxFit.fill)),
          ),
          toolbarHeight: 130,
          //leading: BackButton(),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                    20,
                    MediaQuery.of(context).size.height * 0.1,
                    20,
                    MediaQuery.of(context).size.height * 0.05),
                child: Text(
                  "لطفًا، أدخل بريدك الإلكتروني ليتم إرسال رابط إعادة تعيين كلمة المرور : ",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 15, 53, 120),
                      fontFamily: 'Tajawal'
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 5, right: 20, left: 20, bottom: 50),
                child: TextFormField(
                  controller: _emailController,

                  validator: MultiValidator([
                    RequiredValidator(errorText: 'مطلوب *'),
                    EmailValidator(errorText: 'البريد الإلكتروني غير صالح*')
                  ]),
                  cursorColor: Color.fromARGB(255, 37, 43, 121),
                  style: TextStyle(
                      color: Color.fromARGB(255, 15, 53, 120).withOpacity(0.9)),

                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                            const BorderSide(color:  Color(0x8F909090), width: 1.0)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 15, 53, 120), width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide:
                          const BorderSide(color:  Color(0x8F909090), width: 1.0),
                    ),
                    prefixIcon: Icon(
                        Icons.email,
                      color: Color(0x8F909090),
                    ),
                    iconColor: Colors.white,
                    labelText: " البريد الإلكتروني",
                    labelStyle: TextStyle(
                        color:  Color(0x8F909090)
                            .withOpacity(0.9)),
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
              SizedBox(
                width: 380,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    resetPass();
                  },
                  //ButtonStyle: BorderRadius.circular(30),
                  child: Text(
                    "إعادة تعيين كلمة المرور",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Tajawal'
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
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)))),
                ),
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
        ));
  }
}

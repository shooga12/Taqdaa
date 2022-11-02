import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:taqdaa_application/screens/insideMore.dart';
import '../confige/EcommerceApp.dart';
import 'package:intl/intl.dart';
import '../views/profile_view.dart';

class UpdatePass extends StatefulWidget {
  const UpdatePass({Key? key}) : super(key: key);

  @override
  _UpdatePassState createState() => _UpdatePassState();
}

class _UpdatePassState extends State<UpdatePass> {
  bool isInsideHome = false;
  bool isInsideReceipt = false;
  bool isInsideMore = true;
  bool isInsideCart = false;
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final RepeatPasswordController = TextEditingController();

  final emailController = TextEditingController();

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  String documentName = EcommerceApp().getCurrentUser();
  String errorMsg = '';
  bool isLoading = false;

  static var _firestore;

  @override
  void initState() {
    super.initState();
    emailController.text = EcommerceApp.loggedInUser.email!;
  }

  String CurrentUser = "";
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          "تحديث كلمة المرور",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w100),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/Vector.png"), fit: BoxFit.fill)),
        ),
        centerTitle: true,
        toolbarHeight: 170,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Form(
                    key: _key,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                            20,
                            MediaQuery.of(context).size.height * 0.02,
                            20,
                            MediaQuery.of(context).size.height * 0.02),
                        child: Column(
                          children: <Widget>[
                            //current field
                            TextFormField(
                              controller: currentPasswordController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,

                              validator: MultiValidator([
                                RequiredValidator(errorText: 'مطلوب *'),
                                // PatternValidator(
                                //     r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
                                //     errorText: 'كلمة مرور الحالية خاطئة'),
                              ]),
                              obscureText: true,
                              cursorColor: Color.fromARGB(255, 37, 43, 121),
                              style:
                                  TextStyle(fontSize: 20, color: Colors.black),

                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: const BorderSide(
                                        color: Colors.orange, width: 2.0)),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 15, 53, 120),
                                      width: 2.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: const BorderSide(
                                      color: Colors.orange, width: 2.0),
                                ),
                                prefixIcon:
                                    Icon(Icons.lock, color: Colors.black),
                                iconColor: Colors.white,
                                labelText: "كلمة المرور الحالية",
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.9),
                              ),

                              keyboardType: TextInputType.visiblePassword,
                              //--------------------------------------
                            ),

                            const SizedBox(
                              height: 15,
                            ),
                            //----New password Field----
                            TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: newPasswordController,

                              validator: MultiValidator([
                                RequiredValidator(errorText: 'مطلوب *'),
                                PatternValidator(
                                    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
                                    errorText: 'كلمة مرور غير صالحة'),
                              ]),
                              obscureText: true,
                              cursorColor: Color.fromARGB(255, 37, 43, 121),
                              style:
                                  TextStyle(fontSize: 20, color: Colors.black),

                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: const BorderSide(
                                        color: Colors.orange, width: 2.0)),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 15, 53, 120),
                                      width: 2.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: const BorderSide(
                                      color: Colors.orange, width: 2.0),
                                ),
                                prefixIcon:
                                    Icon(Icons.lock, color: Colors.black),
                                iconColor: Colors.white,
                                labelText: "كلمة المرور الجديدة",
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.9),
                              ),

                              keyboardType: TextInputType.visiblePassword,
                              //--------------------------------------
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: RepeatPasswordController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,

                              validator: (validator) {
                                RequiredValidator(errorText: '* مطلوب');

                                if (validator != newPasswordController.text)
                                  return 'تأكيد كلمة المرور غير متطابق';
                                return null;
                              },

                              // validator: MultiValidator([
                              //   RequiredValidator(errorText: 'مطلوب *'),
                              //   MatchValidator(errorText: 'passwords do not match').validateMatch(newPasswordController.text, RepeatPasswordController.text),
                              //   ConfirmationResult(newPasswordController.text, RepeatPasswordController.text)

                              //   // PatternValidator(
                              //   //     r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
                              //   //     errorText: 'كلمة مرور الحالية خاطئة'),
                              // ]),
                              obscureText: true,
                              cursorColor: Color.fromARGB(255, 37, 43, 121),
                              style:
                                  TextStyle(fontSize: 20, color: Colors.black),

                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: const BorderSide(
                                        color: Colors.orange, width: 2.0)),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 15, 53, 120),
                                      width: 2.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: const BorderSide(
                                      color: Colors.orange, width: 2.0),
                                ),
                                prefixIcon:
                                    Icon(Icons.lock, color: Colors.black),
                                iconColor: Colors.white,
                                labelText: "تأكيد كلمة المرور الجديدة",
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.9),
                              ),

                              keyboardType: TextInputType.visiblePassword,
                              //--------------------------------------
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0, right: 90.0),
                    child: SizedBox(
                      width: 200,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () async {
                          bool confirmed = ConfirmationResult(
                              newPasswordController.text,
                              RepeatPasswordController.text);
                          bool changed = !noChange(
                              currentPasswordController.text,
                              newPasswordController.text);

                          final String? trySavePassChange = await saveChanges(
                              currentPasswordController.text,
                              newPasswordController.text);
                          if (isValidNewPass && changed && confirmed) {
                            showDialog(
                                context: context,
                                builder: ((context) {
                                  return AlertDialog(
                                    title: Text(
                                        "هل أنت متأكد من تغيير كلمة المرور؟"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            if (trySavePassChange == null) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                duration:
                                                    const Duration(seconds: 2),
                                                backgroundColor: Color.fromARGB(
                                                    255, 135, 155, 190),
                                                content: Text(
                                                    "تم تغيير كلمة مرورك بنجاح",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        letterSpacing: 0.8)),
                                                action: null,
                                              ));

                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        More(),
                                                  ));
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        Homepprofile(),
                                                  ));
                                            } // end if-------------------------------
                                            else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                duration:
                                                    const Duration(seconds: 2),
                                                backgroundColor: Color.fromARGB(
                                                    255, 248, 136, 44),
                                                content: Text(
                                                    'تعذّر تحديث كلمة المرور,' +
                                                        trySavePassChange
                                                            .toString(),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        letterSpacing: 0.8)),
                                                action: null,
                                              ));
                                            }
                                          },
                                          child: Text(
                                            "نعم",
                                            style: TextStyle(
                                              color: Colors.green,
                                            ),
                                          )),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("إلغاء"))
                                    ],
                                  );
                                }));
                          } else if (!changed) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: const Duration(seconds: 2),
                              backgroundColor:
                                  Color.fromARGB(255, 248, 136, 44),
                              content: Text(
                                  'تعذّر تحديث كلمة المرور, لم تقم بأي تعديلات على كلمة مرورك القديمة',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 17, letterSpacing: 0.8)),
                              action: null,
                            ));
                          } 
                          else if (!confirmed) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: const Duration(seconds: 2),
                              backgroundColor:
                                  Color.fromARGB(255, 248, 136, 44),
                              content: Text(
                                  'تعذّر تحديث كلمة المرور, تأكيد كلمة المرور الجديدة غير متطابق',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 17, letterSpacing: 0.8)),
                              action: null,
                            ));
                          }
                           else if (!isValidNewPass) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: const Duration(seconds: 2),
                              backgroundColor:
                                  Color.fromARGB(255, 248, 136, 44),
                              content: Text(
                                  'تعذّر تحديث كلمة المرور, كلمة المرور الجديدة ضعيفة',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 17, letterSpacing: 0.8)),
                              action: null,
                            ));
                          }
                        },
                        child: Text(
                          'تحديث كلمة المرور',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
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
                                    borderRadius: BorderRadius.circular(30)))),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  late bool isMatch;
  late bool isSamePass;
  // bool? isLnameValid;
  // bool? isEmailValid;
  // bool? isPhoneValid;

  bool ConfirmationResult(newpass, repeatNewpass) {
    if (newpass != repeatNewpass)
      isMatch = false;
    else
      isMatch = true;

    return isMatch;
  }

  bool noChange(currentPass, newpass) {
    if (currentPass != newpass)
      isSamePass = false;
    else
      isSamePass = true;

    return isSamePass;
  }

  bool get isValidNewPass {
    final passRegExp =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    return passRegExp.hasMatch(newPasswordController.text);
  }

  static Future<String?> saveChanges(
      String oldPassword, String newPassword) async {
    User user = FirebaseAuth.instance.currentUser!;
    AuthCredential credential =
        EmailAuthProvider.credential(email: user.email!, password: oldPassword);

    Map<String, String?> codeResponses = {
      // Re-auth responses
      "user-mismatch": 'المستخدم غير متطابق',
      "user-not-found": 'لم يتم العثور على المستخدم',
      "invalid-credential": 'invalid credential',
      "invalid-email": 'الايميل غير موجود',
      "wrong-password": 'كلمة المرور الحالية خاطئة',
      "invalid-verification-code": 'رمز التحقق غير صالح',
      "invalid-verification-id": 'معرّف التحقق غير صالح',
      // Update password error codes
      "weak-password": 'كلمة المرور غير قوية',
      "requires-recent-login": 'يتطلب تسجيل دخول حديث'
    };

    try {
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
      return await null;
    } on FirebaseAuthException catch (error) {
      return await codeResponses[error.code] ?? "Unknown";
    }
  }
}

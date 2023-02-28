import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../reusable_widget/reusable_widget.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'package:intl/intl.dart';
import '../models/user_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final phonenumberController = TextEditingController();
  final dateofbirthController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final numericRegex = RegExp(r'[0-9]');
  final CharRegex = RegExp(r'[!@#\$&*~]');
  final LetterRegex = RegExp(r'[a-z A-Z]');

  ///User? user = FirebaseAuth.instance.currentUser;
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
      return 'كلمة المرور مطلوبة';
    else if (formPassword.length < 8)
      return 'يجب ان تحتوي كلمة السر على 8 خانات أو أكثر';
    else if (!numericRegex.hasMatch(formPassword))
      return 'يجب أن تحتوي كلمة السر على رقم واحد على الاقل';
    else if (!CharRegex.hasMatch(formPassword))
      return 'يجب أن تحتوي كلمة السر على رمز خاص واحد على الاقل';
    else if (!LetterRegex.hasMatch(formPassword))
      return 'يجب أن تحتوي كلمة السر على حرف واحد على الاقل';
    else
      return null;
  }

  String? validateName(String? formName) {
    final nameRegex = RegExp(
        r'^[\u0600-\u065F\u066A-\u06EF\u06FA-\u06FFa-zA-Z]+[\u0600-\u065F\u066A-\u06EF\u06FA-\u06FFa-zA-Z-_]{1,20}$');

    if (formName == null || formName.isEmpty)
      return 'الاسم مطلوب';
    else if (!nameRegex.hasMatch(formName))
      return 'يجب أن يتكون الأسم من حروف فقط';
    else
      return null;
  }

  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 0,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Form(
        //key: _key,
        //autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _key,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20,
                MediaQuery.of(context).size.height * 0.001,
                20,
                MediaQuery.of(context).size.height * 0.02),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right:15.0),
                  child: SignupcloudDcrWidget("assets/Signup.png"),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  maxLength: 20,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  controller: firstnameController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: validateName,
                  cursorColor: Color.fromARGB(255, 37, 43, 121),
                  style: TextStyle(
                      color: Color.fromARGB(255, 15, 53, 120).withOpacity(0.9),
                    fontFamily: 'Tajawal'
                  ),

                  decoration: InputDecoration(
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
                          const BorderSide(color: Color(0x76909090), width: 1.0),
                    ),
                    prefixIcon: Icon(
                        Icons.person,
                      color: Color(0x8F909090),
                    ),
                    iconColor: Colors.white,
                    labelText: "الاسم الاول",
                    labelStyle: TextStyle(
                        color:  Color(0x8F909090)
                            .withOpacity(0.9),
                      fontFamily: 'Tajawal'
                    ),
                    filled: true,

                    fillColor: Colors.white.withOpacity(0.9),
                      counterText: ""
                    // border: OutlineInputBorder(
                    //  borderRadius: BorderRadius.circular(30.0),),
                  ),

                  keyboardType: TextInputType.name,
                  //--------------------------------------
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  maxLength: 20,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  controller: lastnameController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: validateName,
                  cursorColor: Color.fromARGB(255, 37, 43, 121),
                  style: TextStyle(
                      color: Color.fromARGB(255, 15, 53, 120).withOpacity(0.9),
                      fontFamily: 'Tajawal'
                  ),

                  decoration: InputDecoration(
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
                          const BorderSide(color: Color(0x76909090), width: 1.0),
                    ),
                    prefixIcon: Icon(
                        Icons.person,
                      color: Color(0x8F909090),
                    ),
                    iconColor: Colors.white,
                    labelText: "الاسم الاخير",
                    labelStyle: TextStyle(
                        color:  Color(0x8F909090)
                            .withOpacity(0.9),
                        fontFamily: 'Tajawal'
                    ),
                    filled: true,

                    fillColor: Colors.white.withOpacity(0.9),
                      counterText: ""
                    // border: OutlineInputBorder(
                    //  borderRadius: BorderRadius.circular(30.0),),
                  ),

                  keyboardType: TextInputType.name,
                  //--------------------------------------
                ),
                const SizedBox(
                  height: 20,
                ),
                //email field
                TextFormField(
                  controller: _emailController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,

                  validator: validateEmail,
                  cursorColor: Color.fromARGB(255, 37, 43, 121),
                  style: TextStyle(
                      color: Color.fromARGB(255, 15, 53, 120).withOpacity(0.9),
                      fontFamily: 'Tajawal'
                  ),

                  decoration: InputDecoration(
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
                          const BorderSide(color: Color(0x76909090), width: 1.0),
                    ),
                    prefixIcon: Icon(
                        Icons.email,
                      color: Color(0x8F909090),
                    ),
                    iconColor: Colors.white,
                    labelText: "البريد الالكتروني",
                    labelStyle: TextStyle(
                        color: Color(0x8F909090)
                            .withOpacity(0.9),
                        fontFamily: 'Tajawal'
                    ),
                    filled: true,
                    hintText: 'email@address.com',
                    hintStyle: TextStyle(
                        color:  Color(0x8F909090)
                            .withOpacity(0.9),
                        fontFamily: 'Tajawal'
                    ),

                    fillColor: Colors.white.withOpacity(0.9),
                      counterText: ""
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
                  maxLength: 15,
                  obscureText: true,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  controller: _passController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: validatePassword,
                  cursorColor: Color.fromARGB(255, 37, 43, 121),
                  style: TextStyle(
                      color: Color.fromARGB(255, 15, 53, 120).withOpacity(0.9),
                      fontFamily: 'Tajawal'
                  ),
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
                          const BorderSide(color: Color(0x76909090), width: 1.0),
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
                        fontFamily: 'Tajawal'
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.9),
                      counterText: ""
                  ),
                  //keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 20,
                ),
                //----Phone Number Field----
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: phonenumberController,
                  maxLength: 10,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,


                  validator: MultiValidator([
                    RequiredValidator(errorText: 'مطلوب *'),
                    PatternValidator(r'^(05)([0-9]{8})$',
                        errorText: 'أدخل رقم هاتف صالح')
                  ]),
                  cursorColor: Color.fromARGB(255, 37, 43, 121),
                  style: TextStyle(
                      color: Color.fromARGB(255, 15, 53, 120).withOpacity(0.9),
                      fontFamily: 'Tajawal'
                  ),

                  decoration: InputDecoration(
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
                          const BorderSide(color: Color(0x76909090), width: 1.0),
                    ),
                    prefixIcon: Icon(
                        Icons.phone,
                      color: Color(0x8F909090),
                    ),
                    iconColor: Colors.white,
                    labelText: "رقم الهاتف",
                    labelStyle: TextStyle(
                        color: Color(0x76909090)
                            .withOpacity(0.9),
                        fontFamily: 'Tajawal'
                    ),
                    hintText: '05XXXXXXXX',
                    hintStyle: TextStyle(
                        color: Color(0x76909090)
                            .withOpacity(0.9),
                        fontFamily: 'Tajawal'
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.9),
                    counterText: ""
                  ),

                  keyboardType: TextInputType.phone,
                  //--------------------------------------
                ),
                const SizedBox(
                  height: 20,
                ),
                //-------birthday field----------
                GestureDetector(
                  child: TextFormField(
                    controller: dateofbirthController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,

                    validator: MultiValidator([
                      RequiredValidator(errorText: 'مطلوب *'),
                    ]),
                    cursorColor: Color.fromARGB(255, 37, 43, 121),
                    style: TextStyle(
                        color:
                            Color.fromARGB(255, 15, 53, 120).withOpacity(0.9),
                        fontFamily: 'Tajawal'
                    ),

                    decoration: InputDecoration(
                      prefixIcon: Icon(
                          Icons.calendar_today,
                        color: Color(0x8F909090),
                      ),
                      iconColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                              color: Color(0x76909090), width: 1.0)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 15, 53, 120),
                            width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                            const BorderSide(color: Color(0x76909090), width: 1.0),
                      ),

                      labelText: "تاريخ الميلاد",
                      labelStyle: TextStyle(
                          fontFamily: 'Tajawal',
                        color:  Color(0x8F444444)
                      )//label text of field
                    ),
                    readOnly:
                        true, //set it true, so that user will not able to edit text
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime(2012, 12, 31, 0, 0),
                          firstDate: DateTime(1930),
                          lastDate: DateTime(2012, 12, 31, 0, 0),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(


                              textTheme: TextTheme(
                                headline3: TextStyle(
                                    fontFamily: 'Tajawal'
                                ),
                                headline4: TextStyle(
                                    fontFamily: 'Tajawal'
                                ),
                                headline5: TextStyle(
                                    fontFamily: 'Tajawal'
                                ), // Selected Date landscape
                                headline6: TextStyle(
                                    fontFamily: 'Tajawal'
                                ), // Selected Date portrait
                                overline: TextStyle(
                                    fontFamily: 'Tajawal'
                                ),// Title - SELECT DATE
                                bodyText1: TextStyle(
                                    fontFamily: 'Tajawal'
                                ), // year gridbview picker
                                subtitle1: TextStyle(
                                    fontFamily: 'Tajawal'
                                ), // input
                                subtitle2: TextStyle(
                                    fontFamily: 'Tajawal'
                                ), // month/year picker
                                caption: TextStyle(
                                    fontFamily: 'Tajawal'
                                ),
                              ),

                              colorScheme: ColorScheme.light(
                                primary: Color(0x1D8BA8DE), // <-- SEE HERE
                                onPrimary: Color(0xFF0F3578), // <-- SEE HERE
                                onSurface: Color(0xFF0F3578), // <-- SEE HERE
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  primary: Color(0xFF393939),
                                  textStyle: TextStyle(
                                    fontFamily: 'Tajawal',
                                    fontWeight: FontWeight.w500
                                  )// button text color
                                ),
                              ),
                            ),
                            child: child!,

                          );
                        },


                      );

                      if (pickedDate != null) {
                        print(
                            pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate =
                            DateFormat('dd-MM-yyyy').format(pickedDate);
                        print(formattedDate); //formatted date output using intl package =>  2021-03-16
                        //you can implement different kind of Date Format here according to your requirement

                        setState(() {
                          dateofbirthController.text =
                              formattedDate; //set output date to TextField value.
                        });
                      } else {
                        print("لم يتم اختيار تاريخ");
                      }
                    },
                    //--------------------------------------
                  ),
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
                      : SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: ElevatedButton(
                            onPressed: () async {
                              register(_emailController.text.trim(),
                                  _passController.text);
                            },
                            child: Text(
                              'تسجيل',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
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
        SizedBox(height: 40,),
        const Text("لديك حساب بالفعل؟ ",
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
                  builder: (context) => LoginPage(),
                ));
          },
          child: const Text(
            "تسجيل دخول",
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

  Future signup() async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passController.text)
          .then((value) => Navigator.pop(
              context, MaterialPageRoute(builder: (context) => LoginPage())));
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                content: Text('تم إنشاء الحساب بنجاح'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context,
                        MaterialPageRoute(builder: (context) => LoginPage())),
                    child: const Text('حسنًا'),
                  )
                ]);
          });
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ));
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

  void register(String email, String password) async {
    if (_key.currentState!.validate()) {
      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {postDetailsToFirestore()});
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
          "requires-recent-login": 'يتطلب تسجيل دخول حديث'
        };
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                  content: Text(codeResponses[e.code]!),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'حسنًا'),
                      child: const Text('حسنًا'),
                    )
                  ]);
            });
      }
    }
  }

  postDetailsToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    // writing all the values
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.firstName = firstnameController.text;
    userModel.secondName = lastnameController.text;
    userModel.phonenumber = phonenumberController.text;
    userModel.dateofbirth = dateofbirthController.text;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(
        msg: "تم إنشاء حسابك بنجاح",
      backgroundColor: Color(0xBC082245),

    );
//0509483390
    Navigator.pushAndRemoveUntil((context),
        MaterialPageRoute(builder: (context) => HomePage()), (route) => false);
  }
}

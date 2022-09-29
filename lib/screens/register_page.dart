import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import '../methods/authentication_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
//import 'package:loginlogout_resetpass/register_page.dart';
import '../reusable_widget/reusable_widget.dart';
import 'reset_page.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'login_page.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/date_symbols.dart';
import 'package:intl/date_symbol_data_custom.dart';
import 'package:intl/intl.dart';
import 'package:taqdaa_application/model/user_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../profile/homep_profile.dart';

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
    else if (formPassword.length < 8)
      return 'Should be at least 8 chatacter.';
    else if (formPassword.length > 15)
      return 'Should be less than 15 chatacter.';
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        //key: _key,
        //autovalidateMode: AutovalidateMode.onUserInteraction,
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
                SignupcloudDcrWidget("assets/SignupGroup.png"),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: firstnameController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'Required *'),
                    PatternValidator(r'^[a-z A-Z]+$',
                        errorText: 'name should contain onley letters')
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
                    prefixIcon: Icon(Icons.person),
                    iconColor: Colors.white,
                    labelText: "Enter your First Name",
                    labelStyle: TextStyle(
                        color: Color.fromARGB(236, 113, 113, 117)
                            .withOpacity(0.9)),
                    filled: true,

                    fillColor: Colors.white.withOpacity(0.9),
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
                  controller: lastnameController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,

                  validator: MultiValidator([
                    RequiredValidator(errorText: 'Required *'),
                    PatternValidator(r'^[a-z A-Z]+$',
                        errorText: 'name should contain only letters')
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
                    prefixIcon: Icon(Icons.person),
                    iconColor: Colors.white,
                    labelText: "Enter your Last Name",
                    labelStyle: TextStyle(
                        color: Color.fromARGB(236, 113, 113, 117)
                            .withOpacity(0.9)),
                    filled: true,

                    fillColor: Colors.white.withOpacity(0.9),
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
                    RequiredValidator(errorText: 'Requiered *'),
                    PatternValidator(
                        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
                        errorText: 'Invalid Password'),
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
                    labelText: "Enter your password",
                    labelStyle: TextStyle(
                        color: Color.fromARGB(236, 113, 113, 117)
                            .withOpacity(0.9)),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.9),
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
                    RequiredValidator(errorText: 'Required *'),
                    PatternValidator(r'^(?:[+0][1-9])?[0-9]{10,12}$',
                        errorText: 'Enter a valid phone number')
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
                    prefixIcon: Icon(Icons.phone),
                    iconColor: Colors.white,
                    labelText: "Enter your Phone Number",
                    labelStyle: TextStyle(
                        color: Color.fromARGB(236, 113, 113, 117)
                            .withOpacity(0.9)),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.9),
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
                      RequiredValidator(errorText: 'Required *'),
                    ]),
                    cursorColor: Color.fromARGB(255, 37, 43, 121),
                    style: TextStyle(
                        color:
                            Color.fromARGB(255, 15, 53, 120).withOpacity(0.9)),

                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.calendar_today),
                      iconColor: Colors.white,
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
                        borderSide:
                            const BorderSide(color: Colors.orange, width: 2.0),
                      ),

                      labelText: "Enter Date Of Birth", //label text of field
                    ),
                    readOnly:
                        true, //set it true, so that user will not able to edit text
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime(2012, 12, 31, 0, 0),
                          firstDate: DateTime(1930),
                          lastDate: DateTime(2012, 12, 31, 0, 0));

                      if (pickedDate != null) {
                        print(
                            pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate =
                            DateFormat('dd-MM-yyyy').format(pickedDate);
                        print(
                            formattedDate); //formatted date output using intl package =>  2021-03-16
                        //you can implement different kind of Date Format here according to your requirement

                        setState(() {
                          dateofbirthController.text =
                              formattedDate; //set output date to TextField value.
                        });
                      } else {
                        print("Date is not selected");
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
                          width: 200,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () async {
                              register(_emailController.text.trim(),
                                  _passController.text);
                            },
                            child: Text(
                              'SIGN UP',
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
            "Log in",
            style: TextStyle(
                decoration: TextDecoration.underline,
                color: Color.fromARGB(255, 15, 53, 120),
                fontWeight: FontWeight.bold),
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
                content: Text('Account created sucessfully'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context,
                        MaterialPageRoute(builder: (context) => LoginPage())),
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

  void register(String email, String password) async {
    if (_key.currentState!.validate()) {
      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {postDetailsToFirestore()})
            .catchError((e) {
          Fluttertoast.showToast(msg: e!.message);
        });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMsg = "Your email address appears to be malformed.";
            break;
          case "wrong-password":
            errorMsg = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMsg = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMsg = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMsg = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMsg = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMsg = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: errorMsg);
        print(error.code);
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
    Fluttertoast.showToast(msg: "Account created successfully :) ");

    Navigator.pushAndRemoveUntil((context),
        MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
  }
}

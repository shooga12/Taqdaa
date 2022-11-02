import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:taqdaa_application/screens/insideMore.dart';
import '../confige/EcommerceApp.dart';
import 'package:intl/intl.dart';
import '../views/changePass_view.dart';
import '../views/profile_view.dart';

class Edit extends StatefulWidget {
  const Edit({Key? key}) : super(key: key);

  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  bool isInsideHome = false;
  bool isInsideReceipt = false;
  bool isInsideMore = true;
  bool isInsideCart = false;
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final emailController = TextEditingController();
  final phonenumberController = TextEditingController();
  final dateofbirthController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  String documentName = EcommerceApp().getCurrentUser();
  String errorMsg = '';
  bool isLoading = false;

  static var _firestore;

  static Future<String?> changePassword(
      String oldPassword, String newPassword) async {
    User user = FirebaseAuth.instance.currentUser!;
    AuthCredential credential =
        EmailAuthProvider.credential(email: user.email!, password: oldPassword);

    Map<String, String?> codeResponses = {
      // Re-auth responses
      "user-mismatch": null,
      "user-not-found": null,
      "invalid-credential": null,
      "invalid-email": null,
      "wrong-password": null,
      "invalid-verification-code": null,
      "invalid-verification-id": null,
      // Update password error codes
      "weak-password": null,
      "requires-recent-login": null
    };

    try {
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
      return null;
    } on FirebaseAuthException catch (error) {
      return codeResponses[error.code] ?? "Unknown";
    }
  }

  String? validateEmail(String? formEmail) {
    if (formEmail == null || formEmail.isEmpty)
      return 'البريد الالكتروني مطلوب';

    String pattern = r'\w+@\w+\.\w+';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(formEmail)) return 'صيغة البريد الالكتروني غير صحيحة';

    return null;
  }

  @override
  void initState() {
    super.initState();
    firstnameController.text = EcommerceApp.loggedInUser.firstName!;
    lastnameController.text = EcommerceApp.loggedInUser.secondName!;
    emailController.text = EcommerceApp.loggedInUser.email!;
    phonenumberController.text = EcommerceApp.loggedInUser.phonenumber!;
    dateofbirthController.text = EcommerceApp.loggedInUser.dateofbirth!;
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
          "تعديل الحساب",
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
                            TextFormField(
                              //enabled: false,
                              // initialValue: loggedInUser.firstName,
                              controller: firstnameController,

                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: MultiValidator([
                                RequiredValidator(errorText: 'مطلوب*'),
                                PatternValidator(
                                    r'^[\u0600-\u065F\u066A-\u06EF\u06FA-\u06FFa-zA-Z]+[\u0600-\u065F\u066A-\u06EF\u06FA-\u06FFa-zA-Z-_]*$',
                                    //r'^[a-z A-Z]+$ || r^/[\u0600-\u065F\u066A-\u06EF\u06FA-\u06FF]/',
                                    errorText: 'يجب أن يتكون الأسم من حروف فقط')
                              ]),
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
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Colors.black,
                                ),
                                iconColor: Colors.white,
                                labelText: "الاسم الاول",
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.9),
                              ),

                              keyboardType: TextInputType.name,
                              //--------------------------------------
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              controller: lastnameController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,

                              validator: MultiValidator([
                                RequiredValidator(errorText: 'مطلوب *'),
                                PatternValidator(
                                    r'^[\u0600-\u065F\u066A-\u06EF\u06FA-\u06FFa-zA-Z]+[\u0600-\u065F\u066A-\u06EF\u06FA-\u06FFa-zA-Z-_]*$',
                                    errorText: 'يجب أن يتكون الأسم من حروف فقط')
                              ]),
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
                                    Icon(Icons.person, color: Colors.black),
                                iconColor: Colors.white,
                                labelText: "الاسم الاخير",
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.9),
                              ),

                              keyboardType: TextInputType.name,
                              //--------------------------------------
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            //email field
                            TextFormField(
                              controller: emailController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,

                              validator: MultiValidator([
                                RequiredValidator(errorText: 'مطلوب *'),
                                EmailValidator(
                                    errorText: 'البريد الالكتروني غير صالح*')
                              ]),
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
                                    Icon(Icons.email, color: Colors.black),
                                iconColor: Colors.white,
                                labelText: "البريد الالكتروني",
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.9),
                              ),

                              keyboardType: TextInputType.emailAddress,
                              //--------------------------------------
                            ),

                            const SizedBox(
                              height: 15,
                            ),
                            //----Phone Number Field----
                            TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: phonenumberController,
                              maxLength: 10,
                              maxLengthEnforcement:
                                  MaxLengthEnforcement.enforced,

                              validator: MultiValidator([
                                RequiredValidator(errorText: 'مطلوب *'),
                                PatternValidator(
                                  r'^(05)([0-9]{8})$',
                                  errorText:
                                      " أدخل رقم هاتف يبدأ بمفتاح الدولة و يحتوي على 10 ارقام",
                                ),
                              ]),
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
                                    Icon(Icons.phone, color: Colors.black),
                                iconColor: Colors.white,
                                labelText: "رقم الهاتف",
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.9),
                              ),

                              keyboardType: TextInputType.phone,
                              //--------------------------------------
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            //-------birthday field----------
                            GestureDetector(
                              child: TextFormField(
                                controller: dateofbirthController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,

                                validator: MultiValidator([
                                  RequiredValidator(errorText: 'مطلوب *'),
                                ]),
                                cursorColor: Color.fromARGB(255, 37, 43, 121),
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black),

                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.calendar_today,
                                      color: Colors.black),
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
                                    borderSide: const BorderSide(
                                        color: Colors.orange, width: 2.0),
                                  ),
                                  labelText: 'تاريخ الميلاد',
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
                                        DateFormat('dd-MM-yyyy')
                                            .format(pickedDate);
                                    print(
                                        formattedDate); //formatted date output using intl package =>  2021-03-16
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
                          checkNull();
                          if (Fname == false &&
                              Lname == false &&
                              email == false &&
                              phone == false &&
                              date == false) {
                            showDialog(
                                context: context,
                                builder: ((context) {
                                  return AlertDialog(
                                    title: Text('لم تجري أي تعديلات!'),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("حسنّا"))
                                    ],
                                  );
                                }));
                          } else if (isValidFName &&
                              isValidLName &&
                              isValidEmail &&
                              isValidPhone) {
                            showDialog(
                                context: context,
                                builder: ((context) {
                                  return AlertDialog(
                                    title: Text("هل تريد حفظ التعديلات؟"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              duration:
                                                  const Duration(seconds: 2),
                                              backgroundColor: Color.fromARGB(
                                                  255, 135, 155, 190),
                                              content: Text(
                                                  "تم حفظ التعديلات بنجاح",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      letterSpacing: 0.8)),
                                              action: null,
                                            ));
                                            saveChanges();
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => More(),
                                                ));
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      Homepprofile(),
                                                ));
                                          },
                                          child: Text(
                                            "نعم",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 96, 183, 99)),
                                          )),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("إلغاء"))
                                    ],
                                  );
                                }));
                          }
                        },
                        child: Text(
                          'حفظ التعديلات',
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
                  Padding(
                      padding: EdgeInsets.only(top: 15.0, right: 90.0),
                      child: SizedBox(
                        width: 200,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UpdatePass()));
                          },
                          child: Text(
                            'تغيير كلمة المرور',
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
                                return Color.fromARGB(255, 118, 171, 223);
                              }),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30)))),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool? isFnameValid;
  bool? isLnameValid;
  bool? isEmailValid;
  bool? isPhoneValid;

  isValidFields() {
    isValidFName ? isFnameValid = true : isFnameValid = false;
    isValidLName ? isLnameValid = true : isLnameValid = false;
    isValidEmail ? isEmailValid = true : isEmailValid = false;
    isValidPhone ? isPhoneValid = true : isPhoneValid = false;

    return isFnameValid! && isLnameValid! && isEmailValid! && isPhoneValid!;
    //return isValidFName && isValidLName && isValidEmail && isValidPhone;
  }

  bool get isValidFName {
    final nameRegExp = RegExp(
        r'^[\u0600-\u065F\u066A-\u06EF\u06FA-\u06FFa-zA-Z]+[\u0600-\u065F\u066A-\u06EF\u06FA-\u06FFa-zA-Z-_]*$');
    return nameRegExp.hasMatch(firstnameController.text);
  }

  bool get isValidLName {
    final nameRegExp = RegExp(
        r'^[\u0600-\u065F\u066A-\u06EF\u06FA-\u06FFa-zA-Z]+[\u0600-\u065F\u066A-\u06EF\u06FA-\u06FFa-zA-Z-_]*$');

    return nameRegExp.hasMatch(lastnameController.text);
  }

  bool get isValidEmail {
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegExp.hasMatch(emailController.text);
  }

  bool get isValidPhone {
    final phoneRegExp = RegExp(r'^(05)([0-9]{8})$');
    return phoneRegExp.hasMatch(phonenumberController.text);
  }

  bool? Fname;
  bool? Lname;
  bool? email;
  bool? phone;
  bool? date;

  checkNull() {
    firstnameController.text == EcommerceApp.loggedInUser.firstName!
        ? Fname = false
        : Fname = true;
    lastnameController.text == EcommerceApp.loggedInUser.secondName!
        ? Lname = false
        : Lname = true;
    emailController.text == EcommerceApp.loggedInUser.email!
        ? email = false
        : email = true;
    phonenumberController.text == EcommerceApp.loggedInUser.phonenumber!
        ? phone = false
        : phone = true;
    dateofbirthController.text == EcommerceApp.loggedInUser.dateofbirth!
        ? date = false
        : date = true;
  }

  saveChanges() {
    var saveUser =
        FirebaseFirestore.instance.collection('users').doc(documentName);

    if (firstnameController.text.isNotEmpty) {
      Fname = true;
      saveUser.update({'firstName': firstnameController.text});
    }
    if (lastnameController.text.isNotEmpty) {
      Lname = true;
      saveUser.update({'secondName': lastnameController.text});
    }
    if (emailController.text.isNotEmpty) {
      email = true;
      saveUser.update({'email': emailController.text});
    }
    if (phonenumberController.text.isNotEmpty) {
      phone = true;
      saveUser.update({'phonenumber': phonenumberController.text});
    }
    if (phonenumberController.text.isNotEmpty) {
      date = true;
      saveUser.update({'dateofbirth': dateofbirthController.text});
    }
  }
}

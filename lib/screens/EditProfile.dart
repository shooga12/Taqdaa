import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import '../confige/EcommerceApp.dart';
import '../controller/BNBCustomePainter.dart';
import '../model/user_model.dart';
import '../screens/ShoppingCart.dart';
import '../screens/insideMore.dart';
import '../screens/invoices.dart';
import '../screens/list_of_stores.dart';
import '../screens/NoItmesCart.dart';
import 'package:intl/intl.dart';
import '../profile/homep_profile.dart';

class Edit extends StatefulWidget {
  const Edit({Key? key}) : super(key: key);

  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
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
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
      firstnameController.text = loggedInUser.firstName!;
      lastnameController.text = loggedInUser.secondName!;
      emailController.text = loggedInUser.email!;
      phonenumberController.text = loggedInUser.phonenumber!;
      dateofbirthController.text = loggedInUser.dateofbirth!;
    });
  }

  String CurrentUser = "";
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          "تعديل الحساب",
          style: TextStyle(fontSize: 24),
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
                                  //r'^(?:[+0][1-9])?[0-9]{10,12}$',
                                  //r"^\+?0[0-9]{10}$",
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
                                            saveChanges();
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
                                              color: Colors.red,
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
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: size.width,
              height: 80,
              color: Colors.white,
              child: Stack(
                children: [
                  CustomPaint(
                    size: Size(size.width, 80),
                    painter: BNBCustomePainter(),
                  ),
                  Center(
                      heightFactor: 0.6,
                      child: Container(
                        width: 65,
                        height: 65,
                        child: FittedBox(
                          child: FloatingActionButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ListOfStores2()),
                              );
                            },
                            backgroundColor: Colors.orange,
                            child: Icon(
                              Icons.document_scanner_outlined,
                              size: 27,
                            ),
                            //elevation: 0.1,
                          ),
                        ),
                      )),
                  Container(
                    width: size.width,
                    height: 80,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.home_outlined,
                                size: 35,
                                color: isInsideHome
                                    ? Color.fromARGB(255, 254, 176, 60)
                                    : Colors.white,
                              )),
                          IconButton(
                              onPressed: () {
                                if (EcommerceApp.haveItems) {
                                  /////bug fixes
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => shoppingCart()),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => emptyCart()),
                                  );
                                }
                              },
                              icon: Icon(
                                Icons.shopping_cart,
                                size: 30,
                                color: isInsideCart
                                    ? Color.fromARGB(255, 254, 176, 60)
                                    : Colors.white,
                              )),
                          Container(
                            width: size.width * 0.20,
                          ),
                          IconButton(
                              onPressed: () {
                                //here reem's page
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => invoices(),
                                    ));
                              },
                              icon: Icon(
                                Icons.receipt_long,
                                size: 30,
                                color: isInsideReceipt
                                    ? Color.fromARGB(255, 254, 176, 60)
                                    : Colors.white,
                              )),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => More()),
                              );
                            },
                            icon: Icon(
                              Icons.more_horiz,
                              size: 30,
                              color: isInsideMore
                                  ? Color.fromARGB(255, 254, 176, 60)
                                  : Colors.white,
                            ),
                          ),
                        ]),
                  )
                ],
              ),
            ),
          )
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
    firstnameController.text == loggedInUser.firstName!
        ? Fname = false
        : Fname = true;
    lastnameController.text == loggedInUser.secondName!
        ? Lname = false
        : Lname = true;
    emailController.text == loggedInUser.email! ? email = false : email = true;
    phonenumberController.text == loggedInUser.phonenumber!
        ? phone = false
        : phone = true;
    dateofbirthController.text == loggedInUser.dateofbirth!
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

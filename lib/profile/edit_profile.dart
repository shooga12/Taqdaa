import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:taqdaa_application/main.dart';
import 'package:taqdaa_application/screens/home_page.dart';
import '../confige/EcommerceApp.dart';
import '../controller/BNBCustomePainter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taqdaa_application/screens/login_page.dart';
import '../methods/authentication_services.dart';
import '../model/user_model.dart';
import '../screens/ShoppingCart.dart';
import '../screens/list_of_stores.dart';
import '../screens/NoItmesCart.dart';
import 'homep_profile.dart';

class Editprofile extends StatefulWidget {
  const Editprofile({Key? key}) : super(key: key);

  @override
  _EditprofileState createState() => _EditprofileState();
}

class _EditprofileState extends State<Editprofile> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  bool isInsideHome = false;
  bool isInsideProfile = true;
  bool isInsidelogout = false;

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
    });
  }

  String CurrentUser = "";
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "حسابي",
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
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: firstnameController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: MultiValidator([
                      PatternValidator(r'^[a-z A-Z]+$',
                          errorText: 'يجب أن يتكون الأسم من حروف فقط')
                    ]),
                    cursorColor: Color.fromARGB(255, 37, 43, 121),
                    style: TextStyle(
                        color:
                            Color.fromARGB(255, 15, 53, 120).withOpacity(0.9)),
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
                        borderSide:
                            const BorderSide(color: Colors.orange, width: 2.0),
                      ),
                      prefixIcon: Icon(Icons.person),
                      iconColor: Colors.white,
                      labelText: " ${loggedInUser.firstName}",
                      labelStyle: TextStyle(
                          color: Color.fromARGB(236, 113, 113, 117)
                              .withOpacity(0.9)),
                      filled: true,

                      fillColor: Colors.white.withOpacity(0.9),
                      // border: OutlineInputBorder(
                      //  borderRadius: BorderRadius.circular(30.0),),
                    ),
                    keyboardType: TextInputType.name,
                  ),

// last name
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: firstnameController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: MultiValidator([
                      PatternValidator(r'^[a-z A-Z]+$',
                          errorText: 'يجب أن يتكون الأسم من حروف فقط')
                    ]),
                    cursorColor: Color.fromARGB(255, 37, 43, 121),
                    style: TextStyle(
                        color:
                            Color.fromARGB(255, 15, 53, 120).withOpacity(0.9)),
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
                        borderSide:
                            const BorderSide(color: Colors.orange, width: 2.0),
                      ),
                      prefixIcon: Icon(Icons.person),
                      iconColor: Colors.white,
                      labelText: " ${loggedInUser.secondName}",
                      labelStyle: TextStyle(
                          color: Color.fromARGB(236, 113, 113, 117)
                              .withOpacity(0.9)),
                      filled: true,

                      fillColor: Colors.white.withOpacity(0.9),
                      // border: OutlineInputBorder(
                      //  borderRadius: BorderRadius.circular(30.0),),
                    ),
                    keyboardType: TextInputType.name,
                  ),

                  // ListTile(
                  //   title: Text(
                  //     'Name',
                  //     style: TextStyle(fontSize: 22),
                  //   ),
                  //   subtitle: Text(
                  //     "${loggedInUser.firstName} ${loggedInUser.secondName}",
                  //     style: TextStyle(fontSize: 22),
                  //   ),
                  // ),

                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _emailController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,

                    validator: MultiValidator([
                      EmailValidator(errorText: 'البريد الالكتروني غير صالح*')
                    ]),
                    cursorColor: Color.fromARGB(255, 37, 43, 121),
                    style: TextStyle(
                        color:
                            Color.fromARGB(255, 15, 53, 120).withOpacity(0.9)),

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
                        borderSide:
                            const BorderSide(color: Colors.orange, width: 2.0),
                      ),
                      prefixIcon: Icon(Icons.email),
                      iconColor: Colors.white,
                      labelText: "${loggedInUser.email}",
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
                  // ListTile(
                  //   title: Text(
                  //     'Email',
                  //     style: TextStyle(fontSize: 22),
                  //   ),
                  //   subtitle: Text(
                  //     "${loggedInUser.email}",
                  //     style: TextStyle(fontSize: 22),
                  //   ),
                  // ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: phonenumberController,
                    maxLength: 10,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,

                    validator: MultiValidator([
                      PatternValidator(r'^(?:[+0][1-9])?[0-9]{10,12}$',
                          errorText: 'أدخل رقم هاتف صالح')
                    ]),
                    cursorColor: Color.fromARGB(255, 37, 43, 121),
                    style: TextStyle(
                        color:
                            Color.fromARGB(255, 15, 53, 120).withOpacity(0.9)),

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
                        borderSide:
                            const BorderSide(color: Colors.orange, width: 2.0),
                      ),
                      prefixIcon: Icon(Icons.phone),
                      iconColor: Colors.white,
                      labelText: "${loggedInUser.phonenumber}",
                      labelStyle: TextStyle(
                          color: Color.fromARGB(236, 113, 113, 117)
                              .withOpacity(0.9)),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),
                    ),

                    keyboardType: TextInputType.phone,
                    //--------------------------------------
                  ),

                  // ListTile(
                  //   title: Text(
                  //     'Phone Number',
                  //     style: TextStyle(fontSize: 22),
                  //   ),
                  //   subtitle: Text(
                  //     "${loggedInUser.phonenumber}",
                  //     style: TextStyle(fontSize: 22),
                  //   ),
                  // ),
                  SizedBox(
                    height: 10,
                  ),

                  GestureDetector(
                    child: TextFormField(
                      controller: dateofbirthController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,

                      validator: MultiValidator([]),
                      cursorColor: Color.fromARGB(255, 37, 43, 121),
                      style: TextStyle(
                          color: Color.fromARGB(255, 15, 53, 120)
                              .withOpacity(0.9)),

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
                          borderSide: const BorderSide(
                              color: Colors.orange, width: 2.0),
                        ),

                        labelText:
                            "${loggedInUser.dateofbirth}", //label text of field
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
                          print("لم يتم اختيار تاريخ");
                        }
                      },
                      //--------------------------------------
                    ),
                  ),

                  // ListTile(
                  //   title: Text(
                  //     'Date of Birth',
                  //     style: TextStyle(fontSize: 22),
                  //   ),
                  //   subtitle: Text(
                  //     "${loggedInUser.dateofbirth}",
                  //     style: TextStyle(fontSize: 22),
                  //   ),
                  // ),
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
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyHomePage()),
                                );
                              },
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
                                color: Colors.white,
                              )),
                          Container(
                            width: size.width * 0.20,
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.person,
                                size: 30,
                                color: isInsideProfile
                                    ? Color.fromARGB(255, 254, 176, 60)
                                    : Colors.white,
                              )),
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
}

// ignore: non_constant_identifier_names
DateFormat(String s) {}

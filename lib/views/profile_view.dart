import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:taqdaa_application/screens/home_page.dart';
import '../confige/EcommerceApp.dart';
import '../controller/BNBCustomePainter.dart';
import 'package:taqdaa_application/screens/login_page.dart';
import '../main.dart';
import '../methods/authentication_services.dart';
import '../models/user_model.dart';
import '../screens/EditProfile.dart';

class Homepprofile extends StatefulWidget {
  const Homepprofile({Key? key}) : super(key: key);

  @override
  _HomepprofileState createState() => _HomepprofileState();
}

class _HomepprofileState extends State<Homepprofile> {
  User? user = FirebaseAuth.instance.currentUser;
  //UserModel loggedInUser = UserModel();
  bool isInsideHome = false;
  bool isInsideReceipt = false;
  bool isInsideMore = true;
  bool isInsideCart = false;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      EcommerceApp.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          "حسابي",
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w100,
              fontFamily: 'Tajawal'
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Edit()),
              );
            },
          )
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/AppBar.png"), fit: BoxFit.fill)),
        ),
        centerTitle: true,
        toolbarHeight: 90,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(top: 40),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.orange, width: 2.0, //<-- SEE HERE
                      ),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    color: Colors.white,
                    child: Container(
                        alignment: Alignment.centerLeft,
                        height: 60,
                        width: 370,
                        child: Row(
                          children: [
                            Text("   "),
                            Icon(Icons.person),
                            Text(
                              " ${EcommerceApp.loggedInUser.firstName} ${EcommerceApp.loggedInUser.secondName}",
                              style: TextStyle(
                                  fontSize: 20,
                                  letterSpacing: 0.8,
                                  color: Colors.black,
                                  fontFamily: 'Tajawal'
                              ),
                            ),
                          ],
                        )),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.orange, width: 2.0, //<-- SEE HERE
                      ),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    color: Colors.white,
                    child: Container(
                        alignment: Alignment.centerLeft,
                        height: 60,
                        width: 370,
                        child: Row(
                          children: [
                            Text("   "),
                            Icon(Icons.mail),
                            Text(
                              " ${EcommerceApp.loggedInUser.email}",
                              style: TextStyle(
                                  fontSize: 18,
                                  letterSpacing: 0.8,
                                  color: Colors.black,
                                  fontFamily: 'Tajawal'
                              ),
                            ),
                          ],
                        )),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.orange, width: 2.0, //<-- SEE HERE
                      ),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    color: Colors.white,
                    child: Container(
                        alignment: Alignment.centerLeft,
                        height: 60,
                        width: 370,
                        child: Row(
                          children: [
                            Text("   "),
                            Icon(Icons.phone_enabled),
                            Text(
                              " ${EcommerceApp.loggedInUser.phonenumber}",
                              style: TextStyle(
                                  fontSize: 20,
                                  letterSpacing: 0.8,
                                  color: Colors.black,
                                  fontFamily: 'Tajawal'
                              ),
                            ),
                          ],
                        )),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.orange, width: 2.0, //<-- SEE HERE
                      ),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    color: Colors.white,
                    child: Container(
                        alignment: Alignment.centerLeft,
                        height: 60,
                        width: 370,
                        child: Row(
                          children: [
                            Text("   "),
                            Icon(Icons.calendar_month),
                            Text(
                              " ${EcommerceApp.loggedInUser.dateofbirth}",
                              style: TextStyle(
                                  fontSize: 20,
                                  letterSpacing: 0.8,
                                  color: Colors.black,
                                  fontFamily: 'Tajawal'
                              ),
                            ),
                          ],
                        )),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 15.0),
                  child: SizedBox(
                    width: 350,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () async {
                        showDialog(
                            context: context,
                            builder: ((context) {
                              return AlertDialog(
                                title: Text(
                                  "هل تريد تسجيل الخروج؟",
                                  style: TextStyle(
                                      fontFamily: 'Tajawal',
                                      fontSize: 18
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        FirebaseAuthMethods().signOut();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => LoginPage(),
                                            ));
                                      },
                                      child: Text(
                                        "تسجيل خروج",
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontFamily: 'Tajawal'
                                        ),
                                      )),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "إلغاء",
                                        style: TextStyle(
                                            fontFamily: 'Tajawal'
                                        ),
                                      ))
                                ],
                              );
                            }));
                      },
                      child: Text(
                        'تسجيل الخروج',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
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
                          shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)))),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: SizedBox(
                    width: 350,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () async {
                        showDialog(
                            context: context,
                            builder: ((context) {
                              return AlertDialog(
                                title: Text(
                                    "هل تريد حذف الحساب بالفعل؟",
                                  style: TextStyle(
                                      fontFamily: 'Tajawal'
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        deleteUser(
                                            "${EcommerceApp.loggedInUser.uid}");
                                        user!.delete();

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => LoginPage(),
                                            ));
                                        Fluttertoast.showToast(
                                            msg: "تم حذف الحساب بنجاح");
                                      },
                                      child: Text(
                                        "حذف الحساب",
                                        style: TextStyle(
                                          color: Color(0xBEE72323),
                                            fontFamily: 'Tajawal'
                                        ),
                                      )),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("إلغاء",
                                        style: TextStyle(
                                            fontFamily: 'Tajawal'
                                        ),
                                      ))
                                ],
                              );
                            }));
                      },
                      child: Text(
                        "حذف الحساب",
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            fontFamily: 'Tajawal'
                        ),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith((states) {
                            if (states.contains(MaterialState.pressed)) {
                              return Colors.grey;
                            }
                            return Color(0xCECE0B0B);
                          }),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)))),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> logout(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: ((context) => LoginPage())));
}

Future<void> deleteUser(String uid) async {
  final account =
      await FirebaseFirestore.instance.collection("users").doc('$uid').delete();
}

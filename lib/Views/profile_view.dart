import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../confige/EcommerceApp.dart';
import '../controller/BNBCustomePainter.dart';
import 'package:taqdaa_application/screens/login_page.dart';
import '../main.dart';
import '../methods/authentication_services.dart';
// import '../models/user_model.dart';
import '../model/user_model.dart';
import '../screens/EditProfile.dart';
import '../screens/ShoppingCart.dart';
import '../screens/insideMore.dart';
import 'invoices_view.dart';
import '../screens/list_of_stores.dart';
import 'NoItmesCart.dart';

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
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          "حسابي",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w100),
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
                  Padding(
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
                                    color: Colors.black),
                              ),
                            ],
                          )),
                    ),
                  ),
                  Padding(
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
                                    color: Colors.black),
                              ),
                            ],
                          )),
                    ),
                  ),
                  Padding(
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
                                    color: Colors.black),
                              ),
                            ],
                          )),
                    ),
                  ),
                  Padding(
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
                                    color: Colors.black),
                              ),
                            ],
                          )),
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
                          showDialog(
                              context: context,
                              builder: ((context) {
                                return AlertDialog(
                                  title: Text("هل تريد حذف الحساب بالفعل؟"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          deleteUser(
                                              "${EcommerceApp.loggedInUser.uid}");
                                          user!.delete();

                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginPage(),
                                              ));
                                          Fluttertoast.showToast(
                                              msg: "تم حذف الحساب بنجاح");
                                        },
                                        child: Text(
                                          "حذف الحساب",
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
                        },
                        child: Text(
                          "حذف الحساب",
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
                              return Colors.red;
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
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: ((context) {
                                return AlertDialog(
                                  // content: Container(
                                  //   height: 280,
                                  //   child: Column(
                                  //     children: [
                                  //       Padding(
                                  //         padding: const EdgeInsets.all(8.0),
                                  //         child: Image.asset(
                                  //           "assets/successfull_payment.png",
                                  //           height: 200,
                                  //         ),
                                  //       ),
                                  //       Padding(
                                  //         padding: const EdgeInsets.all(8.0),
                                  //         child: Text(
                                  //           "شكرًا لك، تم الدفع بنجاح !",
                                  //           style: TextStyle(
                                  //               fontSize: 20,
                                  //               color: Color.fromARGB(
                                  //                   255, 98, 160, 100)),
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  title: Text("هل تريد تسجيل الخروج؟"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          FirebaseAuthMethods().signOut();
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginPage(),
                                              ));
                                        },
                                        child: Text(
                                          "تسجيل خروج",
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
                        },
                        child: Text(
                          'تسجيل الخروج',
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

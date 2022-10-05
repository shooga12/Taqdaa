import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

class Homepprofile extends StatefulWidget {
  const Homepprofile({Key? key}) : super(key: key);

  @override
  _HomepprofileState createState() => _HomepprofileState();
}

class _HomepprofileState extends State<Homepprofile> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  bool isInsideHome = false;
  bool isInsideProfile = true;
  bool isInsidelogout = false;

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
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onPressed: () {
              // do something
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
                  Text.rich(
                    TextSpan(
                      style: TextStyle(
                        fontSize: 22,
                      ),
                      children: [
                        WidgetSpan(
                          child: Icon(Icons.person),
                        ),
                        TextSpan(
                          text:
                              " ${loggedInUser.firstName} ${loggedInUser.secondName}",
                        )
                      ],
                    ),
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
                  Text.rich(
                    TextSpan(
                      style: TextStyle(
                        fontSize: 22,
                      ),
                      children: [
                        WidgetSpan(
                          child: Icon(Icons.mail),
                        ),
                        TextSpan(
                          text: " ${loggedInUser.email}",
                        )
                      ],
                    ),
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
                  Text.rich(
                    TextSpan(
                      style: TextStyle(
                        fontSize: 22,
                      ),
                      children: [
                        WidgetSpan(
                          child: Icon(Icons.phone),
                        ),
                        TextSpan(
                          text: " ${loggedInUser.phonenumber}",
                        )
                      ],
                    ),
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

                  Text.rich(
                    TextSpan(
                      style: TextStyle(
                        fontSize: 22,
                      ),
                      children: [
                        WidgetSpan(
                          child: Icon(Icons.calendar_month),
                        ),
                        TextSpan(
                          text: " ${loggedInUser.dateofbirth}",
                        )
                      ],
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
                  Padding(
                    padding: EdgeInsets.only(top: 130.0, right: 45.0),
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
                                          deleteUser("${loggedInUser.uid}");
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
                              fontSize: 18),
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
                    padding: EdgeInsets.only(top: 20.0, right: 45.0),
                    child: SizedBox(
                      width: 200,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: ((context) {
                                return AlertDialog(
                                  title: Text("هل تريد تسجيل الخروج؟"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
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
                          IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: ((context) {
                                    return AlertDialog(
                                      title: Text("هل تريد تسجيل الخروج؟"),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              FirebaseAuthMethods().signOut();
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        LoginPage(),
                                                  ));
                                            },
                                            child: Text("تسجيل خروج")),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text("إلغاء"))
                                      ],
                                    );
                                  }));
                            },
                            icon: Icon(
                              Icons.logout,
                              size: 30,
                              color: isInsidelogout
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
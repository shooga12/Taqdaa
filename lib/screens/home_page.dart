import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:taqdaa_application/confige/EcommerceApp.dart';
import 'package:taqdaa_application/screens/NoItmesCart.dart';
import '../controller/BNBCustomePainter.dart';
import '../methods/authentication_services.dart';
import 'ShoppingCart.dart';
import 'insideMore.dart';
import 'invoices.dart';
import 'list_of_stores.dart';
import 'login_page.dart';
import 'scanBarCode.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../controller/NotificationApi.dart';
import '../profile/homep_profile.dart';
import 'package:taqdaa_application/model/user_model.dart';
import 'package:timezone/data/latest.dart' as tz;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  void initState() {
    super.initState();
    tz.initializeTimeZones();

    //NotificationApi.init();
    //listenNotifications();
  }

  // void listenNotifications() =>
  //     NotificationApi.onNotification.stream.listen(onClickNotification);

  // void onClickNotification(NotificationResponse? details) => Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => ListOfStores2()),
  //     );

  @override
  bool isInsideHome = true;
  bool isInsideReceipt = false;
  bool isInsideMore = false;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
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
                                color: Colors.white,
                              )),
                          Container(
                            width: size.width * 0.20,
                          ),
                          IconButton(
                              onPressed: () {
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

                              // showDialog(
                              //     context: context,
                              //     builder: ((context) {
                              //       return AlertDialog(
                              //         title: Text("هل تريد تسجيل الخروج؟"),
                              //         actions: [
                              //           TextButton(
                              //               onPressed: () {
                              //                 FirebaseAuthMethods().signOut();
                              //                 Navigator.push(
                              //                     context,
                              //                     MaterialPageRoute(
                              //                       builder: (context) =>
                              //                           LoginPage(),
                              //                     ));
                              //               },
                              //               child: Text(
                              //                 "تسجيل خروج",
                              //                 style: TextStyle(
                              //                   color: Colors.red,
                              //                 ),
                              //               )),
                              //           TextButton(
                              //               onPressed: () {
                              //                 Navigator.pop(context);
                              //               },
                              //               child: Text("إلغاء"))
                              //         ],
                              //       );
                              //     }));
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

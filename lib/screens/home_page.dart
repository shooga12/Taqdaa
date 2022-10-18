import 'dart:html';
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
import 'list_of_stores.dart';
import 'login_page.dart';
import 'scanBarCode.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../controller/NotificationApi.dart';
import '../profile/homep_profile.dart';
import 'package:taqdaa_application/model/user_model.dart';
import 'package:timezone/data/latest.dart' as tz;

//import 'package:carousel_slider/carousel_slider.dart';
//import 'view_reward.dart';

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
  bool isInsideProfile = false;
  bool isInsidelogout = false;

//  "2.225 SR /n مجموع النقاط"

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 135,
                elevation: 0,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text.rich(
                    TextSpan(
                      style: TextStyle(
                        fontSize: 14,
                      ),
                      children: [
                        WidgetSpan(
                          child: Icon(
                            Icons.monetization_on,
                            color: Color.fromARGB(255, 229, 223, 181),
                            size: 40,
                          ),
                        ),
                        TextSpan(
                          text: "  2.225 SR \n مجموع النقاط ",
                        ),
                      ],
                    ),
                  ),
                  background: Image.asset(
                    Assets.rewardbc,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
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
/*
                  CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        expandedHeight: 200,
                        elevation: 0,
                        pinned: true,
                        flexibleSpace: FlexibleSpaceBar(
                          title: Text.rich(
                            TextSpan(
                              style: TextStyle(
                                fontSize: 22,
                              ),
                              children: [
                                WidgetSpan(
                                  child: Icon(
                                    Icons.monetization_on,
                                    color: Colors.yellow,
                                    size: 30,
                                  ),
                                ),
                                TextSpan(
                                  text: "  2.225 SR \n مجموع النقاط ",
                                ),
                              ],
                            ),
                          ),
                          background: Image.asset(
                            Assets.rewardbc,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
*/
                  /*
                  Stack(
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Text.rich(
                              TextSpan(
                                style: TextStyle(
                                  fontSize: 22,
                                ),
                                children: [
                                  WidgetSpan(
                                    child: Icon(
                                      Icons.monetization_on,
                                      color: Colors.yellow,
                                      size: 30,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "  2.225 SR \n مجموع النقاط ",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  */

                  /*
                      IconButton(
                          onPressed: (() {}),
                          icon: Icon(
                            Icons.monetization_on,
                            size: 40,
                            color: Colors.yellow,
                          )),
                      Container(
                        width: 800 / 5,
                        height: 500,
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "2.225 SR",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  ?.copyWith(color: Colors.green),
                            )
                          ],
                        ),
                      ),
                      */

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
                                      builder: (context) => Homepprofile()),
                                );
                              },
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

@override
class rewards {
  Widget reward(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        IconButton(
            onPressed: (() {}),
            icon: Icon(
              Icons.monetization_on,
              size: 40,
              color: Colors.yellow,
            )),
        Container(
          width: 800 / 5,
          height: 600,
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "2.225 SR",
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(color: Colors.black),
              )
            ],
          ),
        ),
      ]),
    );
  }
}

class Assets {
  Assets._();
  static String rewardbc = "assets/rewardbc.png";
  static String rewardbg = "assets/reward_bg.jpg";
}

@override
State<StatefulWidget> createState() {
  // TODO: implement createState
  throw UnimplementedError();
}

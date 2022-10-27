import 'package:flutter/material.dart';
import 'package:taqdaa_application/confige/EcommerceApp.dart';
import 'package:taqdaa_application/screens/email.dart';
import 'package:taqdaa_application/views/NoItmesCart.dart';
import 'package:taqdaa_application/views/rewards_view.dart';
import 'package:taqdaa_application/views/scanner.dart';
import '../controller/BNBCustomePainter.dart';
//import '../Views/NoItmesCart.dart';
import 'ShoppingCart.dart';
import '../views/invoices_view.dart';
import 'list_of_stores.dart';
import 'insideMore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
          // Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          //   Text(
          //     "   " + "مرحبًا، ${EcommerceApp.loggedInUser.firstName}",
          //     style: TextStyle(
          //       fontSize: 24,
          //       fontWeight: FontWeight.w100,
          //       color: Color.fromARGB(255, 32, 7, 121),
          //     ),
          //   ),
          // ]),
          InkWell(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 270,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 232.0),
                    child: Text(
                      "    نقاطـي الحـالـيـة :  ",
                      style: TextStyle(
                          color: Color.fromARGB(255, 95, 137, 180),
                          fontSize: 19.5,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.4),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            height: 100,
                            child: Stack(
                              children: [
                                Container(
                                  width: 370,
                                  height: 105,
                                  decoration: new BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 3,
                                        blurRadius: 6,
                                        offset: Offset(0, 3),
                                      )
                                    ],
                                    gradient: LinearGradient(
                                      colors: [
                                        Color.fromARGB(255, 95, 137, 180),
                                        Color.fromARGB(255, 118, 171, 223),
                                        Color.fromARGB(255, 142, 195, 248)
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    shape: BoxShape.rectangle,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 14, right: 30),
                                  child: Container(
                                    width: 65,
                                    height: 65,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          opacity: 0.75,
                                          image:
                                              AssetImage("assets/rewards.png"),
                                          fit: BoxFit.fill),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 25, right: 90),
                                  child: Text(
                                    "  ${EcommerceApp.rewards} ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.8),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 35, right: 330),
                                  child: Icon(
                                    Icons.arrow_back_ios_rounded,
                                    textDirection: TextDirection.ltr,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => rewards_View(),
                  ));
            },
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
                                      builder: (context) =>
                                          email(), // رجعيه invoices
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

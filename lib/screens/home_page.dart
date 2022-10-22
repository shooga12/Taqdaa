import 'package:flutter/material.dart';
import 'package:taqdaa_application/confige/EcommerceApp.dart';
import 'package:taqdaa_application/main.dart';
import 'package:taqdaa_application/views/NoItmesCart.dart';
import 'package:taqdaa_application/views/profile_view.dart';
import 'package:taqdaa_application/views/rewards_view.dart';
import 'package:taqdaa_application/views/scanner.dart';
import '../controller/BNBCustomePainter.dart';
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

  final pages = [
    const homeContent(),
    const shoppingCart(),
    const emptyCart(),
    const invoices(),
    const More(),
  ];

  final titles = [
    "مرحبًا، ${EcommerceApp.loggedInUser.firstName}",
    "سلة التسوق",
    "سلة التسوق",
    "فواتيري",
    "المزيد"
  ];

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            titles[EcommerceApp.pageIndex],
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w100),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/Vector.png"), fit: BoxFit.fill)),
          ),
          toolbarHeight: 170,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: pages[EcommerceApp.pageIndex],
        bottomNavigationBar: Container(
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
                        enableFeedback: false,
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
                          enableFeedback: false,
                          onPressed: () {
                            setState(() {
                              EcommerceApp.pageIndex = 0;
                            });
                          },
                          icon: Icon(
                            Icons.home_outlined,
                            size: 35,
                            color: EcommerceApp.pageIndex == 0
                                ? Color.fromARGB(255, 254, 176, 60)
                                : Colors.white,
                          )),
                      IconButton(
                          enableFeedback: false,
                          onPressed: () {
                            if (EcommerceApp.haveItems) {
                              setState(() {
                                EcommerceApp.pageIndex = 1;
                              });
                            } else {
                              setState(() {
                                EcommerceApp.pageIndex = 2;
                              });
                            }
                          },
                          icon: Icon(
                            Icons.shopping_cart,
                            size: 30,
                            color: EcommerceApp.pageIndex == 2
                                ? Color.fromARGB(255, 254, 176, 60)
                                : Colors.white,
                          )),
                      Container(
                        width: size.width * 0.20,
                      ),
                      IconButton(
                          enableFeedback: false,
                          onPressed: () {
                            setState(() {
                              EcommerceApp.pageIndex = 3;
                            });
                          },
                          icon: Icon(
                            Icons.receipt_long,
                            size: 30,
                            color: EcommerceApp.pageIndex == 3
                                ? Color.fromARGB(255, 254, 176, 60)
                                : Colors.white,
                          )),
                      IconButton(
                        enableFeedback: false,
                        onPressed: () {
                          setState(() {
                            EcommerceApp.pageIndex = 4;
                          });
                        },
                        icon: Icon(
                          Icons.more_horiz,
                          size: 30,
                          color: EcommerceApp.pageIndex == 4
                              ? Color.fromARGB(255, 254, 176, 60)
                              : Colors.white,
                        ),
                      ),
                    ]),
              )
            ],
          ),
        ));
  }
}

class homeContent extends StatefulWidget {
  const homeContent({super.key});

  @override
  State<homeContent> createState() => _homeContentState();
}

class _homeContentState extends State<homeContent> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
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
                            padding: const EdgeInsets.only(top: 14, right: 30),
                            child: Container(
                              width: 65,
                              height: 65,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    opacity: 0.75,
                                    image: AssetImage("assets/rewards.png"),
                                    fit: BoxFit.fill),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 25, right: 90),
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
                            padding: const EdgeInsets.only(top: 35, right: 330),
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
    );
  }
}

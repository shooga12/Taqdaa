import 'package:flutter/material.dart';
import 'package:taqdaa_application/screens/list_of_stores.dart';

import '../confige/EcommerceApp.dart';
import '../controller/BNBCustomePainter.dart';
import '../main.dart';
import '../screens/ShoppingCart.dart';
import '../screens/insideMore.dart';
import 'invoices_view.dart';
//import '../screens/invoices.dart';

class emptyCart extends StatelessWidget {
  const emptyCart({super.key});

  @override
  Widget build(BuildContext context) {
    bool isInsideHome = false;
    bool isInsideReceipt = false;
    bool isInsideMore = false;
    bool isInsideCart = true;

    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "سلة التسوق",
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
        body: Stack(children: [
          Center(
              child: new InkWell(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "لا يوجد منتجات!",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text("ابدأ التسوق الآن!",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  Text(""),
                  SizedBox(
                    width: 200,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListOfStores2()),
                        );
                      },
                      child: Text(
                        'ابدأ التسوق!',
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
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30)))),
                    ),
                  ),
                ],
              ),
            ),
          )),
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
        ])
        //     child: new InkWell(
        //   child: Padding(
        //     padding: const EdgeInsets.only(bottom: 10),
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         Text(
        //           "لا يوجد منتجات!",
        //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        //         ),
        //         Text("ابدأ التسوق الآن!",
        //             style:
        //                 TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        //         Text(""),
        //         SizedBox(
        //           width: 200,
        //           height: 40,
        //           child: ElevatedButton(
        //             onPressed: () {
        //               Navigator.push(
        //                 context,
        //                 MaterialPageRoute(
        //                     builder: (context) => ListOfStores2()),
        //               );
        //             },
        //             child: Text(
        //               'ابدأ التسوق!',
        //               style: const TextStyle(
        //                   color: Colors.white,
        //                   fontWeight: FontWeight.bold,
        //                   fontSize: 18),
        //             ),
        //             style: ButtonStyle(
        //                 backgroundColor:
        //                     MaterialStateProperty.resolveWith((states) {
        //                   if (states.contains(MaterialState.pressed)) {
        //                     return Colors.grey;
        //                   }
        //                   return Colors.orange;
        //                 }),
        //                 shape:
        //                     MaterialStateProperty.all<RoundedRectangleBorder>(
        //                         RoundedRectangleBorder(
        //                             borderRadius: BorderRadius.circular(30)))),
        //           ),
        //         ),

        //       ],
        //     ),
        //   ),
        // ))
        );
  }
}

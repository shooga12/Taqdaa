import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import '../confige/EcommerceApp.dart';
import '../controller/BNBCustomePainter.dart';
import '../main.dart';
import '../views/NoItmesCart.dart';
import 'ShoppingCart.dart';
import 'insideMore.dart';
import '../views/invoices_view.dart';
import 'list_of_stores.dart';

class helpPage extends StatefulWidget {
  const helpPage({super.key});

  @override
  State<helpPage> createState() => _helpPageState();
}

class _helpPageState extends State<helpPage> {
  bool isInsideHome = false;
  bool isInsideReceipt = false;
  bool isInsideMore = true;
  bool isInsideCart = false;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          "أحصل على مساعدة",
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
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      child: new InkWell(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 12, bottom: 12, left: 15, right: 12),
                            child: Row(children: <Widget>[
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.phone_enabled,
                                      size: 30,
                                      color:
                                          Color.fromARGB(223, 134, 186, 243))),
                              Column(children: <Widget>[
                                Text(
                                  "أتصل علينا",
                                  style: new TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ]),
                              Spacer(),
                              // Icon(Icons.arrow_forward,
                              //     color: Color.fromARGB(223, 134, 186, 243)),
                            ]),
                          ),
                          onTap: () async {
                            await FlutterPhoneDirectCaller.callNumber(
                                '+966509483390');
                          }),
                      color: Color.fromARGB(243, 243, 239, 231),
                    ),
                    Card(
                      child: new InkWell(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 12, bottom: 12, left: 15, right: 12),
                            child: Row(children: <Widget>[
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.mail_outline,
                                      size: 30,
                                      color:
                                          Color.fromARGB(223, 134, 186, 243))),
                              Column(children: <Widget>[
                                Text(
                                  "أرسل لنا إيميل",
                                  style: new TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ]),
                              Spacer(),
                              // Icon(Icons.arrow_forward,
                              //     color: Color.fromARGB(223, 134, 186, 243)),
                            ]),
                          ),
                          onTap: () async {
                            // String url = 'mailto:nouraalkho2@gmail.com';
                            // await launchUrl(url);

                            // if (await canLaunchUrl(url)) {
                            //   await launchUrl(url);
                            // }
                          }),
                      color: Color.fromARGB(243, 243, 239, 231),
                    ),
                  ],
                )),
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

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../confige/EcommerceApp.dart';
import '../controller/BNBCustomePainter.dart';
import '../main.dart';
import '../profile/homep_profile.dart';
import 'NoItmesCart.dart';
import 'ShoppingCart.dart';
import 'home_page.dart';
import 'list_of_stores.dart';

class More extends StatefulWidget {
  const More({super.key});

  @override
  State<More> createState() => _MoreState();
}

class _MoreState extends State<More> {
  bool isInsideHome = false;
  bool isInsideReceipt = false;
  bool isInsideMore = true;

  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "المزيد",
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
      backgroundColor: Colors.white,
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
                                  icon: Icon(Icons.person,
                                      size: 30,
                                      color:
                                          Color.fromARGB(223, 134, 186, 243))),
                              Column(children: <Widget>[
                                Text(
                                  "حسابي",
                                  style: new TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ]),
                              Spacer(),
                              Icon(Icons.arrow_forward),
                            ]),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Homepprofile()),
                            );
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
                                  icon: Icon(Icons.contact_support,
                                      size: 30,
                                      color:
                                          Color.fromARGB(223, 134, 186, 243))),
                              Column(children: <Widget>[
                                Text(
                                  "أحصل على مساعدة",
                                  style: new TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ]),
                              Spacer(),
                              Icon(Icons.arrow_forward),
                            ]),
                          ),
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => Homepprofile()),
                            // );
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
                                  icon: Icon(Icons.info,
                                      size: 30,
                                      color:
                                          Color.fromARGB(223, 134, 186, 243))),
                              Column(children: <Widget>[
                                Text(
                                  "عن تقضّى",
                                  style: new TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ]),
                              Spacer(),
                              Icon(Icons.arrow_forward),
                            ]),
                          ),
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => Homepprofile()),
                            // );
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
                                  icon: Icon(Icons.phone_enabled,
                                      size: 30,
                                      color:
                                          Color.fromARGB(223, 134, 186, 243))),
                              Column(children: <Widget>[
                                Text(
                                  "تواصل معنا",
                                  style: new TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ]),
                              Spacer(),
                              Icon(Icons.arrow_forward),
                            ]),
                          ),
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => Homepprofile()),
                            // );
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
                                color: Colors.white,
                              )),
                          Container(
                            width: size.width * 0.20,
                          ),
                          IconButton(
                              onPressed: () {
                                //here reem's page
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

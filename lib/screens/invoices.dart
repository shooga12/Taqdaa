import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Query;
import '../confige/EcommerceApp.dart';
import '../controller/BNBCustomePainter.dart';
import '../main.dart';
import '../profile/homep_profile.dart';
import 'NoItmesCart.dart';
import 'ShoppingCart.dart';
import 'home_page.dart';
import 'insideMore.dart';
import 'invoice_details.dart';
import '../model/invoice.dart';
import 'list_of_stores.dart';

class invoices extends StatefulWidget {
  const invoices({super.key});

  @override
  State<invoices> createState() => _invoicesState();
}

class _invoicesState extends State<invoices> {
  bool isInsideHome = false;
  bool isInsideReceipt = true;
  bool isInsideMore = false;
  bool isInsideCart = false;
  List<Invoice> invoices = [];
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    readInvoices();
  }

  Future readInvoices() async {
    var data =
        await FirebaseFirestore.instance.collection('All-Invoices').get();

    setState(() {
      invoices = List.from(data.docs.map((doc) => Invoice.fromMap(doc)));
    });
  }

  int count = -1;
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "فواتيري",
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
                padding: const EdgeInsets.only(
                    left: 10, right: 10, bottom: 10, top: 15),
                child: ListView.builder(
                    itemCount: invoices.length,
                    itemBuilder: (context, index) {
                      return buildInvoiceCard(invoices[index], context);
                    })),
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

  nothing() {
    return Container();
  }

  buildInvoiceCard(Invoice invoice, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
      child: Container(
        child: new InkWell(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.receipt_long,
                    size: 40,
                    color: Color.fromARGB(255, 254, 177, 57),
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      " رقم الفاتورة: ${invoice.id}",
                      style: new TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      " المتجر: ${invoice.store}",
                      style: new TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      "${invoice.date}",
                      style: new TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Icon(
                  Icons.arrow_back_ios_rounded,
                  textDirection: TextDirection.ltr,
                  color: Color.fromARGB(255, 254, 177, 57),
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => invoice_details(invoice),
              ),
            );
          },
          highlightColor: Color.fromARGB(255, 255, 255, 255),
        ),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 241, 241, 241),
              offset: Offset.zero,
              blurRadius: 20.0,
              blurStyle: BlurStyle.normal,
            ),
          ],
        ),
      ),
    );
  }
}
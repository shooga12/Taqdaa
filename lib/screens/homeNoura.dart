import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:taqdaa_application/confige/EcommerceApp.dart';
import 'package:taqdaa_application/views/NoItmesCart.dart';
import 'package:taqdaa_application/views/rewards_view.dart';
import 'package:taqdaa_application/views/scanner.dart';
import '../controller/BNBCustomePainter.dart';
//import '../Views/NoItmesCart.dart';
import '../model/StoreModel.dart';
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
  List<Store> NearestStores = ListOfStores2State.NearestStores;
  String _counter = "";

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          InkWell(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 10,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 232.0),
                    child: Text(
                      "    نقاطـي الحالية :  ",
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
                                        // image: DecorationImage(
                                        //     opacity: 0.75,
                                        //     image:
                                        //         AssetImage("assets/rewards.png"),
                                        //     fit: BoxFit.fill),
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
          Column(
            children: [
              Row(
                children: [
                  Text('المتاجر القريب منك'),

                  // Icon(
                  //               Icons.View,
                  //               size: 35,
                  //               // color: isInsideHome
                  //               //     ? Color.fromARGB(255, 254, 176, 60)
                  //               //     : Colors.white,
                  //             )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 200.0),
                child: Container(
                  height: 500,
                  child: StreamBuilder<List<Store>>(
                      stream: readStores(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final stores = snapshot.data!;
                          return ListView.builder(
                              itemCount: 1,
                              itemBuilder: (BuildContext context, int index) {
                                var data = stores[0];
                                return buildStoresCards(data, context);
                                // if (nearest >= 5) {
                                //   NearestStores[nearest] = data;
                                //   nearest++;
                                // }
                              });
                        } else if (snapshot.hasError) {
                          return Text(
                              "Some thing went wrong! ${snapshot.error}");
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      }),
                ),
              ),
              // Container(
              //     height: 400,
              //     // SingleChildScrollView(
              //     //     physics: NeverScrollableScrollPhysics(),
              //     //padding: const EdgeInsets.only(top: 50.0),
              //     child: ListView.builder(
              //         itemCount: NearestStores.length,
              //         itemBuilder: (BuildContext context, int index) {
              //           var data = NearestStores[index];
              //           return buildStoresCards(data, context);
              //         }))
            ],
          ),

          // Positioned(
          //   child: InkWell(
          //     child: Expanded(
          //       child: Column(
          //         children: [
          //           ListView.builder(
          //               itemCount: NearestStores.length,
          //               itemBuilder: (BuildContext context, int index) {
          //                 var data = NearestStores[index];
          //                 return buildStoresCards(data, context);
          //               })
          //         ],
          //       ),
          //     ),
          //   ),
          // ),

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

  Stream<List<Store>> readStores() => FirebaseFirestore.instance
      .collection('Stores')
      .orderBy('kilometers')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Store.fromJson(doc.data())).toList());

  Future scan(BuildContext context) async {
    _counter = await FlutterBarcodeScanner.scanBarcode(
        "#004297", "Cancel", true, ScanMode.BARCODE);

    setState(() {
      EcommerceApp.value = _counter;
    });
  }

  buildStoresCards(Store store, BuildContext context) {
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
                // Image.network(
                //   store.StoreLogo,
                //   width: 60,
                //   height: 60,
                // ),
                Column(
                  children: <Widget>[
                    Text(
                      ' ' + store.StoreName,
                      style: new TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          ' ' + store.kilometers.toString(),
                          style: new TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 77, 76, 76),
                          ),
                        ),
                        Text(
                          ' كم',
                          style: new TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 77, 76, 76),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Spacer(),
                Icon(
                  size: 26,
                  Icons.document_scanner_outlined,
                  textDirection: TextDirection.ltr,
                  color: Color.fromARGB(255, 254, 177, 57),
                ),
                SizedBox(
                  width: 7,
                )
              ],
            ),
          ),
          onTap: () async {
            EcommerceApp.storeId = store.StoreId;
            if (EcommerceApp.storeName == "") {
              EcommerceApp.storeName = store.StoreName;
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => scanner()),
              // );
              scan(context);
            } else if (EcommerceApp.haveItems &&
                EcommerceApp.storeName != store.StoreName) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                        content: Text(
                            ".${EcommerceApp.storeName}عذرًا، لديك طلب بالفعل في"),
                        actions: [
                          ElevatedButton(
                              onPressed: () async {
                                EcommerceApp.storeName = "";
                                await ListOfStores2State.deleteCart();
                                await ListOfStores2State.deleteCartDublicate();
                                await ListOfStores2State.saveUserTotal(0);
                                Navigator.pop(context, 'حسنًا');
                              },
                              child:
                                  Text(" ${EcommerceApp.storeName} إلغاء طلب")),
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'حسنًا'),
                            child: const Text('حسنًا'),
                          ),
                        ]);
                  });
            } else {
              EcommerceApp.storeName = store.StoreName;
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => scanner()),
              // );
              scan(context);
            }
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
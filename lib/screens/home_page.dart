import 'dart:math';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:taqdaa_application/confige/EcommerceApp.dart';
import 'package:taqdaa_application/views/NoItmesCart.dart';
import 'package:taqdaa_application/views/rewards_view.dart';
import 'package:taqdaa_application/views/scanner.dart';
import '../controller/BNBCustomePainter.dart';
import '../main.dart';
import '../model/StoreModel.dart';
import 'ShoppingCart.dart';
import '../views/invoices_view.dart';
import 'listOfOffers.dart';
import 'list_of_stores.dart';
import 'insideMore.dart';
import '../model/Offers.dart';

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
  List<Offer> OffersList = [];
  bool ImagesAndText = false;
  // bool empty = false;
  // bool empty = false;

  Stream readOffers = FirebaseFirestore.instance
      .collection('ActiveOffers')
      .snapshots()
      .map(
          (list) => list.docs.map((doc) => doc.data()).toList()); //ActiveOffers

  double pageOffset = 0;
  @override
  void initState() {
    readOffers;
    //AddOffers();
    // AddImagesAndText();
    //checkEmpty();
    controller
      ..addListener(() {
        setState(() {
          pageOffset = controller.page!;
        });
      });

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _animateSlider());
  }

  // checkEmpty() {
  //   StreamBuilder(
  //       stream: readOffers,
  //       builder: (context, snapshot) {
  //         if (snapshot.hasData && snapshot.data!.isEmpty) {
  //           empty = true;
  //           return nothing();
  //         } else if (snapshot.hasError) {
  //           return Text("Something went wrong! ${snapshot.error}");
  //         } else {
  //           return Center(child: CircularProgressIndicator());
  //         }
  //       });
  // }

  nothing() {
    return SizedBox(
      width: 0,
    );
  }

  final PageController controller = PageController(
    viewportFraction: 0.8,
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                height: 900,
                child: Column(
                  children: [
                    // if (empty == false)
                    InkWell(
                        child: Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 390,
                            child: Row(
                              children: [
                                Text(
                                  '  العروض :',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 95, 137, 180),
                                      fontSize: 19.5,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.4),
                                ),
                                SizedBox(
                                  width: 150,
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ListOfOffers()),
                                    );
                                  },
                                  child: Text(
                                    'مشاهدة الكل',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.resolveWith(
                                              (states) {
                                        if (states
                                            .contains(MaterialState.pressed)) {
                                          return Color.fromARGB(
                                              255, 107, 154, 202);
                                        }
                                        return Color.fromARGB(
                                            255, 107, 154, 202);
                                      }),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30)))),
                                )
                              ],
                            ),
                          ),
                          //if (empty == false)
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0, bottom: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    //height: 20,
                                    child: Stack(
                                  children: [
                                    Container(
                                      height: 200,
                                      width: 360,
                                      child: StreamBuilder(
                                          stream: readOffers,
                                          builder: (context, snapshot) {
                                            // if (snapshot.hasData &&
                                            //     snapshot.data!.isEmpty) {
                                            //   ////////empty
                                            //   return NoOffersCard();
                                            // } else
                                            if (snapshot.hasData) {
                                              final offer = snapshot.data!;
                                              return PageView.builder(
                                                  controller: controller,
                                                  itemCount: offer.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    // return AddToList(
                                                    //     offer[index]);
                                                    return buildOfferCards(
                                                        offer[index], index);
                                                  });
                                            } else if (snapshot.hasError) {
                                              return Text(
                                                  "Something went wrong! ${snapshot.error}");
                                            } else {
                                              return Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            }
                                          }),
                                    ),
                                    // StreamBuilder(
                                    //       stream: readOffers,
                                    //       builder: (context, snapshot) {
                                    //         if (snapshot.hasData &&
                                    //             snapshot.data!.isEmpty) {
                                    //           ////////empty
                                    //           return NoOffersCard();
                                    //         } else if (snapshot.hasData) {
                                    //           final offer = snapshot.data!;
                                    //           return
                                    //         } else if (snapshot.hasError) {
                                    //           return Text(
                                    //               "Something went wrong! ${snapshot.error}");
                                    //         } else {
                                    //           return Center(
                                    //               child:
                                    //                   CircularProgressIndicator());
                                    //         }
                                    //       }),
                                  ],
                                )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ))
                    // Column(
                    //   children: [
                    //     Row(
                    //       children: [
                    //         Stack(children: [
                    //           Text('العروض:'),
                    //           SizedBox(
                    //             height: 30,
                    //           ),

                    //           Container(
                    //             width: 300,
                    //             height: 200,
                    //             child: StreamBuilder(
                    //                 stream: readOffers(),
                    //                 builder: (context, snapshot) {
                    //                   if (snapshot.hasData) {
                    //                     final offer = snapshot.data!;
                    //                     return ListView.builder(
                    //                         controller: controller,
                    //                         itemCount: offer.length,
                    //                         itemBuilder: (BuildContext context,
                    //                             int index) {
                    //                           return buildOfferCards(
                    //                               offer[index]);
                    //                         });
                    //                   } else if (snapshot.hasError) {
                    //                     return Text(
                    //                         "Some thing went wrong! ${snapshot.error}");
                    //                   } else {
                    //                     return Center(
                    //                         child: CircularProgressIndicator());
                    //                   }
                    //                 }),
                    //           ),

                    //           //ImagesAndText = AddImagesAndText(),

                    //           //buildOfferCards(context),
                    //         ])
                    //       ],
                    //     ),
                    //   ],
                    // ),
                    ,
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
                                "نقاطـي الحالية :  ",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 95, 137, 180),
                                    fontSize: 19.5,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.4),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 5.0, bottom: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      height: 100,
                                      child: Stack(
                                        children: [
                                          Container(
                                            width: 350,
                                            height: 105,
                                            decoration: new BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8.0),
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 3,
                                                  blurRadius: 6,
                                                  offset: Offset(0, 3),
                                                )
                                              ],
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color.fromARGB(
                                                      255, 95, 137, 180),
                                                  Color.fromARGB(
                                                      255, 118, 171, 223),
                                                  Color.fromARGB(
                                                      255, 142, 195, 248)
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                              shape: BoxShape.rectangle,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 14, right: 30),
                                            child: Container(
                                              width: 65,
                                              height: 65,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    opacity: 0.75,
                                                    image: AssetImage(
                                                        "assets/rewards.png"),
                                                    fit: BoxFit.fill),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 25, right: 90),
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
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                        child: Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 340,
                            //padding: const EdgeInsets.only(left: 200.0),
                            child: Row(
                              children: [
                                Text(
                                  'المتاجر القريبة منك :',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 95, 137, 180),
                                      fontSize: 19.5,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.4),
                                ),
                                SizedBox(
                                  width: 70,
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ListOfStores2()),
                                    );
                                  },
                                  child: Text(
                                    'مشاهدة الكل',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.resolveWith(
                                              (states) {
                                        if (states
                                            .contains(MaterialState.pressed)) {
                                          return Color.fromARGB(
                                              255, 107, 154, 202);
                                        }
                                        return Color.fromARGB(
                                            255, 107, 154, 202);
                                      }),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30)))),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0, bottom: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    //height: 20,
                                    child: Stack(
                                  children: [
                                    Container(
                                      height: 300,
                                      width: 360,
                                      child: StreamBuilder<List<Store>>(
                                          stream: readStores(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              final stores = snapshot.data!;
                                              return ListView.builder(
                                                  itemCount: stores.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    var data = stores[index];
                                                    return buildStoresCards(
                                                        data, context);
                                                    // if (nearest >= 5) {
                                                    //   NearestStores[nearest] = data;
                                                    //   nearest++;
                                                    // }
                                                  });
                                            } else if (snapshot.hasError) {
                                              return Text(
                                                  "Some thing went wrong! ${snapshot.error}");
                                            } else {
                                              return Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            }
                                          }),
                                    )
                                  ],
                                )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
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
                                  MaterialPageRoute(
                                      builder: (context) => More()),
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
        ));
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

  void _animateSlider() {
    Future.delayed(Duration(seconds: 2)).then((_) {
      int nextPage = controller.page!.round() + 1;

      if (nextPage == OffersList.length) {
        nextPage = 0;
      }

      controller
          .animateToPage(nextPage,
              duration: Duration(seconds: 1), curve: Curves.linear)
          .then((_) => _animateSlider());
    });
  }

  // AddToList(Offer offer) {
  //   OffersList.add(offer);
  //   return SizedBox(
  //     width: 0,
  //   );
  // }

  // AddOffers() {
  //   return StreamBuilder(
  //       stream: readOffers,
  //       builder: (context, snapshot) {
  //         if (snapshot.hasData && snapshot.data!.isEmpty) {
  //           ////////empty
  //           return NoOffersCard();
  //         } else if (snapshot.hasData) {
  //           final offer = snapshot.data!;
  //           return ListView.builder(
  //               itemCount: offer.length,
  //               itemBuilder: (BuildContext context, int index) {
  //                 return AddToList(offer[index]);
  //               });
  //         } else if (snapshot.hasError) {
  //           return Text("Something went wrong! ${snapshot.error}");
  //         } else {
  //           return Center(child: CircularProgressIndicator());
  //         }
  //       });

  // return StreamBuilder<Offer>(
  //     stream: readOffers,
  //     builder: (context, snapshot) {
  //       if (snapshot.hasData) {
  //         final offer = snapshot.data!;
  //         return ListView.builder(
  //             itemCount: offer.length,
  //             itemBuilder: (BuildContext context, int index) {
  //               return AddToList(offer[index]);
  //             });
  //       } else if (snapshot.hasError) {
  //         return Text("Some thing went wrong! ${snapshot.error}");
  //       } else {
  //         return Center(child: CircularProgressIndicator());
  //       }
  //     });
  //}

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
                Image.network(
                  store.StoreLogo,
                  width: 60,
                  height: 60,
                ),
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
                  color:
                      //Colors.orange,
                      Color.fromARGB(255, 95, 137, 202),
                  //Color.fromARGB(255, 254, 177, 57),
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => scanner()),
              );
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

  // List<String> Img = [];
  // List<String> text = [];

  // AddImagesAndText() {
  //   if (OffersList != null) {
  //     for (int i = 0; i < OffersList.length; i++) {
  //       Img[i] = OffersList[i].OfferImg;
  //       text[i] = OffersList[i].offerText;
  //     }
  //     return true;
  //   }
  //   return false; /////////////no offers
  // }

  // List<String> Img1 = [
  //   'assets/Zara.png',
  //   'assets/empty_cart.png',
  //   'assets/SignupGroup.png'
  // ];

  // List<Widget> generateImagesTiles() {
  //   return Img1.map((element) => ClipRRect(
  //         child: Image.asset(element, fit: BoxFit.cover),
  //         borderRadius: BorderRadius.circular(5.0),
  //       )).toList();

  //   // return Img.map((element) => ClipRRect(
  //   //       child: Image.network(element, fit: BoxFit.cover),
  //   //       borderRadius: BorderRadius.circular(15.0),
  //   //     )).toList();
  // }

  //int currentImg = 0;

  NoOffersCard() {
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
                Column(
                  children: <Widget>[
                    Text(
                      'لا يوجد عروض حاليًا',
                      style: new TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
    // return Padding(
    //   padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
    //   child: Container(
    //     child: new InkWell(
    //       child: Padding(
    //         padding: const EdgeInsets.only(top: 15, left: 15, right: 12),
    //         child: Row(
    //           //crossAxisAlignment: CrossAxisAlignment.start,
    //           children: <Widget>[
    //             Text('لا يوجد عروض حاليًا',
    //                 style: TextStyle(
    //                   fontSize: 20,
    //                 ))
    //           ],
    //         ),
    //       ),
    //       highlightColor: Color.fromARGB(255, 255, 255, 255),
    //     ),
    //     decoration: BoxDecoration(
    //       color: Color.fromARGB(255, 255, 255, 255),
    //       borderRadius: BorderRadius.circular(20.0),
    //       boxShadow: [
    //         BoxShadow(
    //           color: Color.fromARGB(255, 241, 241, 241),
    //           offset: Offset.zero,
    //           blurRadius: 20.0,
    //           blurStyle: BlurStyle.normal,
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }

  buildOfferCards(Map data, int index) {
    //double scale = max(0.8, (1 - (pageOffset - index).abs()) + 0.8);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
      child: Container(
        child: new InkWell(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 12),
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Image.network(
                  data['OfferImg'],
                  width: 255,
                  height: 120,
                ),
                Text(data['offerText'],
                    style: TextStyle(
                      fontSize: 20,
                    ))
                // Row(
                //   children: <Widget>[
                //     Text(
                //       data['offerText'],
                //       style: new TextStyle(
                //         fontSize: 16,
                //         color: Color.fromARGB(255, 77, 76, 76),
                //       ),
                //     ),
                //   ],
                // ),
                // .SizedBox(
                //   width: 7,
                // )
              ],
            ),
          ),
          onTap: () async {
            EcommerceApp.storeId = data['StoreId'];
            if (EcommerceApp.storeName == "") {
              EcommerceApp.storeName = data['StoreName'];
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => scanner()),
              // );
              scan(context);
            } else if (EcommerceApp.haveItems &&
                EcommerceApp.storeName != data['StoreName']) {
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
              EcommerceApp.storeName = data['StoreName'];
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => scanner()),
              );
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
    // return Container(
    //   margin: EdgeInsets.only(right: 10, left: 10),
    //   decoration: BoxDecoration(
    //       borderRadius: BorderRadius.circular(15.0),
    //       image: DecorationImage(
    //         fit: BoxFit.cover,
    //         image: NetworkImage(data['OfferImg']),
    //       )),
    //   child: Center(
    //     child: Text(
    //       data['offerText'],
    //       style: TextStyle(fontSize: 20),
    //     ),
    //   ),
    // );
  }

//   testCards(context) {
//     return Container(
//         height: 200,
//         width: 392,
//         child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               CarouselSlider(
//                 items: Img1.map((imgUrl) {
//                   return Builder(
//                     builder: (BuildContext context) {
//                       return Container(
//                         width: MediaQuery.of(context).size.width,
//                         margin: EdgeInsets.symmetric(horizontal: 10.0),
//                         decoration: BoxDecoration(
//                           color: Colors.green,
//                         ),
//                         child: Image.network(
//                           imgUrl,
//                           fit: BoxFit.fill,
//                         ),
//                       );
//                     },
//                   );
//                 }).toList(),
//                 options: CarouselOptions(
//                   height: 200.0,
//                   initialPage: 0,
//                   enlargeCenterPage: true,
//                   autoPlay: true,
//                   reverse: false,
//                   enableInfiniteScroll: true,
//                   autoPlayInterval: Duration(seconds: 2),
//                   autoPlayAnimationDuration: Duration(milliseconds: 2000),
// //pauseAutoPlayOnTouch: Duration(seconds: 10),
//                   scrollDirection: Axis.horizontal,
// // onPageChanged: (index) {
// // setState(() {
// // _current = index;
// // });
// // },
//                 ),
//               )
//             ]));
//   }
  //   ImagesAndText = AddImagesAndText();
  //   if (ImagesAndText) {
  //     return Container(
  //       padding: const EdgeInsets.only(top: 50),
  //       width: 300,
  //       height: 100,
  //       child: Stack(
  //         children: [
  //           SizedBox(
  //             width: 340,
  //             height: 150,
  //             child: CarouselSlider(
  //                 items: generateImagesTiles(),
  //                 options: CarouselOptions(
  //                   enlargeCenterPage: true,
  //                 )),
  //           )
  //         ],
  //       ),
  //     );
  //   } else {
  //     return Container(child: Text('error!!!!!1'));
  //   }
  // final List<Widget> imageSliders = widget.OffersList.map((item) => Container(
  //       child: ClipRRect(
  //         borderRadius: BorderRadius.all(
  //           Radius.circular(5.0),
  //         ),
  //         child: Stack(
  //           children: [
  //             Image.network(
  //               item.OfferImg,
  //               fit: BoxFit.cover,
  //               width: 1000,
  //             ),
  //             Positioned(
  //               bottom: 0.0,
  //               left: 0.0,
  //               right: 0.0,
  //               child: Container(
  //                 decoration: BoxDecoration(
  //                   gradient: LinearGradient(
  //                     colors: [
  //                       Color.fromARGB(200, 0, 0, 0),
  //                       Color.fromARGB(0, 0, 0, 0),
  //                     ],
  //                     begin: Alignment.bottomCenter,
  //                     end: Alignment.topCenter,
  //                   ),
  //                 ),
  //                 padding: EdgeInsets.symmetric(
  //                   horizontal: 20,
  //                   vertical: 10,
  //                 ),
  //                 child: Text(
  //                   '${item.offerText}',
  //                   style: TextStyle(
  //                     color: Colors.white,
  //                     fontSize: 20.0,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     )).toList();

  // return Column(
  //   children: [
  //     Padding(
  //       padding: EdgeInsets.all(20),
  //       child: Text(
  //         "Carousel With Image, Text & Dots",
  //         style: TextStyle(
  //           color: Colors.green[700],
  //           fontWeight: FontWeight.bold,
  //           fontSize: 18,
  //         ),
  //       ),
  //     ),
  //     CarouselSlider(
  //       items: imageSliders,
  //       options: CarouselOptions(
  //           autoPlay: true,
  //           enlargeCenterPage: true,
  //           aspectRatio: 1 / 4, //2.0,
  //           onPageChanged: (index, reason) {
  //             setState(() {
  //               currentImg = index;
  //             });
  //           }),
  //     ),
  //     Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: widget.OffersList.map((url) {
  //         int index = widget.OffersList.indexOf(url);
  //         return Container(
  //           width: 8,
  //           height: 8,
  //           margin: EdgeInsets.symmetric(
  //             vertical: 10,
  //             horizontal: 3,
  //           ),
  //           decoration: BoxDecoration(
  //             shape: BoxShape.circle,
  //             color: currentImg == index
  //                 ? Color.fromRGBO(0, 0, 0, 0.9)
  //                 : Color.fromRGBO(0, 0, 0, 0.4),
  //           ),
  //         );
  //       }).toList(),
  //     )
  //   ],
  // );
  // }
}

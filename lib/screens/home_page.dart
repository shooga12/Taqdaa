import 'dart:math';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:infinity_page_view/infinity_page_view.dart';
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

  // Stream readOffers = FirebaseFirestore.instance
  //     .collection('ActiveOffers')
  //     .snapshots()
  //     .map(
  //         (list) => list.docs.map((doc) => doc.data()).toList()); //ActiveOffers

  double pageOffset = 0;
  @override
  void initState() {
    //readOffers;

    controller
      ..addListener(() {
        setState(() {
          pageOffset = controller.page!;
        });
      });

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _animateSlider());
  }

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
                                      height: 230,
                                      width: 360,
                                      child: StreamBuilder(
                                          stream: MyHomePageState.readOffers,
                                          builder: (context, snapshot) {
                                            // if (snapshot.hasData &&
                                            //     snapshot.data!.isEmpty) {
                                            //   ////////empty
                                            //   return NoOffersCard();
                                            // } else
                                            if (snapshot.hasData) {
                                              final offer = snapshot.data!;
                                              return
                                                  // InfinityPageView(
                                                  //     controller: controller,
                                                  //     itemCount: offer.length,
                                                  //     itemBuilder:
                                                  //         (BuildContext context,
                                                  //             int index) {
                                                  //       return buildOfferCards(
                                                  //           offer[index], index);
                                                  //     });
                                                  PageView.builder(
                                                      controller: controller,
                                                      //itemCount: offer.length,
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      onPageChanged: (index) {
                                                        setState(() {
                                                          var _currentIndex =
                                                              index %
                                                                  offer.length;
                                                        });
                                                      },
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return buildOfferCards(
                                                            offer[index %
                                                                offer.length],
                                                            index);
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
    Future.delayed(
      Duration(seconds: 2),
    ).then((_) {
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

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  buildStoresCards(Store store, BuildContext context) {
    if (MyHomePageState.currentPosition == null) {
      return Visibility(visible: false, child: CircularProgressIndicator());
    } else if (MyHomePageState.currentPosition != null) {
      store.kilometers = calculateDistance(
              store.lat,
              store.lng,
              MyHomePageState.currentPosition?.latitude ?? "",
              MyHomePageState.currentPosition?.longitude ?? "")
          .toStringAsFixed(2);

      Future<void> writeLocation(String distance, String id) async {
        final location = await FirebaseFirestore.instance
            .collection("Stores")
            .doc('$id')
            .update({"kilometers": "$distance"});
      }

      writeLocation(store.kilometers, store.StoreId);
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
        child: Container(
          child: new InkWell(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 15, bottom: 15, left: 15, right: 12),
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
                                  await ListOfStores2State
                                      .deleteCartDublicate();
                                  await ListOfStores2State.saveUserTotal(0);
                                  Navigator.pop(context, 'حسنًا');
                                },
                                child: Text(
                                    " ${EcommerceApp.storeName} إلغاء طلب")),
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
  }

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
  }

  buildOfferCards(Map data, int index) {
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      data['StoreName'],
                      style: new TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          data['offerText'],
                          style: new TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 77, 76, 76),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
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
  }
}

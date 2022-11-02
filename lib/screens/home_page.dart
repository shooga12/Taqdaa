import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart' hide Query;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../controller/EcommerceApp.dart';
import '../main.dart';
import '../model/Offers.dart';
import '../model/StoreModel.dart';
import '../views/listOfOffers.dart';
import 'scanBarCode.dart';
import 'package:taqdaa_application/views/NoItmesCart.dart';
import 'package:taqdaa_application/views/rewards_view.dart';
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
  String collectionName = EcommerceApp().getCurrentUser();
  final pages = [
    const homeContent(),
    const shoppingCart(),
    const emptyCart(),
    const invoices(),
    const More(),
  ];

  final titles = [
    "مرحبًا، ${EcommerceApp.loggedInUser.firstName}",
    "سلة التسوق " + EcommerceApp.storeName,
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
                          if (EcommerceApp.pageIndex != 1) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ListOfStores2()),
                            );
                          } else {
                            _scan(context, "NewItem");
                          }
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
                            color: EcommerceApp.pageIndex == 2 ||
                                    EcommerceApp.pageIndex == 1
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

  String _counter = "";

  Future<bool> _scan(BuildContext context, String action) async {
    _counter = await FlutterBarcodeScanner.scanBarcode(
        "#FEB139", "Cancel", false, ScanMode.BARCODE);

    setState(() {
      EcommerceApp.value = _counter;
    });

    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('${collectionName}All')
        .where("Item_number", isEqualTo: EcommerceApp.value.substring(1))
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    if (action != "Decrement" && documents.length == 1) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                content: Text("تم إضافة المنتج مسبقاً."),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  )
                ]);
          });
      return false;
    }

    Query dbref = FirebaseDatabase.instance
        .ref()
        .child(EcommerceApp.storeId)
        .child('store')
        .orderByChild('Barcode')
        .equalTo(EcommerceApp.value.substring(1));

    final event = await dbref.once(DatabaseEventType.value);

    if (event.snapshot.value != null && action == "NewItem") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ScanPage()),
      );
      return true;
    } else if (_counter == "-1") {
      return false;
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                content: Text("عذرًا المنتج غير موجود!"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  )
                ]);
          });
      return false;
    }
  }
}

class homeContent extends StatefulWidget {
  const homeContent({super.key});

  @override
  State<homeContent> createState() => _homeContentState();
}

class _homeContentState extends State<homeContent> {
  String _counter = "";
  List<Offer> OffersList = [];
  String collectionName = EcommerceApp().getCurrentUser();

  Stream readOffers = FirebaseFirestore.instance
      .collection('ActiveOffers')
      .snapshots()
      .map(
          (list) => list.docs.map((doc) => doc.data()).toList()); //ActiveOffers

  //double pageOffset = 0;

  PageController controller = PageController(
    viewportFraction: 0.8,
    initialPage: 0,
  );
  //int currentPageValue = 0;
  int nextPage = 0;
  Timer? _timer;

  @override
  void initState() {
    readOffers;

    _timer = Timer.periodic(Duration(seconds: 2), (Timer timer) {
      nextPage = controller.page!.round() + 1;
      if (nextPage == OffersList.length) {
        nextPage = 0;
      }

      controller.animateToPage(
        nextPage,
        duration: Duration(seconds: 1),
        curve: Curves.linear,
      );
    });

    // controller
    //   ..addListener(() {
    //     setState(() {
    //       pageOffset = controller.page!;
    //     });
    //   });

    super.initState();
    //WidgetsBinding.instance.addPostFrameCallback((_) => _animateSlider());
  }

  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  nothing() {
    return SizedBox(
      width: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                          width: 170,
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
                                  MaterialStateProperty.resolveWith((states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return Color.fromARGB(255, 107, 154, 202);
                                }
                                return Color.fromARGB(255, 107, 154, 202);
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
                              height: 230,
                              width: 360,
                              child: StreamBuilder(
                                  stream: MyHomePageState.readOffers,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final offer = snapshot.data!;
                                      return PageView.builder(
                                          controller: controller,
                                          //itemCount: offer.length,
                                          scrollDirection: Axis.horizontal,
                                          onPageChanged: (index) {
                                            setState(() {
                                              var _currentIndex =
                                                  index % offer.length;
                                            });
                                          },
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return buildOfferCards(
                                                offer[index % offer.length],
                                                index);
                                          });
                                    } else if (snapshot.hasError) {
                                      return Text(
                                          "Something went wrong! ${snapshot.error}");
                                    } else {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    }
                                  }),
                            ),
                          ],
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            )),
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
                      padding: const EdgeInsets.only(top: 5.0, bottom: 5),
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
                                    padding: const EdgeInsets.only(
                                        top: 14, right: 15),
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
                                        top: 25, right: 70),
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
                                        top: 35, right: 310),
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
                                  builder: (context) => ListOfStores2()),
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
                                  MaterialStateProperty.resolveWith((states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return Color.fromARGB(255, 107, 154, 202);
                                }
                                return Color.fromARGB(255, 107, 154, 202);
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
                                          itemBuilder: (BuildContext context,
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
                                          child: CircularProgressIndicator());
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
    );
  }

  Stream<List<Store>> readStores() => FirebaseFirestore.instance
      .collection('Stores')
      .orderBy('kilometers')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Store.fromJson(doc.data())).toList());

  Future<bool> scan(BuildContext context, String action) async {
    _counter = await FlutterBarcodeScanner.scanBarcode(
        "#FEB139", "Cancel", false, ScanMode.BARCODE);

    setState(() {
      EcommerceApp.value = _counter;
    });

    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('${collectionName}All')
        .where("Item_number", isEqualTo: EcommerceApp.value.substring(1))
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    if (action != "Decrement" && documents.length == 1) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                content: Text("تم إضافة المنتج مسبقاً."),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  )
                ]);
          });
      return false;
    }

    Query dbref = FirebaseDatabase.instance
        .ref()
        .child(EcommerceApp.storeId)
        .child('store')
        .orderByChild('Barcode')
        .equalTo(EcommerceApp.value.substring(1));

    final event = await dbref.once(DatabaseEventType.value);

    if (event.snapshot.value != null && action == "NewItem") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ScanPage()),
      );
      return true;
    } else if (_counter == "-1") {
      return false;
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                content: Text("عذرًا المنتج غير موجود!"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  )
                ]);
          });
      return false;
    }
  }

  // void _animateSlider() {
  //   Future.delayed(Duration(seconds: 2)).then((_) {
  //     int nextPage = controller.page!.round() + 1;

  //     if (nextPage == OffersList.length) {
  //       nextPage = 0;
  //     }

  //     controller
  //         .animateToPage(nextPage,
  //             duration: Duration(seconds: 1), curve: Curves.linear)
  //         .then((_) => _animateSlider());
  //   });
  // }

  Widget buildStoresCards(Store store, BuildContext context) {
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
            EcommerceApp.returnDays = store.returnDays;
            if (EcommerceApp.storeName == "") {
              EcommerceApp.storeName = store.StoreName;
              scan(context, "NewItem");
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
              scan(context, "NewItem");
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
                  height: 130,
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
                          data['offerText'] + ' ' + data['percentage'],
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
            EcommerceApp.returnDays = data['returnDays'];
            if (EcommerceApp.storeName == "") {
              EcommerceApp.storeName = data['StoreName'];
              scan(context, "NewItem");
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
              scan(context, "NewItem");
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

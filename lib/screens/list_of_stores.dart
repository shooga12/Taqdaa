import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Query;
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:taqdaa_application/controller/EcommerceApp.dart';
import 'package:taqdaa_application/screens/scanBarCode.dart';
import '../main.dart';
import '../model/StoreModel.dart';
import 'ShoppingCart.dart';
import 'scanBarCode.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class ListOfStores2 extends StatefulWidget {
  const ListOfStores2({super.key});

  @override
  State<ListOfStores2> createState() => ListOfStores2State();
}

class ListOfStores2State extends State<ListOfStores2> {
  @override
  final List<Store> Stores = [];
  static List<Store> NearestStores = [];
  FirebaseDatabase database = FirebaseDatabase.instance;
  static String collectionName = EcommerceApp().getCurrentUser();
  String SearchName = '';
  String _counter = "";

  Future scan(BuildContext context) async {
    _counter = await FlutterBarcodeScanner.scanBarcode(
        "#004297", "Cancel", true, ScanMode.BARCODE);

    setState(() {
      EcommerceApp.value = _counter;
    });

    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('${EcommerceApp.uid}All')
        .where("Item_number", isEqualTo: EcommerceApp.value.substring(1))
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    if (documents.length == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => shoppingCart()),
      );
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                content: Text("تم إضافة المنتج مسبقًا!"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'حسنًا'),
                    child: const Text('حسنًا'),
                  )
                ]);
          });
      return false;
    }

    Query dbref = FirebaseDatabase.instance
        .ref()
        .child(EcommerceApp.storeId) //Ecommerce.storeName
        .child('store')
        .orderByChild('Barcode')
        .equalTo(EcommerceApp.value.substring(1));

    final event = await dbref.once(DatabaseEventType.value);

    if (event.snapshot.value != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ScanPage()),
      );
    } else if (_counter == "-1") {
      return false;
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                content: Text("عذرًا، لم يتم العثور على المنتج"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'حسنًا'),
                    child: const Text('حسنًا'),
                  )
                ]);
          });
    }
  }

  bool flag = false;
  int count = -1;
  //int nearest = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'إختر متجرًا',
          style: TextStyle(fontSize: 24), //TextStyle(fontFamily: 'Cairo'),
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              height: 600,
              child: Column(
                children: [
                  SizedBox(
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 10),
                      child: TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            // borderSide: const BorderSide(
                            //     color: Colors.orange, width: 2.0)
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            // borderSide: const BorderSide(
                            //     color: Colors.orange, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            // borderSide: const BorderSide(
                            //     color: Colors.orange, width: 2.0),
                          ),
                          prefixIcon: Icon(Icons.search),
                          hintText: 'إبحث عن إسم متجر محدد',
                          hintStyle: TextStyle(
                              color: Color.fromARGB(236, 113, 113, 117)
                                  .withOpacity(0.9)),
                        ),
                        onChanged: (val) {
                          setState(() {
                            SearchName = val;
                            //.replaceAll(' ', '');
                          });
                        },
                      ),
                    ),
                  ),
                  Container(
                    height: 500,
                    width: 360,
                    child: StreamBuilder<List<Store>>(
                        stream: readStores(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final stores = snapshot.data!;
                            count = stores.length;
                            return ListView.builder(
                                itemCount: stores.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var data = stores[index];
                                  // if (nearest >= 5) {
                                  //   NearestStores[nearest] = data;
                                  //   nearest++;
                                  // }

                                  if (SearchName.isEmpty) {
                                    flag = false;
                                    return buildStoresCards(
                                        stores[index], context);
                                  } else if (SearchName.isNotEmpty &&
                                      data.StoreName.toString()
                                          .toLowerCase()
                                          .startsWith(
                                              SearchName.toLowerCase())) {
                                    flag = true;
                                    return buildStoresCards(
                                        stores[index], context);
                                  } else if (flag == false &&
                                      index == count - 1) {
                                    return Container(
                                        child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'لا يوجد نتائج',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ));
                                  }
                                  return nothing();
                                });
                          } else if (snapshot.hasError) {
                            return Text(
                                "Some thing went wrong! ${snapshot.error}");
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  nothing() {
    return Container();
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
                  color: Color.fromARGB(255, 95, 137, 202),
                  // Color.fromARGB(255, 254, 177, 57),
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
                                await deleteCart();
                                await deleteCartDublicate();
                                await saveUserTotal(0);
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

  static Stream<List<Store>> readStores() => FirebaseFirestore.instance
      .collection('Stores')
      .where('kilometers')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Store.fromJson(doc.data())).toList());

  static Future saveUserTotal(var total) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('${collectionName}Total')
        .get();
    final DocumentSnapshot document = result.docs.first;
    if (document.exists) {
      document.reference.update({'Total': total});
    }
  }

  static Future deleteCart() async {
    final QuerySnapshot result =
        await FirebaseFirestore.instance.collection('${collectionName}').get();
    final List<DocumentSnapshot> documents = result.docs;
    for (int i = 0; i < documents.length; i++) {
      documents[i].reference.delete();
    }
  }

  static Future deleteCartDublicate() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('${collectionName}All')
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    for (int i = 0; i < documents.length; i++) {
      documents[i].reference.delete();
    }
  }
}

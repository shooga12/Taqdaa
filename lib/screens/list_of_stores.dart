import 'dart:ffi';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:taqdaa_application/confige/EcommerceApp.dart';
import 'package:taqdaa_application/screens/scanBarCode.dart';
import '../controller/searchBar.dart';
import 'scanBarCode.dart';
//import 'package:firebase_database/firebase_database.dart';

class ListOfStores2 extends StatefulWidget {
  const ListOfStores2({super.key});

  @override
  State<ListOfStores2> createState() => _ListOfStores2State();
}

class _ListOfStores2State extends State<ListOfStores2> {
  final List<Store> Stores = [];
  // Query dbref = FirebaseDatabase.instance.ref().child('Stores');

  String _counter = "";

  Future _scan(BuildContext context) async {
    _counter = await FlutterBarcodeScanner.scanBarcode(
        "#004297", "Cancel", true, ScanMode.BARCODE);

    setState(() {
      EcommerceApp.value = _counter;
    });

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ScanPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Choose Store',
          style: TextStyle(fontSize: 24), //TextStyle(fontFamily: 'Cairo'),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: MySearchDelegate());
              },
              icon: const Icon(Icons.search))
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/Vector.png"), fit: BoxFit.fill)),
        ),
        toolbarHeight: 170,
        //leading: BackButton(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body:
          // Container(
          //   height: double.infinity,
          //   child: FirebaseAnimatedList(
          //       query: dbref,
          //       itemBuilder: (BuildContext context, DataSnapshot snapshot,
          //           Animation<double> animation, int index) {
          //         Map store = snapshot.value as Map;
          //         store['key'] = snapshot.key;
          //         return buildStoresCards(store: store);
          //       }),
          // ),

          StreamBuilder<List<Store>>(
              stream: readStores(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final stores = snapshot.data!;
                  return ListView.builder(
                    itemCount: stores.length,
                    itemBuilder: (BuildContext context, int index) =>
                        buildStoresCards(stores[index], context),
                  );
                } else if (snapshot.hasError) {
                  return Text("Some thing went wrong! ${snapshot.error}");
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
    );
  }

  Stream<List<Store>> readStores() => FirebaseFirestore.instance
      .collection('Stores')
      .orderBy('kilometers')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Store.fromJson(doc.data())).toList());

  Widget buildStoresCards(Store store, BuildContext context) {
    //{required Map store}
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 0,
          left: 15,
          right: 15,
          bottom: 3,
        ),
        child: Card(
          child: new InkWell(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 12, bottom: 12, left: 15, right: 12),
              child: Row(
                children: <Widget>[
                  Image.network(
                    store.StoreLogo,
                    width: 60,
                    height: 60,
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        store.StoreName,
                        style: new TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            store.kilometers.toString(),
                            style: new TextStyle(
                              fontSize: 12,
                              color: Color.fromARGB(255, 77, 76, 76),
                            ),
                          ),
                          Text(
                            'Km  ',
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
                  Icon(Icons.document_scanner_outlined),
                  //size: 18,
                ],
              ),
            ),
            onTap: () {
              EcommerceApp.storeName = store.StoreName;
              _scan(context);
            },
          ),
          color: Color.fromARGB(243, 243, 239, 231),
        ),
      ),
    );
  }
}

class Store {
  final String StoreName;
  final String StoreLogo;
  final String kilometers;

  Store(
      {required this.StoreName,
      required this.StoreLogo,
      required this.kilometers});

  Map<String, dynamic> toJson() => {
        'StoreName': StoreName,
        'StoreLogo': StoreLogo,
        'kilometers': kilometers,
      };

  static Store fromJson(Map<String, dynamic> json) => Store(
        StoreName: json['StoreName'],
        StoreLogo: json['StoreLogo'],
        kilometers: json['kilometers'].toString(),
      );
}

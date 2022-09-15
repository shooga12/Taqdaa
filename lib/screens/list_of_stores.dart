import 'dart:ffi';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:taqdaa_application/confige/EcommerceApp.dart';
import 'package:taqdaa_application/screens/scanBarCode.dart';
import '../controller/searchBar.dart';
import 'scanBarCode.dart';
import 'package:firebase_database/firebase_database.dart';

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
      .orderBy('KilloMeters')
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
                    store.url,
                    width: 60,
                    height: 60,
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        store.Name,
                        style: new TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            store.KilloMeters.toString(),
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
              EcommerceApp.storeName = store.Name;
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
  final String Name;
  final String url;
  final String KilloMeters;

  Store({required this.Name, required this.url, required this.KilloMeters});

  Map<String, dynamic> toJson() => {
        'Name': Name,
        'url': url,
        'KilloMeters': KilloMeters,
      };

  static Store fromJson(Map<String, dynamic> json) => Store(
        Name: json['Name'],
        url: json['url'],
        KilloMeters: json['KilloMeters'].toString(),
      );
}

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:taqdaa_application/confige/EcommerceApp.dart';
import 'package:taqdaa_application/screens/scanBarCode.dart';
import 'scanBarCode.dart';

class ListOfStores2 extends StatefulWidget {
  const ListOfStores2({super.key});

  @override
  State<ListOfStores2> createState() => _ListOfStores2State();
}

class _ListOfStores2State extends State<ListOfStores2> {
  final List<Store> Stores = [];

  String _counter = "";
  String _value = "";

  Future _scan(BuildContext context) async {
    _counter = await FlutterBarcodeScanner.scanBarcode(
        "#004297", "Cancel", true, ScanMode.BARCODE);

    setState(() {
      _value = _counter;
    });

    EcommerceApp.itemsCounter++;

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ScanPage(
                _value,
              )),
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
      body: StreamBuilder<List<Store>>(
          stream: readStores(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final stores = snapshot.data!;
              return ListView.builder(
                itemCount: stores.length,
                itemBuilder: (BuildContext context, int index) =>
                    buildStoresCards(stores[index], context),
                //{
                //   //Map thisItem = stores[index];
                //   return ListTile(
                //     title: Text(''),
                //     subtitle: Text(''),
                //   );
                // }
                //
                //children: stores.map(buildStoresCards).toList(),
              );
            } else if (snapshot.hasError) {
              return Text("Some thing went wrong! ${snapshot.error}");
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),

      // Container(
      //   color: Color.fromARGB(255, 243, 243, 243),
      //   child: new ListView.builder(
      //       itemCount: Stores.length,
      //       itemBuilder: (BuildContext context, int index) =>
      //           buildStoresCards(context, index)),
      // ),
    );
  }

  Stream<List<Store>> readStores() => FirebaseFirestore.instance
      .collection('Stores')
      .orderBy('KilloMeters')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Store.fromJson(doc.data())).toList());

  Widget buildStoresCards(Store store, BuildContext context) {
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
                            store.KilloMeters,
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
              _scan(context);
              //   Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => ScanPage()),
              // );
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

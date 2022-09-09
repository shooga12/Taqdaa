import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class ListOfStores extends StatelessWidget {
  ListOfStores({super.key});
  final List<Store> Stores = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Where are you shopping ?',
          // style: TextStyle(fontFamily: 'Cairo'),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/background.png"),
                  fit: BoxFit.fill)),
        ),
        toolbarHeight: 170,
        //leading: BackButton(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: StreamBuilder<List<Store>>(
          stream: readUsers(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final stores = snapshot.data!;
              return ListView(
                children: stores.map(buildStoresCards).toList(),
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

  Stream<List<Store>> readUsers() => FirebaseFirestore.instance
      .collection('Stores')
      .orderBy('KilloMeters')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Store.fromJson(doc.data())).toList());

  Widget buildStoresCards(Store store) {
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
                  top: 25, bottom: 25, left: 15, right: 8),
              child: Row(
                children: <Widget>[
                  Image.network(
                    store.url,
                    width: 60,
                    height: 60,
                  ),
                  Text(
                    store.Name,
                    style: new TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Spacer(),
                  Text(
                    store.KilloMeters,
                    style: new TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(255, 77, 76, 76),
                    ),
                  ),
                  Text(' Km  '),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                  ),
                ],
              ),
            ),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => ListOfStores()),
              // );
            },
          ),
          color: Color.fromARGB(255, 232, 229, 218),
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

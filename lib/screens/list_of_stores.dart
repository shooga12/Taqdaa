import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Query;
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:taqdaa_application/confige/EcommerceApp.dart';
import 'package:taqdaa_application/screens/scanBarCode.dart';
import '../controller/searchBar.dart';
import 'scanBarCode.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class ListOfStores2 extends StatefulWidget {
  const ListOfStores2({super.key});

  @override
  State<ListOfStores2> createState() => _ListOfStores2State();
}

class _ListOfStores2State extends State<ListOfStores2> {
  Position? _currentPosition;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  @override
  String SearchName = '';
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

  bool flag = false;
  int count = -1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Choose Store',
          style: TextStyle(fontSize: 24), //TextStyle(fontFamily: 'Cairo'),
        ),
        bottom: PreferredSize(
            child: Flexible(
              child: Card(
                child: TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search for a store name..'),
                  onChanged: (val) {
                    setState(() {
                      SearchName = val.replaceAll(' ', '');
                    });
                  },
                ),
              ),
            ),
            preferredSize: Size.zero),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/Vector.png"), fit: BoxFit.fill)),
        ),
        toolbarHeight: 170,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: StreamBuilder<List<Store>>(
          stream: readStores(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final stores = snapshot.data!;
              count = stores.length; //2
              return ListView.builder(
                  itemCount: stores.length,
                  itemBuilder: (BuildContext context, int index) {
                    var data = stores[index];

                    if (SearchName.isEmpty) {
                      flag = false;
                      return buildStoresCards(stores[index], context);
                    } else if (SearchName.isNotEmpty &&
                        data.StoreName.toString()
                            .toLowerCase()
                            .startsWith(SearchName.toLowerCase())) {
                      flag = true;
                      return buildStoresCards(stores[index], context);
                    } else if (flag == false && index == count - 1) {
                      return Container(
                          child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'No Results',
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
              return Text("Some thing went wrong! ${snapshot.error}");
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  nothing() {
    return Container();
  }

  Stream<List<Store>> readStores() => FirebaseFirestore.instance
      .collection('Stores')
      .orderBy('kilometers')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Store.fromJson(doc.data())).toList());

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  buildStoresCards(Store store, BuildContext context) {
    _getCurrentPosition();
    if (_currentPosition == null) {
      return CircularProgressIndicator();
    } else if (_currentPosition != null) {
      store.kilometers = calculateDistance(
              store.lat,
              store.lng,
              _currentPosition?.latitude ?? "",
              _currentPosition?.longitude ?? "")
          .toStringAsFixed(2);

      Future<void> writeLocation(String distance, String id) async {
        final location = await FirebaseFirestore.instance
            .collection("Stores")
            .doc('$id')
            .update({"kilometers": "$distance"});
      }

      writeLocation(store.kilometers, store.StoreId);

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
                EcommerceApp.storeId = store.StoreId;
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
}

class Store {
  final String StoreName;
  final String StoreLogo;
  String kilometers;
  final String StoreId;
  final num lat;
  final num lng;

  Store(
      {required this.StoreName,
      required this.StoreLogo,
      required this.kilometers,
      required this.StoreId,
      required this.lat,
      required this.lng});

  Map<String, dynamic> toJson() => {
        'StoreName': StoreName,
        'StoreLogo': StoreLogo,
        'kilometers': kilometers,
        'StoreId': StoreId,
        'lat': lat,
        'lng': lng,
      };

  static Store fromJson(Map<String, dynamic> json) => Store(
        StoreName: json['StoreName'],
        StoreLogo: json['StoreLogo'],
        kilometers: json['kilometers'].toString(),
        StoreId: json['StoreId'],
        lat: json['lat'],
        lng: json['lng'],
      );
}

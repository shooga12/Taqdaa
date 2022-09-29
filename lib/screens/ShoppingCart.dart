import 'package:cloud_firestore/cloud_firestore.dart' hide Query;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:taqdaa_application/main.dart';
//import 'package:taqdaa_application/screens/checkout_Page.dart';
import '../confige/EcommerceApp.dart';
import 'scanBarCode.dart';

class shoppingCart extends StatefulWidget {
  const shoppingCart({Key? key}) : super(key: key);
  @override
  State<shoppingCart> createState() => _shoppingCartState();
}

class _shoppingCartState extends State<shoppingCart> {
  _shoppingCartState();
  String collectionName = EcommerceApp().getCurrentUser();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            EcommerceApp.storeName + " Shopping Cart",
            // style: TextStyle(fontFamily: 'Cairo'),
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
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyHomePage()),
                );
              },
              icon: Icon(
                Icons.home,
                size: 30,
              ),
            )
          ],
        ),
        body: StreamBuilder<List<Product>>(
            stream: readCartItems(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final products = snapshot.data!;
                return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (BuildContext context, int index) {
                      int previousTotal = EcommerceApp.total;
                      EcommerceApp.total = products
                          .map<int>((e) => e.Price * e.quantity)
                          .reduce((value, element) => value + element);
                      if (products.isEmpty) {
                        saveUserTotal(0);
                      }
                      if (previousTotal != EcommerceApp.total &&
                          products.isNotEmpty) {
                        saveUserTotal(EcommerceApp.total);
                      }
                      //getUserTotal();
                      if (products[index].quantity == 0) {
                        deleteItem(products[index].Category);
                        products.removeAt(index);
                        saveUserTotal(0);
                      } else {
                        getUserTotal();
                        return Dismissible(
                            key: ValueKey(products[index].Item_number),
                            background: Container(
                              color: Colors.redAccent,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 300),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete_forever,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                  ],
                                ),
                              ),
                              padding: EdgeInsets.all(8.0),
                              margin: const EdgeInsets.all(8.0),
                            ),
                            direction: DismissDirection.endToStart,
                            confirmDismiss: (direction) {
                              return showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                        title: Text("Please Confirm"),
                                        content: Text(
                                            "Are you sure you want to delete this item ?"),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(ctx).pop(false);
                                              },
                                              child: Text("Cancel")),
                                          ElevatedButton(
                                              //style: Color
                                              onPressed: () {
                                                Navigator.of(ctx).pop(true);
                                              },
                                              child: Text("Delete")),
                                        ],
                                      ));
                            },
                            onDismissed: (DismissDirection direction) {
                              if (direction == DismissDirection.endToStart) {
                                deleteItemGroup(products[index].Category);
                                deleteItem(products[index].Category);
                                products.removeAt(index); ////bug fixes
                                if (products.isEmpty) {
                                  saveUserTotal(0);
                                }
                              }
                            },
                            child: buildSecondItmes(products[index], context));
                      }
                      return Center(child: CircularProgressIndicator());
                    });
              } else if (snapshot.hasError) {
                return Text("Some thing went wrong! ${snapshot.error}");
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
        bottomNavigationBar: SizedBox(
          height: 170,
          child: Container(
              child: Column(
            children: [
              Container(
                  child: Text(
                'Total: ' + EcommerceApp.total.toString() + '\n',
                style: TextStyle(
                    color: Color.fromARGB(255, 32, 7, 121),
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              )),
              Container(
                child: SizedBox(
                  width: 200,
                  height: 40,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _scan(context, "NewItem");
                    },
                    label: Text(
                      'Continue Scanning',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    icon: Icon(Icons.document_scanner_outlined),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.grey;
                          }
                          return Colors.orange;
                        }),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)))),
                  ),
                ),
              ),
              Container(
                child: SizedBox(
                  width: 200,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => CheckOut()),
                      // );
                    },
                    child: Text(
                      'Checkout',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.grey;
                          }
                          return Colors.orange;
                        }),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)))),
                  ),
                ),
              ),
            ],
          )),
        ));
  }

  Future<bool> checkItemExist(bool increment, String itemName) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('${collectionName}')
        .where("Category", isEqualTo: itemName)
        .get();
    final DocumentSnapshot document = result.docs.first;
    if (document.exists && increment) {
      document.reference.update({'quantity': FieldValue.increment(1)});
      return true;
    } else if (!increment) {
      document.reference.update({'quantity': FieldValue.increment(-1)});
      return true;
    } else {
      return false;
    }
  }

  Stream<List<Product>> readCartItems() => FirebaseFirestore.instance
      .collection('${collectionName}')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Product.fromJson(doc.data())).toList());

  Widget buildSecondItmes(Product product, BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            //upper part
            children: [
              Card(
                child: new InkWell(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 0, bottom: 0, left: 0, right: 6),
                    child: Row(
                      children: <Widget>[
                        new Container(
                          child: Stack(children: <Widget>[
                            Container(
                              child: new Image.asset(
                                'assets/Rectangle.png',
                                height: 92.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                            // Container(
                            //   alignment: Alignment.bottomLeft, //اعدله
                            //   child:
                            // ),
                          ]),
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              "\n " + product.Category,
                              style: new TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 32, 7, 121),
                              ),
                            ),
                            Text(
                              "   Price : " + product.Price.toString() + " SR",
                              textAlign: TextAlign.center,
                              style: new TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 77, 76, 76),
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        IconButton(
                            onPressed: () async {
                              EcommerceApp.productName = product.Category;
                              await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                        title: Text("Please note that :"),
                                        content: Text(
                                            "You have to scan the barcode of the removed Item, In order to decrement the quantity."),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context, 'OK');
                                            },
                                            child: const Text('OK'),
                                          )
                                        ]);
                                  });
                              if (await _scan(context, "Decrement")) {
                                checkItemExist(false, product.Category);
                              }
                            },
                            icon: Icon(Icons.remove_circle,
                                color: Color.fromARGB(255, 245, 161, 14))),
                        //Text('$quantity'),
                        Text(product.quantity.toString()),
                        IconButton(
                            onPressed: () async {
                              EcommerceApp.productName = product.Category;
                              await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                        title: Text("Please note that :"),
                                        content: Text(
                                            "You have to scan the barcode of the added Item, In order to increment the quantity."),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context, 'OK');
                                            },
                                            child: const Text('OK'),
                                          )
                                        ]);
                                  });
                              if (await _scan(context, "Increment")) {
                                checkItemExist(true, product.Category);
                              }
                            },
                            icon: Icon(Icons.add_circle,
                                color: Color.fromARGB(255, 245, 161, 14))),
                      ],
                    ),
                  ),
                ),
                color: Color.fromARGB(255, 248, 248, 246),
              ),
            ],
          ),
          //),
        ],
      ),
    );
  }

  String _counter = "";

  Future<bool> _scan(BuildContext context, String action) async {
    _counter = await FlutterBarcodeScanner.scanBarcode(
        "#004297", "Cancel", true, ScanMode.BARCODE);

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
                content: Text("Item already have been added."), ///////
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

    if (event.snapshot.exists &&
        action == "Increment" &&
        event.snapshot.children.first.child('Product Name').value ==
            EcommerceApp.productName) {
      var barcode = event.snapshot.children.first.child('Barcode').value;
      var productName =
          event.snapshot.children.first.child('Product Name').value;
      var RFID = event.snapshot.children.first.child('RFID').value;
      saveUserItemsDublicate(barcode, productName, RFID);
      return true;
    } else if (event.snapshot.exists &&
        action == "Decrement" &&
        event.snapshot.children.first.child('Product Name').value ==
            EcommerceApp.productName) {
      String dat =
          event.snapshot.children.first.child('Barcode').value as String;
      deleteSingleItem(dat);
      return true;
    } else if (event.snapshot.exists && action == "Increment") {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                content: Text(
                    "Sorry, this is not a ${EcommerceApp.productName}."), ///////
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ScanPage()),
                        );
                      },
                      child: Text('Add it either way')),
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  )
                ]);
          });
      return false;
    } else if (event.snapshot.exists && action == "Decrement") {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                content: Text(
                    "Sorry, this is not a ${EcommerceApp.productName}."), ///////
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  )
                ]);
          });
      return false;
    } else if (event.snapshot.value != null && action == "NewItem") {
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
                content: Text("Sorry Item not found!"),
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

  ///End of _scan()
  Future saveUserItemsDublicate(var barcode, var productName, var RFID) async {
    FirebaseFirestore.instance.collection('${collectionName}All').add({
      "Category": productName,
      "Item_number": barcode,
      "Price": "new",
      "Store": "new",
      "quantity": "new",
      "RFID": RFID,
    });
  }

  Future saveUserTotal(var total) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('${collectionName}Total')
        .get();
    final DocumentSnapshot document = result.docs.first;
    if (document.exists) {
      document.reference.update({'Total': total});
    }
  }

  Future getUserTotal() async {
    var collection =
        FirebaseFirestore.instance.collection('${collectionName}Total');
    collection.doc('total').snapshots().listen((docSnapshot) {
      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data()!;

        // You can then retrieve the value from the Map like this:
        setState(() {
          EcommerceApp.total = data['Total'];
        });
      }
    });
  }

  Future<bool> deleteItem(String productName) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('${EcommerceApp.uid}')
        .where("Category", isEqualTo: productName)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    if (documents.length == 1) {
      documents[0].reference.delete();
      return true;
    } else {
      return false;
    }
  }

  Future<void> deleteItemGroup(String productName) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('${EcommerceApp.uid}All')
        .where("Category", isEqualTo: productName)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    for (int i = 0; i < documents.length; i++) {
      documents[i].reference.delete();
    }
  }

  Future<bool> deleteSingleItem(String dat) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('${collectionName}All')
        .where("Item_number", isEqualTo: dat)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    if (documents.length == 1) {
      documents[0].reference.delete();
      return true;
    } else {
      return false;
    }
  }
}

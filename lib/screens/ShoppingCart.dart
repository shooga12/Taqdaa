import 'package:cloud_firestore/cloud_firestore.dart' hide Query;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:taqdaa_application/views/checkOut_view.dart';
import '../confige/EcommerceApp.dart';
import '../models/product_model.dart';
import 'scanBarCode.dart';
import 'dart:core';

class shoppingCart extends StatefulWidget {
  const shoppingCart({Key? key}) : super(key: key);
  @override
  State<shoppingCart> createState() => _shoppingCartState();
}

class _shoppingCartState extends State<shoppingCart> {
  _shoppingCartState();
  String collectionName = EcommerceApp().getCurrentUser();
  bool isInsideHome = false;
  bool isInsideProfile = false;
  bool isInsideSettings = false;
  bool isInsideCart = true;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Color(0xFFF3F4F8),
        body: Padding(
          padding: const EdgeInsets.only(top:20.0),
          child: StreamBuilder<List<Product>>(
              stream: readCartItems(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  /// ماراح يدخل اصلا اذا مافيه ايتمز
                  final products = snapshot.data!;
                  return ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (BuildContext context, int index) {
                        int previousTotal = EcommerceApp.total;
                        if (EcommerceApp.counter == 0) {
                          saveUserTotal(0);
                          return SizedBox(
                            height: 400,
                            child: Center(
                              child: Text(
                                "",
                                //"Your cart is empty!",
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 23,
                                    color: Color.fromARGB(255, 173, 173, 173)),
                              ),
                            ),
                          );
                        }
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
                                          title: Text(
                                              "الرجاء التأكيد!",
                                            style: TextStyle(
                                                fontFamily: 'Tajawal'
                                            ),
                                          ),
                                          content: Text(
                                              "هل أنت متأكد من رغبتك في حذف هذا المنتج؟",
                                            style: TextStyle(
                                                fontFamily: 'Tajawal'
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(ctx).pop(false);
                                                },
                                                child: Text("إلغاء",
                                                  style: TextStyle(
                                                      fontFamily: 'Tajawal'
                                                  ),
                                                )),
                                            ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(ctx).pop(true);
                                                },
                                                child: Text(
                                                  "حذف",
                                                  style: TextStyle(
                                                      color: Color.fromARGB(255, 250, 249, 249),
                                                      fontFamily: 'Tajawal'
                                                  ),
                                                )),
                                          ],
                                        ));
                              },
                              onDismissed: (DismissDirection direction) {
                                if (direction == DismissDirection.endToStart) {
                                  EcommerceApp.counter--;
                                  EcommerceApp.NumOfItems--;
                                  if (products[index].quantity > 1) {
                                    for (int i = 0;
                                        i < products[index].quantity - 1;
                                        i++) {
                                      EcommerceApp.counter--;
                                    }
                                  }
                                  deleteItemGroup(products[index].Category);
                                  deleteItem(products[index].Category);
                                  products.removeAt(index);
                                  if (EcommerceApp.counter < 1) {
                                    saveUserTotal(0);
                                  }
                                }
                              },
                              child: buildSecondItems(products[index], context));
                        }
                        return Center(child: CircularProgressIndicator());
                      });
                } else if (snapshot.hasError) {
                  return Text("Some thing went wrong! ${snapshot.error}");
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
        ),
        bottomNavigationBar: SizedBox(
          height: 220,
          child: Container(

            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topRight: Radius.circular(25), topLeft: Radius.circular(25)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(

                  color: Color(0xBEE7E7E7),
                  blurRadius: 9,
                  blurStyle: BlurStyle.normal

                )
              ]
            ),
              child: Padding(
                padding: const EdgeInsets.only(top:20.0),
                child: Column(
            children: [
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 10.0, right: 20, left: 21),
                  child: Container(

                      alignment: Alignment.centerRight,
                      child: Row(
                        children: [
                          Text(
                            'المجموع  ',
                            style: TextStyle(
                                color: Color.fromARGB(228, 83, 83, 83),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Tajawal'
                            ),
                          ),
                          Spacer(),
                          Text(
                              style: TextStyle(
                                  color: Color.fromARGB(228, 83, 83, 83),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Tajawal'
                              ),
                              (() {
                                if (EcommerceApp.finalTotal == 0) {
                                  saveUserTotal(0);
                                  EcommerceApp.finalTotal = -1;
                                  return EcommerceApp.finalTotal.toString() +
                                      ' ريال';
                                } else {
                                  return EcommerceApp.total.toString() + ' ريال';
                                }
                              }())),
                        ],
                      )),
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 350,
                    height: 45,
                    alignment: Alignment.center,

                    child: SizedBox(
                      width: 350,
                      height: 45,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _scan(context, "NewItem");
                        },
                        label: Text(
                          ' إكـمـال المـسـح',
                          style: const TextStyle(
                              color: Color(0xDD152A56),
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            fontFamily: 'Tajawal'
                          ),
                        ),
                        icon: Icon(
                          Icons.document_scanner,
                          color: Color(0xEE152A56),
                        ),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith((states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Colors.grey;
                              }
                              return Color(0xFFFFFFFF);//Color(0xFFFF9800);
                            }),
                          elevation: MaterialStateProperty.all<double>(0),
                            shape:
                                MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      side: const BorderSide(
                                          color: Color(0xB9152A56),
                                          width: 1.0),
                                    ),

                                ),
                        ),

                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 10),
                  child: Container(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 350,
                      height: 45,
                      child: ElevatedButton(

                        onPressed: () {
                          if (EcommerceApp.total == 0 ||
                              EcommerceApp.finalTotal == 0) {
                            showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                      content: Text(
                                        "لا يوجد منتجات!",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Tajawal'
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(ctx).pop(false);
                                            },
                                            child: Text("إلغاء",
                                              style: TextStyle(
                                                  fontFamily: 'Tajawal'
                                              ),
                                            )),
                                      ],
                                    ));
                          } else {
                            EcommerceApp.totalSummary = EcommerceApp.total;
                            EcommerceApp.inDollars = EcommerceApp.total / 3.75;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CheckOutSummary()),
                            );
                          }
                        },
                        child: Text(
                          'الـدفـع',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              letterSpacing: 1,
                              fontFamily: 'Tajawal'
                          ),
                        ),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith((states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Color(0x86EAEAEA);
                              }
                              return Color(0xFFFF9800);
                            }),
                            elevation: MaterialStateProperty.all<double>(0),
                            shape:
                                MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)))),
                      ),
                    ),
                  ),
                ),
            ],
          ),
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

  Widget buildSecondItems(Product product, BuildContext context) {
    return Container(
      child: Column(
        children: [
          new InkWell(
            child: Row(
              children: <Widget>[
                new Container(
                  child: Stack(children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 0, top: 2.5),
                      child: Container(
                        height: 90,
                        margin: EdgeInsets.all(10),
                        child: ClipRRect(
                          child: Image(
                            image: NetworkImage(
                              product.ProductImage,
                            ),
                          ),
                        ),
                      ),
                    )
                  ]),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      product.Category,
                      style: new TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    SizedBox(height: 10,),
                    if (product.size != "")
                      Text(
                        "المـقاس : " + product.size,
                        style: new TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 0, 0, 0),
                            fontFamily: 'Tajawal'
                        ),
                      ),
                    Text(
                      "السعر : " + product.Price.toString() + ' ريال',
                      textAlign: TextAlign.start,
                      style: new TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 77, 76, 76),
                          fontFamily: 'Tajawal'
                      ),
                    ),
                  ],
                ),
                Spacer(),
                IconButton(
                    onPressed: () async {
                      if (product.quantity == 1) {
                        null;
                      } else {
                        EcommerceApp.productName = product.Category;
                        await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                  title: Text(
                                    "ملاحظة :",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Tajawal'
                                    ),
                                  ),
                                  content: Text(
                                      "يجب عليك مسح الباركود للمنتج المراد حذفه مرة أخرى.",
                                    style: TextStyle(
                                        fontFamily: 'Tajawal'
                                    ),

                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.pop(context, 'حسناً');
                                      },
                                      child: const Text('حسناً'),
                                    )
                                  ]);
                            });
                        if (await _scan(context, "Decrement")) {
                          checkItemExist(false, product.Category);
                        }
                      }
                    },
                    icon: Icon(Icons.remove_circle,
                        color: product.quantity == 1
                            ? Color.fromARGB(255, 195, 195, 195)
                            : Color.fromARGB(181, 128, 149, 186))),
                //Text(product.quantity.toString()),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 35,
                      height: 35,
                      decoration: new BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Text(
                      product.quantity.toString(),
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
                IconButton(
                      onPressed: () async {
                        EcommerceApp.productName = product.Category;
                        await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                  title: Text("ملاحظة :",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Tajawal'
                                      )),
                                  content: Text(
                                      "يجب عليك مسح الباركود للمنتج المراد إضافته.",
                                    style: TextStyle(
                                        fontFamily: 'Tajawal'
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.pop(context, 'حسناً');
                                      },
                                      child: const Text(
                                          'حسناً',
                                        style: TextStyle(
                                            fontFamily: 'Tajawal'
                                        ),
                                      ),
                                    )
                                  ]);
                            });
                        if (await _scan(context, "Increment")) {
                          checkItemExist(true, product.Category);
                          EcommerceApp.counter++;
                        }
                      },
                      icon: Icon(Icons.add_circle,
                          color: Color.fromARGB(181, 128, 149, 186))),
                
              ],
            ),
          ),

        ],
      ),
      color: Color.fromARGB(255, 255, 255, 255),
    );
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
                content: Text(
                    "تم إضافة المنتج مسبقاً.",
                  style: TextStyle(
                      fontFamily: 'Tajawal'
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text(
                        'حسنًا',
                      style: TextStyle(
                          fontFamily: 'Tajawal'
                      ),
                    ),
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Color.fromARGB(255, 135, 155, 190),
        content: Text("تم إضافة المنتج بنجاح",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 17,
                letterSpacing: 0.8,
                fontFamily: 'Tajawal'
            )),
        action: null,
      ));
      return true;
    } else if (event.snapshot.exists &&
        action == "Decrement" &&
        event.snapshot.children.first.child('Product Name').value ==
            EcommerceApp.productName) {
      String dat =
          event.snapshot.children.first.child('Barcode').value as String;
      deleteSingleItem(dat);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Color.fromARGB(255, 135, 155, 190),
        content: Text("تم حذف المنتج بنجاح",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 17,
                letterSpacing: 0.8,
                fontFamily: 'Tajawal'
            )),
        action: null,
      ));
      return true;
    } else if (event.snapshot.exists && action == "Increment") {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                content:
                    Text("Sorry, this is not a ${EcommerceApp.productName}."),
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
                content:
                    Text("Sorry, this is not a ${EcommerceApp.productName}."),
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
                content: Text(
                    "عذرًا المنتج غير موجود!",
                  style: TextStyle(
                      fontFamily: 'Tajawal'
                  ),
                ),
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
      "ProductImage": "new",
    });
  }

  Future saveUserTotal(var total) async {
    await FirebaseFirestore.instance
        .collection('${collectionName}Total')
        .doc("total")
        .set({"Total": total});
  }

  Future getUserTotal() async {
    var collection =
        FirebaseFirestore.instance.collection('${collectionName}Total');
    collection.doc('total').snapshots().listen((docSnapshot) {
      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data()!;

        // You can then retrieve the value from the Map like this:
        //if (mounted)
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

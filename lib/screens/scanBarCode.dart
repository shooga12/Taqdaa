import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:taqdaa_application/screens/ShoppingCart.dart';
import '../confige/EcommerceApp.dart';
import 'list_of_stores.dart';

class ScanPage extends StatefulWidget {
  const ScanPage(this.value, {Key? key}) : super(key: key);
  final String value;
  @override
  State<ScanPage> createState() => _ScanPageState(value);
}

class _ScanPageState extends State<ScanPage> {
  String _value = "";
  _ScanPageState(this._value);
  String collectionName = "sjjbkAloSn0nggB3B";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "",
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
      ),
      body: StreamBuilder<List<Product>>(
          stream: readItems(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final products = snapshot.data!;
              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (BuildContext context, int index) =>
                    buildBeforeCart(products[index], context),
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
      //Text(widget.value),
    );
  }

  Future saveUserItems(Product product) async {
    FirebaseFirestore.instance.collection('${collectionName}').add({
      "Category": product.Category,
      "Item_number": product.Item_number,
      "Price": product.Price,
      "Store": product.Store,
    });
    // final docUser = FirebaseFirestore.instance
    //     .collection('10NoXYa9i2zFkhJqObtG')
    //     .doc('UserItems');
    // final json = {
    //   "Category": product.Category,
    //   "Item_number": product.Item_number,
    //   "Price": product.Price,
    //   "Store": product.Store,
    // };
    // await docUser.set(json);

    // FirebaseFirestore.instance
    //     .collection("ktRaj5JVLTY69zWa8MX4")
    //     .doc("UserItme") ////لازم نغيره لفاريبل بعدين fUser.uid
    //     .set({
    //   "Category": product.Category,
    //   "Item_number": product.Item_number,
    //   "Price": product.Price,
    //   "Store": product.Store,
    // });
  }

  Stream<List<Product>> readItems() => FirebaseFirestore.instance
      .collection('Products')
      .where("Item_number", isEqualTo: _value.substring(1))
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Product.fromJson(doc.data())).toList());

  Widget buildBeforeCart(Product product, BuildContext context) {
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
                            // Container(
                            //   child: new Image.asset(
                            //     'assets/Rectangle.png',
                            //     height: 80.0,
                            //     fit: BoxFit.cover,
                            //   ),
                            // ),
                            Container(
                              alignment: Alignment.bottomLeft, //اعدله
                              child: Text(
                                "\n      " + product.Category,
                                style: new TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ]),
                        ),
                        Text(
                          "   Price : " + product.Price + " SR",
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 77, 76, 76),
                          ),
                        ),

                        IconButton(
                            onPressed: () {
                              //controller.removeProduct(product);
                            },
                            icon: Icon(Icons.remove_circle,
                                color: Color.fromARGB(255, 245, 161, 14))),
                        //Text('$quantity'),
                        Text('1'),
                        IconButton(
                            onPressed: () {
                              //controller.addProduct(product);
                            },
                            icon: Icon(Icons.add_circle,
                                color: Color.fromARGB(255, 245, 161, 14))),
                      ],
                    ),
                  ),
                  onTap: () {},
                ),
                color: Color.fromARGB(255, 248, 248, 246),
              ),
              // IconButton(
              //     onPressed: () {
              //       saveUserItems(product);
              //     },
              //     icon: Icon(Icons.add_shopping_cart)),
            ],
          ),
          //),
          Column(
            //lower part
            children: [
              Divider(thickness: 2, color: Color.fromARGB(255, 162, 190, 243)),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     Text("TOTAL ", style: Theme.of(context).textTheme.headline5),
              //     Text("5" + " SR",
              //         style: Theme.of(context).textTheme.headline5),
              //   ],
              // ),
              Column(
                children: [
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        //save
                        saveUserItems(product);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => shoppingCart(_value)),
                        );
                        // EcommerceApp.itemsCounter++;
                        // saveUserItems(product);
                        // StreamBuilder<List<Product>>(
                        //     stream: readItems(), ////
                        //     builder: (context, snapshot) {
                        //       if (snapshot.hasData) {
                        //         final products = snapshot.data!;
                        //         return ListView.builder(
                        //           itemCount: products.length,
                        //           itemBuilder:
                        //               (BuildContext context, int index) =>
                        //                   buildSecondItmes(
                        //                       products[index], context),
                        //           //{
                        //           //   //Map thisItem = stores[index];
                        //           //   return ListTile(
                        //           //     title: Text(''),
                        //           //     subtitle: Text(''),
                        //           //   );
                        //           // }
                        //           //
                        //           //children: stores.map(buildStoresCards).toList(),
                        //         );
                        //       } else if (snapshot.hasError) {
                        //         return Text(
                        //             "Some thing went wrong! ${snapshot.error}");
                        //       } else {
                        //         return Center(
                        //             child: CircularProgressIndicator());
                        //       }
                        //     });
                      }, //_scan,
                      child: const Text('Add to cart'),
                      style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 245, 161, 14)),

                      // child: const Text('Continue Scanning'),
                      // style: ElevatedButton.styleFrom(
                      //     primary: Color.fromARGB(255, 245, 161, 14)),
                    ),
                  ),
                  // Center(
                  //   child: ElevatedButton(
                  //     child: const Text('Checkout'),
                  //     onPressed: () {
                  //       // Navigator.push(
                  //       //   context,
                  //       //   MaterialPageRoute(
                  //       //       builder: (context) => ListOfStores2()),
                  //       // );
                  //     },
                  //     style: ElevatedButton.styleFrom(
                  //         primary: Color.fromARGB(255, 245, 161, 14)),
                  //   ),
                  // )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

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
                            // Container(
                            //   child: new Image.asset(
                            //     'assets/Rectangle.png',
                            //     height: 80.0,
                            //     fit: BoxFit.cover,
                            //   ),
                            // ),
                            Container(
                              alignment: Alignment.bottomLeft, //اعدله
                              child: Text(
                                "\n      " + product.Category,
                                style: new TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ]),
                        ),
                        Text(
                          "   Price : " + product.Price + " SR",
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 77, 76, 76),
                          ),
                        ),
                        Spacer(),
                        IconButton(
                            onPressed: () {
                              //controller.removeProduct(product);
                            },
                            icon: Icon(Icons.remove_circle,
                                color: Color.fromARGB(255, 245, 161, 14))),
                        //Text('$quantity'),
                        Text('1'),
                        IconButton(
                            onPressed: () {
                              //controller.addProduct(product);
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
          Column(
            //lower part
            children: [
              Divider(thickness: 2, color: Color.fromARGB(255, 162, 190, 243)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("TOTAL ", style: Theme.of(context).textTheme.headline5),
                  Text("5" + " SR",
                      style: Theme.of(context).textTheme.headline5),
                ],
              ),
              Column(
                children: [
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        _scan(context, product.Store);
                      }, //_scan,
                      child: const Text('Continue Scanning'),
                      style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 245, 161, 14)),
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                      child: const Text('Checkout'),
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => ListOfStores2()),
                        // );
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 245, 161, 14)),
                    ),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _counter = "";
  //String _value = "";

  Future _scan(BuildContext context, String storeName) async {
    _counter = await FlutterBarcodeScanner.scanBarcode(
        "#004297", "Cancel", true, ScanMode.BARCODE);

    setState(() {
      _value = _counter;
    });

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //       builder: (context) => ScanPage(
    //             _value,
    //             storeName,
    //             products2
    //           )),
    // );
  }
}

class Product {
  final String Category;
  final String Item_number;
  final String Price;
  final String Store;

  Product(
      {required this.Category,
      required this.Item_number,
      required this.Price,
      required this.Store});

  Map<String, dynamic> toJson() => {
        'Category': Category,
        'Item_number': Item_number,
        'Price': Price,
        'Store': Store,
      };

  static Product fromJson(Map<String, dynamic> json) => Product(
        Category: json['Category'],
        Item_number: json['Item_number'],
        Price: json['Price'].toString(),
        Store: json['Store'],
      );
}

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:taqdaa/main.dart';
import 'package:taqdaa/screens/home_page.dart';
import '../confige/EcommerceApp.dart';
import 'paypalPayment.dart';
import 'scanBarCode.dart';
import 'package:http/http.dart' as http;

class shoppingCart extends StatefulWidget {
  const shoppingCart({Key? key}) : super(key: key);
  @override
  State<shoppingCart> createState() => _shoppingCartState();
}

class _shoppingCartState extends State<shoppingCart> {
  _shoppingCartState();
  String collectionName = EcommerceApp().getCurrentUser();
  var url = 'https://us-central1-taqdaa-10e41.cloudfunctions.net/paypalPayment';

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
                      //saveUserItems(products[index]);
                      return buildSecondItmes(products[index], context);
                    }
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
        bottomNavigationBar: SizedBox(
          height: 140,
          child: Container(
              child: Column(
            children: [
              Container(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _scan(
                      context,
                    );
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
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)))),
                ),
              ),

              //----------------------------------------------------------------

              Container(
                height: kToolbarHeight,
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Text(
                              'TOTAL',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Text(
                              'SR ', //${products.totalAmount.roundToDouble()}
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ElevatedButton.icon(
                            icon: Icon(
                              Icons.paypal,
                              color: Color.fromARGB(255, 2, 85, 123),
                              size: 30.0,
                            ),
                            label: Text('Pay with paypal'),
                            onPressed: () async {
                              //-------------------make paypal payment---------------

                              var request = BraintreeDropInRequest(
                                tokenizationKey:
                                    'sandbox_jy7b8nfy_pdhgjqwbz3wk8t76',
                                collectDeviceData: true,
                                cardEnabled: true,
                                paypalRequest: BraintreePayPalRequest(
                                    amount: '9',
                                    currencyCode: 'USD',
                                    displayName: 'Taqdaa'),
                              );
                              BraintreeDropInResult? result =
                                  await BraintreeDropIn.start(request);

                              if (result != null) {
                                print(result.paymentMethodNonce.description);
                                print(result.paymentMethodNonce.nonce);

                                String urli =
                                    '$url?payment_method_nonce=${result.paymentMethodNonce.nonce}&device_data=${result.deviceData}';

                                final http.Response response = await http
                                    .post(Uri.parse(urli)); //tryParse?

                                // final payResult = jsonEncode(response.body);

                                // if (payResult == null) {
                                //   print('payment done');
                                // }

                                print('Here!');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0),
                              ),
                            ),
                          )
                        ],
                      )),
                      // child: ElevatedButton(
                      //   onPressed: () {
                      //     //-------make paypal payment-----------
                      //     Navigator.of(context).push(MaterialPageRoute(
                      //         builder: (BuildContext context) =>
                      //             PaypalPayment(onFinish: (number) async {
                      //               print('order id:' + number);
                      //             })));
                      //   },
                      //   child: Text(
                      //     'Checkout',
                      //     style: const TextStyle(
                      //         color: Colors.white,
                      //         fontWeight: FontWeight.bold,
                      //         fontSize: 16),
                      //   ),
                      //   style: ButtonStyle(
                      //       backgroundColor:
                      //           MaterialStateProperty.resolveWith((states) {
                      //         if (states.contains(MaterialState.pressed)) {
                      //           return Colors.grey;
                      //         }
                      //         return Colors.orange;
                      //       }),
                      //       shape: MaterialStateProperty.all<
                      //               RoundedRectangleBorder>(
                      //           RoundedRectangleBorder(
                      //               borderRadius: BorderRadius.circular(30)))),
                      // ),
                    )
                  ],
                ),
              ),
              //-----------------------------------------------------------------
            ],
          )),
        ));
  }

  Future saveUserItems(Product product) async {
    final docUser = FirebaseFirestore.instance
        .collection('${collectionName}')
        .doc('UserItem');
    final json = {
      "Category": product.Category,
      "Item_number": product.Item_number,
      "Price": product.Price,
      "Store": product.Store,
    };
    await docUser.set(json);
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
                                height: 100.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomLeft, //اعدله
                              child: Text(
                                "\n " + product.Category,
                                style: new TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 32, 7, 121),
                                ),
                              ),
                            ),
                          ]),
                        ),
                        Text(
                          "   Price : " + product.Price.toString() + " SR",
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
        ],
      ),
    );
  }

  String _counter = "";
  //String _value = "";

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
}

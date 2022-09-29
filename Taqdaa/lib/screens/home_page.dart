import 'dart:convert';
import 'dart:core';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:taqdaa/confige/EcommerceApp.dart';
import 'package:taqdaa/screens/NoItmesCart.dart';
import 'ShoppingCart.dart';
import 'list_of_stores.dart';
import 'paypalPayment.dart';
import 'scanBarCode.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var url = 'https://us-central1-taqdaa-10e41.cloudfunctions.net/paypalPayment';

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                 mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton.icon(
                icon: Icon(
                  Icons.paypal,
                  color: Colors.lightBlue,
                  size: 30.0,
                ),
                label: Text('Pay with paypal'),
                onPressed: () async {
                  //-------make paypal payment-----------

                  var request = BraintreeDropInRequest(
                      tokenizationKey: 'sandbox_jy7b8nfy_pdhgjqwbz3wk8t76',
                      collectDeviceData: true,
                      paypalRequest: BraintreePayPalRequest(
                          amount: '9.77', displayName: 'Taqdaa'),
                      cardEnabled: true);
                  BraintreeDropInResult? result =
                      await BraintreeDropIn.start(request);
                  if (result != null) {
                    print(result.paymentMethodNonce.description);
                    print(result.paymentMethodNonce.nonce);

                    String urli =
                        '$url?payment_method_nonce=${result.paymentMethodNonce.nonce}&device_data=${result.deviceData}';
            
                    final http.Response response = await http
                        .post(Uri.parse(urli)); //tryParse?
                          //http.post(Uri.parse(Uri.encodeFull(urli)));

                    

                    final payResult = jsonDecode(jsonEncode(response.body));

                    if (payResult == null) {
                      print('payment done');
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0),
                  ),
                ),
              )
            ],
          )),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: size.width,
              height: 80,
              color: Colors.white,
              child: Stack(
                children: [
                  CustomPaint(
                    size: Size(size.width, 80),
                    painter: BNBCustomePainter(),
                  ),
                  Center(
                      heightFactor: 0.6,
                      child: Container(
                        width: 65,
                        height: 65,
                        child: FittedBox(
                          child: FloatingActionButton(
                            onPressed: () {
                              // ApiServices apiServices = ApiServices();
                              // apiServices.addCollection();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ListOfStores2()),
                              );
                            },
                            backgroundColor: Colors.orange,
                            child: Icon(
                              Icons.document_scanner_outlined,
                              size: 27,
                            ),
                            //elevation: 0.1,
                          ),
                        ),
                      )),
                  Container(
                    width: size.width,
                    height: 80,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.home,
                                size: 30,
                                color: Colors.white,
                              )),
                          IconButton(
                              onPressed: () {
                                if (EcommerceApp.haveItmes) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => shoppingCart()),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => emptyCart()),
                                  );
                                }
                              },
                              icon: Icon(
                                Icons.shopping_cart,
                                size: 30,
                                color: Colors.white,
                              )),
                          Container(
                            width: size.width * 0.20,
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.person,
                                size: 30,
                                color: Colors.white,
                              )),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.settings,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ]),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class BNBCustomePainter extends CustomPainter {
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Color.fromARGB(255, 32, 7, 121)
      ..style = PaintingStyle.fill;
    Path path = Path()..moveTo(0, 20);
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(Offset(size.width * 0.60, 20),
        radius: Radius.circular(10.0), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawPath(path, paint);
  }

  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

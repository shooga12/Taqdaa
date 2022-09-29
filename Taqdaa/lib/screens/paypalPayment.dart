import 'dart:core';
//import 'dart:html';
import 'package:flutter/material.dart';
import 'package:taqdaa/methods/paypalServices.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_paypal/flutter_paypal.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taqdaa/main.dart';
import '../confige/EcommerceApp.dart';
import 'paymentButton.dart';
import 'scanBarCode.dart';
import 'ShoppingCart.dart';

class PaypalPayment extends StatefulWidget {
  final Function onFinish;
  PaypalPayment({required this.onFinish});

  @override
  State<PaypalPayment> createState() {
    return _PaypalPaymentState();
  }
}

class _PaypalPaymentState extends State<PaypalPayment> {
  GlobalKey<ScaffoldState> _scaffloldKey = GlobalKey<ScaffoldState>();
  var checkoutUrl;
  var executeUrl;
  var accessToken;
  PaypalServices services = PaypalServices();

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      try {
        accessToken = await services.getAccessToken();
        final transactions = getOrderParams();
        final res =
            await services.createPaypalPayment(transactions, accessToken);
        if (res != null) {
          setState(() {
            checkoutUrl = res["approvalUrl"];
            executeUrl = res["executeUrl"];
          });
        }
      } catch (e) {
        print('exception:' + e.toString());
      }
    });
  }

  String returnURL = "return.example.com"; //----------
  String cancelURL = "return.example.com"; //----------

  Map<dynamic, dynamic> defaultCurrency = {
    "symbol": "SR",
    "decimalDigits": 2,
    "symbolBeforeTheNumber": true,
    "currency": "SR"
  };
  String itemName = "SheetMask";
  String itemPrice = "9.77";
  int quantity = 1;

  Map<String, dynamic> getOrderParams() {
    List items = [
      {
        "name": itemName,
        "quantity": quantity,
        "price": itemPrice,
        "currency": defaultCurrency["currency"]
      }
    ];

    Map<String, dynamic> temp = {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": [
        {
          "amount": {
            "total": EcommerceApp.totalAmount, ////-------------
            "currency": defaultCurrency["currency"],
          },
          "description": "The payment trasaction description.",
          "payment_options": {
            "allowed_paymant_method": "INSTANT_FUNDING_SOURCE"
          },
          "item_list": {
            "items": items,
          }
        }
      ],
      "note_to_payer": "Contact us for any questions on your order.",
      "redirect_urls": {"return_url": returnURL, "cancel_url": cancelURL}
    };

    return temp;
  }

  @override
  Widget build(BuildContext context) {
    print(checkoutUrl);
    if (checkoutUrl != null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          leading: GestureDetector(
            child: Icon(Icons.arrow_back),
            onTap: () => Navigator.pop(context),
          ),
        ),
        body: WebView(
          initialUrl: checkoutUrl,
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (NavigationRequest request) {
            if (request.url.contains(returnURL)) {
              final uri = Uri.parse(request.url);
              final payerID = uri.queryParameters['PayerID'];
              if (payerID != null) {
                services
                    .executePayment(executeUrl, payerID, accessToken)
                    .then((id) {
                  widget.onFinish(id);
                  Navigator.pop(context);
                });
              } else {
                Navigator.of(context).pop();
              }
              Navigator.of(context).pop();
            }
            if (request.url.contains(cancelURL)) {
              Navigator.of(context).pop();
            }
            return NavigationDecision.navigate;
          },
        ),
      );
    } else {
      return Scaffold(
        key: _scaffloldKey,
        appBar: AppBar(
            leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )),
        body: Center(child: Container(child: CircularProgressIndicator(),)),
      );
    }
  }
}

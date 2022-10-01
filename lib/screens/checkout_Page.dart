import 'package:cloud_firestore/cloud_firestore.dart' hide Query;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import '../confige/EcommerceApp.dart';
import '../main.dart';
import 'package:http/http.dart' as http;

class checkOut {
  var url = 'https://us-central1-taqdaa-10e41.cloudfunctions.net/paypalPayment';

  String collectionName = EcommerceApp().getCurrentUser();
  final RFIDs = [];
  String data1 = "";

  void payment(BuildContext context) async {
    var request = BraintreeDropInRequest(
      tokenizationKey: 'sandbox_jy7b8nfy_pdhgjqwbz3wk8t76',
      collectDeviceData: true,
      paypalEnabled: true,
      paypalRequest: BraintreePayPalRequest(
          amount: EcommerceApp.total.toString(), displayName: 'Taqdaa'),
    );

    BraintreeDropInResult? result = await BraintreeDropIn.start(request);
    if (result != null) {
      print(result.paymentMethodNonce.description);
      print(result.paymentMethodNonce.nonce);

      EcommerceApp.storeName = "";

      String urli =
          '$url?payment_method_nonce=${result.paymentMethodNonce.nonce}&device_data=${result.deviceData}';

      final http.Response response = await http.post(Uri.parse(urli));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                title: Text(
                  "Your Payment completed succefully!\nThank you!",
                  style: TextStyle(fontSize: 18),
                ),
                actions: [
                  TextButton(
                    onPressed: () async {
                      await readRFIDs();
                      await writeRFID();
                      await deleteCart();
                      await deleteCartDublicate();
                      await saveUserTotal(0);
                      Navigator.pop(context, 'OK');
                    },
                    child: const Text('OK'),
                  )
                ]);
          });
    }
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

  Future deleteCart() async {
    final QuerySnapshot result =
        await FirebaseFirestore.instance.collection('${collectionName}').get();
    final List<DocumentSnapshot> documents = result.docs;
    for (int i = 0; i < documents.length; i++) {
      documents[i].reference.delete();
    }
  }

  Future deleteCartDublicate() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('${collectionName}All')
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    for (int i = 0; i < documents.length; i++) {
      documents[i].reference.delete();
    }
  }

  Future readRFIDs() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('${collectionName}All')
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    for (int i = 0; i < documents.length; i++) {
      RFIDs.add(documents[i].get("RFID"));
    }
  }

  Future writeRFID() async {
    DatabaseReference dbref = FirebaseDatabase.instance.ref('Purchased');

    for (int i = 0; i < RFIDs.length; i++) {
      //dbref.push().set({"$i": RFIDs[i]});
      dbref.update({"$collectionName$i": RFIDs[i]});
    }
  }
}

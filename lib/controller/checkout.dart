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
          amount: EcommerceApp.inDollars.toString(), displayName: 'Taqdaa'),
    );

    BraintreeDropInResult? result = await BraintreeDropIn.start(request);
    if (result != null) /*Successful Payment*/ {
      int reward = ((EcommerceApp.total * 2) / 100) as int; //make sure works
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
                  "شكرًا لك، تم الدفع بنجاح!",
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
                      await saveUserRewards(reward);
                      Navigator.pop(context, 'حسنًا');
                    },
                    child: const Text('حسنًا'),
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

  Future saveUserRewards(var reward) async {
    if (EcommerceApp.rewards == 0) {
      await FirebaseFirestore.instance
          .collection('${collectionName}Total')
          .doc("rewards")
          .set({"Rewards": reward});
    } else {
      ///write rewards
      await FirebaseFirestore.instance
          .collection('${collectionName}Total')
          .doc("rewards")
          .update({"Rewards": FieldValue.increment(reward)});
    }

    // ///update number of invoices
    // FirebaseFirestore.instance
    //     .collection('${collectionName}Total')
    //     .doc("NumberOfInvoices")
    //     .update({"NumberOfInvoices": FieldValue.increment(1)});
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

      ///write invoices
      FirebaseFirestore.instance.collection('${collectionName}Invoices').add({
        "Category": documents[i].get("Category"),
        "Item_number": documents[i].get("Item_number"),
        "Price": documents[i].get("Price"),
        "Store": documents[i].get("Store"),
        "ProductImage": documents[i].get("ProductImage"),
      });
      FirebaseFirestore.instance.collection('InvoicesManager').add({
        "Category": documents[i].get("Category"),
        "Item_number": documents[i].get("Item_number"),
        "Price": documents[i].get("Price"),
        "Store": documents[i].get("Store"),
        "ProductImage": documents[i].get("ProductImage"),
      });
    }
  }

  Future writeRFID() async {
    DatabaseReference dbref = FirebaseDatabase.instance.ref('Purchased');

    for (int i = 0; i < RFIDs.length; i++) {
      dbref.update({"$collectionName$i": RFIDs[i]});
    }
  }
}

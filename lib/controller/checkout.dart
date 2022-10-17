import 'package:cloud_firestore/cloud_firestore.dart' hide Query;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:taqdaa_application/screens/invoice_afterPayment.dart';
import '../confige/EcommerceApp.dart';
import '../main.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'package:taqdaa_application/models/item.dart';
import '../models/invoice.dart';
import '../screens/invoice_details.dart';
import 'package:intl/intl.dart';

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
      int reward = 0;
      if (EcommerceApp.rewardsExchanged) {
        reward = (EcommerceApp.total * 2) ~/ 100;
      } //make sure works

      String urli =
          '$url?payment_method_nonce=${result.paymentMethodNonce.nonce}&device_data=${result.deviceData}';

      final http.Response response = await http.post(Uri.parse(urli));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
      Invoice invoice = await writeInvoices();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => invoice_afterPayment(invoice),
        ),
      );
      EcommerceApp.storeName = "";
      EcommerceApp.haveItems = false;
      EcommerceApp.NumOfItems = 0;
      EcommerceApp.counter = 0;
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
                      Navigator.pop(context, 'حسنًا');
                      await readRFIDs();
                      await writeRFID();
                      await deleteCart();
                      await deleteCartDublicate();
                      await saveUserTotal(0);
                      if (EcommerceApp.rewardsExchanged) {
                        await saveUserRewards(
                            reward); //bug fixes rewards not gained
                      }
                    },
                    child: const Text('حسنًا'),
                  )
                ]);
          });
      EcommerceApp.rewardsExchanged = false;
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

      // FirebaseFirestore.instance.collection('InvoicesManager').add({
      //   "Category": documents[i].get("Category"),
      //   "Item_number": documents[i].get("Item_number"),
      //   "Price": documents[i].get("Price"),
      //   "Store": documents[i].get("Store"),
      //   "ProductImage": documents[i].get("ProductImage"),
      // });
    }
  }

  Future writeRFID() async {
    DatabaseReference dbref = FirebaseDatabase.instance.ref('Purchased');

    for (int i = 0; i < RFIDs.length; i++) {
      dbref.update({"$collectionName$i": RFIDs[i]});
    }
  }

  Future<Invoice> writeInvoices() async {
    var items = [];
    Random random = new Random();
    int randomNumber = random.nextInt(1000);
    double vat = (EcommerceApp.total * 15) / 100;
    int subTotal = EcommerceApp.total - vat.toInt();
    var now = new DateTime.now();
    var formatter = new DateFormat('dd/MM/yyyy');
    String todayDate = formatter.format(now);

    final QuerySnapshot result =
        await FirebaseFirestore.instance.collection('${collectionName}').get();
    final List<DocumentSnapshot> documents = result.docs;
    for (int i = 0; i < documents.length; i++) {
      items.add(Item(
              barcode: documents[i].get("Item_number"),
              name: documents[i].get("Category"),
              img: documents[i].get("ProductImage"),
              quantity: documents[i].get("quantity"),
              price: documents[i].get("Price"),
              returnable: true)

          ///bug fixes returnable
          .toMap());
    }
    FirebaseFirestore.instance.collection('${collectionName}Invoices').add({
      "ID": randomNumber.toString(),
      "Date": '20/10/2022',

      ///bug fixes date should be generated
      "Total": EcommerceApp.total - EcommerceApp.discount.toInt(),
      "Store": EcommerceApp.storeName,
      "items": items,
      'sub-total': subTotal,
      'vat-total': vat,
      'rewardsDiscount': EcommerceApp.discount,
      'HaveReturnReq': false,
      'status': ""
    }).catchError((onError) => print(onError));

    Invoice invoice = new Invoice(items,
        id: randomNumber.toString(),
        date: todayDate,
        total: EcommerceApp.total - EcommerceApp.discount.toInt(),
        store: EcommerceApp.storeName,
        sub_total: subTotal,
        vat_total: vat,
        rewardsDiscount: EcommerceApp.discount);
    return invoice;
  }
}

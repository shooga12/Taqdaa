import 'package:cloud_firestore/cloud_firestore.dart' hide Query;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../confige/EcommerceApp.dart';

class CheckOut extends StatefulWidget {
  const CheckOut({super.key});

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  String collectionName = EcommerceApp().getCurrentUser();
  final RFIDs = [];
  String data1 = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
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
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              readRFIDs();
              writeRFID();
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                        title: Text(
                          "Your Payment completed succefully!",
                          style: TextStyle(fontSize: 18),
                        ), ///////
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'OK'),
                            child: const Text('OK'),
                          )
                        ]);
                  });
            },
            child: Padding(
              padding: const EdgeInsets.all(9.0),
              child: Text(
                'Pay',
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: 20),
              ),
            ),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.pressed)) {
                    return Colors.grey;
                  }
                  return Colors.orange;
                }),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)))),
          ),
        ));
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

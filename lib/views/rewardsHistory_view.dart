import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../confige/EcommerceApp.dart';
import '../models/invoice.dart';

class rewardsHistory extends StatefulWidget {
  const rewardsHistory({super.key});

  @override
  State<rewardsHistory> createState() => _rewardsHistoryState();
}

class _rewardsHistoryState extends State<rewardsHistory> {
  String collectionName = EcommerceApp().getCurrentUser();
  List<Invoice> invoices = [];
  num discount = 0;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    readInvoices();
  }

  Future readInvoices() async {
    var data = await FirebaseFirestore.instance
        .collection('${collectionName}Invoices')
        .get();

    setState(() {
      invoices = List.from(data.docs.map((doc) => Invoice.fromMap(doc)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "تاريخ النقاط",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w100),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/Vector.png"), fit: BoxFit.fill)),
          ),
          toolbarHeight: 170,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: ListView.builder(
            itemCount: invoices.length,
            itemBuilder: (context, index) {
              discount = invoices[index].rewardsDiscount! * 10;
              return Column(
                children: [
                  buildEarnedRewards(invoices[index], context),
                  if (invoices[index].rewardsDiscount != 0)
                    buildDiscountRewards(invoices[index], context)
                ],
              );
            }));
  }

  buildEarnedRewards(Invoice invoice, BuildContext context) {
    int reward = (invoice.total! * 2) ~/ 100;
    return Card(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 15.0, right: 15, top: 18, bottom: 5),
        child: Container(
          height: 60,
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.add,
                    color: Colors.green,
                  ),
                  Text("  $reward.0 نقطة",
                      style: TextStyle(fontSize: 18, color: Colors.green)),
                  Spacer(),
                  Text("${invoice.date}   ", style: TextStyle(fontSize: 18)),
                ],
              ),
              Row(
                children: [
                  Spacer(),
                  Text("رقـم الـفـاتـورة ${invoice.id}  ",
                      style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(133, 80, 80, 80))),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  buildDiscountRewards(Invoice invoice, BuildContext context) {
    return Card(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 15.0, right: 15, top: 18, bottom: 5),
        child: Container(
          height: 60,
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.remove,
                    color: Color.fromARGB(255, 227, 45, 45),
                  ),
                  Text("  $discount نقطة",
                      style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 227, 45, 45))),
                  Spacer(),
                  Text("${invoice.date}   ", style: TextStyle(fontSize: 18)),
                ],
              ),
              Row(
                children: [
                  Spacer(),
                  Text("رقـم الـفـاتـورة ${invoice.id}  ",
                      style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(133, 80, 80, 80))),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

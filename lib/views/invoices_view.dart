import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Query;
import '../confige/EcommerceApp.dart';
import '../screens/invoice_details.dart';
import '../models/invoice.dart';

class invoices extends StatefulWidget {
  const invoices({super.key});

  @override
  State<invoices> createState() => _invoicesState();
}

class _invoicesState extends State<invoices> {
  String collectionName = EcommerceApp().getCurrentUser();
  List<Invoice> invoices = [];
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

  int count = -1;
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
          padding:
              const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 15),
          child: ListView.builder(
              itemCount: invoices.length,
              itemBuilder: (context, index) {
                return buildInvoiceCard(invoices[index], context);
              })),
    );
  }

  nothing() {
    return Container();
  }

  buildInvoiceCard(Invoice invoice, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
      child: Container(
        child: new InkWell(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.receipt_long,
                    size: 40,
                    color: Color.fromARGB(255, 254, 177, 57),
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      " رقم الفاتورة: ${invoice.id}",
                      style: new TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      " المتجر: ${invoice.store}",
                      style: new TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      "${invoice.date}",
                      style: new TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Icon(
                  Icons.arrow_back_ios_rounded,
                  textDirection: TextDirection.ltr,
                  color: Color.fromARGB(255, 254, 177, 57),
                ),
              ],
            ),
          ),
          onTap: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => invoice_details(invoice),
              ),
            );
          },
          highlightColor: Color.fromARGB(255, 255, 255, 255),
        ),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 241, 241, 241),
              offset: Offset.zero,
              blurRadius: 20.0,
              blurStyle: BlurStyle.normal,
            ),
          ],
        ),
      ),
    );
  }
}

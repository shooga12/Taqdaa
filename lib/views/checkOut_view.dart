import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../confige/EcommerceApp.dart';
import '../controller/checkout.dart';
import '../screens/scanBarCode.dart';

class CheckOutSummary extends StatefulWidget {
  const CheckOutSummary({super.key});

  @override
  State<CheckOutSummary> createState() => _CheckOutSummaryState();
}

class _CheckOutSummaryState extends State<CheckOutSummary> {
  String collectionName = EcommerceApp().getCurrentUser();
  double vat = (EcommerceApp.total * 15) / 100;

  @override
  Widget build(BuildContext context) {
    String subTotal = (EcommerceApp.total - vat).toString();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Review your order!",
          style: TextStyle(fontSize: 24),
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
      body: StreamBuilder<List<Product>>(
          stream: readCartItems(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              /// ماراح يدخل اصلا اذا مافيه ايتمز
              final products = snapshot.data!;
              return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (BuildContext context, int index) {
                    return buildSecondItmes(products[index], context);
                  });
            } else if (snapshot.hasError) {
              return Text("Some thing went wrong! ${snapshot.error}");
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
      bottomNavigationBar: SizedBox(
        height: 300,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0, left: 25, right: 25),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: Row(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text('Sub-Total',
                              style: TextStyle(
                                color: Color.fromARGB(255, 32, 7, 121),
                                fontSize: 15,
                              )),
                        ),
                        Spacer(),
                        Text(subTotal + ' SR',
                            style: TextStyle(
                              color: Color.fromARGB(255, 32, 7, 121),
                              fontSize: 15,
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: Row(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text('VAT 15%',
                              style: TextStyle(
                                color: Color.fromARGB(255, 32, 7, 121),
                                fontSize: 15,
                              )),
                        ),
                        Spacer(),
                        Text(vat.toString() + ' SR',
                            style: TextStyle(
                              color: Color.fromARGB(255, 32, 7, 121),
                              fontSize: 15,
                            )),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Total',
                            style: TextStyle(
                                color: Color.fromARGB(255, 32, 7, 121),
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          )),
                      Spacer(),
                      Text(EcommerceApp.total.toString() + ' SR',
                          style: TextStyle(
                              color: Color.fromARGB(255, 32, 7, 121),
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey,
              indent: 20,
              endIndent: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 5,
                bottom: 10.0,
                left: 25,
              ),
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text("Payment Method",
                    style: TextStyle(
                        color: Color.fromARGB(255, 32, 7, 121),
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 23, bottom: 23),
              child: Container(
                alignment: Alignment.centerLeft,
                child: new Image.asset(
                  'assets/paypal.png',
                  height: 45.0,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: SizedBox(
                width: 200,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                              title: Text("Please Note"),
                              content: Text(
                                  "Your total price will be in ${EcommerceApp.inDollars.toStringAsFixed(2)}\$."), ////Teacher note
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(ctx).pop(false);
                                    },
                                    child: Text("Cancel")),
                                ElevatedButton(
                                    //style: Color
                                    onPressed: () {
                                      checkOut().payment(context);
                                      Navigator.of(ctx).pop(false);
                                    },
                                    child: Text("Continue")),
                              ],
                            ));
                  },
                  child: Text(
                    'Place Order',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
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
            ),
          ],
        ),
      ),
    );
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
                                height: 92.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 25, top: 2.5),
                              child: Container(
                                width: 65,
                                margin: EdgeInsets.all(10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image(
                                    image: NetworkImage(
                                      product.ProductImage,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ]),
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              "\n " + product.Category,
                              style: new TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 32, 7, 121),
                              ),
                            ),
                            Text(
                              "   Price : " + product.Price.toString() + " SR",
                              textAlign: TextAlign.center,
                              style: new TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 77, 76, 76),
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 35,
                              height: 35,
                              decoration: new BoxDecoration(
                                color: Color.fromARGB(255, 245, 161, 14),
                                shape: BoxShape.circle,
                              ),
                            ),
                            Text(
                              product.quantity.toString(),
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                        Text("  "),
                      ],
                    ),
                  ),
                ),
                color: Color.fromARGB(255, 248, 248, 246),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

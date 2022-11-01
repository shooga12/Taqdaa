import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'rewardsExchange_view.dart';
import '../confige/EcommerceApp.dart';
import '../controller/checkout.dart';
import '../screens/ShoppingCart.dart';

class CheckOutSummary extends StatefulWidget {
  const CheckOutSummary({super.key});

  @override
  State<CheckOutSummary> createState() => _CheckOutSummaryState();
}

class _CheckOutSummaryState extends State<CheckOutSummary> {
  String collectionName = EcommerceApp().getCurrentUser();
  double vat = (EcommerceApp.total * 15) / 100;
  int offerDiscpunt = EcommerceApp.totalSummary * 20 ~/ 100;

  @override
  Widget build(BuildContext context) {
    String subTotal = (EcommerceApp.total - vat).toString();
    if (EcommerceApp.storeName == "Sephora" && EcommerceApp.firstOffer ||
        EcommerceApp.storeName == "H&M" && EcommerceApp.firstOffer) {
      EcommerceApp.totalSummary =
          EcommerceApp.totalSummary - EcommerceApp.totalSummary * 20 ~/ 100;
      EcommerceApp.firstOffer = false;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "مراجعة الطلب !",
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
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 8,
              bottom: 10.0,
              right: 5,
            ),
            child: Container(
              alignment: Alignment.centerRight,
              child: Text("سلـتـي",
                  style: TextStyle(
                      color: Color.fromARGB(255, 32, 7, 121),
                      fontSize: 18,
                      fontWeight: FontWeight.w600)),
            ),
          ),
          FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('${collectionName}')
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final documents = snapshot.data!;
                  return SizedBox(
                      height: 100.0 * EcommerceApp.NumOfItems,
                      child: ListView.builder(
                          itemCount: documents.size,
                          itemBuilder: (BuildContext context, int index) {
                            return buildSecondItmes(
                                documents.docs[index], context);
                          }));
                } else if (snapshot.hasError) {
                  return Text('Its Error!');
                }
                return Text(""
                    // CircularProgressIndicator(
                    //     semanticsLabel: 'Circular progress indicator')
                    );
              }),
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: InkWell(
                child: Container(
                  height: 90,
                  width: 370,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 46, 44, 99),
                        Color.fromARGB(255, 83, 76, 162),
                        Color.fromARGB(255, 149, 144, 232),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        "   اسـتـخـدام نـقـاطـي",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2),
                      ),
                      Spacer(),
                      Icon(
                        Icons.arrow_forward_sharp,
                        color: Colors.white,
                      ),
                      Text("   ")
                    ],
                  ),
                ),
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => rewards()),
                  );
                },
              ),
            ),
          ),
          SizedBox(
            height: 280, //313,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 0, bottom: 5.0, left: 25, right: 25),
                  child: Column(
                    children: [
                      Divider(
                        color: Colors.grey,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6.0),
                        child: Row(
                          children: [
                            Container(
                              child: Text('المجموع الجزئي',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 32, 7, 121),
                                    fontSize: 15,
                                  )),
                            ),
                            Spacer(),
                            Text(subTotal + ' ريال',
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
                              child: Text('الضريـبة',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 32, 7, 121),
                                    fontSize: 15,
                                  )),
                            ),
                            Spacer(),
                            Text(vat.toString() + ' ريال',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 32, 7, 121),
                                  fontSize: 15,
                                )),
                          ],
                        ),
                      ),
                      if (EcommerceApp.storeName == "Sephora" ||
                          EcommerceApp.storeName == "H&M")
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: Row(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text('عرض الإجازة',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 227, 45, 45),
                                      fontSize: 15,
                                    )),
                              ),
                              Spacer(),
                              Text('- $offerDiscpunt ريال',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 227, 45, 45),
                                    fontSize: 15,
                                  )),
                            ],
                          ),
                        ),
                      if (EcommerceApp.rewardsExchanged)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: Row(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text('نـقـاطـي',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 227, 45, 45),
                                      fontSize: 15,
                                    )),
                              ),
                              Spacer(),
                              Text('- ${EcommerceApp.discount} ريال',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 227, 45, 45),
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
                                'المجموع',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 32, 7, 121),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              )),
                          Spacer(),
                          Text(
                              EcommerceApp.totalSummary.toString() +
                                  '.0' +
                                  ' ريال (' +
                                  EcommerceApp.inDollars.toStringAsFixed(2) +
                                  '\$)',
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
                    right: 25,
                  ),
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Text("طرق الدفع",
                        style: TextStyle(
                            color: Color.fromARGB(255, 32, 7, 121),
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 23, bottom: 10),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 3),
                        child: Container(
                          width: 83,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(3.0),
                              ),
                              border: Border.all(
                                color: Color.fromARGB(255, 23, 124, 255),
                                width: 4,
                              )),
                          alignment: Alignment.centerLeft,
                          child: new Image.asset(
                            'assets/paypal.png',

                            ///change pic
                            height: 40.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Card(
              color: Color.fromARGB(243, 243, 239, 231),
              child: Container(
                  alignment: Alignment.centerLeft,
                  height: 70,
                  width: 370,
                  child: Row(
                    children: [
                      Text("   "),
                      Icon(Icons.info_outline_rounded),
                      Text(
                        " يرجي الإنتباه أن المجموع النهائي سيكون بالدولار \n " +
                            EcommerceApp.inDollars.toStringAsFixed(2) +
                            "\$",
                        style: TextStyle(fontSize: 15, letterSpacing: 0.8),
                      ),
                    ],
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Container(
              alignment: Alignment.center,
              child: SizedBox(
                width: 200,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    saveUserTotal(EcommerceApp
                        .totalSummary); // bugg fixes (saves it then saves the original price)
                    checkOut().payment(context);
                  },
                  child: Text(
                    'إتمام الطلب',
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
          ),
          Text("   "),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "     بإتمامك للطلب فإنك تقوم بالموافقة على سياسة الترجيع لدينا،\n" +
                    "                    ٧ أيام على الأكثر لترجيع منتج" +
                    ".",
                //"     By placing your order you agree to our return\n        policies, 7 days max for returning an item.",
                style: TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 142, 142, 142),
                  letterSpacing: 0.6,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildSecondItmes(
      QueryDocumentSnapshot<Object?> product, BuildContext context) {
    return Card(
      child: new InkWell(
        child: Row(
          children: <Widget>[
            new Container(
              child: Stack(children: <Widget>[
                Container(
                  child: new Image.asset(
                    'assets/Rectangle.png',
                    height: 70.0,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 25, top: 2.5),
                  child: Container(
                    width: 45,
                    margin: EdgeInsets.all(10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image(
                        image: NetworkImage(
                          product["ProductImage"],
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
                  product["Category"],
                  style: new TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 32, 7, 121),
                  ),
                ),
                if (product['size'] != "")
                  Text(
                    "المـقاس : " + product['size'],
                    style: new TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(255, 32, 7, 121),
                    ),
                  ),
                Text(
                  "  السعر : " + product["Price"].toString() + ' ريال',
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    fontSize: 13,
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
                  width: 30,
                  height: 30,
                  decoration: new BoxDecoration(
                    color: Color.fromARGB(255, 245, 161, 14),
                    shape: BoxShape.circle,
                  ),
                ),
                Text(
                  product["quantity"].toString(),
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
            Text("  "),
          ],
        ),
      ),
      color: Color.fromARGB(255, 248, 248, 246),
    );
  }

  Future saveUserTotal(var total) async {
    await FirebaseFirestore.instance
        .collection('${collectionName}Total')
        .doc("total")
        .update({"Total": total});
  }
}

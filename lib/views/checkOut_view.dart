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
        iconTheme: IconThemeData(
          color: Color(0xFF535353), //change your color here
        ),
        automaticallyImplyLeading: true,
        title: Text(
          "مراجعة عملية الشراء ",
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w100,
              fontFamily: 'Tajawal',
              color: Color(0xFF636363)),
        ),
        shadowColor: Color(0x41C4C4C4),
        toolbarHeight: 60,
        backgroundColor: Colors.white,
        elevation: 3,
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
                bottom: 15.0,
                right: 15,
              ),
              child: Container(
                alignment: Alignment.centerRight,
                child: Text("المنتجات",
                    style: TextStyle(
                        color: Color.fromARGB(255, 35, 35, 35),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Tajawal')),
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
              padding: const EdgeInsets.only(
                  top: 25, bottom: 12.0, left: 12, right: 12),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: InkWell(
                  child: Container(
                    height: 90,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      gradient: LinearGradient(
                        colors: [
                          /*
                          Color.fromARGB(255, 46, 44, 99),
                          Color.fromARGB(255, 83, 76, 162),
                          Color.fromARGB(255, 149, 144, 232),
                           */
                          Color.fromARGB(255, 85, 108, 157),
                          Color.fromARGB(255, 36, 60, 112),
                          Color.fromARGB(255, 21, 42, 86)
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
                              fontFamily: 'Tajawal'),
                        ),
                        Spacer(),
                        Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                          size: 30,
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
              height: 250, //313,
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
                                        color: Color.fromARGB(255, 21, 21, 21),
                                        fontSize: 15,
                                        fontFamily: 'Tajawal')),
                              ),
                              Spacer(),
                              Text(subTotal + ' ريال',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 21, 21, 21),
                                      fontSize: 15,
                                      fontFamily: 'Tajawal')),
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
                                        color: Color.fromARGB(255, 21, 21, 21),
                                        fontSize: 15,
                                        fontFamily: 'Tajawal')),
                              ),
                              Spacer(),
                              Text(vat.toString() + ' ريال',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 21, 21, 21),
                                      fontSize: 15,
                                      fontFamily: 'Tajawal')),
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
                                          color:
                                              Color.fromARGB(255, 227, 45, 45),
                                          fontSize: 15,
                                          fontFamily: 'Tajawal')),
                                ),
                                Spacer(),
                                Text('- $offerDiscpunt ريال',
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 227, 45, 45),
                                        fontSize: 15,
                                        fontFamily: 'Tajawal')),
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
                                          color:
                                              Color.fromARGB(255, 227, 45, 45),
                                          fontSize: 15,
                                          fontFamily: 'Tajawal')),
                                ),
                                Spacer(),
                                Text('- ${EcommerceApp.discount} ريال',
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 227, 45, 45),
                                        fontSize: 15,
                                        fontFamily: 'Tajawal')),
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
                                      color: Color.fromARGB(255, 21, 21, 21),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Tajawal'),
                                )),
                            Spacer(),
                            Text(
                                EcommerceApp.totalSummary.toString() +
                                    '.0' +
                                    ' ريال (' +
                                    EcommerceApp.inDollars.toStringAsFixed(2) +
                                    '\$)',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 21, 21, 21),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Tajawal')),
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
                              color: Color.fromARGB(255, 36, 36, 36),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Tajawal')),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 8, right: 23, bottom: 7),
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
              padding: const EdgeInsets.only(bottom: 25, top: 8),
              child: Container(
                  color: Color.fromARGB(55, 128, 149, 186),
                  alignment: Alignment.centerLeft,
                  height: 60,
                  width: 370,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("   "),
                      Icon(
                        Icons.info_outline_rounded,
                      ),
                      Text(
                        " ملاحظة: المجموع النهائي سيكون بالدولار " +
                            EcommerceApp.inDollars.toStringAsFixed(2) +
                            "\$",
                        style: TextStyle(
                          fontSize: 15,
                          letterSpacing: 0.8,
                          fontFamily: 'Tajawal',
                          //color: Colors.white
                        ),
                      ),
                    ],
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 15),
              child: Container(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 220,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      saveUserTotal(EcommerceApp
                          .totalSummary); // bugg fixes (saves it then saves the original price)
                      checkOut().payment(context);
                    },
                    child: Text(
                      'إتمام عملية الشراء',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          fontFamily: 'Tajawal'),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.orange;
                          }
                          return Colors.orange;
                        }),
                        elevation: MaterialStateProperty.all<double>(0),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)))),
                  ),
                ),
              ),
            ),
            Text("   "),
            Center(
              child: Container(
                width: 350,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 350,
                      child: Text(
                        "بإتمامك لعملية الشراء فإنك تقوم بالموافقة على سياسة الترجيع لدينا، " +
                            "٧ أيام على الأكثر لترجيع منتج.",
                        textAlign: TextAlign.center,

                        //"     By placing your order you agree to our return\n        policies, 7 days max for returning an item.",
                        style: TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 142, 142, 142),
                            letterSpacing: 0.6,
                            fontFamily: 'Tajawal'),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
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
                Padding(
                  padding: const EdgeInsets.only(right: 0, top: 2.5),
                  child: Container(
                    height: 90,
                    margin: EdgeInsets.all(10),
                    child: ClipRRect(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  product["Category"],
                  style: new TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 36, 36, 36),
                      fontFamily: 'Tajawal'),
                ),
                if (product['size'] != "")
                  Text(
                    "المـقاس : " + product['size'],
                    style: new TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 28, 28, 28),
                        fontFamily: 'Tajawal'),
                  ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "السعر : " + product["Price"].toString() + ' ريال',
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                      fontSize: 13,
                      color: Color.fromARGB(255, 77, 76, 76),
                      fontFamily: 'Tajawal'),
                ),
              ],
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: new BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Text(
                    product["quantity"].toString(),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontFamily: 'Tajawal',
                    ),
                  )
                ],
              ),
            ),
            Text("  "),
          ],
        ),
      ),
      color: Color.fromARGB(255, 255, 255, 255),
    );
  }

  Future saveUserTotal(var total) async {
    await FirebaseFirestore.instance
        .collection('${collectionName}Total')
        .doc("total")
        .update({"Total": total});
  }
}

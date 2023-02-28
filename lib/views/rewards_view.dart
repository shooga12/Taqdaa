import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taqdaa_application/confige/EcommerceApp.dart';
import 'package:taqdaa_application/views/rewardsHistory_view.dart';
import '../views/checkOut_view.dart';
import 'package:flutter/services.dart';

import 'rewardsHistory_view.dart';

class rewards_View extends StatefulWidget {
  const rewards_View({super.key});

  @override
  State<rewards_View> createState() => _rewardsViewState();
}

class _rewardsViewState extends State<rewards_View> {
  String collectionName = EcommerceApp().getCurrentUser();
  TextEditingController _controller = TextEditingController();
  double inRiyals = EcommerceApp.rewards / 10;

  @override
  void initState() {
    super.initState();
    _controller.text = "10"; // Setting the initial value for the field.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "نقاطي",
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.w100, fontFamily: 'Tajawal'),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/AppBar.png"), fit: BoxFit.fill)),
        ),
        toolbarHeight: 90,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(children: [
          Card(
            child: Container(
              height: 280,
              width: 400,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 60,
                ),
                child: Column(
                  children: [
                    Text(
                      "   نقاطي الحالية    ",
                      style: TextStyle(
                          color: Color.fromARGB(255, 95, 137, 180),
                          fontSize: 19.5,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.4,
                          fontFamily: 'Tajawal'),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 100,
                            child: InkWell(
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 170,
                                      height: 110,
                                      decoration: new BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8.0),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 3,
                                            blurRadius: 6,
                                            offset: Offset(0, 3),
                                          )
                                        ],
                                        gradient: LinearGradient(
                                          colors: [
                                            Color.fromARGB(255, 95, 137, 180),
                                            Color.fromARGB(255, 118, 171, 223),
                                            Color.fromARGB(255, 142, 195, 248)
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        shape: BoxShape.rectangle,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 14, right: 110),
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              opacity: 0.75,
                                              image: AssetImage(
                                                  "assets/rewards.png"),
                                              fit: BoxFit.fill),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 18, left: 50, right: 15),
                                      child: Text(
                                        "  ${EcommerceApp.rewards} ",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.8,
                                            fontFamily: 'Tajawal'),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 72, left: 50, right: 28),
                                      child: Text(
                                        "   = ${inRiyals.toDouble()} ريـــال ",
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 233, 232, 232),
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.8,
                                            fontFamily: 'Tajawal'),
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => rewardsHistory()),
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Card(
            child: Container(
              alignment: Alignment.centerLeft,
              height: 200,
              width: 400,
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Row(
                  children: [
                    Text(
                      "\n    معلومات مـهـمـة", //نقاط تحتاج إلى معرفتها
                      style: TextStyle(
                          color: Colors.orange,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Tajawal'),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      Text("       "),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: new BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Text(
                        "  كل ١٠ نقاط تتحول إلى ١ ريال.",
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 16,
                            fontFamily: 'Tajawal'),
                      ),
                    ],
                  ),
                ),
                Stack(
                  children: [
                    Row(
                      children: [
                        Text("\n       "),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: new BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Text(
                          "  الحد الأدنى للإستبدال هو ١٠ نقاط.",
                          style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 16,
                              fontFamily: 'Tajawal'),
                        ),
                      ],
                    ),
                  ],
                ),
                Stack(
                  children: [
                    Row(
                      children: [
                        Text("       "),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: new BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Text(
                          "  بعد كل عملية شراء ستكسب ٢٪ من المجموع",
                          style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 16,
                              fontFamily: 'Tajawal'),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: Row(
                        children: [
                          Text(
                            "          كنقاط إضافية.",
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 16,
                                fontFamily: 'Tajawal'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ]),
            ),
          )
        ]),
      ),
    );
  }

  Future updateRewards() async {
    await FirebaseFirestore.instance
        .collection('${collectionName}Total')
        .doc("rewards")
        .update({'Rewards': FieldValue.increment(-EcommerceApp.rewardsInput)});
  }
}

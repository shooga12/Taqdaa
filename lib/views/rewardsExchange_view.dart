import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taqdaa_application/confige/EcommerceApp.dart';
import 'package:taqdaa_application/screens/ShoppingCart.dart';
import 'package:taqdaa_application/screens/home_page.dart';
import 'rewardsHistory_view.dart';
import '../views/checkOut_view.dart';
import 'package:flutter/services.dart';

import 'rewardsHistory_view.dart';

class rewards extends StatefulWidget {
  const rewards({super.key});

  @override
  State<rewards> createState() => _rewardsState();
}

class _rewardsState extends State<rewards> {
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "استبدال النقاط",
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w100,
              fontFamily: 'Tajawal',
              color: Color(0xFF636363)),
        ),
        backgroundColor: Colors.white,
        toolbarHeight: 70,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Color(0xFF535353), //change your color here
        ),
      ),
      body: Container(
        color: Color(0xFFF3F4F8),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(children: [
            Card(
              shadowColor: Color(0x4ACBCBCB),
              elevation: 2,
              child: Container(
                height: 380,
                width: 400,
                child: Column(
                  children: [
                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 40, bottom: 10),
                        child: Column(
                          children: [
                            Text(
                              //"   current points    ",
                              "   نقاطك الحالية    ",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 21, 42, 86),
                                  fontSize: 19.5,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.4,
                                  fontFamily: 'Tajawal'),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 15.0, bottom: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      height: 100,
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
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 3,
                                                  blurRadius: 6,
                                                  offset: Offset(0, 3),
                                                )
                                              ],
                                              gradient: LinearGradient(
                                                colors: [
                                                  /*
                                                  Color.fromARGB(255, 95, 137, 180),
                                                  Color.fromARGB(255, 118, 171, 223),
                                                  Color.fromARGB(255, 142, 195, 248)
                                                   */
                                                  Color.fromARGB(
                                                      255, 85, 108, 157),
                                                  Color.fromARGB(
                                                      255, 36, 60, 112),
                                                  Color.fromARGB(
                                                      255, 21, 42, 86)
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
                                                top: 17, left: 50, right: 15),
                                            child: Text(
                                              "  ${EcommerceApp.rewards} ", //bug fixes
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 0.8),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 72, left: 50, right: 28),
                                            child: Text(
                                              "   = ${inRiyals.toDouble()} ريـــال ",
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 255, 255, 255),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 0.8,
                                                  fontFamily: 'Tajawal'),
                                            ),
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => rewardsHistory()),
                        );
                      },
                    ),
                    SizedBox(
                        width: 300,
                        height: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                                child: IconButton(
                                    onPressed: () async {
                                      int currentValue =
                                          int.parse(_controller.text);
                                      setState(() {
                                        if (currentValue <=
                                            EcommerceApp.rewards - 1) {
                                          currentValue++;
                                        }
                                        _controller.text =
                                            (currentValue).toString();
                                      });
                                    },
                                    icon: Icon(Icons.add_circle_outline,
                                        color: Color.fromARGB(
                                            255, 135, 155, 190)))),
                            Container(
                              width: 70,
                              height: 70,
                              child: TextFormField(
                                showCursor: false,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                                controller: _controller,
                                keyboardType: TextInputType.numberWithOptions(
                                  decimal: false,
                                  signed: true,
                                ),
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                              ),
                            ),
                            InkWell(
                                child: IconButton(
                                    onPressed: () async {
                                      int currentValue =
                                          int.parse(_controller.text);
                                      setState(() {
                                        currentValue--;
                                        _controller.text = (currentValue > 10
                                                ? currentValue
                                                : 10)
                                            .toString();
                                      });
                                    },
                                    icon: Icon(Icons.remove_circle_outline,
                                        color: Color.fromARGB(
                                            255, 135, 155, 190))))
                          ],
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 200,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_controller.text == "") {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                        content: Text(
                                            "عذراً، يجب عليك تحديد كمية النقاط المراد استبدالها."),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context, 'حسناً');
                                            },
                                            child: const Text('حسناً'),
                                          )
                                        ]);
                                  });
                            } else {
                              if (int.parse(_controller.text) >= 10 &&
                                  int.parse(_controller.text) <=
                                      EcommerceApp.rewards) {
                                EcommerceApp.rewardsInput =
                                    int.parse(_controller.text);
                                EcommerceApp.rewardsExchanged = true;
                                EcommerceApp.totalSummary = EcommerceApp
                                        .totalSummary -
                                    (EcommerceApp.rewardsInput / 10).toInt();
                                EcommerceApp.inDollars =
                                    EcommerceApp.totalSummary / 3.75;
                                updateRewards();
                                //saveUserTotal(EcommerceApp.total);
                                EcommerceApp.rewards -=
                                    EcommerceApp.rewardsInput;
                                EcommerceApp.discount +=
                                    EcommerceApp.rewardsInput / 10;
                                EcommerceApp.pageIndex = 1;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage()),
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CheckOutSummary()),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  duration: const Duration(milliseconds: 1500),
                                  backgroundColor:
                                      Color.fromARGB(255, 135, 155, 190),
                                  content: Text(
                                    textAlign: TextAlign.center,
                                    "تم استبدال النقاط بنجاح.",
                                    style: TextStyle(
                                        fontSize: 17, letterSpacing: 0.8),
                                  ),
                                  action: null,
                                ));
                              } else if (int.parse(_controller.text) < 10) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                          content: Text(
                                              "عذراً، لا يمكنك استبدال أقل من ١٠ نقاط."),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context, 'حسناً');
                                              },
                                              child: const Text('حسناً'),
                                            )
                                          ]);
                                    });
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                          content: Text(
                                              "عذراً، لا يمكنك استبدال أكثر من ${EcommerceApp.rewards} نقطه"
                                              //"Sorry, you can't exchange more than  points.",
                                              ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context, 'حسناً');
                                              },
                                              child: const Text('حسناً'),
                                            )
                                          ]);
                                    });
                              }
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 7.0),
                            child: Text(
                              'اسـتـبـدال',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  fontFamily: 'Tajawal'),
                            ),
                          ),
                          style: ButtonStyle(
                              elevation: MaterialStateProperty.all<double>(0),
                              backgroundColor:
                                  MaterialStateProperty.resolveWith((states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return Colors.orange;
                                }
                                return Colors.orange;
                              }),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10)))),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Card(
                shadowColor: Color(0x4ACBCBCB),
                elevation: 2,
                child: Container(
                  alignment: Alignment.centerLeft,
                  height: 180,
                  width: 400,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: Text(
                                "\n    معلومات مـهـمـة", //نقاط تحتاج إلى معرفتها
                                style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Tajawal'),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
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
                                    "            كنقاط إضافية.",
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
              ),
            )
          ]),
        ),
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

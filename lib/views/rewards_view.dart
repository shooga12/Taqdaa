import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taqdaa_application/confige/EcommerceApp.dart';
import '../views/checkOut_view.dart';
import 'package:flutter/services.dart';

class rewards extends StatefulWidget {
  const rewards({super.key});

  @override
  State<rewards> createState() => _rewardsState();
}

class _rewardsState extends State<rewards> {
  String collectionName = EcommerceApp().getCurrentUser();
  TextEditingController _controller = TextEditingController();

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
          "Exchange Rewards!",
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
      body: Column(children: [
        Card(
          child: Container(
            height: 350,
            width: 400,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 40,
                    left: 15,
                  ),
                  child: Column(
                    children: [
                      Text(
                        "   current points    ", //bug fixes
                        style: TextStyle(
                            color: Color.fromARGB(255, 32, 7, 121),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                height: 100,
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 170,
                                      height: 80,
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
                                            // Color.fromARGB(255, 56, 54, 122),
                                            // Color.fromARGB(255, 103, 94, 198),
                                            // Color.fromARGB(255, 149, 144, 232),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        shape: BoxShape.rectangle,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 14, left: 8),
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              // opacity: 0.75,
                                              image: AssetImage(
                                                  "assets/rewards.png"),
                                              fit: BoxFit.fill),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 17, left: 50),
                                      child: Text(
                                        "  ${EcommerceApp.rewards} ", //bug fixes
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.8),
                                      ),
                                    ),
                                  ],
                                )),
                            // Container(
                            //   height: 30,
                            //   child: Text(
                            //     "points",
                            //     style: TextStyle(
                            //       color: Color.fromARGB(255, 32, 7, 121),
                            //       fontSize: 18,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
                                    // EcommerceApp.rewardsInput =
                                    //     int.parse(_controller.text);
                                    currentValue--;
                                    _controller.text =
                                        (currentValue > 10 ? currentValue : 10)
                                            .toString();
                                  });
                                },
                                icon: Icon(Icons.remove_circle_outline,
                                    color:
                                        Color.fromARGB(255, 118, 171, 223)))),
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
                                    // EcommerceApp.rewardsInput =
                                    //     int.parse(_controller.text);
                                    if (currentValue <=
                                        EcommerceApp.rewards - 1) {
                                      currentValue++;
                                    }
                                    _controller.text =
                                        (currentValue).toString();
                                  });
                                },
                                icon: Icon(Icons.add_circle_outline,
                                    color: Color.fromARGB(255, 118, 171, 223))))
                      ],
                    )),
                Container(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 200,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        if (int.parse(_controller.text) >= 10 &&
                            int.parse(_controller.text) <=
                                EcommerceApp.rewards) {
                          EcommerceApp.rewardsInput =
                              int.parse(_controller.text);
                          EcommerceApp.rewardsExchanged = true;
                          EcommerceApp.totalSummary =
                              EcommerceApp.totalSummary -
                                  (EcommerceApp.rewardsInput / 10).toInt();
                          EcommerceApp.inDollars =
                              EcommerceApp.totalSummary / 3.75;
                          updateRewards();
                          //saveUserTotal(EcommerceApp.total);
                          EcommerceApp.rewards -= EcommerceApp.rewardsInput;
                          EcommerceApp.discount +=
                              EcommerceApp.rewardsInput / 10;
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            duration: const Duration(milliseconds: 1500),
                            backgroundColor: Color.fromARGB(255, 135, 155, 190),
                            content: Text(
                              "Rewards exchanged succeffully",
                              style:
                                  TextStyle(fontSize: 17, letterSpacing: 0.8),
                            ),
                            action: null,
                          ));
                        } else if (int.parse(_controller.text) < 10) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                    content: Text(
                                        "Sorry, you can't exchange less than 10 points."),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, 'OK');
                                        },
                                        child: const Text('OK'),
                                      )
                                    ]);
                              });
                        } else if (_controller.text == null) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                    content: Text(
                                        "Sorry, you have to indicate the number of points."),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, 'OK');
                                        },
                                        child: const Text('OK'),
                                      )
                                    ]);
                              });
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                    content: Text(
                                      "Sorry, you can't exchange more than ${EcommerceApp.rewards} points.",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, 'OK');
                                        },
                                        child: const Text('OK'),
                                      )
                                    ]);
                              });
                        }
                      },
                      child: Text(
                        'Exchange',
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
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30)))),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Card(
          child: Container(
            alignment: Alignment.centerLeft,
            height: 220,
            width: 400,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Row(
                children: [
                  Text(
                    "\n   Need To Know",
                    style: TextStyle(
                        color: Color.fromARGB(255, 32, 7, 121),
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
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
                    "  Every 10 reward points converts to 1 SR.",
                    style: TextStyle(
                      color: Color.fromARGB(255, 32, 7, 121),
                      fontSize: 16,
                    ),
                  ),
                ],
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
                        "  The least amount you can exchange is",
                        style: TextStyle(
                          color: Color.fromARGB(255, 32, 7, 121),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: Row(
                      children: [
                        Text(
                          "          10 points.",
                          style: TextStyle(
                            color: Color.fromARGB(255, 32, 7, 121),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Stack(
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
                          "  After each payment you will earn 2%",
                          style: TextStyle(
                            color: Color.fromARGB(255, 32, 7, 121),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: Row(
                        children: [
                          Text(
                            "          as a reward points.",
                            style: TextStyle(
                              color: Color.fromARGB(255, 32, 7, 121),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ]),
          ),
        )
      ]),
    );
  }

  // Future saveUserTotal(var total) async {
  //   await FirebaseFirestore.instance
  //       .collection('${collectionName}Total')
  //       .doc("total")
  //       .update({"Total": total});
  // }

  Future updateRewards() async {
    await FirebaseFirestore.instance
        .collection('${collectionName}Total')
        .doc("rewards")
        .update({'Rewards': FieldValue.increment(-EcommerceApp.rewardsInput)});
  }
}

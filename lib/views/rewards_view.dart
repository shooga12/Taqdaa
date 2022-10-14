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
    _controller.text = "1"; // Setting the initial value for the field.
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
            height: 270,
            width: 400,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40, left: 15),
                  child: Row(
                    children: [
                      Text(
                        " My rewards:    ", //bug fixes
                        style: TextStyle(
                          color: Color.fromARGB(255, 32, 7, 121),
                          fontSize: 18,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 50,
                            child: Text(
                              "${EcommerceApp.rewards} ", //bug fixes
                              style: TextStyle(
                                  color: Color.fromARGB(255, 32, 7, 121),
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            height: 30,
                            child: Text(
                              "points",
                              style: TextStyle(
                                color: Color.fromARGB(255, 32, 7, 121),
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
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
                                        (currentValue > 1 ? currentValue : 1)
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
                        setState(() {
                          EcommerceApp.rewardsInput =
                              int.parse(_controller.text);
                        });
                        EcommerceApp.rewardsExchanged = true;
                        EcommerceApp.total -=
                            (EcommerceApp.rewardsInput / 10).toInt();
                        saveUserTotal(EcommerceApp.total);
                        //updateRewards(EcommerceApp.rewardsInput);
                        //EcommerceApp.rewards -= EcommerceApp.rewardsInput;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CheckOutSummary()),
                        );
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
            height: 110,
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
                    //+EcommerceApp.rewardsInput.toString(),
                    style: TextStyle(
                      color: Color.fromARGB(255, 32, 7, 121),
                      fontSize: 16,
                    ),
                  ),
                ],
              )
            ]),
          ),
        )
      ]),
    );
  }

  Future saveUserTotal(var total) async {
    await FirebaseFirestore.instance
        .collection('${collectionName}Total')
        .doc("total")
        .set({"Total": total});
  }

  Future updateRewards(var total) async {
    await FirebaseFirestore.instance
        .collection('${collectionName}Total')
        .doc("rewards")
        .update({'Rewards': FieldValue.increment(-EcommerceApp.rewardsInput)});
  }
}

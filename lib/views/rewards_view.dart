import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taqdaa_application/confige/EcommerceApp.dart';
import '../views/checkOut_view.dart';

class rewards extends StatefulWidget {
  const rewards({super.key});

  @override
  State<rewards> createState() => _rewardsState();
}

class _rewardsState extends State<rewards> {
  String collectionName = EcommerceApp().getCurrentUser();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            height: 200,
            width: 400,
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "\n   My Rewards\n",
                        style: TextStyle(
                            color: Color.fromARGB(255, 32, 7, 121),
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 50,
                      child: Text(
                        "25 ", //bug fixes
                        style: TextStyle(
                            color: Color.fromARGB(255, 32, 7, 121),
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      height: 30,
                      child: Text(
                        "Reward points",
                        style: TextStyle(
                          color: Color.fromARGB(255, 32, 7, 121),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 200,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          EcommerceApp.rewardsExchanged = true;
                          EcommerceApp.total -= 25;

                          ///buuugg fixes + make sure to alter the rewards in firestore
                          saveUserTotal(EcommerceApp.total);
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
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)))),
                      ),
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
                  Text("\n     "),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: new BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Text(
                    " Every 10 reward points coverts to 1 SR.",
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
}

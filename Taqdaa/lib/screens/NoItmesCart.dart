import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:taqdaa/screens/list_of_stores.dart';

class emptyCart extends StatelessWidget {
  const emptyCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            //EcommerceApp.storeName +
            "Shopping Cart",
            // style: TextStyle(fontFamily: 'Cairo'),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/Vector.png"), fit: BoxFit.fill)),
          ),
          toolbarHeight: 170,
          //leading: BackButton(),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
            child: new InkWell(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Your Cart is empty! ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text("Start shopping Now!",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                Text(""),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ListOfStores2()),
                    );
                  },
                  child: Text(
                    'Start Shopping',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
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
              ],
            ),
          ),
        )));
  }
}

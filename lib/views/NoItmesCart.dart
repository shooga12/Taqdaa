import 'package:flutter/material.dart';
import 'package:taqdaa_application/screens/list_of_stores.dart';

class emptyCart extends StatelessWidget {
  const emptyCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            //EcommerceApp.storeName +
            "Shopping Cart",
            style: TextStyle(fontSize: 24),
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
                Image.asset(
                  'assets/empty_cart.png',
                  width: 170,
                ),
                SizedBox(height: 30,),
                Text(
                  "Your Cart is empty ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color(0x87666666)
                  ),
                ),
                SizedBox(height: 10,),
                Text("Start shopping Now!",
                    style:
                        TextStyle(fontWeight: FontWeight.bold,
                            fontSize: 18,
                          color: Color(0x87909090)
                        ),
                ),
                SizedBox(height: 40,),
                SizedBox(
                  width: 200,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ListOfStores2()),
                      );
                    },
                    child: Text(
                      'Start Shopping',
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
                                    borderRadius: BorderRadius.circular(30)))),
                  ),
                ),
              ],
            ),
          ),
        )));
  }
}

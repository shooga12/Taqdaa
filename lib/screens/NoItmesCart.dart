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
            "سلة التسوق",
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
                Text(
                  "لا يوجد منتجات!",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text("ابدأ التسوق الآن!",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                Text(""),
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
                      'ابدأ التسوق!',
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

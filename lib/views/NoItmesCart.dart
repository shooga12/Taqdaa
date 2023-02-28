import 'package:flutter/material.dart';

import '../screens/list_of_stores.dart';


class emptyCart extends StatelessWidget {
  const emptyCart({super.key});

  @override
  Widget build(BuildContext context) {

    return Container(
      color: Color(0xFFF3F4F8),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/empty_cart2.png',
                width: 170,
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "سـلتـك فـارغـة",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Color(0xFFADADAD),
                    fontFamily: 'Tajawal'
                ),
              ),
              SizedBox(height: 10,),
              Text("ابدأ التسوق الآن!",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xD8ADADAD),
                      fontFamily: 'Tajawal'
                  ),
              ),
              SizedBox(
                height: 40,
              ),
              SizedBox(
                width: 200,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ListOfStores2()),
                    );
                  },
                  child: Text(
                    'ابدأ التسوق!',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      fontFamily: 'Tajawal'
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

                      shadowColor: MaterialStateProperty.all<Color>(Color(0x86888666)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),

                          ),
                      ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }
}

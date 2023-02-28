import 'package:flutter/material.dart';
import 'package:taqdaa_application/screens/paypalPayment.dart';

class MakePayment extends StatefulWidget {
  const MakePayment({super.key});

  @override
  State<MakePayment> createState() => _MakePaymentState();
}

class _MakePaymentState extends State<MakePayment> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Container(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton.icon(
              icon: Icon(
                Icons.paypal,
                color: Colors.lightBlue,
                size: 30.0,
              ),
              label: Text('الدفع بواسطة باي بال'),

              onPressed: () {
                //-------make paypal payment-----------
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        PaypalPayment(onFinish: (number) async {

                          print('رقم الطلب:' + number);

                        })));
              },
              style: ElevatedButton.styleFrom(
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}

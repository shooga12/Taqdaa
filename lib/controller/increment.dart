import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taqdaa_application/confige/EcommerceApp.dart';

class NumberInputWithIncrementDecrement extends StatefulWidget {
  @override
  _NumberInputWithIncrementDecrementState createState() =>
      _NumberInputWithIncrementDecrementState();
}

class _NumberInputWithIncrementDecrementState
    extends State<NumberInputWithIncrementDecrement> {
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = "1"; // Setting the initial value for the field.
  }

  @override
  void setState(VoidCallback fn) {
    EcommerceApp.rewardsInput = int.parse(_controller.text);
    // TODO: implement setState
    super.setState(fn);
  }

  ///transfer

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Container(
          width: 100.0,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  width: 100,
                  height: 90,
                  child: TextFormField(
                    showCursor: false,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(8.0),
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
              ),
              Container(
                height: 100.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: InkWell(
                          child: IconButton(
                              iconSize: 18,
                              onPressed: () async {},
                              icon: Icon(Icons.add_circle_outline,
                                  color: Color.fromARGB(255, 118, 171, 223)))),
                      // child: InkWell(
                      //   child: Icon(
                      //     Icons.arrow_drop_up,
                      //     size: 18.0,
                      //   ),
                      //   onTap: () {
                      //     int currentValue = int.parse(_controller.text);
                      //     setState(() {
                      //       EcommerceApp.rewardsInput =
                      //           int.parse(_controller.text);
                      //       if (currentValue <=
                      //           EcommerceApp.rewards -
                      //               1) /*bug fixes rewards -1 */ {
                      //         currentValue++;
                      //       }
                      //       _controller.text =
                      //           (currentValue).toString(); // incrementing value
                      //     });
                      //   },
                      // ),
                    ),
                    InkWell(
                        child: IconButton(
                            iconSize: 18,
                            onPressed: () async {},
                            icon: Icon(Icons.remove_circle_outline,
                                color: Color.fromARGB(255, 118, 171, 223))))
                    // InkWell(
                    //   child: Icon(
                    //     Icons.arrow_drop_down,
                    //     size: 18.0,
                    //   ),
                    //   onTap: () {
                    //     int currentValue = int.parse(_controller.text);
                    //     setState(() {
                    //       EcommerceApp.rewardsInput =
                    //           int.parse(_controller.text);
                    //       currentValue--;
                    //       _controller.text =
                    //           (currentValue > 1 ? currentValue : 1)
                    //               .toString(); // decrementing value
                    //     });
                    //   },
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void dispose() {
    // Clean up the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }
}

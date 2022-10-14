import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../confige/EcommerceApp.dart';

class returnRequest extends StatefulWidget {
  const returnRequest({super.key});

  @override
  State<returnRequest> createState() => _returnRequestState();
}

class _returnRequestState extends State<returnRequest> {
  FirebaseDatabase database = FirebaseDatabase.instance;
  String documentName = EcommerceApp().getCurrentUser();

  // Map<String, String> userInvoice = {
  //   'product1': '123456789',
  //   'returnable1': "ture",
  //   'product2': '987654321',
  //   'returnable2': "false",
  // };
  // Map<String, String> userReq = {'product1': '123456789'};

  bool result = false;
  // AddToInvoice() {
  //   var collection = FirebaseFirestore.instance.collection('Invoices');
  //   collection.doc(documentName).set(userInvoice);
  //   //return true;
  // }

  List checkBoxList = [false, false, false];
  List Barcodes = ["123456789", "987654321", "567894321"];

  //Map<String, String> choice = { "value1":"false" ,"value2":"false","value3":"false"}
  //var value = false;
  // var value1 = false;
  // var value2 = false;
  // var value3 = false;

  // String barcode1 = "123456789";
  // String barcode2 = "987654321";
  // String barcode3 = "567894321";
  //var count = 0;

  var added = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text(
            "طلب الاسترجاع",
            style: TextStyle(fontSize: 24),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/Vector.png"), fit: BoxFit.fill)),
          ),
          centerTitle: true,
          toolbarHeight: 170,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "المنتجات",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      height: 1,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: checkBoxList[0],
                          onChanged: (val) {
                            setState(() {
                              checkBoxList[0] = val;
                              // if (!value) {
                              //         value = false;
                              //       }
                              //storeRequests("123456789");
                            });
                          },
                          activeColor: Colors.orange,
                          checkColor: Colors.white,
                        ),
                        Expanded(
                          flex: 1,
                          child: Image.asset(
                            'assets/s2497212-main-zoom.jpeg',
                            height: 50,
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          flex: 3,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "ماسكارا",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      "الكمية: 1",
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "SR",
                                          textDirection: TextDirection.rtl,
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(width: 5.0),
                                        Text(
                                          "100",
                                          textDirection: TextDirection.rtl,
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: checkBoxList[1],
                          onChanged: (val) {
                            setState(() {
                              checkBoxList[1] = val;
                              //storeRequests("987654321");
                            });
                          },
                          activeColor: Colors.orange,
                          checkColor: Colors.white,
                        ),
                        Expanded(
                          flex: 1,
                          child: Image.asset(
                            'assets/243280_swatch.jpeg',
                            height: 50,
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          flex: 3,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "ماسكارا",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      "الكمية: 1",
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "SR",
                                          textDirection: TextDirection.rtl,
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(width: 5.0),
                                        Text(
                                          "100",
                                          textDirection: TextDirection.rtl,
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Checkbox(
                        //   value: value3,
                        //   onChanged: (val) {
                        //     setState(() {
                        //       value3 = val!;
                        //       //storeRequests("567894321");
                        //     });
                        //   },
                        //   activeColor: Colors.orange,
                        //   checkColor: Colors.white,
                        // ),
                        Expanded(
                          flex: 1,
                          child: Image.asset(
                            'assets/sephora_con.webp',
                            height: 50,
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          flex: 3,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "ماسكارا",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      "الكمية: 1",
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "SR",
                                          textDirection: TextDirection.rtl,
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(width: 5.0),
                                        Text(
                                          "100",
                                          textDirection: TextDirection.rtl,
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      height: 1,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "المجموع",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Row(
                        children: [
                          Text("SR "),
                          Text("300"),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Center(
                    child: SizedBox(
                      width: 200,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () async {
                          added = addToDB();
                          if (added == true) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                      content: Text(
                                          "تم إرسال الطلب بنجاح! \n سيتم تنبيهك عند قبول الطلب"),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'حسنًا'),
                                          child: const Text('حسنًا'),
                                        )
                                      ]);
                                });
                          } else if (added == true) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                      content:
                                          Text('حدث خطأ، لطفًا حاول لاحقًا'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'حسنًا'),
                                          child: const Text('حسنًا'),
                                        )
                                      ]);
                                });
                          }
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => returnRequest()),
                          // );
                        },
                        child: Text(
                          'إرسال الطلب',
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
                ],
              ),
            ),
          ),
        )
        // body: Container(
        //   child: Column(children: [
        //     StreamBuilder<List<invoice>>(
        //         stream: readProducts(),
        //         builder: (context, snapshot) {
        //           if (snapshot.hasData) {
        //             final invoice = snapshot.data!;
        //             return ListView.builder(
        //                 scrollDirection: Axis.vertical,
        //                 shrinkWrap: true,
        //                 itemCount: invoice.length,
        //                 itemBuilder: (BuildContext context, int index) {
        //                   var data = invoice[index];
        //                   if (data.returnable == true) {
        //                     return ListTile(
        //                       leading: Checkbox(
        //                         value: value,
        //                         onChanged: (val) {
        //                           setState(() {
        //                             value = val!;
        //                             storeRequests(data.barcode);
        //                             if (!value) {
        //                               value = false;
        //                             }
        //                           });
        //                         },
        //                         activeColor: Colors.orange,
        //                         checkColor: Colors.white,
        //                       ),
        //                       title: Text(
        //                         data.barcode,
        //                         style: TextStyle(fontSize: 16),
        //                       ),
        //                     );
        //                   } else if (data.returnable == false) {
        //                     return Row(
        //                       children: [Text(data.barcode)],
        //                     );
        //                   }
        //                   return nothing();
        //                 });
        //           } else if (snapshot.hasError) {
        //             return Text("Some thing went wrong! ${snapshot.error}");
        //           } else {
        //             return Center(child: CircularProgressIndicator());
        //           }
        //         }),
        //     ElevatedButton(
        //         onPressed: () {
        //           added = addToDB();
        //           if (added == true) {
        //             showDialog(
        //                 context: context,
        //                 builder: (context) {
        //                   return AlertDialog(
        //                       content: Text(
        //                           "تم إرسال الطلب بنجاح! \n سيتم تنبيهك عند قبول الطلب"),
        //                       actions: [
        //                         TextButton(
        //                           onPressed: () =>
        //                               Navigator.pop(context, 'حسنًا'),
        //                           child: const Text('حسنًا'),
        //                         )
        //                       ]);
        //                 });
        //           } else if (added == true) {
        //             showDialog(
        //                 context: context,
        //                 builder: (context) {
        //                   return AlertDialog(
        //                       content: Text('حدث خطأ، لطفًا حاول لاحقًا'),
        //                       actions: [
        //                         TextButton(
        //                           onPressed: () =>
        //                               Navigator.pop(context, 'حسنًا'),
        //                           child: const Text('حسنًا'),
        //                         )
        //                       ]);
        //                 });
        //           }
        //           // Navigator.push(
        //           //   context,
        //           //   MaterialPageRoute(builder: (context) => returnRequest()),
        //           // );
        //         },
        //         child: Text('تقديم طلب الاسترجاع'),
        //         style: ButtonStyle(
        //             backgroundColor: MaterialStateProperty.resolveWith((states) {
        //               if (states.contains(MaterialState.pressed)) {
        //                 return Colors.grey;
        //               }
        //               return Colors.orange;
        //             }),
        //             shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        //                 RoundedRectangleBorder(
        //                     borderRadius: BorderRadius.circular(30))))),
        //   ]),
        // ),

        // for (var entry in userInvoice.entries) {
        //   if (entry.key == "returnable1" &&
        //       entry.value == "true") {
        //     return buildCheckBox("123456789");
        //   }
        //   return Row(
        //     children: [Text('987654321')],
        //   );
        // }
        // return nothing();
        // Column(
        //   children: [
        //     ListView.builder(
        //       itemCount: userInvoice.length,
        //       itemBuilder: (BuildContext context, int index) {
        //         for (var entry in userInvoice.entries) {
        //           if (entry.key == "returnable1" && entry.value == "true") {
        //             return buildCheckBox("123456789");
        //           }
        //         }
        //         return Row(
        //           children: [Text('987654321')],
        //         );
        //       },
        //     ),
        // Row(
        //   children: [
        //     buildCheckBox("123456789")
        //     // Text('123456789')
        //   ],
        // ),
        // Row(
        //   children: [Text('987654321')],
        // ),
        // ElevatedButton(
        //     onPressed: () {
        //       checkReturnable(userInvoice);

        //       // Navigator.push(
        //       //   context,
        //       //   MaterialPageRoute(builder: (context) => returnRequest()),
        //       // );
        //     },
        //     child: Text('طلب استرجاع'),
        //     style: ButtonStyle(
        //         backgroundColor: MaterialStateProperty.resolveWith((states) {
        //           if (states.contains(MaterialState.pressed)) {
        //             return Colors.grey;
        //           }
        //           return Colors.orange;
        //         }),
        //         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        //             RoundedRectangleBorder(
        //                 borderRadius: BorderRadius.circular(30))))),
        // ],
        );
  }
  //   result = storeRequests();
  //   if (result == true) {
  //     return Text("added successfully");
  //   } else
  //     return Text("not added");
  // }

  //  AddToInvoice() {
  //   var collection = FirebaseFirestore.instance.collection('Invoices');
  //   collection.doc(documentName).set(userInvoice);
  //   //return true;
  // }

  Stream<List<invoice>> readProducts() => FirebaseFirestore.instance
      .collection('Invoices')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => invoice.fromJson(doc.data())).toList());

  nothing() {
    return Container();
  }

  // checkReturnable(Map<String, String> products) async {
  //   for (var entry in products.entries) {
  //     if (entry.key == "returnable1" && entry.value == "true") {
  //       return ListTile(
  //         leading: CheckboxListTile(
  //           title: Text(
  //             '123456789',
  //             style: TextStyle(fontSize: 16),
  //           ),
  //           controlAffinity: ListTileControlAffinity.leading,
  //           value: value,
  //           onChanged: (val) {
  //             setState(() {
  //               value = val!;
  //             });
  //           },
  //           activeColor: Colors.orange,
  //           checkColor: Colors.white,
  //         ),
  //       );
  //     }
  //   }
  // }

  buildCheckBox(String barcode) {
    return ListTile(
        // onTap: () {
        //   setState(() {
        //     this.value = !value;
        //   });
        // },
        // leading: CheckboxListTile(
        //   title: Text(
        //     barcode,
        //     style: TextStyle(fontSize: 16),
        //   ),
        //   controlAffinity: ListTileControlAffinity.leading,
        //   value: value,
        //   onChanged: (val) {
        //     setState(() {
        //       value = val!;
        //     });
        //   },
        //   activeColor: Colors.orange,
        //   checkColor: Colors.white,
        // ),
        // title: Text(
        //   barcode,
        //   style: TextStyle(fontSize: 16),
        // ),
        );
  }

  var i = 0;
  Map<String, String> userReq = {};
  storeRequests(String barcode) {
    userReq['product${i}'] = barcode;
    i++;
  }

  bool addToDB() {
    for (int i = 0; i < checkBoxList.length; i++) {
      if (checkBoxList[i] == true) {
        storeRequests(Barcodes[i]);
      }
    }
    var collection = FirebaseFirestore.instance.collection('ReturnRequests');
    collection.doc(documentName).set(userReq);
    return true;
  }
}

class invoice {
  final String barcode;
  final bool returnable;

  invoice({
    required this.barcode,
    required this.returnable,
  });

  Map<String, dynamic> toJson() => {
        'barcode': barcode,
        'returnable': returnable,
      };

  static invoice fromJson(Map<String, dynamic> json) => invoice(
        barcode: json['barcode'],
        returnable: json['returnable'],
      );
}

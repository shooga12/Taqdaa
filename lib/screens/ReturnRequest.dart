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

  Map<String, String> userInvoice = {
    'product1': '123456789',
    'returnable1': "ture",
    'product2': '987654321',
    'returnable2': "false",
  };
  // Map<String, String> userReq = {'product1': '123456789'};

  bool result = false;
  AddToInvoice() {
    var collection = FirebaseFirestore.instance.collection('Invoices');
    collection.doc(documentName).set(userInvoice);
    //return true;
  }

  var value = false;
  //var count = 0;
  var added = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
        child: Column(children: [
          StreamBuilder<List<invoice>>(
              stream: readProducts(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final invoice = snapshot.data!;
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: invoice.length,
                      itemBuilder: (BuildContext context, int index) {
                        var data = invoice[index];
                        if (data.returnable == true) {
                          return CheckboxListTile(
                            title: Text(
                              data.barcode,
                              style: TextStyle(fontSize: 16),
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                            value: value,
                            onChanged: (val) {
                              setState(() {
                                value = val!;
                                storeRequests(data.barcode);
                              });
                            },
                            activeColor: Colors.orange,
                            checkColor: Colors.white,
                          );
                        } else if (data.returnable == false) {
                          return Row(
                            children: [Text(data.barcode)],
                          );
                        }
                        return nothing();
                      });
                } else if (snapshot.hasError) {
                  return Text("Some thing went wrong! ${snapshot.error}");
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
          ElevatedButton(
              onPressed: () {
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
                            content: Text('حدث خطأ، لطفًا حاول لاحقًا'),
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
                //   MaterialPageRoute(builder: (context) => returnRequest()),
                // );
              },
              child: Text('طلب استرجاع'),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.grey;
                    }
                    return Colors.orange;
                  }),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30))))),
        ]),
      ),

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
      leading: CheckboxListTile(
        title: Text(
          barcode,
          style: TextStyle(fontSize: 16),
        ),
        controlAffinity: ListTileControlAffinity.leading,
        value: value,
        onChanged: (val) {
          setState(() {
            value = val!;
          });
        },
        activeColor: Colors.orange,
        checkColor: Colors.white,
      ),
      // title: Text(
      //   barcode,
      //   style: TextStyle(fontSize: 16),
      // ),
    );
  }

  var i = 1;
  Map<String, String> userReq = {};
  storeRequests(String barcode) {
    userReq['product${i}'] = barcode;
    i++;
  }

  bool addToDB() {
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../model/invoice.dart';
import '../model/item.dart';
import 'invoice_details.dart';
import '../confige/EcommerceApp.dart';

class returnRequest extends StatefulWidget {
  final invoice;
  const returnRequest(this.invoice, {super.key});

  @override
  State<returnRequest> createState() => _returnRequestState(invoice);
}

class _returnRequestState extends State<returnRequest> {
  Invoice? invoice;
  FirebaseDatabase database = FirebaseDatabase.instance;
  String documentName = EcommerceApp().getCurrentUser();

  _returnRequestState(invoice) {
    this.invoice = invoice;
  }

  //bool result = false;

  List Barcodes = [];
  List returnable = [];
  List checkBoxList = [];
  List<int> selectedItem = [];
  int n = -1;

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
      body: Padding(
        padding:
            const EdgeInsets.only(top: 15.0, bottom: 15.0, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    " رقم الفاتورة: ${invoice!.id}",
                    style: new TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    " المتجر: ${invoice!.store}",
                    style: new TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    "${invoice!.date}",
                    style: new TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
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
              height: 5,
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: invoice?.items.length,
                    itemBuilder: (context, index) {
                      var item = invoice?.items[index];
                      AddToList(item!);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          width: double.infinity,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Checkbox(
                                value:
                                    selectedItem.contains(index) ? true : false,
                                onChanged: (newValue) {
                                  if (selectedItem.contains(index)) {
                                    selectedItem.remove(index);
                                  } else {
                                    selectedItem.add(index);
                                  }
                                  setState(() {
                                    checkBoxList[index] = newValue;
                                    //storeRequests(item.barcode);
                                  });
                                },
                                activeColor: Colors.orange,
                                checkColor: Colors.white,
                              ),
                              Expanded(
                                flex: 1,
                                child: Image.network(
                                  '${item.img}',
                                  height: 60,
                                ),
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                flex: 3,
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${item.name}",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Text(
                                            " الكمية: ${item.quantity}",
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "SR",
                                                textDirection:
                                                    TextDirection.rtl,
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(width: 5.0),
                                              Text(
                                                "${item.price}",
                                                textDirection:
                                                    TextDirection.rtl,
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
                              )
                            ],
                          ),
                        ),
                      );
                      //++n;
                      //checkeReturnable(invoice?.items[index], n);
                      // return Container(
                      //     width: double.infinity,
                      //     child: Column(
                      //       mainAxisSize: MainAxisSize.min,
                      //       children: [
                      //         Checkbox(
                      //           value:
                      //               selectedItem.contains(index) ? true : false,
                      //           onChanged: (newValue) {
                      //             if (selectedItem.contains(index)) {
                      //               selectedItem.remove(index);
                      //             } else {
                      //               selectedItem.add(index);
                      //             }
                      //             setState(() {});
                      //           },
                      //           // value: checkBoxList[++n],
                      //           // onChanged: (val) {
                      //           //   setState(() {
                      //           //     checkBoxList[n] = val;
                      //           //     storeRequests(item!.barcode);
                      //           //   });
                      //           //},
                      //           activeColor: Colors.orange,
                      //           checkColor: Colors.white,
                      //         ),

                      //         buildItemCard(
                      //             invoice?.items[index], context, index)
                      //       ],
                      //     ));

                      // return buildItemCard(invoice?.items[index], context, ++n);

                      //checkeReturnable(invoice?.items[index], n);
                      // return buildItemCard(invoice?.items[index], context, n);
                    })),
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
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
                          Text("${invoice!.sub_total}"),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "الضريبة المضافة 15% ",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Row(
                        children: [
                          Text("SR "),
                          Text("${invoice!.vat_total}"),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "إجمالي الفاتورة",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w500),
                      ),
                      Row(
                        children: [
                          Text(
                            "SR ",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "${invoice!.total}",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w500),
                          ),
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
          ],
        ),
      ),
    );
  }

  nothing() {
    return Container();
  }

  // buildItemCard(dynamic item, BuildContext context, int n) {
  //   AddToList(item);
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8.0),
  //     child: Container(
  //       width: double.infinity,
  //       child: Row(
  //         mainAxisSize: MainAxisSize.max,
  //         children: [
  //           //checkeReturnable(item, n),

  //           Checkbox(
  //             value: checkBoxList[n],
  //             onChanged: (val) {
  //               setState(() {
  //                 checkBoxList[n] = val;
  //                 storeRequests(item.barcode);
  //               });
  //             },
  //             activeColor: Colors.orange,
  //             checkColor: Colors.white,
  //           ),
  //           Expanded(
  //             flex: 1,
  //             child: Image.network(
  //               '${item.img}',
  //               height: 60,
  //             ),
  //           ),
  //           SizedBox(width: 20),
  //           Expanded(
  //             flex: 3,
  //             child: Row(
  //               mainAxisSize: MainAxisSize.max,
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Expanded(
  //                   flex: 1,
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         "${item.name}",
  //                         style: TextStyle(
  //                           fontSize: 18,
  //                           fontWeight: FontWeight.w500,
  //                         ),
  //                       ),
  //                       SizedBox(
  //                         height: 5.0,
  //                       ),
  //                       Text(
  //                         " الكمية: ${item.quantity}",
  //                         style: TextStyle(
  //                           color: Colors.grey,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 Expanded(
  //                   flex: 1,
  //                   child: Row(
  //                     mainAxisSize: MainAxisSize.max,
  //                     mainAxisAlignment: MainAxisAlignment.end,
  //                     children: [
  //                       Row(
  //                         children: [
  //                           Text(
  //                             "SR",
  //                             textDirection: TextDirection.rtl,
  //                             textAlign: TextAlign.end,
  //                             style: TextStyle(
  //                               fontSize: 18,
  //                               fontWeight: FontWeight.w600,
  //                             ),
  //                           ),
  //                           SizedBox(width: 5.0),
  //                           Text(
  //                             "${item.price}",
  //                             textDirection: TextDirection.rtl,
  //                             textAlign: TextAlign.end,
  //                             style: TextStyle(
  //                               fontSize: 18,
  //                               fontWeight: FontWeight.w600,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ],
  //                   ),
  //                 )
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  AddToList(Item item) {
    Barcodes.add(item.barcode);
    returnable.add(item.returnable);
    checkBoxList.add(false);
  }

  // checkeReturnable(item, n) {
  //   return Checkbox(
  //     value: checkBoxList[n],
  //     onChanged: (val) {
  //       setState(() {
  //         checkBoxList[n] = val;
  //         storeRequests(item.barcode);
  //       });
  //     },
  //     activeColor: Colors.orange,
  //     checkColor: Colors.white,
  //   );
  // }

  var i = 0;
  Map<String, String> userReq = {};
  storeRequests(String? barcode) {
    userReq['product${i}'] = barcode!;
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

// Container(
//   width: double.infinity,
//   child: Padding(
//     padding: const EdgeInsets.all(20.0),
//     child: Expanded(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.max,
//         children: [
//           Text(
//             "المنتجات",
//             textAlign: TextAlign.right,
//             style: TextStyle(
//               fontSize: 22,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 8.0),
//             child: Container(
//               height: 1,
//               decoration: BoxDecoration(
//                 color: Colors.grey,
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           Container(
//             width: double.infinity,
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Checkbox(
//                   value: checkBoxList[0],
//                   onChanged: (val) {
//                     setState(() {
//                       checkBoxList[0] = val;
//                       // if (!value) {
//                       //         value = false;
//                       //       }
//                       //storeRequests("123456789");
//                     });
//                   },
//                   activeColor: Colors.orange,
//                   checkColor: Colors.white,
//                 ),
//                 Expanded(
//                   flex: 1,
//                   child: Image.asset(
//                     'assets/s2497212-main-zoom.jpeg',
//                     height: 50,
//                   ),
//                 ),
//                 SizedBox(width: 20),
//                 Expanded(
//                   flex: 3,
//                   child: Row(
//                     mainAxisSize: MainAxisSize.max,
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         flex: 1,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "ماسكارا",
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                             SizedBox(
//                               height: 5.0,
//                             ),
//                             Text(
//                               "الكمية: 1",
//                               style: TextStyle(
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Expanded(
//                         flex: 1,
//                         child: Row(
//                           mainAxisSize: MainAxisSize.max,
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             Row(
//                               children: [
//                                 Text(
//                                   "SR",
//                                   textDirection: TextDirection.rtl,
//                                   textAlign: TextAlign.end,
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                                 SizedBox(width: 5.0),
//                                 Text(
//                                   "100",
//                                   textDirection: TextDirection.rtl,
//                                   textAlign: TextAlign.end,
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           Container(
//             width: double.infinity,
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Checkbox(
//                   value: checkBoxList[1],
//                   onChanged: (val) {
//                     setState(() {
//                       checkBoxList[1] = val;
//                       //storeRequests("987654321");
//                     });
//                   },
//                   activeColor: Colors.orange,
//                   checkColor: Colors.white,
//                 ),
//                 Expanded(
//                   flex: 1,
//                   child: Image.asset(
//                     'assets/243280_swatch.jpeg',
//                     height: 50,
//                   ),
//                 ),
//                 SizedBox(width: 20),
//                 Expanded(
//                   flex: 3,
//                   child: Row(
//                     mainAxisSize: MainAxisSize.max,
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         flex: 1,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "ماسكارا",
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                             SizedBox(
//                               height: 5.0,
//                             ),
//                             Text(
//                               "الكمية: 1",
//                               style: TextStyle(
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Expanded(
//                         flex: 1,
//                         child: Row(
//                           mainAxisSize: MainAxisSize.max,
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             Row(
//                               children: [
//                                 Text(
//                                   "SR",
//                                   textDirection: TextDirection.rtl,
//                                   textAlign: TextAlign.end,
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                                 SizedBox(width: 5.0),
//                                 Text(
//                                   "100",
//                                   textDirection: TextDirection.rtl,
//                                   textAlign: TextAlign.end,
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           Container(
//             width: double.infinity,
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [

//                 Expanded(
//                   flex: 1,
//                   child: Image.asset(
//                     'assets/sephora_con.webp',
//                     height: 50,
//                   ),
//                 ),
//                 SizedBox(width: 20),
//                 Expanded(
//                   flex: 3,
//                   child: Row(
//                     mainAxisSize: MainAxisSize.max,
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         flex: 1,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "ماسكارا",
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                             SizedBox(
//                               height: 5.0,
//                             ),
//                             Text(
//                               "الكمية: 1",
//                               style: TextStyle(
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Expanded(
//                         flex: 1,
//                         child: Row(
//                           mainAxisSize: MainAxisSize.max,
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             Row(
//                               children: [
//                                 Text(
//                                   "SR",
//                                   textDirection: TextDirection.rtl,
//                                   textAlign: TextAlign.end,
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                                 SizedBox(width: 5.0),
//                                 Text(
//                                   "100",
//                                   textDirection: TextDirection.rtl,
//                                   textAlign: TextAlign.end,
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           SizedBox(
//             height: 20.0,
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 8.0),
//             child: Container(
//               height: 1,
//               decoration: BoxDecoration(
//                 color: Colors.grey,
//               ),
//             ),
//           ),
//           Row(
//             mainAxisSize: MainAxisSize.max,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "المجموع",
//                 style: TextStyle(
//                   fontSize: 18,
//                 ),
//               ),
//               Row(
//                 children: [
//                   Text("SR "),
//                   Text("300"),
//                 ],
//               ),
//             ],
//           ),
//           SizedBox(
//             height: 40.0,
//           ),
//           Center(
//             child: SizedBox(
//               width: 200,
//               height: 40,
//               child: ElevatedButton(
//                 onPressed: () async {
//                   added = addToDB();
//                   if (added == true) {
//                     showDialog(
//                         context: context,
//                         builder: (context) {
//                           return AlertDialog(
//                               content: Text(
//                                   "تم إرسال الطلب بنجاح! \n سيتم تنبيهك عند قبول الطلب"),
//                               actions: [
//                                 TextButton(
//                                   onPressed: () =>
//                                       Navigator.pop(context, 'حسنًا'),
//                                   child: const Text('حسنًا'),
//                                 )
//                               ]);
//                         });
//                   } else if (added == true) {
//                     showDialog(
//                         context: context,
//                         builder: (context) {
//                           return AlertDialog(
//                               content:
//                                   Text('حدث خطأ، لطفًا حاول لاحقًا'),
//                               actions: [
//                                 TextButton(
//                                   onPressed: () =>
//                                       Navigator.pop(context, 'حسنًا'),
//                                   child: const Text('حسنًا'),
//                                 )
//                               ]);
//                         });
//                   }

//                 },
//                 child: Text(
//                   'إرسال الطلب',
//                   style: const TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 18),
//                 ),
//                 style: ButtonStyle(
//                     backgroundColor:
//                         MaterialStateProperty.resolveWith((states) {
//                       if (states.contains(MaterialState.pressed)) {
//                         return Colors.grey;
//                       }
//                       return Colors.orange;
//                     }),
//                     shape: MaterialStateProperty.all<
//                             RoundedRectangleBorder>(
//                         RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30)))),
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   ),
// )

// Stream<List<invoice>> readProducts() => FirebaseFirestore.instance
//     .collection('Invoices')
//     .snapshots()
//     .map((snapshot) =>
//         snapshot.docs.map((doc) => invoice.fromJson(doc.data())).toList());
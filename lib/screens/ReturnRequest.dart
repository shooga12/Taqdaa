import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/src/widgets/container.dart';
//import 'package:flutter/src/widgets/framework.dart';
import '../model/invoice.dart';
import '../model/item.dart';
import 'invoices.dart';
import '../confige/EcommerceApp.dart';

class returnRequest extends StatefulWidget {
  final invoice;
  const returnRequest(this.invoice, {super.key});

  @override
  State<returnRequest> createState() => _returnRequestState(invoice);
}

class _returnRequestState extends State<returnRequest> {
  String user = EcommerceApp().getCurrentUser();
  Invoice? invoice;
  FirebaseDatabase database = FirebaseDatabase.instance;
  String documentName = EcommerceApp().getCurrentUser();
  TextEditingController? _controller;
  //List thisInvoice [] = invoicesState.invoices ;

  _returnRequestState(invoice) {
    this.invoice = invoice;
  }
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
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
        padding: const EdgeInsets.only(bottom: 15.0, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 5.0,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Card(
                color: Color.fromARGB(243, 243, 239, 231),
                child: Container(
                    alignment: Alignment.centerLeft,
                    height: 50,
                    width: 370,
                    child: Row(
                      children: [
                        Text("   "),
                        Icon(Icons.info_outline_rounded),
                        Text(
                          " يمكنك اختيار المنتجات التي يسمح بترجيعها فقط ",
                          style: TextStyle(fontSize: 15.5, letterSpacing: 0.8),
                        ),
                      ],
                    )),
              ),
            ),
            // Center(
            //   child: Row(
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: <Widget>[
            //       Text(
            //         " رقم الفاتورة: ${invoice!.id}  ",
            //         style: new TextStyle(
            //           fontSize: 16,
            //         ),
            //       ),
            //       SizedBox(
            //         height: 5.0,
            //       ),
            //       Text(
            //         " المتجر: ${invoice!.store}  ",
            //         style: new TextStyle(
            //           fontSize: 16,
            //         ),
            //       ),
            //       SizedBox(
            //         height: 5.0,
            //       ),
            //       Text(
            //         "${invoice!.date}",
            //         style: new TextStyle(
            //           fontSize: 17,
            //           color: Colors.black,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            Text(
              "المنتجات",
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 20,
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
            // SizedBox(
            //   height: 5,
            // ),
            Expanded(
              child: ListView.builder(
                  itemCount: invoice?.items.length,
                  itemBuilder: (context, index) {
                    var item = invoice?.items[index];
                    AddToList(item!);
                    if (item.returnable == true) {
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
                    } else {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          width: double.infinity,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              SizedBox(
                                width: 46,
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
                    }
                  }),
            ),
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    // child: Container(
                    //   height: 1,
                    //   decoration: BoxDecoration(
                    //     color: Colors.grey,
                    //   ),
                    // ),
                  ),
                  // Row(
                  //   mainAxisSize: MainAxisSize.max,
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text(
                  //       "المجموع",
                  //       style: TextStyle(
                  //         fontSize: 18,
                  //       ),
                  //     ),
                  //     Row(
                  //       children: [
                  //         Text("SR "),
                  //         Text("${invoice!.sub_total}"),
                  //       ],
                  //     ),
                  //   ],
                  // ),
                  // Row(
                  //   mainAxisSize: MainAxisSize.max,
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text(
                  //       "الضريبة المضافة 15% ",
                  //       style: TextStyle(
                  //         fontSize: 18,
                  //       ),
                  //     ),
                  //     Row(
                  //       children: [
                  //         Text("SR "),
                  //         Text("${invoice!.vat_total}"),
                  //       ],
                  //     ),
                  //   ],
                  // ),
                  // Row(
                  //   mainAxisSize: MainAxisSize.max,
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text(
                  //       "إجمالي الفاتورة",
                  //       style: TextStyle(
                  //           fontSize: 20, fontWeight: FontWeight.w500),
                  //     ),
                  //     Row(
                  //       children: [
                  //         Text(
                  //           "SR ",
                  //           style: TextStyle(
                  //               fontSize: 20, fontWeight: FontWeight.w500),
                  //         ),
                  //         Text(
                  //           "${invoice!.total}",
                  //           style: TextStyle(
                  //               fontSize: 20, fontWeight: FontWeight.w500),
                  //         ),
                  //       ],
                  //     ),
                  //   ],
                  // ),
                  SizedBox(
                    height: 10.0,
                  ),
                  // SizedBox(
                  //   width: 370,
                  //   height: 50,
                  //   child: TextField(
                  //     controller: _controller,
                  //     cursorColor: Color.fromARGB(255, 37, 43, 121),
                  //     style: TextStyle(
                  //         color: Color.fromARGB(255, 15, 53, 120)
                  //             .withOpacity(0.9)),
                  //     decoration: InputDecoration(
                  //       border: OutlineInputBorder(),
                  //       filled: true, //<-- SEE HERE
                  //       fillColor:
                  //           Color.fromARGB(243, 243, 239, 231), //<-- SEE HERE

                  //       labelText: ' لطفًا زودنا بسبب الترجيع ',
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    height: 15.0,
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
                  // SizedBox(
                  //   height: 8,
                  // ),
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

  AddToList(Item item) {
    Barcodes.add(item.barcode);
    returnable.add(item.returnable);
    checkBoxList.add(false);
  }

  var i = 0;
  Map<String, String> userReq = {};
  storeRequests(String? barcode) {
    userReq['product${i}'] = barcode!;
    i++;
  }

  bool addToDB() {
    var addToInvoice =
        FirebaseFirestore.instance.collection('All-Invoices').doc("Invoice1");

    /// "Invoice${invoice!.id}${EcommerceApp.uid}"
    addToInvoice.update({"HaveReturnReq": true});
    addToInvoice.update({'status': 'pending'});

    String? storeName = invoice!.store;

    for (int i = 0; i < checkBoxList.length; i++) {
      if (checkBoxList[i] == true) {
        storeRequests(Barcodes[i]);
        // addToInvoice.update({

        //    'items[$i]':
        //     {
        //       '$i': {
        //         'barcode': invoice?.items[i].barcode,
        //         'name': invoice?.items[i].name,
        //         'img': invoice?.items[i].img,
        //         'price': invoice?.items[i].price,
        //         'quantity': invoice?.items[i].quantity,
        //         'returnRequest': true,
        //         'returnable': invoice?.items[i].returnable,
        //       }
        //     }

        // 'items': [
        //   {
        //     '$i': {
        //       'barcode': invoice?.items[i].barcode,
        //       'name': invoice?.items[i].name,
        //       'img': invoice?.items[i].img,
        //       'price': invoice?.items[i].price,
        //       'quantity': invoice?.items[i].quantity,
        //       'returnRequest': true,
        //       'returnable': invoice?.items[i].returnable,
        //     }
        //   }
        // ]

      }
    }

    var collection = FirebaseFirestore.instance.collection('ReturnRequests');
    collection.doc('$storeName$documentName').set(userReq);
    return true;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../models/invoice.dart';
import '../models/item.dart';
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
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w100),
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
                margin: EdgeInsets.all(5),
                color: Color.fromARGB(243, 243, 239, 231),
                child: Container(
                    alignment: Alignment.centerLeft,
                    height: 60,
                    width: 370,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(" "),
                          Icon(Icons.info_outline_rounded),
                          Text(
                            " يمكنك اختيار المنتجات التي يسمح بترجيعها فقط.",
                            style:
                                TextStyle(fontSize: 14.5, letterSpacing: 0.8),
                          ),
                        ],
                      ),
                    )),
              ),
            ),
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
                                Container(
                                  child: Stack(children: <Widget>[
                                    Container(
                                      child: new Image.asset(
                                        'assets/Rectangle.png',
                                        height: 82.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 17.0),
                                      child: Checkbox(
                                        value: selectedItem.contains(index)
                                            ? true
                                            : false,
                                        onChanged: (newValue) {
                                          if (selectedItem.contains(index)) {
                                            selectedItem.remove(index);
                                          } else {
                                            selectedItem.add(index);
                                          }
                                          setState(() {
                                            checkBoxList[index] = newValue;
                                          });
                                        },
                                        activeColor:
                                            Color.fromARGB(255, 0, 38, 255),
                                        checkColor: Colors.white,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 35, top: 2.5),
                                      child: Container(
                                        width: 55,
                                        margin: EdgeInsets.all(10),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: Image(
                                            image: NetworkImage(
                                              '${item.img}',
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ]),
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  flex: 3,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${item.name}",
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 32, 7, 121),
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Text(
                                            "السعر : " +
                                                item.price.toString() +
                                                ' ريال',
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 80),
                                      Expanded(
                                        flex: 1,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              width: 35,
                                              height: 35,
                                              decoration: new BoxDecoration(
                                                color: Color.fromARGB(
                                                    255, 245, 161, 14),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            Text(
                                              item.quantity.toString(),
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )
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
                    })),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  color: Colors.grey,
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: 25.0,
                  ),
                  Center(
                    child: SizedBox(
                      width: 200,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyHomePage()),
                          );
                          added = await addToDB(invoice!.id);
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
                            ///bug fixes شنو هذا
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

  Future<bool> addToDB(String? id) async {
    var addToInvoice = await FirebaseFirestore.instance
        .collection('${documentName}Invoices')
        .where("ID", isEqualTo: id)
        .get();
    var documentId = addToInvoice.docs.first.id;
    var document = FirebaseFirestore.instance
        .collection('${documentName}Invoices')
        .doc(documentId);
    document.update({"HaveReturnReq": true});
    document.update({'status': 'pending'});

    String? storeName = invoice!.store;

    for (int i = 0; i < checkBoxList.length; i++) {
      if (checkBoxList[i] == true) {
        storeRequests(Barcodes[i]);
      }
    }

    var collection = FirebaseFirestore.instance
        .collection('ReturnRequests'); ////bug fixes should be atomic
    collection.doc('$storeName$documentName').set(userReq);
    return true;
  }
}

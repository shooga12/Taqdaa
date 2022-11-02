import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controller/EcommerceApp.dart';
import '../model/invoice.dart';
import '../model/item.dart';
import '../views/ViewReturnRequests.dart';
import 'home_page.dart';

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
  List price = [];
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
                      padding: const EdgeInsets.all(0.0),
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
                                        // child: ClipRRect(
                                        //   borderRadius:
                                        //       BorderRadius.circular(50),
                                        //   child: Image.network(
                                        //     '${item.img}',
                                        //     height: 60,
                                        //   ),
                                        // ),
                                      ),
                                    )
                                  ]),
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      // mainAxisAlignment:
                                      //     MainAxisAlignment.spaceBetween,
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
                                            if (item.size != "")
                                              Text(
                                                "المـقاس : ${item.size}",
                                                style: new TextStyle(
                                                  fontSize: 16,
                                                  color: Color.fromARGB(
                                                      255, 32, 7, 121),
                                                ),
                                              ),
                                            Text(
                                              "السعر : " +
                                                  item.price.toString() +
                                                  ' ريال',
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Row(
                                              children: <Widget>[
                                                first != 0
                                                    ? new IconButton(
                                                        onPressed: () {
                                                          if (first > 1) {
                                                            setState(() {
                                                              first--;
                                                              listentoChange(
                                                                  item);
                                                            });
                                                          }
                                                          ;
                                                        },
                                                        icon: Icon(
                                                            Icons.remove_circle,
                                                            color: first == 1
                                                                ? Color
                                                                    .fromARGB(
                                                                        255,
                                                                        195,
                                                                        195,
                                                                        195)
                                                                : Color
                                                                    .fromARGB(
                                                                        255,
                                                                        118,
                                                                        171,
                                                                        223)))
                                                    : new Container(),
                                                Container(
                                                  alignment: Alignment.center,
                                                  width: 35,
                                                  height: 35,
                                                  decoration: new BoxDecoration(
                                                    color: Color.fromARGB(
                                                        255, 245, 161, 14),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Text(
                                                    first.toString(),
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                new IconButton(
                                                    icon: new Icon(
                                                        Icons.add_circle,
                                                        color: first ==
                                                                item.quantity
                                                            ? Color.fromARGB(
                                                                255,
                                                                195,
                                                                195,
                                                                195)
                                                            : Color.fromARGB(
                                                                255,
                                                                118,
                                                                171,
                                                                223)),
                                                    onPressed: () {
                                                      if (first <
                                                          item.quantity) {
                                                        setState(() {
                                                          first++;
                                                          listentoChange(item);
                                                        });
                                                      }
                                                    })
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
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
                                      padding: const EdgeInsets.only(
                                          right: 35, top: 2.5),
                                      child: Container(
                                        width: 55,
                                        margin: EdgeInsets.all(10),
                                        // child: ClipRRect(
                                        //   borderRadius:
                                        //       BorderRadius.circular(50),
                                        //   child: Image(
                                        //     image: NetworkImage(
                                        //       '${item.img}',
                                        //     ),
                                        //   ),
                                        // ),
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
                          if (selectedItem.isNotEmpty) {
                            added = await addToDB();
                            EcommerceApp.pageIndex = 0;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    HomePage(), //bug fixes make sure works
                              ),
                            );
                            if (added == true) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewReturnReq(),
                                ),
                              );
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                        content: Container(
                                          height: 300,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Image.asset(
                                                  "assets/successfull_payment.png",
                                                  height: 200,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "تم إرسال الطلب بنجاح! \n سيتم تنبيهك عند قبول الطلب",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: Color.fromARGB(
                                                          255, 98, 160, 100)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, 'حسنًا'),
                                            child: const Text('حسنًا'),
                                          )
                                        ]);
                                  });
                            } else if (added == false) {
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
                          } else if (selectedItem.isEmpty) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                      content:
                                          Text("قم باختيار المنتجات أولًا!"),
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

  int first = 1;

  var items = [];
  AddToList(Item item) {
    items.add(Item(
            barcode: item.barcode,
            name: item.name,
            img: item.img,
            quantity: first,
            price: item.price,
            returnable: true)
        .toMap());
    Barcodes.add(item.barcode);
    returnable.add(item.returnable);
    checkBoxList.add(false);
    price.add(item.price);
  }

  listentoChange(Item item) {
    for (int i = 0; i < items.length; i++) {
      if (items[i].containsKey("barcode")) {
        if (items[i]["barcode"] == Barcodes[i]) {
          items[i]["quantity"] = first;
        }
        ;
      }
    }
  }

  Future<bool> addToDB() async {
    var checkedItems = [];
    num total = 0;
    var now = new DateTime.now();
    var formatter = new DateFormat('dd/MM/yyyy');
    String todayDate = formatter.format(now);

    for (int i = 0; i < checkBoxList.length; i++) {
      if (checkBoxList[i] == true) {
        checkedItems.add(items[i]);
        total = total + price[i];
      }
    }

    double vat = (total * 15) / 100;
    num subTotal = total - vat.toInt();

    Invoice? invoice1 = this.invoice!;
    FirebaseFirestore.instance.collection('ReturnRequests${documentName}').add({
      "ID": invoice1.id,
      "Date": todayDate,
      "Total": total,
      "Store": invoice1.store,
      "items": checkedItems,
      'sub-total': subTotal,
      'vat-total': vat,
      'status': "pending"
    }).catchError((onError) => print(onError));

    var addToInvoice = await FirebaseFirestore.instance
        .collection('${documentName}Invoices')
        .where("ID", isEqualTo: invoice1.id)
        .get();
    var documentId = addToInvoice.docs.first.id;
    var document = FirebaseFirestore.instance
        .collection('${documentName}Invoices')
        .doc(documentId);
    document.update({"HaveReturnReq": true});

    return true;
  }
}

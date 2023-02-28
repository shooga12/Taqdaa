import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Query;
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../confige/EcommerceApp.dart';
import '../main.dart';
import 'home_page.dart';
import 'scanBarCode.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/store_model.dart';
import '../views/scanner.dart';

class ListOfStores2 extends StatefulWidget {
  const ListOfStores2({super.key});

  @override
  State<ListOfStores2> createState() => ListOfStores2State();
}

class ListOfStores2State extends State<ListOfStores2> {
  final List<Store> Stores = [];
  FirebaseDatabase database = FirebaseDatabase.instance;
  static String collectionName = EcommerceApp().getCurrentUser();

  String _counter = "";

  Future _scan(BuildContext context) async {
    _counter = await FlutterBarcodeScanner.scanBarcode(
        "#FEB139", "Cancel", true, ScanMode.BARCODE);

    setState(() {
      EcommerceApp.value = _counter;
    });

    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('${EcommerceApp.uid}All')
        .where("Item_number", isEqualTo: EcommerceApp.value.substring(1))
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    if (documents.length == 1) {
      EcommerceApp.pageIndex = 1;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                content: Text(
                    "تمت إضافة المنتج مسبقًا!",
                  style: TextStyle(
                      fontFamily: 'Tajawal'
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'حسنًا'),
                    child: const Text('حسنًا',
                      style: TextStyle(
                          fontFamily: 'Tajawal'
                      ),
                    ),
                  )
                ]);
          });
      return false;
    }

    Query dbref = FirebaseDatabase.instance
        .ref()
        .child(EcommerceApp.storeId)
        .child('store')
        .orderByChild('Barcode')
        .equalTo(EcommerceApp.value.substring(1));

    final event = await dbref.once(DatabaseEventType.value);
    print("BARCODE: ${EcommerceApp.value.substring(1)}");
    if (event.snapshot.value != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ScanPage()),
      );
    } else if (_counter == "-1") {
      return false;
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                content: Text("عذراً، لم يتم العثور على المنتج"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'حسنًا'),
                    child: const Text('حسنًا'),
                  )
                ]);
          });
    }
  }

  String SearchName = '';
  bool flag = false;
  int count = -1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Colors.white,
      body: Container(

          child: Stack(
            children: [
              Container(
                height: 350,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            'assets/AppBar.png'),
                        fit: BoxFit.cover

                    ),
                    borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(0)
                    )
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top:90.0),
                child: SingleChildScrollView(
                  child: Container(
                    height: 800,
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,

                          alignment: Alignment.center,
                          child: Row(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                  onPressed: ()=>Navigator.pop(context),
                                  icon: Icon(
                                    Icons.chevron_left_rounded,
                                        color: Colors.white,
                                    size: 45,

                                  ),
                              ),
                              SizedBox(width: 5,),
                              Padding(
                                padding: const EdgeInsets.only(top:20),
                                child: Text(
                                  'المتاجر',
                                  style: TextStyle(
                                    fontFamily: 'Tajawal',
                                    color: Colors.white,
                                    fontSize: 30
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 30,),
                        SizedBox(
                          height: 60,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 10),
                            child: TextField(
                              textAlignVertical: TextAlignVertical.bottom,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: const BorderSide(
                                        color: Color(0x76909090), width: 1.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: const BorderSide(
                                        color: Colors.orange, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: const BorderSide(
                                        color: Color(0x85747474), width: 1.0),
                                  ),

                                  prefixIcon: Icon(Icons.search),
                                  hintText: 'ابحث عن اسم متجر محدد',
                              ),
                              onChanged: (val) {
                                setState(() {
                                  SearchName = val;
                                });
                              },
                              style: TextStyle(
                                fontFamily: 'Tajawal'
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 0,),
                        Container(
                          height: 500,
                          width: 390,
                          child: StreamBuilder<List<Store>>(
                              stream: readStores(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final stores = snapshot.data!;
                                  count = stores.length;
                                  return ListView.builder(
                                      itemCount: stores.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        var data = stores[index];
                                        if (SearchName.isEmpty) {
                                          flag = false;
                                          return buildStoresCards(
                                              stores[index], context);
                                        } else if (SearchName.isNotEmpty &&
                                            data.StoreName.toString()
                                                .toLowerCase()
                                                .startsWith(
                                                    SearchName.toLowerCase())) {
                                          flag = true;
                                          return buildStoresCards(
                                              stores[index], context);
                                        } else if (flag == false &&
                                            index == count - 1) {
                                          return Container(
                                              child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              'لا يوجد نتائج',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontFamily: 'Tajawal',
                                              ),
                                            ),
                                          ));
                                        }
                                        return nothing();
                                      });
                                } else if (snapshot.hasError) {
                                  return Text(
                                      "Some thing went wrong! ${snapshot.error}");
                                } else {
                                  return Center(child: CircularProgressIndicator());
                                }
                              }),
                        ),
                      ],
                    ),
                  ),
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

  Stream<List<Store>> readStores() => FirebaseFirestore.instance
      .collection('Stores')
      .orderBy('kilometers')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Store.fromJson(doc.data())).toList());

  Widget buildStoresCards(Store store, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 5),
      child: Container(
        child: new InkWell(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.network(
                  store.StoreLogo,
                  width: 60,
                  height: 60,
                ),
                SizedBox(width: 12,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      ' ' + store.StoreName,
                      style: new TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,

                      children: <Widget>[
                        Text(
                          ' ' + store.kilometers.toString(),
                          style: new TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 77, 76, 76),
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        Text(
                          ' كم',
                          style: new TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 77, 76, 76),
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Spacer(),
                Icon(
                  size: 26,
                  Icons.document_scanner_outlined,
                  textDirection: TextDirection.ltr,
                  color: Color.fromARGB(255, 254, 177, 57),
                ),
                SizedBox(
                  width: 7,
                )
              ],
            ),
          ),
          onTap: () async {
            EcommerceApp.storeId = store.StoreId;
            EcommerceApp.returnDays = store.returnDays;
            if (EcommerceApp.storeName == "") {
              EcommerceApp.storeName = store.StoreName;
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => scanner()),
              // );
              _scan(context);
            } else if (EcommerceApp.haveItems &&
                EcommerceApp.storeName != store.StoreName) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                        content: Text(
                            ".${EcommerceApp.storeName}عذرًا، لديك طلب بالفعل في"),
                        actions: [
                          ElevatedButton(
                              onPressed: () async {
                                EcommerceApp.storeName = "";
                                await deleteCart();
                                await deleteCartDublicate();
                                await saveUserTotal(0);
                                Navigator.pop(context, 'حسنًا');
                              },
                              child:
                                  Text(" ${EcommerceApp.storeName} إلغاء طلب")),
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'حسنًا'),
                            child: const Text('حسنًا'),
                          ),
                        ]);
                  });
            } else {
              EcommerceApp.storeName = store.StoreName;
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => scanner()),
              // );
              _scan(context);
            }
          },
          highlightColor: Color.fromARGB(255, 255, 255, 255),
        ),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(55, 187, 187, 187),
              offset: Offset.zero,
              blurRadius: 20.0,
              blurStyle: BlurStyle.normal,
            ),
          ],
        ),
      ),
    );
  }

  static Future saveUserTotal(var total) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('${collectionName}Total')
        .get();
    final DocumentSnapshot document = result.docs.first;
    if (document.exists) {
      document.reference.update({'Total': total});
    }
  }

  static Future deleteCart() async {
    final QuerySnapshot result =
        await FirebaseFirestore.instance.collection('${collectionName}').get();
    final List<DocumentSnapshot> documents = result.docs;
    for (int i = 0; i < documents.length; i++) {
      documents[i].reference.delete();
    }
  }

  static Future deleteCartDublicate() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('${collectionName}All')
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    for (int i = 0; i < documents.length; i++) {
      documents[i].reference.delete();
    }
  }
}

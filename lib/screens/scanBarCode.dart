import 'package:cloud_firestore/cloud_firestore.dart' hide Query;
import 'package:flutter/material.dart';
import 'package:taqdaa_application/main.dart';
import 'package:taqdaa_application/screens/ShoppingCart.dart';
import '../confige/EcommerceApp.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

import '../models/product_model.dart';
import 'home_page.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({Key? key}) : super(key: key);
  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  _ScanPageState();

  Query dbref = FirebaseDatabase.instance
      .ref()
      .child(EcommerceApp.storeId)
      .child('store')
      .orderByChild('Barcode')
      .equalTo(EcommerceApp.value.substring(1));

  String collectionName = EcommerceApp().getCurrentUser();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      /*appBar: AppBar(
        leadingWidth: 90,
        title: Text(
          "المنتج الذي تم مسحه",
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w100,
              fontFamily: 'Tajawal'
          ),
        ),

        flexibleSpace: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/AppBar.png"), fit: BoxFit.fill)),
        ),


        toolbarHeight: 70,
        //leading: BackButton(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      */

      body: Padding(
        padding: const EdgeInsets.only(top: 0),
        child: Container(
            height: double.infinity,
            child: FirebaseAnimatedList(
                query: dbref,
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  //if (snapshot.hasChild('Barcode')) {
                  Map product = snapshot.value as Map;
                  product['key'] = snapshot.key;
                  //return buildBeforeCart(product: product);

                  return buildBeforeCart(product: product);
                })),
      ),
    );
  }

  Future saveUserItems(Product product) async {
    FirebaseFirestore.instance.collection('${collectionName}').add({
      "Category": product.Category,
      "Item_number": product.Item_number,
      "Price": product.Price,
      "Store": product.Store,
      "quantity": product.quantity,
      "RFID": product.RFID,
      "ProductImage": product.ProductImage,
      "returnable": product.returnable,
      "size": product.size,
    });
  }

  Future saveUserItemsDublicate(Product product) async {
    FirebaseFirestore.instance.collection('${collectionName}All').add({
      "Category": product.Category,
      "Item_number": product.Item_number,
      "Price": product.Price,
      "Store": product.Store,
      "quantity": product.quantity,
      "RFID": product.RFID,
      "returnable": product.returnable,
      "size": product.size,
    });
  }

  Widget buildBeforeCart({required Map product}) {
    return Container(
      child: Stack(
        children: [
          Container(
            height: 350,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/AppBar.png'), fit: BoxFit.cover),
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(0))),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 90.0),
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
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(
                              Icons.chevron_left_rounded,
                              color: Colors.white,
                              size: 45,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, right: 22),
                            child: Text(
                              'المنتج الذي تم مسحه',
                              style: TextStyle(
                                  fontFamily: 'Tajawal',
                                  color: Colors.white,
                                  fontSize: 30),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Text('\n\n\n'),
          // Text("المنتج الذي تم مسحه هو: \n",
          //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 280.0),
              child: Container(
                width: 300,
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Color(0x40EBEBEB),
                          offset: Offset.zero,
                          blurRadius: 5,
                          spreadRadius: 5,
                          blurStyle: BlurStyle.normal)
                    ],
                    borderRadius: BorderRadius.circular(5)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: new Container(
                    child: Column(
                      children: <Widget>[
                        new Container(
                          child: Stack(children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Container(
                                width: 140,
                                margin: EdgeInsets.all(10),
                                child: ClipRRect(
                                  child: Image(
                                    image: NetworkImage(
                                      product['ProductImage'],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ]),
                        ),
                        Column(
                          children: <Widget>[
                            SizedBox(height: 10),
                            Text(
                              product['Product Name'],
                              style: new TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            if (product['size'] != "")
                              Text(
                                "المـقاس : " + product['size'],
                                style: new TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 32, 7, 121),
                                    fontFamily: 'Tajawal'),
                              ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "   السعر : " +
                                  product['Price'].toString() +
                                  " ريال",
                              textAlign: TextAlign.center,
                              style: new TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 77, 76, 76),
                                  fontFamily: 'Tajawal'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Text('\n'),
          //),

          Padding(
            padding: const EdgeInsets.only(top: 660.0),
            child: Center(
              child: SizedBox(
                width: 250,
                height: 45,
                child: ElevatedButton(
                  onPressed: () async {
                    EcommerceApp.haveItems = true; ////bug fixes
                    EcommerceApp.productName = product['Product Name'];

                    Product toBeSavedProduct = Product(
                      Category: product['Product Name'],
                      Item_number: product['Barcode'],
                      Price: product['Price'],
                      Store: product['StoreName'],
                      quantity: product['quantity'],
                      RFID: product['RFID'],
                      ProductImage: product['ProductImage'],
                      returnable: product['returnable'],
                      size: product['size'],
                    );

                    if (await checkItemExist()) {
                      saveUserItemsDublicate(toBeSavedProduct);
                    } else {
                      saveUserItemsDublicate(toBeSavedProduct);
                      saveUserItems(toBeSavedProduct);
                    }
                    EcommerceApp.counter++;
                    EcommerceApp.NumOfItems++;
                    EcommerceApp.pageIndex = 1;
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      duration: const Duration(seconds: 2),
                      backgroundColor: Color.fromARGB(114, 128, 149, 186),
                      content: Text(
                          "تم إضافته بالسلة، سيتم الاحتفاظ به لمدة ساعة",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              letterSpacing: 0.8,
                              fontFamily: 'Tajawal')),
                      action: null,
                    ));
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                  child: Text(
                    'إضافة للسلة',
                    style: const TextStyle(
                        color: Color.fromARGB(255, 21, 42, 86),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        fontFamily: 'Tajawal'),
                  ),
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all<double>(0),
                    backgroundColor:
                        MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.grey;
                      }
                      return Color(0x37FFFFFF);
                    }),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(
                            color: Color(0xB9152A56), width: 1.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> checkItemExist() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('${collectionName}')
        .where("Category", isEqualTo: EcommerceApp.productName)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    if (documents.length >= 1) {
      ///increment real time
      documents[0].reference.update({'quantity': FieldValue.increment(1)});
      return true;
    } else {
      return false;
    }
  }
}

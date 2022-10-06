import 'package:cloud_firestore/cloud_firestore.dart' hide Query;
import 'package:flutter/material.dart';
import 'package:taqdaa_application/screens/ShoppingCart.dart';
import '../confige/EcommerceApp.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({Key? key}) : super(key: key);
  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  _ScanPageState();

  Query dbref = FirebaseDatabase.instance
      .ref()
      .child(EcommerceApp.storeId) //Ecommerce.storeName
      .child('store')
      .orderByChild('Barcode')
      .equalTo(EcommerceApp.value.substring(1));

  String collectionName = EcommerceApp().getCurrentUser();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/Vector.png"), fit: BoxFit.fill)),
        ),
        toolbarHeight: 170,
        //leading: BackButton(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
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
      "ProductImage": product.ProductImage,
    });
  }

  Widget buildBeforeCart({required Map product}) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            //upper part
            children: [
              Text('\n'),
              Text("المنتج الذي تم مسحه هو: \n",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              Card(
                child: new InkWell(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 0, bottom: 0, left: 0, right: 6),
                    child: Row(
                      children: <Widget>[
                        new Container(
                          child: Stack(children: <Widget>[
                            Container(
                              child: new Image.asset(
                                'assets/Rectangle.png',
                                height: 100.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 25, top: 5),
                              child: Container(
                                width: 70,
                                margin: EdgeInsets.all(10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image(
                                    image: NetworkImage(
                                      product['ProductImage'],
                                    ),
                                  ),
                                ),
                                // Container(
                                //   alignment: Alignment.bottomLeft, //اعدله
                                //   child:
                                // ),
                              ),
                            )
                            // Container(
                            //   alignment: Alignment.center, //اعدله
                            //   child:  photo*****
                            // ),
                          ]),
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              "\n " + product['Product Name'],
                              style: new TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 32, 7, 121),
                              ),
                            ),
                            Text(
                              "   السعر : " +
                                  product['Price'].toString() +
                                  " ريال",
                              textAlign: TextAlign.center,
                              style: new TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 77, 76, 76),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                color: Color.fromARGB(255, 248, 248, 246),
              ),
              Text('\n'),
            ],
          ),
          //),
          Column(
            //lower part
            children: [
              Column(
                children: [
                  Center(
                    child: SizedBox(
                      width: 200,
                      height: 40,
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
                          );

                          if (await checkItemExist()) {
                            saveUserItemsDublicate(toBeSavedProduct);
                          } else {
                            saveUserItemsDublicate(toBeSavedProduct);
                            saveUserItems(toBeSavedProduct);
                          }
                          EcommerceApp.counter++;
                          // await FirebaseFirestore.instance
                          //     .collection('total')
                          //     .add({
                          //   "Total": 0,
                          // });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => shoppingCart()),
                          );
                        },
                        child: Text(
                          'إضافة للسلة',
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
            ],
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

class Product {
  final String Category;
  final String Item_number;
  final int Price;
  final String Store;
  final int quantity;
  final String RFID;
  final String ProductImage;

  Product(
      {required this.Category,
      required this.Item_number,
      required this.Price,
      required this.Store,
      required this.quantity,
      required this.RFID,
      required this.ProductImage});

  Map<String, dynamic> toJson() => {
        'Category': Category,
        'Item_number': Item_number,
        'Price': Price,
        'Store': Store,
        'quantity': quantity,
        'RFID': RFID,
        'ProductImage': ProductImage,
      };

  static Product fromJson(Map<String, dynamic> json) => Product(
        Category: json['Category'],
        Item_number: json['Item_number'],
        Price: json['Price'],
        Store: json['Store'],
        quantity: json['quantity'],
        RFID: json['RFID'],
        ProductImage: json['ProductImage'],
      );
}

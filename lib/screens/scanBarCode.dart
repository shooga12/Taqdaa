import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:taqdaa_application/screens/ShoppingCart.dart';
import '../confige/EcommerceApp.dart';
import 'list_of_stores.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({Key? key}) : super(key: key);
  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  _ScanPageState();

  String collectionName = EcommerceApp().getCurrentUser();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "",
          // style: TextStyle(fontFamily: 'Cairo'),
        ),
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
      body: StreamBuilder<List<Product>>(
          stream: readItems(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final products = snapshot.data!;
              return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (EcommerceApp.storeName == products[index].Store) {
                      return buildBeforeCart(products[index], context);
                    } else {
                      return AlertDialog(
                          content: Text("Sorry you can only scan items from " +
                              EcommerceApp.storeName +
                              " store!"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'OK'),
                              child: const Text('OK'),
                            )
                          ]);
                    }
                  }
                  //{
                  //   //Map thisItem = stores[index];
                  //   return ListTile(
                  //     title: Text(''),
                  //     subtitle: Text(''),
                  //   );
                  // }
                  //
                  //children: stores.map(buildStoresCards).toList(),
                  );
            } else if (snapshot.hasError) {
              return Text("Some thing went wrong! ${snapshot.error}");
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
      //Text(widget.value),
    );
  }

  Future saveUserItems(Product product) async {
    FirebaseFirestore.instance.collection('${collectionName}').add({
      "Category": product.Category,
      "Item_number": product.Item_number,
      "Price": product.Price,
      "Store": product.Store,
    });
  }

  Stream<List<Product>> readItems() => FirebaseFirestore.instance
      .collection('Products')
      .where("Item_number", isEqualTo: EcommerceApp.value.substring(1))
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Product.fromJson(doc.data())).toList());

  Widget buildBeforeCart(Product product, BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            //upper part
            children: [
              Text('\n'),
              Text("The product you Scanned is :\n",
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
                            Container(
                              alignment: Alignment.center, //اعدله
                              child: Text(
                                "\n " + product.Category,
                                style: new TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 32, 7, 121),
                                ),
                              ),
                            ),
                          ]),
                        ),
                        Text(
                          "   Price : " + product.Price + " SR",
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 77, 76, 76),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              //controller.removeProduct(product);
                            },
                            icon: Icon(Icons.remove_circle,
                                color: Color.fromARGB(255, 245, 161, 14))),
                        //Text('$quantity'),
                        Text('1'),
                        IconButton(
                            onPressed: () {
                              //controller.addProduct(product);
                            },
                            icon: Icon(Icons.add_circle,
                                color: Color.fromARGB(255, 245, 161, 14))),
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
                    child: ElevatedButton(
                      onPressed: () {
                        EcommerceApp.haveItmes = true;
                        saveUserItems(product);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => shoppingCart()),
                        );
                      },
                      child: Text(
                        'Add to cart',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith((states) {
                            if (states.contains(MaterialState.pressed)) {
                              return Colors.grey;
                            }
                            return Colors.orange;
                          }),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30)))),
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
}

class Product {
  final String Category;
  final String Item_number;
  final String Price;
  final String Store;

  Product(
      {required this.Category,
      required this.Item_number,
      required this.Price,
      required this.Store});

  Map<String, dynamic> toJson() => {
        'Category': Category,
        'Item_number': Item_number,
        'Price': Price,
        'Store': Store,
      };

  static Product fromJson(Map<String, dynamic> json) => Product(
        Category: json['Category'],
        Item_number: json['Item_number'],
        Price: json['Price'].toString(),
        Store: json['Store'],
      );
}

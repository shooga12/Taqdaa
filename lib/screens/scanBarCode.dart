import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'list_of_stores.dart';

class ScanPage extends StatefulWidget {
  const ScanPage(this.value, {Key? key}) : super(key: key);
  final String value;
  @override
  State<ScanPage> createState() => _ScanPageState(value);
}

class _ScanPageState extends State<ScanPage> {
  String _value = "";
  _ScanPageState(this._value);
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
                  image: AssetImage("assets/background.png"),
                  fit: BoxFit.fill)),
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
                itemBuilder: (BuildContext context, int index) =>
                    buildItemsCards(products[index], context),
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

  Stream<List<Product>> readItems() => FirebaseFirestore.instance
      .collection('Products')
      .where("Item_number", isEqualTo: _value.substring(1))
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Product.fromJson(doc.data())).toList());

  Widget buildItemsCards(Product product, BuildContext context) {
    return Container(
      child: Card(
        child: new InkWell(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 25, bottom: 25, left: 15, right: 8),
            child: Row(
              children: <Widget>[
                Text(
                  product.Category,
                  style: new TextStyle(
                    fontSize: 18,
                  ),
                ),
                Spacer(),
                Text(
                  product.Price,
                  style: new TextStyle(
                    fontSize: 15,
                    color: Color.fromARGB(255, 77, 76, 76),
                  ),
                ),
              ],
            ),
          ),
          onTap: () {},
        ),
        color: Color.fromARGB(255, 232, 229, 218),
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

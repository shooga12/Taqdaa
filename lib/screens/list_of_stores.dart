import 'package:flutter/material.dart';

class ListOfStores extends StatelessWidget {
  ListOfStores({super.key});
  final List<Store> Stores = [
    Store("Zara", "", ElevatedButton),
    Store("H&M", "", ElevatedButton),
    Store("Sephora", "", ElevatedButton),
    Store("CenterPoint", "", ElevatedButton),
    Store("HomeCenter", "", ElevatedButton),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: Container(
        color: Color.fromARGB(255, 243, 243, 243),
        child: new ListView.builder(
            itemCount: Stores.length,
            itemBuilder: (BuildContext context, int index) =>
                buildStoresCards(context, index)),
      ),
    );
  }

  Widget buildStoresCards(BuildContext context, int index) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 0,
          left: 15,
          right: 15,
          bottom: 3,
        ),
        child: Card(
          child: new InkWell(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 25, bottom: 25, left: 15, right: 8),
              child: Row(
                children: <Widget>[
                  Text(
                    Stores[index].name,
                    style: new TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ListOfStores()),
              );
            },
          ),
          color: Color.fromARGB(255, 232, 229, 218),
        ),
      ),
    );
  }
}

class Store {
  final String name;
  final String pictureUrl;
  final ElevatedButton;

  Store(this.name, this.pictureUrl, this.ElevatedButton);
}

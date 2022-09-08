import 'package:flutter/material.dart';
import 'list_of_stores.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   flexibleSpace: Container(
      //     decoration: BoxDecoration(
      //         image: DecorationImage(
      //             image: AssetImage("assets/background.png"),
      //             fit: BoxFit.fill)),
      //   ),
      //   toolbarHeight: 170,
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      // ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Scan'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ListOfStores()),
            );
          },
        ),
      ),
    );
  }
}

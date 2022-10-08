import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../confige/EcommerceApp.dart';

class returnRequest extends StatefulWidget {
  const returnRequest({super.key});

  @override
  State<returnRequest> createState() => _returnRequestState();
}

class _returnRequestState extends State<returnRequest> {
  FirebaseDatabase database = FirebaseDatabase.instance;
  String collectionName = EcommerceApp().getCurrentUser();

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Future saveUserTotal(var total) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('${collectionName}Return')
        .get();
  }
}

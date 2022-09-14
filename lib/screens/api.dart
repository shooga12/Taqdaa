import 'package:cloud_firestore/cloud_firestore.dart';

class ApiServices {
  Future<String?> addCollection() async {
    CollectionReference users = FirebaseFirestore.instance.collection('ftm');
    var result = await users.add({'id': '1234', 'name': 'khalid'});
    //result.id
  }
}

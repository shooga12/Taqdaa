import 'package:firebase_auth/firebase_auth.dart';

class EcommerceApp {
  static bool haveItmes = false;
  static String storeName = '';
  static String value = '';
  static String storeId = '';

  static String uid = '';
  final FirebaseAuth auth = FirebaseAuth.instance;
  String getCurrentUser() {
    final User? user = auth.currentUser;
    uid = user!.uid;
    return uid;
    // here you write the codes to input the data into firestore
  }
}

import 'package:firebase_auth/firebase_auth.dart';

class EcommerceApp {
  static bool haveItems = false; // if cart is empty
  static String storeName = '';
  static String value = '';
  static String storeId = '';
  static int quantity = 0;
  static int total = 0;
  static String userName = 'Shoug'; //bug fixes
  static String productName = '';

  static String uid = '';
  final FirebaseAuth auth = FirebaseAuth.instance;
  String getCurrentUser() {
    final User? user = auth.currentUser;
    uid = user!.uid;
    return uid;
    // here you write the codes to input the data into firestore
  }
}

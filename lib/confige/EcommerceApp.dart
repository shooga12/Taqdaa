import 'package:firebase_auth/firebase_auth.dart';

class EcommerceApp {
  static bool haveItems = false; // if cart is empty
  static String storeName = '';
  static String value = '';
  static String storeId = '';
  static int quantity = 0;
  static int total = 0;
  static int finalTotal = -1;
  static String userName = ''; //bug fixes
  static String productName = '';
  static int counter = 0;
  static double inDollars = 0;
  static bool itsFirst = true;

  static String uid = '';
  final FirebaseAuth auth = FirebaseAuth.instance;
  String getCurrentUser() {
    final User? user = auth.currentUser;
    uid = user!.uid;
    return uid;
    // here you write the codes to input the data into firestore
  }
}

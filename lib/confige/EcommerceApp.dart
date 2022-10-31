import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';

class EcommerceApp {
  static bool haveItems = false; // if cart is empty
  static String storeName = '';
  static String value = '';
  static String storeId = '';
  static int quantity = 0;
  static int total = 0;
  static int finalTotal = -1;
  static String userName = '';
  static String productName = '';
  static int counter = 0;
  static double inDollars = 0;
  static bool itsFirst = true;
  static bool rewardsExchanged = false;
  static int rewards = 0;
  static int rewardsInput = 0;
  static double discount = 0;
  static int NumOfItems = 0;
  static int totalSummary = 0;
  static UserModel loggedInUser = UserModel();
  static int pageIndex = 0;
  static String uid = '';
  final FirebaseAuth auth = FirebaseAuth.instance;
  static num? returnDays = 0;

  String getCurrentUser() {
    final User? user = auth.currentUser;
    uid = user!.uid;
    return uid;
    // here you write the codes to input the data into firestore
  }
}

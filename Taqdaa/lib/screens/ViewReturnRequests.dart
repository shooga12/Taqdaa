import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taqdaa/main.dart';
import 'package:taqdaa/screens/home_page.dart';
// import '../confige/EcommerceApp.dart';
import '../controller/BNBCustomePainter.dart';
// import '../models/user_model.dart'; ----------------------------------
// import 'package:taqdaa_application/screens/login_page.dart';
// import '../screens/ShoppingCart.dart';
// import '../screens/list_of_stores.dart';
// import 'NoItmesCart.dart';

class ViewReturnReq extends StatefulWidget {
  const ViewReturnReq({super.key});

  @override
  State<ViewReturnReq> createState() => _ViewReturnReqState();
}

class _ViewReturnReqState extends State<ViewReturnReq> {
  User? user = FirebaseAuth.instance.currentUser;
  // UserModel loggedInUser = UserModel(); ------------------------------------------
  bool isInsideHome = false;
  bool isInsideProfile = true;
  bool isInsideSettings = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
        .collection("users") //------------------------------------------------------
        .doc(user!.uid)
        .get()
        .then((value) {
      // this.loggedInUser = UserModel.fromMap(value.data()); ------------------------
      setState(() {});
    });
  }


  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "My Return Requests",
          style: TextStyle(fontSize: 24),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onPressed: () {
              // do something
            },
          )
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/Vector.png"), fit: BoxFit.fill)),
        ),
        centerTitle: true,
        toolbarHeight: 170,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),













      
    );
  }
}
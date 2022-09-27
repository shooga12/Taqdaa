import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taqdaa_application/confige/EcommerceApp.dart';
import 'package:taqdaa_application/model/user_model.dart';
import 'package:taqdaa_application/screens/NoItmesCart.dart';
import 'package:taqdaa_application/screens/login_page.dart';
import '../screens/register_page.dart';

class Homepprofile extends StatefulWidget {
  const Homepprofile({Key? key}) : super(key: key);

  @override
  _HomepprofileState createState() => _HomepprofileState();
}

class _HomepprofileState extends State<Homepprofile> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  // get dateofbirthController => null; //("${loggedInUser.dateofbirth}");

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Profile",
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
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ListTile(
                title: Text(
                  'Name',
                  style: TextStyle(fontSize: 22),
                ),
                subtitle: Text(
                  "${loggedInUser.firstName} ${loggedInUser.secondName}",
                  style: TextStyle(fontSize: 22),
                ),
              ),
              ListTile(
                title: Text(
                  'Email',
                  style: TextStyle(fontSize: 22),
                ),
                subtitle: Text(
                  "${loggedInUser.email}",
                  style: TextStyle(fontSize: 22),
                ),
              ),
              ListTile(
                title: Text(
                  'Phone Number',
                  style: TextStyle(fontSize: 22),
                ),
                subtitle: Text(
                  "${loggedInUser.phonenumber}",
                  style: TextStyle(fontSize: 22),
                ),
              ),
              ListTile(
                title: Text(
                  'Date of Birth',
                  style: TextStyle(fontSize: 22),
                ),
                subtitle: Text(
                  "${loggedInUser.dateofbirth}",
                  style: TextStyle(fontSize: 22),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 40.0),
                child: ElevatedButton(
                  onPressed: () async {
                    logout(context);
                  },
                  child: Text(
                    'Logout',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.grey;
                        }
                        return Colors.orange;
                      }),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> logout(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: ((context) => LoginPage())));
}

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
        title: Text("My Profile"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/Vector.png"), fit: BoxFit.fill)),
        ),
        centerTitle: true,
        toolbarHeight: 170,
        //leading: BackButton(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              /*
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide:
                          const BorderSide(color: Colors.orange, width: 2.0)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 15, 53, 120), width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide:
                        const BorderSide(color: Colors.orange, width: 2.0),
                  ),
                  prefixIcon: Icon(Icons.person),
                  iconColor: Colors.white,
                  labelText:
                      "${loggedInUser.firstName} ${loggedInUser.secondName}",
                  labelStyle: TextStyle(
                      color:
                          Color.fromARGB(236, 113, 113, 117).withOpacity(0.9)),
                  filled: true,

                  fillColor: Colors.white.withOpacity(0.9),
                  // border: OutlineInputBorder(
                  //  borderRadius: BorderRadius.circular(30.0),),
                ),

                //--------------------------------------
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                cursorColor: Color.fromARGB(255, 37, 43, 121),
                style: TextStyle(
                    color: Color.fromARGB(255, 15, 53, 120).withOpacity(0.9)),

                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide:
                          const BorderSide(color: Colors.orange, width: 2.0)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 15, 53, 120), width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide:
                        const BorderSide(color: Colors.orange, width: 2.0),
                  ),
                  prefixIcon: Icon(Icons.person),
                  iconColor: Colors.white,
                  labelText: "${loggedInUser.email}",
                  labelStyle: TextStyle(
                      color:
                          Color.fromARGB(236, 113, 113, 117).withOpacity(0.9)),
                  filled: true,

                  fillColor: Colors.white.withOpacity(0.9),
                  // border: OutlineInputBorder(
                  //  borderRadius: BorderRadius.circular(30.0),),
                ),

                keyboardType: TextInputType.name,
                //--------------------------------------
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                cursorColor: Color.fromARGB(255, 37, 43, 121),
                style: TextStyle(
                    color: Color.fromARGB(255, 15, 53, 120).withOpacity(0.9)),

                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide:
                          const BorderSide(color: Colors.orange, width: 2.0)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 15, 53, 120), width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide:
                        const BorderSide(color: Colors.orange, width: 2.0),
                  ),
                  prefixIcon: Icon(Icons.person),
                  iconColor: Colors.white,
                  labelText: "${loggedInUser.phonenumber}",
                  labelStyle: TextStyle(
                      color:
                          Color.fromARGB(236, 113, 113, 117).withOpacity(0.9)),
                  filled: true,

                  fillColor: Colors.white.withOpacity(0.9),
                  // border: OutlineInputBorder(
                  //  borderRadius: BorderRadius.circular(30.0),),
                ),

                keyboardType: TextInputType.name,
                //--------------------------------------
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                child: TextFormField(
                  cursorColor: Color.fromARGB(255, 37, 43, 121),
                  style: TextStyle(
                      color: Color.fromARGB(255, 15, 53, 120).withOpacity(0.9)),

                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.calendar_today),
                    iconColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide:
                            const BorderSide(color: Colors.orange, width: 2.0)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 15, 53, 120), width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide:
                          const BorderSide(color: Colors.orange, width: 2.0),
                    ),

                    labelText:
                        "${loggedInUser.dateofbirth}", //label text of field
                  ),
                  readOnly:
                      true, //set it true, so that user will not able to edit text

                  //--------------------------------------
                ),
              ),

              */
              ListTile(
                title: Text('Name'),
                subtitle: Text(
                    " ${loggedInUser.firstName} ${loggedInUser.secondName}"),
              ),
              ListTile(
                title: Text('Email'),
                subtitle: Text(" ${loggedInUser.email}"),
              ),
              ListTile(
                title: Text('Phone Number'),
                subtitle: Text(" ${loggedInUser.phonenumber}"),
              ),
              ListTile(
                title: Text('Date of Birth'),
                subtitle: Text(" ${loggedInUser.dateofbirth}"),
              ),

/*
              Text(
                  "Name:  ${loggedInUser.firstName} ${loggedInUser.secondName}",
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  )),
              SizedBox(
                height: 20,
                width: 200,
                child: Divider(),
              ),
              Text("Email:  ${loggedInUser.email}",
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  )),
              SizedBox(
                height: 20,
                width: 200,
                child: Divider(),
              ),
              Text("Phone Number:  ${loggedInUser.phonenumber}",
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  )),
              SizedBox(
                height: 20,
                width: 200,
                child: Divider(),
              ),
              Text("Date of Birth:  ${loggedInUser.dateofbirth}",
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  )),
              SizedBox(
                height: 20,
                width: 200,
                child: Divider(),
              ),
              SizedBox(
                height: 20,
              ),
              */

              ActionChip(
                  label: Text("Logout"),
                  onPressed: (() {
                    logout(context);

                    style:
                    const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16);
                    style:
                    ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.grey;
                          }
                          return Colors.orange;
                        }),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30))));
                  })),
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

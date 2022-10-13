import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taqdaa_application/main.dart';
import 'package:taqdaa_application/screens/home_page.dart';
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

  List dataItem = [
    {
      "date": "10/10/2022",
      "product": "Face Mask",
      "brand": "SEPHORA",
      "logo": "sephora.png",
      //----comments? or reason?
      "pic": "returnPic.png",
    },
    {
      "date": "10/10/2022",
      "product": "Tote bag",
      "brand": "ZARA",
      "logo": "zara.png",
       //----comments? or reason?
      "pic": "returnPic1.png",
    }
  ];




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
body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Recent Return Requests',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'View all',
                        style: TextStyle(
                          color: Colors.indigo,
                        ),
                      ),
                    ],
                  ),

                  //------------------------------------------------------------
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: dataItem.length, //--- how many return requests?
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (context) => RequestDetailsScreen( //--------------------------------?  do i need it?
                          //       data: dataItem[index],
                          //     ),
                          //   ),
                          // );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Card(
                            // color: Colors.indigo.shade100.withOpacity(0.1),
                            elevation: 2,
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                dataItem[index]['date'],
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                dataItem[index]['product'],
                                              ),
                                            ],
                                          ),
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: Image.asset(
                                              dataItem[index]['logo'], //----- brand logo
                                              width: 50,
                                              height: 50,
                                            ),
                                            
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('PENDING'),
                                              Text('APPROVED'),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const CircleAvatar(
                                                backgroundColor: Colors.indigo,
                                                radius: 8,
                                              ),
                                              Flexible(
                                                flex: 1,
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                    left: 8,
                                                    right: 8,
                                                  ),
                                                  color: Colors.indigo,
                                                  height: 2,
                                                ),
                                              ),
                                              const CircleAvatar(
                                                backgroundColor: Color.fromARGB(
                                                    255, 197, 202, 233),
                                                radius: 14,
                                                child: Icon(
                                                  Icons.timelapse, //---------------------------------------
                                                  size: 16,
                                                ),
                                              ),
                                              Flexible(
                                                flex: 1,
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                    left: 8,
                                                    right: 8,
                                                  ),
                                                  color: const Color.fromARGB(
                                                      255, 197, 202, 233),
                                                  height: 2,
                                                ),
                                              ),
                                              const CircleAvatar(
                                                backgroundColor: Color.fromARGB(
                                                    255, 197, 202, 233),
                                                radius: 8,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      













      
    );
  }
}
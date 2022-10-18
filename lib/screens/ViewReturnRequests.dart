//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taqdaa_application/main.dart';
import 'package:taqdaa_application/model/invoice.dart';
import 'package:taqdaa_application/screens/ReturnRequest.dart';
import 'package:taqdaa_application/screens/home_page.dart';
// import '../confige/EcommerceApp.dart';
import '../controller/BNBCustomePainter.dart';
// import '../models/user_model.dart'; ----------------------------------
// import 'package:taqdaa_application/screens/login_page.dart';
// import '../screens/ShoppingCart.dart';
// import '../screens/list_of_stores.dart';
// import 'NoItmesCart.dart';
import 'package:taqdaa_application/model/invoice.dart';
import 'package:taqdaa_application/model/item.dart';
import 'package:taqdaa_application/model/returnModel.dart';
//import 'NoReturnReq.dart';

import 'returnReqDetails.dart';

class ViewReturnReq extends StatefulWidget {
  const ViewReturnReq({super.key});

  @override
  State<ViewReturnReq> createState() => _ViewReturnReqState();
}

class _ViewReturnReqState extends State<ViewReturnReq> {
  User? user = FirebaseAuth.instance.currentUser;
  final CollectionReference UserInvoices =
      FirebaseFirestore.instance.collection('ReturnRequests');

  List<returnInvoice> ReturnInvoices = [];
  bool noReturnReq = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    readInvoices();
  }

  Future readInvoices() async {
    var data = await FirebaseFirestore.instance.collection(
        //'ReturnRequestsSURodyNHPgXABPsE2GXlq2Lmnyh2') /////bug fixes-----------------------
        'ReturnRequests${user!.uid}').get();

    setState(() {
      ReturnInvoices =
          List.from(data.docs.map((doc) => returnInvoice.fromMap(doc)));

      if (ReturnInvoices.length == 0) {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => NoReturnReq()),
        // );
        noReturnReq = true;
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "طلباتي",
          style: TextStyle(fontSize: 24),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/Vector.png"), fit: BoxFit.fill)),
        ),
        toolbarHeight: 170,
        //leading: BackButton(),
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
                        'طلبات الإرجاع',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  if (noReturnReq == true)
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(top: 97),
                            child: Text(
                              ' لا يوجد لديك طلبات إرجاع حتى الآن.',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  //------------------------------------------------------------
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount:
                        ReturnInvoices.length, //--- how many return requests?
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (context) => RequestDetailsScreen( //--------------------------------
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
                                                //'رقم الفاتورة: ' +
                                                // dataItem[index]
                                                //     ['requestNumber'],
                                                " رقم الفاتورة: ${ReturnInvoices[index].id}",
                                                //userReturnReqList[index]
                                                //['ID'],
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                  'من متجر : ${ReturnInvoices[index].store}'
                                                  // dataItem[index]['brand'],
                                                  // userReturnReqList[index]
                                                  //     ['Store'],
                                                  ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                  'تاريخ تقديم الطلب:  ${ReturnInvoices[index].date}'
                                                  // dataItem[index]['date'],
                                                  // userReturnReqList[index]
                                                  //     ['Date'],
                                                  ),
                                            ],
                                          ),
                                          // ClipRRect(
                                          //   borderRadius:
                                          //       BorderRadius.circular(15),
                                          //   child: Image.asset(
                                          //     dataItem[index]
                                          //         ['logo'], //----- brand logo
                                          //     width: 50,
                                          //     height: 50,
                                          //   ),
                                          // ),
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
                                              Text('تحت الدراسة'),
                                              Text('جاهزة للاستلام'),
                                              Text('تم استلام السلع'),
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
                                                backgroundColor: Color.fromARGB(
                                                    255, 197, 202, 233),
                                                radius: 14,
                                                child: Icon(
                                                  Icons
                                                      .timelapse, //---------------------------------------
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
                                              // const CircleAvatar(
                                              //   backgroundColor: Colors.indigo,
                                              //   radius: 8,
                                              // ),
                                              // Flexible(
                                              //   flex: 1,
                                              //   child: Container(
                                              //     margin: const EdgeInsets.only(
                                              //       left: 8,
                                              //       right: 8,
                                              //     ),
                                              //     color: Colors.indigo,
                                              //     height: 2,
                                              //   ),
                                              // ),
                                              const CircleAvatar(
                                                backgroundColor: Color.fromARGB(
                                                    255, 197, 202, 233),
                                                radius: 8,
                                              ),
                                              // const CircleAvatar(
                                              //   backgroundColor: Color.fromARGB(
                                              //       255, 197, 202, 233),
                                              //   radius: 14,
                                              //   child: Icon(
                                              //     Icons.store_mall_directory, //---------------------------------------
                                              //     size: 16,
                                              //   ),
                                              // ),
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
                                      // Divider(
                                      //   height: 20,
                                      //   thickness: 1,
                                      //   color: Colors.grey,
                                      // ),

                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 6,
                                            bottom: 0,
                                            left: 0,
                                            right: 0),
                                        child: Card(
                                          child: new InkWell(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 6,
                                                    bottom: 6,
                                                    left: 10,
                                                    right: 10),
                                                child: Row(children: <Widget>[
                                                  Column(children: <Widget>[
                                                    Text(
                                                      "تفاصيل الطلبية",
                                                      style: new TextStyle(
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ]),
                                                  Spacer(),
                                                  Icon(Icons.arrow_forward,
                                                      color: Color.fromARGB(
                                                          223, 134, 186, 243)),
                                                ]),
                                              ),
                                              onTap: () {
                                                // Navigator.push(
                                                //   context,
                                                //   MaterialPageRoute(
                                                //       builder: (context) => Homepprofile()),
                                                // );
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        invoice_details(
                                                            ReturnInvoices[
                                                                index]),
                                                  ),
                                                );
                                              }),
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
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

                //if (ReturnInvoices.length == 0)
              ),
            ),
          ],
        ),
      ),
    );
  }
}

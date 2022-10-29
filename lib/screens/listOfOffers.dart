import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../model/Offers.dart';

class ListOfOffers extends StatefulWidget {
  const ListOfOffers({super.key});

  @override
  State<ListOfOffers> createState() => _ListOfOffersState();
}

class _ListOfOffersState extends State<ListOfOffers> {
  bool flag = false;
  String SearchName = '';
  int count = -1;
  bool enable = true;

  Stream<List<Offer>> readOffers() => FirebaseFirestore.instance
      .collection('ActiveOffers')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Offer.fromJson(doc.data())).toList());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          "جميع العروض",
          style: TextStyle(fontSize: 24),
        ),
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              height: 600,
              child: Column(
                children: [
                  SizedBox(
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 10),
                      child: TextField(
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              // borderSide: const BorderSide(
                              //     color: Colors.orange, width: 2.0)
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              // borderSide: const BorderSide(
                              //     color: Colors.orange, width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              // borderSide: const BorderSide(
                              //     color: Colors.orange, width: 2.0),
                            ),
                            prefixIcon: Icon(Icons.search),
                            hintText: 'إبحث عن إسم عرض محدد'),
                        onChanged: (val) {
                          setState(() {
                            SearchName = val;
                            //.replaceAll(' ', '');
                          });
                        },
                      ),
                    ),
                  ),
                  Container(
                    height: 500,
                    width: 360,
                    child: StreamBuilder<List<Offer>>(
                        stream: readOffers(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data!.isEmpty) {
                            //enable = false;
                            ////////empty
                            return Nodata();
                          }
                          if (snapshot.hasData) {
                            final offer = snapshot.data!;
                            count = offer.length;
                            return ListView.builder(
                                //controller: controller,
                                itemCount: offer.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var Current = offer[index];
                                  if (SearchName.isEmpty) {
                                    flag = false;
                                    return buildOfferCards(Current, index);
                                  } else if (SearchName.isNotEmpty &&
                                      Current.offerText
                                          .toString()
                                          .toLowerCase()
                                          .contains(SearchName.toLowerCase())) {
                                    flag = true;
                                    return buildOfferCards(Current, index);
                                  } else if (flag == false &&
                                      index == count - 1) {
                                    return Container(
                                        child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'لا يوجد نتائج',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ));
                                  }
                                  return nothing();
                                });
                          } else if (snapshot.hasError) {
                            return Text(
                                "Something went wrong! ${snapshot.error}");
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        }),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  nothing() {
    return Container();
  }

  Nodata() {
    return Container(
        child: Align(
      alignment: Alignment.center,
      child: Text(
        'لا يوجد عروض حاليًا',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    ));
  }

  buildOfferCards(Offer Offer, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
      child: Container(
        child: new InkWell(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 12),
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Image.network(
                  Offer.OfferImg
                  //data['OfferImg'],
                  ,
                  width: 255,
                  height: 120,
                ),
                Text(
                    Offer.offerText
                    //data['offerText'],
                    ,
                    style: TextStyle(
                      fontSize: 20,
                    ))
                // Row(
                //   children: <Widget>[
                //     Text(
                //       data['offerText'],
                //       style: new TextStyle(
                //         fontSize: 16,
                //         color: Color.fromARGB(255, 77, 76, 76),
                //       ),
                //     ),
                //   ],
                // ),
                // .SizedBox(
                //   width: 7,
                // )
              ],
            ),
          ),
          // onTap: () async {
          //   EcommerceApp.storeId = store.StoreId;
          //   if (EcommerceApp.storeName == "") {
          //     EcommerceApp.storeName = store.StoreName;
          //     // Navigator.push(
          //     //   context,
          //     //   MaterialPageRoute(builder: (context) => scanner()),
          //     // );
          //     scan(context);
          //   } else if (EcommerceApp.haveItems &&
          //       EcommerceApp.storeName != store.StoreName) {
          //     showDialog(
          //         context: context,
          //         builder: (context) {
          //           return AlertDialog(
          //               content: Text(
          //                   ".${EcommerceApp.storeName}عذرًا، لديك طلب بالفعل في"),
          //               actions: [
          //                 ElevatedButton(
          //                     onPressed: () async {
          //                       EcommerceApp.storeName = "";
          //                       await ListOfStores2State.deleteCart();
          //                       await ListOfStores2State.deleteCartDublicate();
          //                       await ListOfStores2State.saveUserTotal(0);
          //                       Navigator.pop(context, 'حسنًا');
          //                     },
          //                     child:
          //                         Text(" ${EcommerceApp.storeName} إلغاء طلب")),
          //                 TextButton(
          //                   onPressed: () => Navigator.pop(context, 'حسنًا'),
          //                   child: const Text('حسنًا'),
          //                 ),
          //               ]);
          //         });
          //   } else {
          //     EcommerceApp.storeName = store.StoreName;
          //     // Navigator.push(
          //     //   context,
          //     //   MaterialPageRoute(builder: (context) => scanner()),
          //     // );
          //     scan(context);
          //   }
          // },
          highlightColor: Color.fromARGB(255, 255, 255, 255),
        ),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 241, 241, 241),
              offset: Offset.zero,
              blurRadius: 20.0,
              blurStyle: BlurStyle.normal,
            ),
          ],
        ),
      ),
    );
  }
}

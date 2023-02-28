import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../models/Offers.dart';

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
      body: Stack(
        children: [
          Container(
            height: 350,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                        'assets/AppBar3.png'),
                    fit: BoxFit.cover

                ),
                borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(50)
                )
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, top:90.0),
            child: SingleChildScrollView(
              child: Container(
                height: 1000,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,

                      alignment: Alignment.center,
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: ()=>Navigator.pop(context),
                            icon: Icon(
                              Icons.chevron_left_rounded,
                              color: Colors.white,
                              size: 45,

                            ),
                          ),
                          SizedBox(width: 5,),
                          Padding(
                            padding: const EdgeInsets.only(top:20),
                            child: Text(
                              'العروض',
                              style: TextStyle(
                                  fontFamily: 'Tajawal',
                                  color: Colors.white,
                                  fontSize: 30
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 30,),
                    SizedBox(
                      height: 60,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 30),
                        child: TextField(
                          textAlignVertical: TextAlignVertical.bottom,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: const BorderSide(
                                    color: Color(0x76909090), width: 1.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: const BorderSide(
                                    color: Colors.orange, width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: const BorderSide(
                                    color: Color(0x76909090), width: 1.0),
                              ),
                              prefixIcon: Icon(Icons.search),
                              hintText: 'ابحث عن اسم عرض محدد'),
                          onChanged: (val) {
                            setState(() {
                              SearchName = val;
                            });
                          },
                          style: TextStyle(
                              fontFamily: 'Tajawal'
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      height: 800,
                      width: 360,
                      child: StreamBuilder<List<Offer>>(
                          stream: readOffers(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData && snapshot.data!.isEmpty) {
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
                                              fontFamily: 'Tajawal'
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
            fontFamily: 'Tajawal'
        ),
      ),
    ));
  }

  buildOfferCards(Offer Offer, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
      child: Column(
        children: [
          Container(
            child: new InkWell(
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 15, bottom: 15, left: 20, right: 20),
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.network(
                      Offer.OfferImg
                      //data['OfferImg'],
                      ,
                      height: 160,
                    ),
                    SizedBox(height: 10,),
                    Text(
                        Offer.offerText
                        //data['offerText'],
                        ,
                        style: TextStyle(
                          fontSize: 20,
                            fontFamily: 'Tajawal'
                        ))
                  ],
                ),
              ),
              highlightColor: Color.fromARGB(255, 255, 255, 255),
            ),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(81, 208, 208, 208),
                  offset: Offset.zero,
                  blurRadius: 20.0,
                  blurStyle: BlurStyle.normal,
                ),
              ],
            ),
          ),
          SizedBox(height: 10,),
        ],
      ),
    );
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import '../model/Offers.dart';

// abstract class ReadOffers {
//   List<Offer> OffersList = [];

//   Stream<List<Offer>> readOffers() => FirebaseFirestore.instance
//       .collection('ActiveOffers')
//       .snapshots()
//       .map((snapshot) =>
//           snapshot.docs.map((doc) => Offer.fromJson(doc.data())).toList());

//   AddToList(Offer offer) {
//     OffersList.add(offer);
//     return SizedBox(width: 0, height: 0);
//   }

//   read() {
//     return StreamBuilder<List<Offer>>(
//         stream: readOffers(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             final offer = snapshot.data!;
//             return ListView.builder(
//                 itemCount: offer.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return AddToList(offer[index]);
//                 });
//           } else if (snapshot.hasError) {
//             return Text("Some thing went wrong! ${snapshot.error}");
//           } else {
//             return Center(child: CircularProgressIndicator());
//           }
//         });
//   }

//   HomePage(OffersList);
// }

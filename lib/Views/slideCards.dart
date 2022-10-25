// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import '../model/Offers.dart';

// class SlideCards extends StatefulWidget {
//   List<String> imgList;

//   SlideCards({this.Offer});

//   @override
//   _SlideCardsState createState() => _SlideCardsState();
// }

// class _SlideCardsState extends State<SlideCards> {
//   int _current = 0;

//   @override
//   Widget build(BuildContext context) {
//     final List<Widget> imageSliders = widget.imgList
//         .map((item) => Container(
//               child: ClipRRect(
//                 borderRadius: BorderRadius.all(
//                   Radius.circular(5.0),
//                 ),
//                 child: Stack(
//                   children: [
//                     Image.network(
//                       item,
//                       fit: BoxFit.cover,
//                       width: 1000,
//                     ),
//                     Positioned(
//                       bottom: 0.0,
//                       left: 0.0,
//                       right: 0.0,
//                       child: Container(
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [
//                               Color.fromARGB(200, 0, 0, 0),
//                               Color.fromARGB(0, 0, 0, 0),
//                             ],
//                             begin: Alignment.bottomCenter,
//                             end: Alignment.topCenter,
//                           ),
//                         ),
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 20,
//                           vertical: 10,
//                         ),
//                         child: Text(
//                           'No. ${widget.imgList.indexOf(item)} image',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 20.0,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ))
//         .toList();

//     return Column(
//       children: [
//         Padding(
//           padding: EdgeInsets.all(20),
//           child: Text(
//             "Carousel With Image, Text & Dots",
//             style: TextStyle(
//               color: Colors.green[700],
//               fontWeight: FontWeight.bold,
//               fontSize: 18,
//             ),
//           ),
//         ),
//         CarouselSlider(
//           items: imageSliders,
//           options: CarouselOptions(
//               autoPlay: true,
//               enlargeCenterPage: true,
//               aspectRatio: 2.0,
//               onPageChanged: (index, reason) {
//                 setState(() {
//                   _current = index;
//                 });
//               }),
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: widget.imgList.map((url) {
//             int index = widget.imgList.indexOf(url);
//             return Container(
//               width: 8,
//               height: 8,
//               margin: EdgeInsets.symmetric(
//                 vertical: 10,
//                 horizontal: 3,
//               ),
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: _current == index
//                     ? Color.fromRGBO(0, 0, 0, 0.9)
//                     : Color.fromRGBO(0, 0, 0, 0.4),
//               ),
//             );
//           }).toList(),
//         )
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../reusable_widget/reusable_widget.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  @override
  // void initState() {
  //   fetchRecords();
  //   super.initState();
  // }

  // fetchRecords() async {
  //   var records = await FirebaseFirestore.instance.collection("About us").get();
  //   // mapRecords();
  // }

  //mapRecords(QuerySnapshot<Map<String, dynamic>> records) {}

  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leadingWidth: 100,
        title: Text(
          "عن تقضّى",
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w100,
              fontFamily: 'Tajawal'
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/AppBar.png"), fit: BoxFit.fill)),
        ),
        centerTitle: true,
        toolbarHeight: 60,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              5,
              MediaQuery.of(context).size.height * 0.02,
              5,
              MediaQuery.of(context).size.height * 0.02),
          child: Column(children: <Widget>[
            SignupcloudDcrWidget("assets/logoWhite.png"),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12),
              child: Container(
                alignment: Alignment.bottomCenter,
                height: 280,
                width: 450,
                child: Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                  child: Text(
                    "تقضى هي منصة الكترونية متقدمة تربط بين المحلات التجارية والمستخدم، من خلال أنظمة الإدارة التفاعلية يتيح تقضى للمستخدم سهولة اختيار المحل المتواجد به,\n حيث يتم مسح الباركود الموجود في المنتجات ليتم جمعها في العربة والدفع مباشرة ليتم بعد ذلك إمكانية تصفح الفاتورة, وأيضا نوفر خدمات ما بعد البيع في حال كانت هناك مشكلة في أي من المنتجات التي تم شرائها نقدم خدمة الاسترجاع ",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.w100,
                        letterSpacing: 0.4,
                        fontFamily: 'Tajawal'
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  // Future AboutUsPage() async {
  //   await FirebaseFirestore.instance
  //       .collection('About us')
  //       .doc("about us")
  //       .update({'taqdda': 'About us'});
  // }
}

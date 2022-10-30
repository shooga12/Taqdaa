import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../reusable_widget/reusable_widget.dart';
import 'insideMore.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  @override
  void initState() {
    fetchRecords();
    super.initState();
  }

  fetchRecords() async {
    var records = await FirebaseFirestore.instance.collection("About us").get();
    // mapRecords();
  }

  mapRecords(QuerySnapshot<Map<String, dynamic>> records) {}

  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          "عن تقضّى",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w100),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              5,
              MediaQuery.of(context).size.height * 0.02,
              5,
              MediaQuery.of(context).size.height * 0.02),
          child: Column(children: <Widget>[
            SignupcloudDcrWidget("assets/Logo.jpg"),
            const SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.bottomCenter,
              height: 280,
              width: 450,
              child: Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "تقضى هي منصة الكترونية متقدمة تربط بين المحلات (المحلات التجارية) والمستخدم، من خلال أنظمة الإدارة التفاعلية يتيح تقضى للمستخدم سهولة اختيار المحل المتواجد به,\n حيث يتم مسح الباركود الموجود في المنتجات ليتم جمعها في العربة والدفع مباشرة ليتم بعد ذلك إمكانية تصفح الفاتورة, وأيضا نوفر خدمات ما بعد البيع في حال كانت هناك مشكلة في أي من المنتجات التي تم شرائها نقدم خدمة الاسترجاع .",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 19.5,
                            fontWeight: FontWeight.w100,
                            letterSpacing: 0.4),
                      ),
                    ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Future AboutUsPage() async {
    await FirebaseFirestore.instance
        .collection('About us')
        .doc("about us")
        .update({'taqdda': 'About us'});
  }
}

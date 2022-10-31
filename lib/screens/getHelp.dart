import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:mailto/mailto.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:url_launcher/url_launcher.dart';

class helpPage extends StatefulWidget {
  const helpPage({super.key});

  @override
  State<helpPage> createState() => _helpPageState();
}

class _helpPageState extends State<helpPage> {
  bool isInsideHome = false;
  bool isInsideReceipt = false;
  bool isInsideMore = true;
  bool isInsideCart = false;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          "أحصل على مساعدة",
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
      body: Center(
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildCards("تواصل معنا عبر الهاتف", context),
                buildCards("تواصل معنا عبر الايميل", context),
              ],
            )),
      ),
    );
  }

  buildCards(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
      child: Container(
        child: new InkWell(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (title == "تواصل معنا عبر الهاتف")
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.phone_enabled,
                      size: 40,
                      color: Color.fromARGB(255, 254, 177, 57),
                    ),
                  ),
                if (title == "تواصل معنا عبر الايميل")
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.mail_outline,
                      size: 40,
                      color: Color.fromARGB(255, 254, 177, 57),
                    ),
                  ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  title,
                  style: new TextStyle(
                    fontSize: 18,
                  ),
                ),
                Spacer(),
                Icon(
                  Icons.arrow_back_ios_rounded,
                  textDirection: TextDirection.ltr,
                  color: Color.fromARGB(255, 254, 177, 57),
                ),
              ],
            ),
          ),
          onTap: () async {
            if (title == "تواصل معنا عبر الهاتف") {
              await FlutterPhoneDirectCaller.callNumber('+966509483390');
            } else if (title == "تواصل معنا عبر الايميل") {
              String email = Uri.encodeComponent("taqdda@gmail.com");
              String subject = Uri.encodeComponent("");
              String body = Uri.encodeComponent(
                  "Hi! we're Taqdda team, how we can help you");
              print(subject); //output: Hello%20Flutter
              Uri mail = Uri.parse("mailto:$email?subject=$subject&body=$body");
              if (await launchUrl(mail)) {
                //email app opened
              } else {
                //email app is not opened
              }
            }
          },
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

import 'dart:convert';
import 'dart:html';
import 'dart:ui';

import 'package:url_launcher/url_launcher.dart';
import 'package:mailto/mailto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:form_field_validator/form_field_validator.dart';
import '../main.dart';
import 'package:http/http.dart' as http;

class Send_email extends StatefulWidget {
  const Send_email({super.key});

  @override
  State<Send_email> createState() => _Send_emailState();
}

class _Send_emailState extends State<Send_email> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
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
          backgroundColor: Color.fromARGB(0, 255, 255, 255),
          elevation: 0,
        ),
        body: Container(
            height: 280,
            width: 400,
            padding: EdgeInsets.only(top: 20, left: 20, right: 20),
            alignment: Alignment.bottomCenter,
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    String email = Uri.encodeComponent("taqdda@gmail.com");
                    String subject = Uri.encodeComponent("");
                    String body = Uri.encodeComponent(
                        "Hi! we're Taqdda team, how we can help you");
                    print(subject); //output: Hello%20Flutter
                    Uri mail =
                        Uri.parse("mailto:$email?subject=$subject&body=$body");
                    if (await launchUrl(mail)) {
                      //email app opened
                    } else {
                      //email app is not opened
                    }
                  },
                  child: Icon(Icons.email_outlined,
                      size: 30, color: Color.fromARGB(255, 254, 176, 60)),
                )
              ],
            )));
  }
}

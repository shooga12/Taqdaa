/*
import 'dart:convert';
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

class email extends StatefulWidget {
  const email({super.key});

  @override
  State<email> createState() => _emailState();
}

class _emailState extends State<email> {
  /*
  void _mailTo() async {
    String email = "taqdda@gmail.com";
    var url = 'mailto:$email';
    if (await canLaunched(url)) {
      await launch(url);
    } else {
      throw 'Error occured';
    }
  }
*/
/*
  launchMailto() async {
    final mailtoLink = Mailto(
      to: ['taqdda@gmail.com'],
    );

    await launch('$mailtoLink');
  }
  */

  sendEmail() {
    final Email email = Email(
      subject: "Text",
      body: "type your problem",
      recipients: ['taqdda@gmail.com'],
      isHTML: false,
    );
    FlutterEmailSender.send(email);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            title: Text(
              "أحصل على مساعدة",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w100),
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/Vector.png"),
                      fit: BoxFit.fill)),
            ),
            centerTitle: true,
            toolbarHeight: 170,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Container(
            height: 280,
            width: 400,
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => sendEmail()),
                );
              },
              icon: Icon(Icons.email_outlined,
                  size: 30, color: Color.fromARGB(255, 254, 176, 60)),
            ),
          ),
        ),
      ),
    );
  }
/* 
  @override
  Widget build(BuildContext context) => IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => launchMailto()),
          );
        },
        icon: Icon(Icons.email_outlined,
            size: 30, color: Color.fromARGB(255, 254, 176, 60)),
      );
      */

  canLaunched(String mailtoLink) {}

  launch(String mailtoLink) {}
}
*/

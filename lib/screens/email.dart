import 'dart:convert';
import 'dart:ui';

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
  final controllername = TextEditingController();
  final controllerTo = TextEditingController();
  final controllerSubject = TextEditingController();
  final controllerMessage = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          padding: EdgeInsets.all(26),
          child: Column(
            children: [
              // buildTextField(title: 'الاسم', controller: controllername),
              // const SizedBox(height: 16),
              buildTextField(
                title: 'إلى',
                controller: controllerTo,
                validator: MultiValidator([
                  RequiredValidator(errorText: 'مطلوب*'),
                ]),
              ),
              const SizedBox(height: 16),
              buildTextField(
                title: 'الموضوع',
                controller: controllerSubject,
                validator: MultiValidator([
                  RequiredValidator(errorText: 'مطلوب*'),
                ]),
              ),
              const SizedBox(height: 16),
              buildTextField(
                title: 'الرسالة',
                controller: controllerMessage,
                maxLines: 8,
                validator: MultiValidator([
                  RequiredValidator(errorText: 'مطلوب*'),
                ]),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(50),
                  textStyle: TextStyle(fontSize: 20),
                ),
                child: Text('ارسال',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      //  color:Colors.orange,
                    )),
                onPressed: () => lanchEmail(
                  // name: controllername.text,
                  toEmail: controllerTo.text,
                  subject: controllerSubject.text,
                  message: controllerMessage.text,
                ),
              ),
            ],
          )),
    );
  }

  Future lanchEmail({
    // required String name,
    required String toEmail,
    required String subject,
    required String message,
  }) async {
    /*
    final serviceId = 'service_w7ph9st';
    final templateId = 'template_ux5kt9e';
    final userId = '';
*/
    final url = //Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
        'mailto:$toEmail?subject=${Uri.encodeFull(subject)}&body=${Uri.encodeFull(message)}';

    if (await canLaunched(url)) {
      await launch(url);
    }

/*
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'user_name': name,
          'user_email': 'taqdda@gmail.com',
          'user_subject': subject,
          'user_message': message,
        },
      }),
    );
    */
  }

  Widget buildTextField({
    required String title,
    required TextEditingController controller,
    int maxLines = 1,
    required MultiValidator validator,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide:
                      const BorderSide(color: Colors.orange, width: 2.0)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: const BorderSide(
                    color: Color.fromARGB(255, 15, 53, 120), width: 2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: const BorderSide(color: Colors.orange, width: 2.0),
              ),
            ),
          ),
        ],
      );

  canLaunched(String url) {}

  launch(String url) {}
}

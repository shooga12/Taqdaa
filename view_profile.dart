import 'package:cloud_firestore/cloud_firestore.dart';

import '../methods/authentication_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'home_page.dart';
//import 'package:loginlogout_resetpass/register_page.dart';
import '../reusable_widget/reusable_widget.dart';
//import 'reset_page.dart';
import 'package:form_field_validator/form_field_validator.dart';
//import 'login_page.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/date_symbols.dart';
import 'package:intl/date_symbol_data_custom.dart';
import 'package:intl/intl.dart';

class GetUserName extends StatelessWidget {

  final String documentId;

  GetUserName({required this.documentId})

  @override    // solve this error
  Widget build(BuildContext context) {

// get the collection
CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder: ((context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done){
      Map<String, dynamic> data =
        snapshot.data!.data() as Map<String, dynamic>;
        return Text('First Name: ${data['firstName']}');
      }
      return Text('loading..');

    }),
     );
  }
}
//changes
//how to retrieve users information ?
Future<DocumentSnapshot> _getDocument(String uid) async {
 return await Firestore().collection('Users').where('user_id', isEqualTo: uid).get();
}


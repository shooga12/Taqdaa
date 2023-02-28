import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taqdaa_application/models/invoice.dart';
import 'package:taqdaa_application/models/returnModel.dart';
import 'package:taqdaa_application/screens/list_of_stores.dart';
import '../methods/authentication_services.dart';
import '../screens/home_page.dart';
import 'package:flutter/foundation.dart';
import '../screens/login_page.dart';
import '../screens/register_page.dart';
import '../confige/EcommerceApp.dart';
import '../controller/Notification_api.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_localizations/flutter_localizations.dart';
import '../models/user_model.dart';
import 'models/store_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDrQ2UiNzImDzxToF5I5BaRREfkRWrUwN8",
            projectId: "taqdaa-10e41",
            storageBucket: "taqdaa-10e41.appspot.com",
            messagingSenderId: "782203884662",
            appId: "1:782203884662:android:92f455fd8e3958c27a7b57"));
  } else {
    await Firebase.initializeApp();
  }

  tz.initializeTimeZones();

  String closest = "";
  String storeName = "";
  int theIndex = 0;
  UserModel loggedInUser = UserModel();

  Future readClosest() async {
    String distance = "";
    final QuerySnapshot result =
        await FirebaseFirestore.instance.collection('Stores').get();
    final List<DocumentSnapshot> documents = result.docs;
    for (int i = 0; i < documents.length; i++) {
      distance = documents[0].get("kilometers");
      if (distance == "0.1") {
        ///bug fixes < 0.1
        closest = documents[i].id;
        theIndex = i;
      }
    }
    storeName = documents[theIndex].get("StoreName"); //bug fixes
  }

  await readClosest();

  var collection = FirebaseFirestore.instance.collection('Stores');
  QuerySnapshot result =
      await FirebaseFirestore.instance.collection('Stores').get();
  final List<DocumentSnapshot> documents = result.docs;
  for (int i = 0; i < documents.length; i++) {
    collection.doc("${documents[i].id}").snapshots().listen((docSnapshot) {
      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data()!;
        if (data["kilometers"] == "0.1") {
          NotificationApi.showScheduledNotification(
              title: 'Taqdaa is waiting for you!',
              body:
                  'Hey, ${loggedInUser.firstName}\nyou\'re very close from ${data['StoreName']} come and shop with us now!',
              payload: 'paylod.nav',
              scheduledDate: DateTime.now().add(Duration(seconds: 1)));
        }
      }
    });
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Localizations Sample App',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('ar', 'EN'), // English, no country code
      ],
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData) {
            return const MyHomePage();
          }

          return RegisterPage();
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  static Stream readOffers = FirebaseFirestore.instance
      .collection('ActiveOffers')
      .snapshots()
      .map(
          (list) => list.docs.map((doc) => doc.data()).toList()); //ActiveOffers

  @override
  void initState() {
    super.initState();
    readOffers;
    readStores();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      setState(() {
        EcommerceApp.loggedInUser = UserModel.fromMap(value.data());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<List<Store>>(
          stream: readStores(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final stores = snapshot.data!;
              if (stores.isNotEmpty) {
                NotificationApi.showScheduledNotification(
                    title: 'Taqdaa is waiting for you!',
                    body:
                        'Hey, ${EcommerceApp.loggedInUser.firstName} \nyour Return request got accepted come and drop it by!',
                    payload: 'paylod.nav',
                    scheduledDate: DateTime.now().add(Duration(seconds: 1)));
              }
              return StreamBuilder<List<returnInvoice>>(
                  stream: readRequest(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final requests = snapshot.data!;
                      if (requests.isNotEmpty) {
                        NotificationApi.showScheduledNotification(
                            title: 'Taqdaa is waiting for you!',
                            body:
                                'Hey, ${EcommerceApp.loggedInUser.firstName} \nyou\'re very close from Sephora come and shop with us now!',

                            ///bug fixes
                            payload: 'paylod.nav',
                            scheduledDate:
                                DateTime.now().add(Duration(seconds: 3)));
                      }
                      //checkRequestAccepted(); //bug fixessss
                      getRewards();
                      return HomePage();
                    } else if (snapshot.hasError) {
                      return Text("Some thing went wrong! ${snapshot.error}");
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  });
            } else if (snapshot.hasError) {
              return Text("Some thing went wrong! ${snapshot.error}");
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  Future getRewards() async {
    var collection = FirebaseFirestore.instance
        .collection('${EcommerceApp.loggedInUser.uid}Total');
    collection.doc('rewards').snapshots().listen((docSnapshot) {
      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data()!;

        if (mounted) {
          setState(() {
            EcommerceApp.rewards = data['Rewards'];
          });
        }
      }
    });
  }

  // Future checkRequestAccepted() async {
  //   final QuerySnapshot result = await FirebaseFirestore.instance
  //       .collection('ReturnRequests${EcommerceApp.loggedInUser.uid}')
  //       .where('status', isEqualTo: "Accepted")
  //       .get();
  //   final DocumentSnapshot document = result.docs.first;
  //   if (document.exists) {
  //     NotificationApi.showScheduledNotification(
  //         title: 'Taqdaa is waiting for you!',
  //         body:
  //             'Hey, ${EcommerceApp.loggedInUser.firstName} \nyour Return request got accepted come and drop it by!',
  //         payload: 'paylod.nav',
  //         scheduledDate: DateTime.now().add(Duration(seconds: 1)));
  //   }
  // }

  static Stream<List<Store>> readStores() => FirebaseFirestore.instance
      .collection('Stores')
      .where('kilometers', isEqualTo: 0.1)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Store.fromJson(doc.data())).toList());

  static Stream<List<returnInvoice>> readRequest() => FirebaseFirestore.instance
      .collection('ReturnRequests${EcommerceApp.loggedInUser.uid}')
      .where('status', isEqualTo: "ready")
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => returnInvoice.fromJson(doc.data()))
          .toList());
}

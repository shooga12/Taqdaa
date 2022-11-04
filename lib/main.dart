import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import '../screens/home_page.dart';
import 'package:flutter/foundation.dart';
import '../screens/register_page.dart';
import '../controller/NotificationApi.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'controller/EcommerceApp.dart';
import 'model/Offers.dart';
import 'model/StoreModel.dart';
import 'model/invoice.dart';
import 'model/returnModel.dart';
import 'model/user_model.dart';

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

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await NotificationApi.init();
  tz.initializeTimeZones();

  String closest = "";
  String storeName = "";
  int theIndex = -1;
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
    //storeName = documents[theIndex].get("StoreName"); //bug fixes
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

  static Position? currentPosition;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => currentPosition = position);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  static Stream<List<returnInvoice>> readRequest() => FirebaseFirestore.instance
      .collection('ReturnRequests${EcommerceApp.loggedInUser.uid}')
      .where('status', isEqualTo: "ready")
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => returnInvoice.fromJson(doc.data()))
          .toList());

  static Stream<List<Store>> readStores() => FirebaseFirestore.instance
      .collection('Stores')
      .where('kilometers', isEqualTo: 0.1)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Store.fromJson(doc.data())).toList());

  static Stream readOffers = FirebaseFirestore.instance
      .collection('ActiveOffers')
      .snapshots()
      .map(
          (list) => list.docs.map((doc) => doc.data()).toList()); //ActiveOffers

  @override
  void initState() {
    super.initState();
    _getCurrentPosition();
    readStores();
    readOffers;
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      EcommerceApp.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      //     Text(
      //       "مرحبًا، ${EcommerceApp.loggedInUser.firstName}",
      //       style: TextStyle(fontSize: 24, fontWeight: FontWeight.w100),
      //     ),
      //   ]),
      //   flexibleSpace: Container(
      //     decoration: BoxDecoration(
      //         image: DecorationImage(
      //             image: AssetImage("assets/Vector.png"), fit: BoxFit.fill)),
      //   ),
      //   toolbarHeight: 170,
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      // ),
      body: StreamBuilder<List<Store>>(
          stream: readStores(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final stores = snapshot.data!;
              if (stores.isNotEmpty) {
                NotificationApi.showScheduledNotification(
                    title: 'تقضّى بانتظارك!',
                    body: 'مرحبًا, ${EcommerceApp.loggedInUser.firstName} \n ',
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
                            title: 'تقضّى بانتظارك!',
                            body:
                                'مرحبًا, ${EcommerceApp.loggedInUser.firstName} \nطلب استرجاعك تم قبوله , وهو جاهز للاستلام',

                            ///bug fixes
                            payload: 'paylod.nav',
                            scheduledDate:
                                DateTime.now().add(Duration(seconds: 3)));
                      }

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

  nothing() {
    return SizedBox(width: 0, height: 0);
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
}

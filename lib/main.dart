import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taqdaa_application/screens/list_of_stores.dart';
import '../methods/authentication_services.dart';
import '../screens/home_page.dart';
import 'package:flutter/foundation.dart';
import '../screens/login_page.dart';
import '../screens/register_page.dart';
import '../confige/EcommerceApp.dart';
import '../controller/Notification_api.dart';
import 'package:timezone/data/latest.dart' as tz;

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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  // late final LocalNotificationsService service;

  // @override
  // void initState() {
  //   service = LocalNotificationsService();
  //   service.initialize();
  //   listenToNotification();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        //   Text(
        //     "Hey, Shoug",
        //     style: TextStyle(fontSize: 25),
        //   ),
        // ]),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/Vector.png"), fit: BoxFit.fill)),
        ),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuthMethods().signOut();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ));
            },
            icon: Icon(
              Icons.logout,
              size: 35,
              color: Color.fromARGB(255, 32, 7, 121),
            ),
          ),
        ],
        toolbarHeight: 170,
        //leading: BackButton(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: StreamBuilder<List<Store>>(
          stream: readStores(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final stores = snapshot.data!;
              if (stores.isNotEmpty) {
                // service.showNotification(
                //     id: 0,
                //     title: 'Taqdaa is waiting for you!',
                //     body: 'Hey, ' +
                //         EcommerceApp.userName +
                //         '\nyou\'re very close from ${stores.first.StoreName} come and shop with us now!',
                //     payload: 'payload nav');

                // NotificationApi.showNotification(
                //   title: 'Taqdaa is waiting for you!',
                //   body: 'Hey, ' +
                //       EcommerceApp.userName +
                //       '\nyou\'re very close from ${stores.first.StoreName} come and shop with us now!',
                //   payload: 'paylod nav',
                // );

                NotificationApi.showScheduledNotification(
                    title: 'Taqdaa is waiting for you!',
                    body: 'Hey, ' +
                        EcommerceApp.userName +
                        '\nyou\'re very close from ${stores.first.StoreName} come and shop with us now!',
                    payload: 'paylod.nav',
                    scheduledDate: DateTime.now().add(Duration(seconds: 3)));
              }
              return HomePage();
              //   }
              // );
            } else if (snapshot.hasError) {
              return Text("Some thing went wrong! ${snapshot.error}");
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),

      //HomePage(),

      //
      // bottomNavigationBar: BottomNavigationBar(
      //   onTap: (onTapTapped) {},
      //   currentIndex: _currentIndex,
      //   items: [
      //     BottomNavigationBarItem(
      //       label: Title(child: Text),
      //       icon: new Icon(Icons.home),
      //     ),
      //     BottomNavigationBarItem(
      //       icon: new Icon(Icons.explore),
      //     ),
      //     BottomNavigationBarItem(
      //       icon: new Icon(Icons.account_circle),
      //     )
      //   ],
      // ),
    );
  }

  Stream<List<Store>> readStores() => FirebaseFirestore.instance
      .collection('Stores')
      .where('kilometers', isEqualTo: 0.1)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Store.fromJson(doc.data())).toList());

  // void listenToNotification() =>
  //     service.onNotificationClick.stream.listen(onNotificationListener);

  // void onNotificationListener(NotificationResponse? payload) {
  //   if (payload != null) {
  //     print('payload $payload');
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => ListOfStores2()),
  //     );
  //   }
  // }
}

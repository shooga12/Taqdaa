import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';

class LocalNotificationsService {
  LocalNotificationsService();

  final _localNotificationservice = FlutterLocalNotificationsPlugin();

  final BehaviorSubject<NotificationResponse?> onNotificationClick =
      BehaviorSubject();

  Future<void> initialize() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@drawable/ic_stat_group_4');

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
      // notificationCategories: [
      //    DarwinNotificationCategory(
      //     'demoCategory',
      //     <DarwinNotificationAction>[
      //       IOSNotificationAction('id_1', 'Action 1'),
      //       IOSNotificationAction(
      //       'id_2',
      //       'Action 2',
      //       options: <DarwinNotificationActionOption>{
      //           DarwinNotificationActionOption.destructive,
      //       },
      //       ),
      //       DarwinNotificationAction(
      //       'id_3',
      //       'Action 3',
      //       options: <DarwinNotificationActionOption>{
      //           DarwinNotificationActionOption.foreground,
      //       },
      //       ),
      //     ],
      //     options: <DarwinNotificationCategoryOption>{
      //       DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
      //   },
      //   )
      // ]
    );

    final InitializationSettings settings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: initializationSettingsDarwin,
    );

    await _localNotificationservice.initialize(settings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {
      onNotificationClick.add(notificationResponse);
    }); //onSelectNotification
  }

  Future<NotificationDetails> _notificationDetails() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('channel_id', 'channel_name',
            channelDescription: 'description',
            importance: Importance.max,
            priority: Priority.max,
            playSound: true);

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails();

    return const NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
  }) async {
    final details = await _notificationDetails();
    await _localNotificationservice.show(id, title, body, details,
        payload: payload);
  }

  void _onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    print('id $id');
  }

  // void onDidReceiveNotificationResponse(NotificationResponse details) {
  //   print('payload ${details}');
  // }
}

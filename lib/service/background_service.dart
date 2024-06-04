// import 'dart:async';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:usage_stats/usage_stats.dart';
//
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// FlutterLocalNotificationsPlugin();
//
// void startBackgroundService() async {
//   final service = FlutterBackgroundService();
//
//   service.configure(
//     androidConfiguration: AndroidConfiguration(
//       onStart: onStart,
//       isForegroundMode: true,
//       autoStart: true,
//     ),
//     iosConfiguration: IosConfiguration(),
//   );
//
//   await service.startService();
// }
//
// Future<void> onStart(ServiceInstance service) async {
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   const AndroidNotificationDetails androidPlatformChannelSpecifics =
//   AndroidNotificationDetails(
//     'your_channel_id',
//     'your_channel_name',
//     importance: Importance.max,
//     priority: Priority.high,
//   );
//   const NotificationDetails platformChannelSpecifics =
//   NotificationDetails(android: androidPlatformChannelSpecifics);
//
//   Timer.periodic(Duration(minutes: 1), (timer) async {
//     if (!(await service.isServiceRunning())) timer.cancel();
//
//     final endTime = DateTime.now();
//     final startTime = endTime.subtract(Duration(days: 1));
//
//     List<UsageStats> usageStats =
//     await UsageStats.queryUsageStats(startTime, endTime);
//
//     for (var stats in usageStats) {
//       final totalTimeInForeground = stats.totalTimeInForeground;
//       final usageThreshold = 3 * 60 * 60 * 1000; // 3 hours in milliseconds
//
//       if (totalTimeInForeground >= usageThreshold) {
//         String appName = stats.packageName.split('.').last;
//         await flutterLocalNotificationsPlugin.show(
//           stats.packageName.hashCode,
//           'Usage Alert',
//           '$appName usage exceeded 3 hours',
//           platformChannelSpecifics,
//         );
//       }
//     }
//   });
// }

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_phone_addiction/provider/apps_provider.dart';
import 'package:smart_phone_addiction/service/show_notice.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  /// OPTIONAL, using custom notification channel id
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground2', // id
    'MY FOREGROUND SERVICE', // title
    description:
    'This channel is used for important notifications.', // description
    importance: Importance.high, // importance must be at low or higher level
    //playSound: true,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  if (Platform.isIOS || Platform.isAndroid) {
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        iOS: DarwinInitializationSettings(),
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );
  }

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,
      // notificationChannelId: 'my_foreground2',
      // initialNotificationTitle: 'AWESOME SERVICE',
      // initialNotificationContent: 'Initializing',
      // foregroundServiceNotificationId: 88,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
}
@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();

  // For flutter prior to version 3.0.0
  // We have to register the plugin manually

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setString("hello", "world");

  /// OPTIONAL when use custom notification
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });
  SharedPreferences prefs = await SharedPreferences.getInstance();


  // bring to foreground
  Timer.periodic(const Duration(seconds: 3), (timer) async {
    int id = Random().nextInt(10000);
    bool isEnableNotification = prefs.getBool('notification')??false;
    if(!isEnableNotification){
      return ;
    }
    // if (service is AndroidServiceInstance) {
    //   if (await service.isForegroundService()) {
    //     /// OPTIONAL for use custom notification
    //     /// the notification id must be equals with AndroidConfiguration when you call configure() method.
    //     flutterLocalNotificationsPlugin.show(
    //       900,
    //       'COOL SERVICE',
    //       'Awesome ${DateTime.now()}',
    //       const NotificationDetails(
    //         android: AndroidNotificationDetails(
    //           'my_foreground',
    //           'MY FOREGROUND SERVICE',
    //           icon: '@mipmap/ic_launcher',
    //           ongoing: true,
    //         ),
    //       ),
    //     );
    //
    //     // if you don't using custom notification, uncomment this
    //     service.setForegroundNotificationInfo(
    //       title: "My App Service",
    //       content: "Updated at ${DateTime.now()}",
    //     );
    //   }
    // }
    /// you can see this log in logcat
    print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');

    fetchUsageStats();
    // test using external plugin
    // flutterLocalNotificationsPlugin.show(
    //   900,
    //   'App usage',
    //   'Awesome ${DateTime.now()}',
    //   const NotificationDetails(
    //     android: AndroidNotificationDetails(
    //       'my_foreground',
    //       'MY FOREGROUND SERVICE',
    //       icon: '@mipmap/ic_launcher',
    //       ongoing: true,
    //     ),
    //   ),
    // );
    service.invoke(
      'update');
  });
}
@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.reload();
  final log = preferences.getStringList('log') ?? <String>[];
  log.add(DateTime.now().toIso8601String());
  await preferences.setStringList('log', log);

  return true;
}




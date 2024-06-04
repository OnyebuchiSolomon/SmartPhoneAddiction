import 'dart:async';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:usage_stats/usage_stats.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();


Future<void> fetchUsageStats() async {
  // UsageStats.grantUsagePermission();
  DateTime endDate = DateTime.now();
  DateTime startDate = DateTime(endDate.year, endDate.month, endDate.day);  // Last 24 hours

  try {
    List<UsageInfo> usageStats =
    await UsageStats.queryUsageStats(startDate, endDate);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> whitelistedApps = prefs.getStringList('whitedPackageName') ?? [];
    final notifiedApps = prefs.getStringList('notified_apps') ?? [];
if(whitelistedApps.isNotEmpty){
  for (var whitelistedApp in whitelistedApps) {
    for (var stats in usageStats) {
      if(whitelistedApp==stats.packageName) {
        final packageName = stats.packageName;
        final totalTimeInForeground = stats.totalTimeInForeground;
        int total = int.parse(totalTimeInForeground ?? '0');
        int usageInHours = total ~/ 3600;
        // const hour2usageThreshold = 2 * 60 * 60 * 1000; // 2 hours in milliseconds
        // const hour4usageThreshold = 4 * 60 * 60 * 1000; // 4 hours in milliseconds
        // const hour6usageThreshold = 6 * 60 * 60 * 1000; // 6 hours in milliseconds
        /*
      if (total >= hour2usageThreshold && total<=hour4usageThreshold &&whitelistedApps.contains(packageName)) {
        if(packageName!= null){
         String  appName =packageName.split('.').last;

          await flutterLocalNotificationsPlugin.show(
            packageName.hashCode,
            'Usage Alert',
            '$appName usage exceeded 2 hours',
            const NotificationDetails(
              android: AndroidNotificationDetails(
                'my_foreground',
                'App U',
                icon: '@mipmap/ic_launcher',
                ongoing: true,
              ),
            ),
          );
          print('packageName2 is empty');
        }else{
          print('packageName2 is empty');
        }
      }else{
        print('not upto 2 is empty');
      }
      if (total >= hour4usageThreshold && total<=hour6usageThreshold &&whitelistedApps.contains(packageName)) {
        if(packageName!= null){
          String  appName =packageName.split('.').last;

          await flutterLocalNotificationsPlugin.show(
            packageName.hashCode,
            'Usage Alert',
            '$appName usage exceeded 4 hours',
            const NotificationDetails(
              android: AndroidNotificationDetails(
                'my_foreground',
                'App U',
                icon: '@mipmap/ic_launcher',
                ongoing: true,
              ),
            ),
          );
          print('packageName4 is empty');
        }else{
          print('packageName4 is empty');
        }
      }else{
        print('not upto4 is empty');
      }
      if (total >= hour6usageThreshold &&whitelistedApps.contains(packageName)) {
        if(packageName!= null){
          String  appName =packageName.split('.').last;

          await flutterLocalNotificationsPlugin.show(
            packageName.hashCode,
            'Usage Alert',
            '$appName usage exceeded 4 hours',
            const NotificationDetails(
              android: AndroidNotificationDetails(
                'my_foreground',
                'App U',
                icon: '@mipmap/ic_launcher',
                ongoing: true,
              ),
            ),
          );
          print('packageName 6is empty');
        }else{
          print('packageName6 is empty');
        }
      }else{
        print('not upto 6 is empty');
      }


     */
        if (usageInHours >= 2 && !notifiedApps.contains('${stats.packageName}_2')) {
          String  appName =packageName!.split('.').last;

          await flutterLocalNotificationsPlugin.show(
            packageName.hashCode,
            'Usage Alert',
            '$appName usage exceeded 2 hours',
            const NotificationDetails(
              android: AndroidNotificationDetails(
                'my_foreground',
                'App U',
                icon: '@mipmap/ic_launcher',
                ongoing: true,
              ),
            ),
          );
          notifiedApps.add('${stats.packageName}_2');
          await prefs.setStringList('notified_apps', notifiedApps);
        } else if (usageInHours >= 4 && !notifiedApps.contains('${stats.packageName}_4')) {
          String  appName =packageName!.split('.').last;

          await flutterLocalNotificationsPlugin.show(
            packageName.hashCode,
            'Usage Alert',
            '$appName usage exceeded 4 hours',
            const NotificationDetails(
              android: AndroidNotificationDetails(
                'my_foreground',
                'App U',
                icon: '@mipmap/ic_launcher',
                ongoing: true,
              ),
            ),
          );
          notifiedApps.add('${stats.packageName}_4');
          await prefs.setStringList('notified_apps', notifiedApps);
        } else if (usageInHours >= 6 && !notifiedApps.contains('${stats.packageName}_6')) {
          String  appName =packageName!.split('.').last;

          await flutterLocalNotificationsPlugin.show(
            packageName.hashCode,
            'Usage Alert',
            '$appName usage exceeded 6 hours',
            const NotificationDetails(
              android: AndroidNotificationDetails(
                'my_foreground',
                'App U',
                icon: '@mipmap/ic_launcher',
                ongoing: true,
              ),
            ),
          );
          notifiedApps.add('${stats.packageName}_6');
          await prefs.setStringList('notified_apps', notifiedApps);
        }
      }

    }
  }
}else{
  print('whitelisted is empty');
}

  } catch (e) {

  }


}
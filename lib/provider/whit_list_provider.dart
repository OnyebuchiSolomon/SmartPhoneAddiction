import 'package:device_apps/device_apps.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:smart_phone_addiction/provider/apps_provider.dart';
import 'package:usage_stats/usage_stats.dart';
import 'dart:developer' as devTool;
import '../service/show_notice.dart';

class WhiteListProvider extends ChangeNotifier {
  //late AppsProvider appsProvider;
  WhiteListProvider() {
    loadIconApp();
    fetchInstalledApps();
  }
  List<ApplicationWithIcon> installedAppsWithIcons = [];
  List<ApplicationWithIcon> newInstalledAppsWithIcons = [];

  List<String> newList = [];
  bool isLoadingWhiteListApp = false;
  int numberOfSelectedApp = 0;

  List<String> oldList = [];


  Future<void> fetchInstalledApps() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.reload();
    List<String> whitelistedApps =
        prefs.getStringList('whitedPackageName') ?? [];
    List<Application> apps = await DeviceApps.getInstalledApplications(
      onlyAppsWithLaunchIntent: true,
      includeSystemApps: false,
    );


    List<Application> filteredApps =[];
    for(var w in whitelistedApps){
      for(var a in apps){
        if(w.contains(a.packageName)){
          filteredApps.add(a);
        }
      }
    }

    List<ApplicationWithIcon> appsWithIcons = [];
    for (var app in filteredApps) {
      var appWithIcon = await DeviceApps.getApp(app.packageName, true);
      if (appWithIcon is ApplicationWithIcon) {
        appsWithIcons.add(appWithIcon);
      }
    }
    newInstalledAppsWithIcons = appsWithIcons;

    notifyListeners();
  }











  Future<void> loadIconApp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.reload();
    oldList = prefs.getStringList('whitedPackageName') ?? [];
    List<ApplicationWithIcon> appsWithIcons = [];
    for (var app in oldList) {
      var appWithIcon = await DeviceApps.getApp(app, true);
      if (appWithIcon is ApplicationWithIcon) {
        appsWithIcons.add(appWithIcon);
      }
    }
    installedAppsWithIcons = appsWithIcons;
    devTool.log(
        'installedAppsWithIconsinstalledAppsWithIcons${installedAppsWithIcons.length}');
    notifyListeners();
  }

  Future<void> loadApps() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    oldList = prefs.getStringList('whitedPackageName') ?? [];

    //
    //  List<ApplicationWithIcon> appsWithIcons = [];
    //  for (var app in oldList) {
    //   for(var appsWithIcon in appsProvider.installedAppsWithIcons){
    //     if(appsWithIcon.packageName.contains(app)){
    //       installedAppsWithIcons.add(appsWithIcon);
    //
    //     }
    //
    //   }
    //    // var appWithIcon = await DeviceApps.getApp(app, true);
    //    // if (appWithIcon is ApplicationWithIcon) {
    //    //   installedAppsWithIcons.add(appWithIcon);
    //    // }
    //  }
    //
    // // installedAppsWithIcons = appsWithIcons;
    //  isLoadingWhiteListApp = false;
    notifyListeners();
  }

  Future<void> selectWhiteList(String packageName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> oldList = prefs.getStringList('whitedPackageName') ?? [];
    if (oldList.contains(packageName)) {
      Fluttertoast.showToast(
          msg: "Already in whiteListed app",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      oldList.add(packageName);
      newList.addAll(oldList);
      await prefs.setStringList('whitedPackageName', newList).whenComplete(() {
        numberOfSelectedApp = 0;
        newList = [];
        devTool.log('after deleted ${newList.length}');
        List<String> oldList = prefs.getStringList('whitedPackageName') ?? [];

        devTool.log('new record after adding ${oldList.length}');
        Fluttertoast.showToast(
            msg: "Added successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        notifyListeners();
      });
      print('old ${oldList.length}');
      // for (var i in oldList) {
      //   if (i == packageName) {
      //
      //     Fluttertoast.showToast(
      //         msg: "Already in whiteListed app",
      //         toastLength: Toast.LENGTH_SHORT,
      //         gravity: ToastGravity.CENTER,
      //         timeInSecForIosWeb: 1,
      //         backgroundColor: Colors.red,
      //         textColor: Colors.white,
      //         fontSize: 16.0);
      //   }
      //   oldList.add(packageName);
      //   for (var x in newList) {
      //     if (x == packageName) {
      //       print('add $numberOfSelectedApp ...............');
      //       newList.removeWhere((element) => element == packageName);
      //
      //     }
      //   }

      numberOfSelectedApp++;
      print('new ${newList.length}');
    }

    notifyListeners();
  }

  Future<void> addWhiteList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    devTool.log('Before adding ${newList.length}');
    //print(installedAppsWithIcons.first.appName);
    await prefs.setStringList('whitedPackageName', newList).whenComplete(() {
      numberOfSelectedApp = 0;
      newList = [];
      devTool.log('after deleted ${newList.length}');
      List<String> oldList = prefs.getStringList('whitedPackageName') ?? [];

      devTool.log('new record after adding ${oldList.length}');
      Fluttertoast.showToast(
          msg: "Added successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      notifyListeners();
    });
  }

  Future<void> removeWhiteListed(String packageName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> oldList = prefs.getStringList('whitedPackageName') ?? [];
    oldList.removeWhere((element) => element == packageName);
    newList.addAll(oldList);
    devTool.log('new  after removing the newList ${newList.length}');
    await prefs.setStringList('whitedPackageName', newList).whenComplete(() {
      newList = [];

      List<String> oldList = prefs.getStringList('whitedPackageName') ?? [];
      devTool.log(' after removing the newRecordt ${oldList.length}');
      notifyListeners();
      Fluttertoast.showToast(
          msg: "Removed successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }

  Future<void> fetchUsageStats() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
prefs.reload();

    DateTime endDate = DateTime.now();
    DateTime startDate =
        DateTime(endDate.year, endDate.month, endDate.day); // Last 24 hours

    try {
      List<Application> apps = await DeviceApps.getInstalledApplications(
        onlyAppsWithLaunchIntent: true,
        includeSystemApps: false,
      );
      List<UsageInfo> selectedUsageStats = [];
      List<UsageInfo> selectedUsageStat = [];
      List<UsageInfo> usageStats =
          await UsageStats.queryUsageStats(startDate, endDate);
      for (var installedApp in apps) {
        for (var usage in usageStats) {
          if (installedApp.packageName == usage.packageName) {
            selectedUsageStat.add(usage);
          }
        }
      }
      selectedUsageStats.addAll(selectedUsageStat);
      // devTool.log(
      //     '............................................here${whitelistedApps.length}');
      List<String> whitelistedApps =
          prefs.getStringList('whitedPackageName') ?? [];
      List<String> appPackageName = [];

     // List<String> whiteListHolder = whitelistedApps;
      devTool.log(
          'first whitelistedApps: $whitelistedApps...whitelistedApps length: ${whitelistedApps.length}');

      if (whitelistedApps.isEmpty) {
        devTool.log(
            'white list is empty');
        for(var s in selectedUsageStats){
          final totalTimeInForeground = s.totalTimeInForeground;
          int total = int.parse(totalTimeInForeground!);
          double usageInHours = total / 3600000;
          devTool.log(
              'Empty side All app hour: ${usageInHours.toStringAsFixed(1)}...Package name: ${s.packageName}');
          if(usageInHours>=2.0){
            devTool.log(
                'Empty side hour: ${usageInHours.toStringAsFixed(1)}...Package name: ${s.packageName}');
            appPackageName.add(s.packageName.toString());
          }
        }
       // whitelistedApps.addAll(appPackageName);
        List<String> uniqueList = appPackageName.toSet().toList();
        prefs.setStringList('whitedPackageName', uniqueList);
      }

        for (var selet in selectedUsageStats) {
          final totalTimeInForeground = selet.totalTimeInForeground;
          int total = int.parse(totalTimeInForeground!);
          double usageInHours = total / 3600000;
          List<String> whitelisted =
              prefs.getStringList('whitedPackageName') ?? [];
          devTool.log(
              'NOT Empty side ALL hour: ${usageInHours.toStringAsFixed(1)}...Package name: ${selet.packageName}');
          for(var s in whitelisted){
            // devTool.log(
            //     'matched ? ${s.contains(selet.packageName!)} hour: ${usageInHours.toStringAsFixed(1)}..main.Package name: ${selet.packageName} ..whitelist.Package name: ${s}');
            if(!selet.packageName!.contains(s)){
              if(usageInHours>=2.0){
                // devTool.log(
                //     'NOT Empty side hour: ${usageInHours.toStringAsFixed(1)}...Package name: ${selet.packageName}');
                appPackageName.add(selet.packageName.toString());
                devTool.log(
                    'Added ${selet.packageName!} hour: ${usageInHours.toStringAsFixed(1)}');

              }else{

                return;
              }

            }else{
              //
              return;
            }
          }

        }
        whitelistedApps.addAll(appPackageName);
      List<String> uniqueList = appPackageName.toSet().toList();
        prefs.setStringList('whitedPackageName', uniqueList);
      oldList = prefs.getStringList('whitedPackageName') ?? [];
      final notifiedApps = prefs.getStringList('notified_apps') ?? [];
      devTool.log(
          'whitelistedApps: $oldList...whitelistedApps length: ${oldList.length}');
      /*
      for (var iconApp in apps) {
        for (var app in usageStats) {
          if (iconApp.packageName == app.packageName) {
            final totalTimeInForeground = app.totalTimeInForeground;
            int total = int.parse(totalTimeInForeground!);
            double usageInHours = total / 3600000;
            List<String> whitelistedApps =
                prefs.getStringList('whitedPackageName') ?? [];
            List<String> storedWhitelistedApps = whitelistedApps;
            // devTool.log(
            //     'hour: ${usageInHours.toStringAsFixed(1)}...Package name: ${app.packageName}');
            // devTool
            //     .log('millsec type: ${app.totalTimeInForeground.runtimeType}');
            for (String whiteListApp in whitelistedApps) {
              // devTool.log('equal is true or false : ${apps.packageName.toString()!=whiteListApp&&usageInHours>=2}');
              // if (app.packageName.toString() == whiteListApp &&
              //     usageInHours >= 0.3) {
              //   devTool.log('whiteListApp.............${app.packageName}');
              // }
              if (app.packageName.toString() != whiteListApp &&
                  usageInHours >= 0.3) {
                devTool.log('whiteListApp.............${app.packageName}');
                appPackageName.add(app.packageName.toString());
              }
            }

            if (whitelistedApps.isEmpty && usageInHours >= 0.3) {
              devTool
                  .log('whiteListApp...empty side..........${app.packageName}');
              appPackageName.add(app.packageName.toString());
            }
            // devTool.log('whiteListApp.............{apps.packageName}');
            storedWhitelistedApps.addAll(appPackageName);
            prefs.setStringList('whitedPackageName', storedWhitelistedApps);
            devTool.log('$storedWhitelistedApps');
            notifyListeners();

            //   if(usageInHours>=2){
            //     if (whitelistedApps.isNotEmpty) {
            //       for (String item in whitelistedApps) {
            //         if (item==apps.packageName) {
            //         }else{
            //           print('............................Package Name${apps.packageName} usageInHours:$usageInHours');
            //           // List<String> whitelistedApps = prefs.getStringList('whitedPackageName') ?? [];
            //           newList.add(apps.packageName.toString());
            //
            //           print('............................added ${iconApp.packageName}');
            //           print('.........................packageNamelenght... ${whitelistedApps.length}');
            //         }
            //         prefs.setStringList('whitedPackageName', newList);
            //       }}
            //     // }else{
            //     //   List<String> whitelistedAppsa = prefs.getStringList('whitedPackageName') ?? [];
            //     //   print('.........................packageNamelenght... ${whitelistedAppsa.length}');
            //     //   newList.add(apps.packageName.toString());
            //     //   print('............................added ${iconApp.packageName}');
            //     // }
            //     // prefs.setStringList('whitedPackageName', newList);
            //   }
            //   notifyListeners();
          }
        }
      }


       */




    notifyListeners();
    } catch (e) {}
  }
  sendNotice() async {

    DateTime endDate = DateTime.now();
    DateTime startDate =
    DateTime(endDate.year, endDate.month, endDate.day);
    List<UsageInfo> usageStats =
    await UsageStats.queryUsageStats(startDate, endDate);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.reload();
    List<String> whitelistedApps =
        prefs.getStringList('whitedPackageName') ?? [];
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
  }
}

import 'package:device_apps/device_apps.dart';
import 'package:flutter/cupertino.dart';
import 'package:usage_stats/usage_stats.dart';
import 'dart:developer' as devTool;
class AppsProvider extends ChangeNotifier {
  AppsProvider() {
    // fetchUsageStats();
    // fetchInstalledApps();
  }
  List<UsageInfo> usageInfoList = [];
  List<ApplicationWithIcon> installedAppsWithIcons = [];

  Map<String, Duration> _appUsageMap = {};
  double totalUsagePercentage = 0.0;
  int allTotalUsage = 0;
  double usageThresholdHour = 6; // 4
  AppUsageDetails? _highestUsageAppDetails;

  AppUsageDetails? get highestUsageAppDetails => _highestUsageAppDetails;
  bool isLoadingApp = false;
  DateTime endDate = DateTime.now();

  Future<void> fetchUsageStats() async {
    DateTime startDate = DateTime(endDate.year, endDate.month, endDate.day); //
    try {
      int t = 0;
      List<UsageInfo> usageStats =
          await UsageStats.queryUsageStats(startDate, endDate);

      usageInfoList = usageStats;
      _appUsageMap = _calculateTotalUsage(usageStats);
      isLoadingApp = false;
      notifyListeners();
    } catch (e) {
      print('errrrrrr$isLoadingApp rrrrrrrrrr$e');
      usageInfoList = [];
      isLoadingApp = false;
      notifyListeners();
    }
  }

  void _sortAppsByUsage() {
    installedAppsWithIcons.sort((a, b) {
      int aUsage = _getUsageTime(a.packageName);
      int bUsage = _getUsageTime(b.packageName);
      //isLoadingApp= true;
      notifyListeners();
      return bUsage.compareTo(aUsage); // Descending order
    });
  }

  Future<void> fetchInstalledApps() async {
    isLoadingApp = true;

    List<Application> apps = await DeviceApps.getInstalledApplications(
      onlyAppsWithLaunchIntent: true,
      includeSystemApps: false,
    );

    List<ApplicationWithIcon> appsWithIcons = [];
    for (var app in apps) {

      var appWithIcon = await DeviceApps.getApp(app.packageName, true);
      if (appWithIcon is ApplicationWithIcon) {
        appsWithIcons.add(appWithIcon);
      }
    }
    installedAppsWithIcons = appsWithIcons;
    _sortAppsByUsage();

    isLoadingApp = false;
    notifyListeners();
  }

  Map<String, Duration> _calculateTotalUsage(List<UsageInfo> usageStats) {
    Map<String, Duration> usageMap = {};
    int totalUsageInSeconds = 0;
    for (var info in usageStats) {
      Duration totalUsage =
          Duration(milliseconds: int.parse(info.totalTimeInForeground!));
      totalUsageInSeconds += int.parse(info.totalTimeInForeground!);
      if (usageMap.containsKey(info.packageName)) {
        usageMap[info.packageName!] = usageMap[info.packageName]! + totalUsage;
      } else {
        usageMap[info.packageName!] = totalUsage;
      }
    }

    int totalUsageInHours =
        totalUsageInSeconds ~/ 3600000; // Convert total usage time to hours
    double percentageOfDay = (totalUsageInHours * usageThresholdHour) /
        100.0; // Calculate percentage based on 24 hours
    //isLoadingApp= true;
    totalUsagePercentage = double.parse(percentageOfDay.toStringAsFixed(1));

    allTotalUsage = totalUsageInHours;
    print('.............'
        ''
        '.............$totalUsagePercentage');
    print('..................time........$totalUsageInHours');
    // usageStats.reduce((value, element) => int.parse(value.totalTimeInForeground!)>int.parse(element.totalTimeInForeground!)?value:element);
    // Calculate the highest usage app details
    String maxUsagePackageName =
        usageMap.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    Duration maxUsageDuration = usageMap[maxUsagePackageName]!;
    double usageHours = maxUsageDuration.inMilliseconds / 3600000;
    app().then((value) => {
          for (var w in value)
            {
              print('iconnnnnnnnnnnnnnnnnnnnnnnn ${w.appName}'),
              if (w.packageName == maxUsagePackageName)
                {
                  _highestUsageAppDetails = AppUsageDetails(
                    appName: w.appName,
                    usageHours: usageHours,
                    appIcon: w,
                  ),
                  print(
                      'aaaaaaaaaaaaaaaaaaa${w.appName}${usageHours}${w.icon}${w.packageName}'),
                  notifyListeners()
                }
            }
        });

    notifyListeners();
    return usageMap;
  }

  double getUsageProgress(String packageName) {
    Duration totalUsage = _appUsageMap[packageName] ?? const Duration();
    print(
        '................iyt..........${totalUsage.inMinutes / usageThresholdHour * 100}');

    double mins = totalUsage.inMilliseconds / 60000;

    // Convert minutes to hours
    double hoursUsed = mins / 60.0;

    // Calculate the percentage
    double percentage = (hoursUsed / usageThresholdHour) * 100;

    return percentage / 100; //(totalUsage.inMinutes * usageThresholdHour)/100;
  }

  int _getUsageTime(String packageName) {
    Duration totalUsage = Duration();
    Duration allTotalUsage = Duration();
    for (var info in usageInfoList) {
      // allTotalUsage +=
      //     Duration(milliseconds: int.parse(info.totalTimeInForeground!));

      if (info.packageName == packageName) {
        totalUsage =
            Duration(milliseconds: int.parse(info.totalTimeInForeground!));
      }
      // this.allTotalUsage += allTotalUsage.inHours;
      // isLoadingApp= true;
    }

    print('Total usage ${allTotalUsage.inHours}');
    return totalUsage.inMinutes;
  }

// int highestUsage(String packageName) {
//   Duration totalUsage = _appUsageMap[packageName] ?? const Duration();
//
//   int hours = totalUsage.inHours;
//   int minutes = totalUsage.inMinutes.remainder(60);
//   int seconds = totalUsage.inSeconds.remainder(60);
// //
// //   DateTime startDate =DateTime(endDate.year, endDate.month, endDate.day); //
// //   List<UsageInfo> usageStats =
// //   await UsageStats.queryUsageStats(startDate, endDate);
// // late  ApplicationWithIcon? appIcon;
// // int time = 0;
// //   UsageInfo singleUsageInfo  = usageStats.reduce((value, element) => int.parse(value.totalTimeInForeground!)>int.parse(element.totalTimeInForeground!)?value:element);
// //   for(var i in installedAppsWithIcons){
// //     if(i.packageName==singleUsageInfo.packageName){
// //       appIcon =i;
// //       time = int.parse(singleUsageInfo.totalTimeInForeground!);
// //     }
// //   }
//  return totalUsage.inMilliseconds;//"With $hours:${minutes.toString().padLeft(2, '0')} hrs ${seconds.toString().padLeft(2, '0')} mins of usage";
// }
//   Future<void> getHighestUsageAppDetails(List<ApplicationWithIcon>installedAppsWithIcons) async {
//
//     // Find the package name with the highest usage
//     String maxUsagePackageName = _appUsageMap.entries.reduce((a, b) => a.value > b.value ? a : b).key;
//     Duration maxUsageDuration = _appUsageMap[maxUsagePackageName]!;
//     double usageHours = maxUsageDuration.inMilliseconds / 3600000;
//
//     print('maxUsagePackageNamevvvvvvvvvvvvvvv $maxUsagePackageName');
//     // ApplicationWithIcon? maxUsageApp = installedAppsWithIcons.firstWhere(
//     //       (app) => app.packageName == maxUsagePackageName,
//     //
//     // );
//
//     for(var w in installedAppsWithIcons){
//       print('iconnnnnnnnnnnnnnnnnnnnnnnn ${w.appName}');
//       if(w.packageName==maxUsagePackageName){
//         _highestUsageAppDetails = AppUsageDetails(
//           appName: w.appName,
//           usageHours: usageHours,
//           appIcon: w,
//         );
//         print('aaaaaaaaaaaaaaaaaaa${w.appName}${usageHours}${w.icon}${w.packageName}');
//       }
//
//     }
//
//   }
  Future<List<ApplicationWithIcon>> app() async {
    List<Application> apps = await DeviceApps.getInstalledApplications(
      onlyAppsWithLaunchIntent: true,
      includeSystemApps: false,
    );

    List<ApplicationWithIcon> appsWithIcons = [];
    for (var app in apps) {
      var appWithIcon = await DeviceApps.getApp(app.packageName, true);
      if (appWithIcon is ApplicationWithIcon) {
        appsWithIcons.add(appWithIcon);
      }
    }
    return appsWithIcons;
  }
}

class AppUsageDetails {
  final String appName;
  final double usageHours;
  final ApplicationWithIcon appIcon;

  AppUsageDetails(
      {required this.appName, required this.usageHours, required this.appIcon});
}

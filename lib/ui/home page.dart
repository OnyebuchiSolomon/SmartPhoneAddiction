import 'dart:async';
import 'package:device_apps/device_apps.dart';
import 'package:usage_stats/usage_stats.dart';
import 'package:flutter/material.dart';
import 'package:smart_phone_addiction/ui/setting_page.dart';
import 'package:smart_phone_addiction/wigets/app_details.dart';
import 'package:smart_phone_addiction/wigets/usage_time_card.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<UsageInfo> _usageInfoList = [];
  List<ApplicationWithIcon> _installedAppsWithIcons = [];
  Map<String, Duration> _appUsageMap = {};
  // List<EventUsageInfo> events = [];
  // Map<String?, NetworkInfo?> _netInfoMap = Map();Reading a NULL string not supported here.
  final int _usageThresholdMinutes = 240; // 4
/*
  Future<void> initUsage() async {
    try {
      UsageStats.grantUsagePermission();

      DateTime endDate = DateTime.now();
      DateTime startDate = endDate.subtract(const Duration(days: 1));

      List<EventUsageInfo> queryEvents =
      await UsageStats.queryEvents(startDate, endDate);
      List<NetworkInfo> networkInfos = await UsageStats.queryNetworkUsageStats(
        startDate,
        endDate,
        networkType: NetworkType.all,
      );

      Map<String?, NetworkInfo?> netInfoMap = {
        for (var v in networkInfos) v.packageName : v };

      List<UsageInfo> t = await UsageStats.queryUsageStats(startDate, endDate);

      for (var i in t) {
        if (double.parse(i.totalTimeInForeground!) > 0) {
          print(
              DateTime.fromMillisecondsSinceEpoch(int.parse(i.firstTimeStamp!))
                  .toIso8601String());

          print(DateTime.fromMillisecondsSinceEpoch(int.parse(i.lastTimeStamp!))
              .toIso8601String());

          print(i.packageName);
          print(DateTime.fromMillisecondsSinceEpoch(int.parse(i.lastTimeUsed!))
              .toIso8601String());
          print(int.parse(i.totalTimeInForeground!) / 1000 / 60);

          print('-----\n');
        }
      }

      this.setState(() {
        events = queryEvents.reversed.toList();
       this. _netInfoMap = netInfoMap;
      });
    } catch (err) {
      print(err);
    }
  }


 */
  @override
  void initState() {
    super.initState();
    _fetchUsageStats();
    _fetchInstalledApps();
  }

  Future<void> _fetchUsageStats() async {
    UsageStats.grantUsagePermission();
    DateTime endDate = DateTime.now();
    DateTime startDate =
        endDate.subtract(const Duration(days: 1)); // Last 24 hours

    try {
      List<UsageInfo> usageStats =
          await UsageStats.queryUsageStats(startDate, endDate);


        setState(() {
          _usageInfoList = usageStats;
         // _sortAppsByUsage();
           _appUsageMap = _calculateTotalUsage(usageStats);
          // _installedAppsWithIcons.sort((a, b) {
          //   Duration aUsage = _appUsageMap[a.packageName] ?? Duration();
          //   Duration bUsage = _appUsageMap[b.packageName] ?? Duration();
          //   return bUsage.compareTo(aUsage); // Sort in descending order
          // });
        });


    } catch (e) {
      setState(() {
        _usageInfoList = [];
      });
    }
  }
  void _sortAppsByUsage() {
    _installedAppsWithIcons.sort((a, b) {
      int aUsage = _getUsageTime(a.packageName);
      int bUsage = _getUsageTime(b.packageName);
      return bUsage.compareTo(aUsage); // Descending order
    });
  }

  Future<void> _fetchInstalledApps() async {
    List<Application> apps = await DeviceApps.getInstalledApplications(
      onlyAppsWithLaunchIntent: true,
      includeSystemApps: true,
    );

    List<ApplicationWithIcon> appsWithIcons = [];
    for (var app in apps) {
      var appWithIcon = await DeviceApps.getApp(app.packageName, true);
      if (appWithIcon is ApplicationWithIcon) {
        appsWithIcons.add(appWithIcon);
      }
    }

    setState(() {
      _installedAppsWithIcons = appsWithIcons;
    });
    _sortAppsByUsage();
  }
  Map<String, Duration> _calculateTotalUsage(List<UsageInfo> usageStats) {
    Map<String, Duration> usageMap = {};
    for (var info in usageStats) {
      Duration totalUsage = Duration(milliseconds: int.parse(info.totalTimeInForeground!));
      if (usageMap.containsKey(info.packageName)) {
        usageMap[info.packageName!] = usageMap[info.packageName]! + totalUsage;
      } else {
        usageMap[info.packageName!] = totalUsage;
      }
    }
    return usageMap;
  }
  double _getUsageProgress(String packageName) {
    Duration totalUsage = _appUsageMap[packageName] ?? const Duration();
    return totalUsage.inMinutes / _usageThresholdMinutes;
  }
  // String _getUsageTime(String packageName) {
  //   Duration totalUsage = Duration();
  //   for (var info in _usageInfoList) {
  //     if (info.packageName == packageName) {
  //       totalUsage +=
  //           Duration(milliseconds: int.parse(info.totalTimeInForeground!));
  //     }
  //   }
  //   return '${totalUsage.inMinutes} minutes';
  // }
  int _getUsageTime(String packageName) {
    Duration totalUsage = Duration();
    for (var info in _usageInfoList) {
      if (info.packageName == packageName) {
        totalUsage += Duration(milliseconds: int.parse(info.totalTimeInForeground!));
      }
    }
    return totalUsage.inMinutes;
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingsPage()));
              },
              icon: const Icon(
                Icons.settings,
                color: Colors.orange,
                size: 25,
              )),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            // SizedBox(
            //   height: height * .2,
            //   width: 100,
            //   child: Stack(
            //     children: [
            //       Stack(
            //         children: [
            //           // SizedBox(
            //           //   height: height * 0.2,
            //           //   width: width * 0.45,
            //           //   child: PieChart(
            //           //     PieChartData(
            //           //         startDegreeOffset: 150,
            //           //         sectionsSpace: 0,
            //           //         centerSpaceRadius: 40,
            //           //         // you can assign values according to your need
            //           //         sections: widget.subjectModel
            //           //             .asMap()
            //           //             .entries
            //           //             .map((e) {
            //           //           double totalSubject =
            //           //               360 / (widget.subjectModel.length);
            //           //           double percentageValue = (e
            //           //               .value.totalCorrectQuestions /
            //           //               e.value.questionModel.length) *
            //           //               totalSubject;
            //           //           double radiusValue = (percentageValue /
            //           //               e.value.questionModel.length) *
            //           //               45;
            //           //           print(radiusValue + 12);
            //           //           return PieChartSectionData(
            //           //             value: percentageValue,
            //           //             color: colors[e.key % colors.length],
            //           //             radius: radius[e.key % radius.length],
            //           //             showTitle: false,
            //           //           );
            //           //         }).toList()),
            //           //   ),
            //           // ),
            //           Positioned.fill(
            //             //now perfect
            //             child: Container(
            //               height: 50,
            //               width: 50,
            //               decoration: BoxDecoration(
            //                 color: Colors.white,
            //                 shape: BoxShape.circle,
            //                 boxShadow: [
            //                   BoxShadow(
            //                       color: Colors.grey.shade200,
            //                       blurRadius: 10.0,
            //                       spreadRadius: 10.0,
            //                       offset: const Offset(3.0, 3.0)),
            //                 ],
            //               ),
            //               child: const Center(
            //                   child: CircleAvatar(
            //
            //                   )
            //               ),
            //             ),
            //           ),
            //         ],
            //       ),
            //
            //     ],
            //   ),
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Column(
                  children: [
                    Text('Most used app'),
                    Text('App Name'),
                    Text('Hours used'),
                  ],
                ),
                Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(100)),
                ),
              ],
            ),
            const Text('STATS'),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                UsageTime(timeTitle: 'Screen\nTime', value: '2 hours'),
                UsageTime(timeTitle: 'Usage\nPercentage', value: '95%'),
              ],
            ),
            SizedBox(
              height: height * .6,
              width: double.infinity,
              child: Card(
                child: ListView.builder(

                    itemCount: _installedAppsWithIcons.length,
                    itemBuilder: (context, index) {

                      double usageProgress = _getUsageProgress(_installedAppsWithIcons[index].packageName);
                      return ListTile(
                        leading: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.memory(
                                _installedAppsWithIcons[index].icon,
                                width: 40,
                                height: 40)),
                        title: Text(_installedAppsWithIcons[index].appName),
                        subtitle: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: LinearProgressIndicator(
                            backgroundColor: Colors.white,
                            value: usageProgress ,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.orange),
                          ),
                        ),
                      );
                      //  Text('Usage: $usageTime')
                      //APPDetails(value: 40.2, packageName: '${events[index].eventType}',);
                    }),
              ),
            )
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

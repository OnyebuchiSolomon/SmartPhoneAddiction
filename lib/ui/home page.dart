import 'dart:async';
import 'package:device_apps/device_apps.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:smart_phone_addiction/provider/apps_provider.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:smart_phone_addiction/ui/setting_page.dart';
import 'package:smart_phone_addiction/wigets/app_details.dart';
import 'package:smart_phone_addiction/wigets/usage_time_card.dart';

import '../provider/whit_list_provider.dart';
import '../service/background_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // List<EventUsageInfo> events = [];
  // Map<String?, NetworkInfo?> _netInfoMap = Map();Reading a NULL string not supported here.

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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<AppsProvider>(context, listen: false).fetchUsageStats();
      Provider.of<AppsProvider>(context, listen: false).fetchInstalledApps();
      // final v = Provider.of<AppsProvider>(context, listen: false);
      // Provider.of<AppsProvider>(context, listen: false)
      //     .getHighestUsageAppDetails(v.installedAppsWithIcons);

      // Perform state changes here
      // Example: Provider.of<AppsProvider>(context, listen: false).updateState();
    });

    super.initState();

    // _fetchInstalledApps();
  }
  // Future<void> initializeNotifications() async {
  //   const AndroidInitializationSettings initializationSettingsAndroid =
  //   AndroidInitializationSettings('@mipmap/ic_launcher');
  //   const InitializationSettings initializationSettings =
  //   InitializationSettings(android: initializationSettingsAndroid);
  //   await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  // }

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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsPage()));
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
            Consumer<AppsProvider>(
              builder: (BuildContext context, value, Widget? child) {
                final appUsageDetails = value.highestUsageAppDetails;
                if (appUsageDetails == null) {
                  return const Text('No data available');
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        const Text('Most used app'),

                        Text(appUsageDetails.appName),
                        Text(
                            'Usage: ${appUsageDetails.usageHours.toStringAsFixed(2)} hours'),
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    // Container(
                    //   height: 70,
                    //   width: 70,
                    //   decoration: BoxDecoration(
                    //       color: Colors.green,
                    //       borderRadius: BorderRadius.circular(100)),
                    //Image.memory(appUsageDetails.appIcon.icon),
                    // ),
                    Stack(
                      children: [
                        SizedBox(
                          height: height * 0.15,
                          width: width * 0.32,
                          child: PieChart(
                            PieChartData(
                                startDegreeOffset: 180,
                                sectionsSpace: 0,
                                centerSpaceRadius: 40,
                                // you can assign values according to your need
                                sections: [
                                  PieChartSectionData(
                                    value: 60,
                                    color: Colors.orange,
                                    radius: 20,
                                    showTitle: false,
                                  ),
                                  PieChartSectionData(
                                    value: 40,
                                    color: Colors.black12,
                                    radius: 20,
                                    showTitle: false,
                                  )
                                ]),
                          ),
                        ),
                        Positioned.fill(
                          //now perfect
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.shade200,
                                        blurRadius: 10.0,
                                        spreadRadius: 10.0,
                                        offset: const Offset(3.0, 3.0)),
                                  ],
                                ),
                                child:  Center(
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.memory(
                                          appUsageDetails.appIcon.icon,
                                          width: 40,
                                          height: 40)),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            const Text('STATS'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                UsageTime(
                    timeTitle: 'Screen\nTime',
                    value:
                        '${context.watch<AppsProvider>().allTotalUsage} hour(s)'),
                UsageTime(
                    timeTitle: 'Usage\nPercentage',
                    value:
                        '${context.watch<AppsProvider>().totalUsagePercentage}%'),
              ],
            ),
            Consumer<AppsProvider>(
              builder:
                  (BuildContext context, appsProviderValue, Widget? child) {
                return Expanded(
                  child: Card(
                    child: ListView.builder(
                        itemCount:
                            appsProviderValue.installedAppsWithIcons.length,
                        itemBuilder: (context, index) {
                          double usageProgress = appsProviderValue
                              .getUsageProgress(appsProviderValue
                                  .installedAppsWithIcons[index].packageName);
                          return ListTile(
                            leading: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.memory(
                                    appsProviderValue
                                        .installedAppsWithIcons[index].icon,
                                    width: 40,
                                    height: 40)),
                            title: Text(appsProviderValue
                                .installedAppsWithIcons[index].appName),
                            subtitle: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: LinearProgressIndicator(
                                backgroundColor: Colors.white,
                                value: usageProgress,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    Colors.orange),
                              ),
                            ),
                          );
                          //  Text('Usage: $usageTime')
                          //APPDetails(value: 40.2, packageName: '${events[index].eventType}',);
                        }),
                  ),
                );
              },
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

  String formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);

    return "With $hours:${minutes.toString().padLeft(2, '0')} hrs ${seconds.toString().padLeft(2, '0')} mins of usage";
  }
}

import 'dart:convert';

import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_phone_addiction/provider/apps_provider.dart';
import 'package:smart_phone_addiction/provider/whit_list_provider.dart';
import 'package:smart_phone_addiction/wigets/whitelistcard.dart';

class WhiteListPage extends StatefulWidget {
  const WhiteListPage({super.key});

  @override
  State<WhiteListPage> createState() => _WhiteListPageState();
}

class _WhiteListPageState extends State<WhiteListPage> {
  // List<ApplicationWithIcon> _installedAppsWithIcons =[];
  // Set<String> whitelistedApps = {};
  //
  // Future<void> addToWhitelist(List<ApplicationWithIcon> app) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final appsJson = jsonEncode(app);
  //
  //   await prefs.setString('applications', appsJson);// Store package name for icon retrieval
  //   setState(() {});
  // }
  //
  // Future<void> loadApps() async {
  //   List<Application> apps = await DeviceApps.getInstalledApplications(
  //     onlyAppsWithLaunchIntent: true,
  //     includeSystemApps: true,
  //   );
  //
  //
  //   List<ApplicationWithIcon> appsWithIcons = [];
  //   for (var app in apps) {
  //     var appWithIcon = await DeviceApps.getApp(app.packageName, true);
  //     if (appWithIcon is ApplicationWithIcon) {
  //       appsWithIcons.add(appWithIcon);
  //     }
  //   }
  //
  //   setState(() {
  //     _installedAppsWithIcons = appsWithIcons;
  //   });
  // }

  // Future<void> loadWhitelist() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final jsonString = prefs.getString('applications');
  //   if (jsonString != null) {
  //     List<ApplicationWithIcon> jsonList = jsonDecode(jsonString);
  //     List<ApplicationWithIcon> loadedApps = jsonList.map((json) => ApplicationWithIcon.fromJson(json)).toList();
  //     setState(() {
  //    //   applications = loadedApps;
  //     });
  //   }
  //   setState(() {
  //     whitelistedApps = prefs.getStringList('whitelist')?.toSet() ?? {};
  //   });
  // }

  @override
  void initState() {
    //loadApps();

    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Access the inherited widget or provider here.
    final whiteListProvider = Provider.of<WhiteListProvider>(context);
    // Initialize based on the whiteListProvider if needed.
    whiteListProvider.loadApps();

  }

  @override
  Widget build(BuildContext context) {

    return Consumer<AppsProvider>(
      builder: (BuildContext context, value, Widget? child) {
        return  Consumer<WhiteListProvider>(
          builder: (BuildContext context, whiteValue, Widget? child) {
            List<ApplicationWithIcon> appsWithIcons = [];
            for (String app in whiteValue.oldList) {
              for(var appsWithIcon in value.installedAppsWithIcons){
                if(appsWithIcon.packageName==app){
                  appsWithIcons.add(appsWithIcon);

                }

              }}

            return Scaffold(
              appBar: AppBar(
                  backgroundColor: Colors.white,
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                  )),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Text('WHITELISTED APP'),
                    const SizedBox(
                      height: 10,
                    ),
                    appsWithIcons.isEmpty
                        ? Text('No App')
                        : Expanded(
                      child: ListView.builder(
                          itemCount: appsWithIcons.length,
                          itemBuilder: (context, index) => ListTile(
                            leading: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.memory(
                                    appsWithIcons[index]
                                        .icon,
                                    width: 40,
                                    height: 40)),
                            title: Text(appsWithIcons[index].appName),
                            trailing: IconButton(
                                onPressed: () {
                                  whiteValue.removeWhiteListed(appsWithIcons[index]
                                      .packageName);
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.orange,
                                )),
                          )),
                    )
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton.small(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                backgroundColor: Colors.orange,
                onPressed: () {
                  _showPhasesButtonSheet();
                },
                tooltip: 'Add',
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ), // This tr
            );
          },

        );
      },

    );
  }

  _showPhasesButtonSheet() {
    showModalBottomSheet(
        isScrollControlled: false,
        isDismissible: true,
        elevation: 5,
        barrierColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        context: context,
        builder: (context) {
          return SizedBox(
            height: double.infinity,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close)),
                    // SizedBox(
                    //   height: 50,
                    //   child: MaterialButton(
                    //       color: Colors.orange,
                    //       onPressed: () {
                    //         context.read<WhiteListProvider>().addWhiteList();
                    //       },
                    //       child: Text(
                    //           'Add ${context.watch<WhiteListProvider>().numberOfSelectedApp} app')),
                    // ),
                  ],
                ),
                Expanded(
                  child: Consumer<AppsProvider>(
                    builder: (BuildContext context, whiteValue, Widget? child) {
                      return  Consumer<WhiteListProvider>(
                        builder: (BuildContext context, value, Widget? child) {
                          return whiteValue.installedAppsWithIcons.isEmpty
                              ? const Text('No app')
                              : ListView.builder(
                              itemCount:
                              whiteValue.installedAppsWithIcons.length,
                              itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  child: ListTile(
                                    onTap: () {
                                      value.selectWhiteList(whiteValue.installedAppsWithIcons[index]
                                          .packageName);
                                    },
                                    leading: ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(16),
                                        child: Image.memory(
                                            whiteValue.installedAppsWithIcons[
                                            index]
                                                .icon,
                                            width: 40,
                                            height: 40)),
                                    title: Text(whiteValue.installedAppsWithIcons[index]
                                        .appName),
                                  ),
                                ),
                              ));
                        },
                      );
                    },

                  ),
                ),
              ],
            ),
          );
        });
  }
}
/*
Column(
            children: [
              TextButton(onPressed: (){
                context.read<WhiteListProvider>().addWhiteList();
              }, child: Text('Add ${context.watch<WhiteListProvider>().numberOfSelectedApp} app')),
              Card(
                color: Colors.white,
                elevation: 5,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))),
                child: Container(

                    height: MediaQuery.of(context).size.height / 1.7,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                    ),
                    child: Consumer<WhiteListProvider>(
                      builder: (BuildContext context, whiteValue, Widget? child) {
                        return  Consumer<AppsProvider>(
                          builder: (BuildContext context, value, Widget? child) {
                            return value.isLoadingApp
                                ? const CircularProgressIndicator()
                                : value.installedAppsWithIcons.isEmpty
                                ? const Text('No app')
                                : Expanded(
                                  child: ListView.builder(
                                  itemCount: value.installedAppsWithIcons.length,
                                  itemBuilder: (context, index) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                      child: ListTile(
                                        onTap: (){
                                          whiteValue.selectWhiteList(value.installedAppsWithIcons[index].packageName);
                                        },
                                        leading: ClipRRect(
                                            borderRadius:
                                            BorderRadius.circular(16),
                                            child: Image.memory(
                                                value
                                                    .installedAppsWithIcons[
                                                index]
                                                    .icon,
                                                width: 40,
                                                height: 40)),
                                        title: Text(value
                                            .installedAppsWithIcons[index]
                                            .appName),
                                      ),
                                    ),
                                  )),
                                );
                          },
                        );
                      },

                    )),
              ),
            ],
          );
 */

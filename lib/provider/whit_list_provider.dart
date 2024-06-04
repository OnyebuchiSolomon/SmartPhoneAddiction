import 'package:device_apps/device_apps.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:smart_phone_addiction/provider/apps_provider.dart';

class WhiteListProvider extends ChangeNotifier {
  //late AppsProvider appsProvider;
WhiteListProvider(){
  loadIconApp();
}
  List<ApplicationWithIcon> installedAppsWithIcons = [];

  List<String> newList = [];
  bool isLoadingWhiteListApp = false;
  int numberOfSelectedApp = 0;

  List<String> oldList=[];

Future<void>loadIconApp()async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  oldList = prefs.getStringList('whitedPackageName') ?? [];
  List<ApplicationWithIcon> appsWithIcons = [];
  for (var app in oldList) {
    var appWithIcon = await DeviceApps.getApp(app, true);
    if (appWithIcon is ApplicationWithIcon) {
      appsWithIcons.add(appWithIcon);
    }
  }
  installedAppsWithIcons = appsWithIcons;
  print('installedAppsWithIconsinstalledAppsWithIcons${installedAppsWithIcons.length}');
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
if(oldList.contains(packageName)){
  Fluttertoast.showToast(
      msg: "Already in whiteListed app",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);

}else{
  oldList.add(packageName);
  newList.addAll(oldList);
  await prefs.setStringList('whitedPackageName', newList).whenComplete(() {


    numberOfSelectedApp=0;
    newList=[];
    print('after deleted ${newList.length}');
    List<String> oldList = prefs.getStringList('whitedPackageName') ?? [];

    print('new record after adding ${oldList.length}');
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
    print('Before adding ${newList.length}');
    //print(installedAppsWithIcons.first.appName);
    await prefs.setStringList('whitedPackageName', newList).whenComplete(() {


      numberOfSelectedApp=0;
      newList=[];
      print('after deleted ${newList.length}');
      List<String> oldList = prefs.getStringList('whitedPackageName') ?? [];

      print('new record after adding ${oldList.length}');
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
    print('new  after removing the newList ${newList.length}');
    await prefs.setStringList('whitedPackageName', newList).whenComplete(() {
      newList = [];

      List<String> oldList = prefs.getStringList('whitedPackageName') ?? [];
      print(' after removing the newRecordt ${oldList.length}');
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
}

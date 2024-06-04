import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends ChangeNotifier{


  Future<void> setEnable(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('notification', value);
  }
  Future<void> setDisEnable(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('notification', value);
  }
  Future<bool> getNoti() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
   return  prefs.getBool('notification')!;
    notifyListeners();
  }
}
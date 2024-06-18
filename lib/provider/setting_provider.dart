import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer'as dev_debug;

import '../service/background_service.dart';
class Settings extends ChangeNotifier{

late bool _istrue = false;
get isTrue=>_istrue;
  Future<void> setEnable(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('notification', value);
  }
  Future<void> setDisEnable(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('notification', value);
    getNoti();

  }
  Future<bool> getNoti() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
  final  _istruea = prefs.getBool('notification')!;
      _istrue = prefs.getBool('notification')!;
    dev_debug.log('$_istruea ...provider side',name:devDebugName );
    notifyListeners();
   return  prefs.getBool('notification')!;

  }
}
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_phone_addiction/provider/setting_provider.dart';
import 'package:smart_phone_addiction/service/background_service.dart';
import 'package:smart_phone_addiction/ui/whitelistpage.dart';
import 'package:smart_phone_addiction/wigets/notification_card.dart';
import 'package:smart_phone_addiction/wigets/settingsWiget.dart';
import 'package:usage_stats/usage_stats.dart';
import 'dart:developer' as dev_debug;

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool notice = false;
  late Timer _timer;
  late Settings _settings;
  Future<void> setEnable(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('notification', value);
    setState(() {});
  }

  getNoti() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _settings.getNoti(); // prefs.getBool('notification')!;

      dev_debug.log('${_settings.isTrue} ...', name: devDebugName);
    });
  }

  getCurrent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    notice = prefs.getBool('notification')??false;

    dev_debug.log('$notice ...getCurrentValue', name: devDebugName);

    setState(() {});
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _settings = Provider.of<Settings>(context, listen: false);
    //  getNoti();
      getCurrent();
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Settings>(
      builder: (BuildContext context, value, Widget? child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              onPressed: () async {
                Navigator.pop(context);
                // SharedPreferences prefs = await SharedPreferences.getInstance();
                // final notice = prefs.getBool('notification') ?? false;
                // dev_debug.log('$notice', name: devDebugName);
              },
              icon: const Icon(Icons.arrow_back),
            ),
            actions: [
              /*
              IconButton(
                  onPressed: () async {
                    final service = FlutterBackgroundService();
                    var isRunning = await service.isRunning();
                    if (isRunning) {
                      service.invoke("stopService");
                    } else {
                      service.startService();
                    }
                    String text = '';
                    if (!isRunning) {
                      text = 'Stop Service';
                    } else {
                      text = 'Start Service';
                    }

                    setState(() {});
                    print('sssssssssssssssss$text');
                  },
                  icon: const Icon(Icons.stop)),

               */
              // IconButton(onPressed: () async {
              //   FlutterBackgroundService().invoke("setAsBackground");
              // }, icon: const Icon(Icons.backspace)),
              // IconButton(onPressed: () async {
              //   FlutterBackgroundService().invoke("setAsForeground");
              // }, icon: const Icon(Icons.forward))
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text('SETTINGS',
                  style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w600)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SettingsWiget(
                        widget: const Icon(
                          Icons.bug_report_rounded,
                          color: Colors.green,
                          size: 35,
                        ),
                        onPress: () {
                          _showPermissionButtonSheet();
                        }),
                    SettingsWiget(
                        widget: Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(100)),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(100)),
                              child: const Center(child: Text('3')),
                            ),
                          ),
                        ),
                        onPress: () {
                          _showPhasesButtonSheet();
                        }),
                    SettingsWiget(
                        widget: const Icon(
                          Icons.apps,
                          color: Colors.orange,
                          size: 35,
                        ),
                        onPress: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const WhiteListPage()));
                        }),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Text('Notification',
                      style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w500)),
                    ),
                    Switch(
                      value: notice, //context.watch<Settings>().isTrue,
                      onChanged: (val) async {
                        setEnable(val);
                        setState(() {
                          getCurrent();
                        });
                      },
                      activeColor: Colors.orange,
                    ),
                  ],
                ),
                 Text('Rate us',
                  style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _showPermissionButtonSheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: true,
        barrierColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Card(
            elevation: 25,
            margin: EdgeInsets.all(0.0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      'SPECIAL PERMISSION',
                      style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.0),
                    child: Column(
                      children: [
                        Text(
                            'if your phone is rooted grant permission directly on your phone\n'),
                        Text(
                            'if your phone isn\'t rooted then you need to use adb (android debug bridged) to grant the app special permission\n'),
                        Text(
                            'adb d shell pm grant com.example.negative android.permission.WRITE_SECURE_SETTINGS'),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width -20,
                      onPressed: () {
                        UsageStats.grantUsagePermission();
                      },
                      color: Colors.green[900],
                      child: const Text('GRANT'),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  _showPhasesButtonSheet() {
    showModalBottomSheet(
        isScrollControlled: false,
        isDismissible: true,
        elevation: 5,
        barrierColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        context: context,
        builder: (context) {
          return Card(
            elevation: 25,
            margin: EdgeInsets.all(0.0),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10))),
            child: Container(
              height: MediaQuery.of(context).size.height / 1.7,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    children: [
                      Container(
                        height: 20,
                      ),
                      Text(
                        'RELIEF LEVEL',
                        style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                       Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                            'your curbing phase changes base on your screen time. '
                            'you will be notified when you\'re about to enter a new phase (Resets to level 1 the next day)',
                          style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                      SizedBox(
                        height: 10,

                      ),
                      const NotificationCard(
                          header: 'Phase 1',
                          headerColor: Colors.green,
                          notice: 'Mutes notification of high trafficked apps'),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: NotificationCard(
                            header: 'Phase 2',
                            headerColor: Colors.orange,
                            notice: 'Level one features '
                                'block high trafficked apps'),
                      ),
                      const NotificationCard(
                          header: 'Phase 3',
                          headerColor: Colors.red,
                          notice: 'level one and level two features '
                              'Activates gray scale mode')
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}

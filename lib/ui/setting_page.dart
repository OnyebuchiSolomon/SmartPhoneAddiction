import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_phone_addiction/provider/setting_provider.dart';
import 'package:smart_phone_addiction/ui/whitelistpage.dart';
import 'package:smart_phone_addiction/wigets/notification_card.dart';
import 'package:smart_phone_addiction/wigets/settingsWiget.dart';
import 'package:usage_stats/usage_stats.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool notice = false;
  Future<void> setEnable(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('notification', value);
    setState(() {});
  }

  getNoti() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    notice = prefs.getBool('notification')!;
    setState(() {});
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getNoti();
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
              onPressed: () {},
              icon: const Icon(Icons.arrow_back),
            ),
            actions: [
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
                const Text('SETTINGS'),
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
                                  builder: (context) => WhiteListPage()));
                        }),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Notification'),
                    Switch(
                      value: notice,
                      onChanged: (val) {
                        setEnable(val);
                        setState(() {
                          getNoti();
                        });
                      },
                      activeColor: Colors.orange,
                    ),
                  ],
                ),
                const Text('Rate us'),
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
          return Container(
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Text('SPECIAL PERMISSION'),
                Text('data'),
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: MaterialButton(
                    minWidth: MediaQuery.of(context).size.width - 16,
                    onPressed: () {
                      UsageStats.grantUsagePermission();
                    },
                    color: Colors.green,
                    child: const Text('GRANT'),
                  ),
                )
              ],
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
              child: const SingleChildScrollView(
                child: Column(
                  children: [
                    Text('SPECIAL PERMISSION'),
                    SizedBox(
                      height: 20,
                    ),
                    Text('dafgrhrsdkljsakjklsdaklaslksaklslkdslsdkdskldlksta'),
                    Text('dafgrhrsdkljsakjklsdaklaslksaklslkdslsdkdskldlksta'),
                    Text('dafgrhrsdkljsakjklsdaklaslksaklslkdslsdkdskldlksta'),
                    SizedBox(
                      height: 20,
                    ),
                    NotificationCard(
                        header: 'Phase 1',
                        headerColor: Colors.green,
                        notice:
                            'ajbsbjhdsjhdsjbkhdsjbhdsbhjdbhjjdshjhjdsbhjdsbhj\ndjbhdhjdsbbdjbhjdsbhjdshbj'),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: NotificationCard(
                          header: 'Phase 2',
                          headerColor: Colors.orange,
                          notice:
                              'ajbsbjhdsjhdsjbkhdsjbhdsbhjdbhjjdshjhjdsbhjdsbhj\ndjbhdhjdsbbdjbhjdsbhjdshbj'),
                    ),
                    NotificationCard(
                        header: 'Phase 3',
                        headerColor: Colors.red,
                        notice:
                            'ajbsbjhdsjhdsjbkhdsjbhdsbhjdbhjjdshjhjdsbhjdsbhj\ndjbhdhjdsbbdjbhjdsbhjdshbj')
                  ],
                ),
              ),
            ),
          );
        });
  }
}

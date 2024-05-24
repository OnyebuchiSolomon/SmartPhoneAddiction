import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.arrow_back),
          )),
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
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>WhiteListPage()));
                    }),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Notification'),
                Switch(
                  value: true,
                  onChanged: (val) {},
                  activeColor: Colors.orange,
                ),
              ],
            ),
            const Text('Rate us'),
          ],
        ),
      ),
    );
  }
  _showPermissionButtonSheet(){
      showModalBottomSheet(
          isScrollControlled: true,
          isDismissible: true,
          barrierColor: Colors.transparent,
          context: context,
          builder: (context) {
            return Container(
              height: MediaQuery.of(context).size.height/2,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Text('SPECIAL PERMISSION'),
                  Text('data'),
                  const SizedBox(height: 20,),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width-16,
                      onPressed: (){

                   UsageStats.grantUsagePermission();
                      },color: Colors.green,child: const Text('GRANT'),),
                  )
                ],
              ),
            );
          });
    
  }

  _showPhasesButtonSheet(){

    showModalBottomSheet(
        isScrollControlled: false,
        isDismissible: true,
        elevation: 5,
        barrierColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
        ),
        context: context,
        builder: (context) {
          return Card(
            color: Colors.white,
            elevation: 5,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
            ),
            child: Container(
              height: MediaQuery.of(context).size.height/1.7,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),

              ),

              child: const SingleChildScrollView(
                child: Column(
                  children: [
                    Text('SPECIAL PERMISSION'),
                    SizedBox(height: 20,),
                    Text('dafgrhrsdkljsakjklsdaklaslksaklslkdslsdkdskldlksta'),
                    Text('dafgrhrsdkljsakjklsdaklaslksaklslkdslsdkdskldlksta'),
                    Text('dafgrhrsdkljsakjklsdaklaslksaklslkdslsdkdskldlksta'),
                    SizedBox(height: 20,),
                    NotificationCard(header: 'Phase 1', headerColor: Colors.green, notice: 'ajbsbjhdsjhdsjbkhdsjbhdsbhjdbhjjdshjhjdsbhjdsbhj\ndjbhdhjdsbbdjbhjdsbhjdshbj'),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: NotificationCard(header: 'Phase 2', headerColor: Colors.orange, notice: 'ajbsbjhdsjhdsjbkhdsjbhdsbhjdbhjjdshjhjdsbhjdsbhj\ndjbhdhjdsbbdjbhjdsbhjdshbj'),
                    ),
                    NotificationCard(header: 'Phase 3', headerColor: Colors.red, notice: 'ajbsbjhdsjhdsjbkhdsjbhdsbhjdbhjjdshjhjdsbhjdsbhj\ndjbhdhjdsbbdjbhjdsbhjdshbj')
                            
                  ],
                ),
              ),
            ),
          );
        });

  }
}

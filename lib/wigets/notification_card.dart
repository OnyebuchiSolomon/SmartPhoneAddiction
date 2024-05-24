import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final String header;
  final String notice;
  final Color headerColor;
  const NotificationCard({super.key, required this.header, required this.headerColor, required this.notice});

  @override
  Widget build(BuildContext context) {
    return Container(

      height: 100,
      width: MediaQuery.of(context).size.width-18,
      child: Card(
color: Colors.white,
        child: Column(
          children: [
            Text(header,style: TextStyle(
              color: headerColor
            ),),
            const SizedBox(height: 20,),
            Text(notice)

          ],
        ),
      ),
    );
  }
}

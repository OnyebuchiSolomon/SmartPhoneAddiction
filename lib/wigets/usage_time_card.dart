import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UsageTime extends StatelessWidget {
  final String timeTitle;
  final String value;
  const UsageTime({super.key, required this.timeTitle, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      child: Container(

        decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(10)
        ),
        height: 70,
        width: MediaQuery.of(context).size.width / 2.5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(timeTitle),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  value,
                  style: TextStyle(color: Colors.orange),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

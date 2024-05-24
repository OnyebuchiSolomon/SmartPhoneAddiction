import 'package:flutter/material.dart';

class SettingsWiget extends StatelessWidget {
 final Widget widget;
 final VoidCallback onPress;
  const SettingsWiget({super.key, required this.widget, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: onPress,
      child: SizedBox(
        height: 80,
        width: 100,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child:widget ,
            ),
          ),
        ),
      ),
    );
  }
}

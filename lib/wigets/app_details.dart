import 'package:flutter/material.dart';

class APPDetails extends StatelessWidget {
  final double value;
  final String packageName;
  const APPDetails({super.key, required this.value, required this.packageName});

  @override
  Widget build(BuildContext context) {
    return  ListTile(
      leading: const CircleAvatar(),
      title: Text(packageName),
      subtitle: LinearProgressIndicator(
        backgroundColor: Colors.white,
        value: 50,
        //valueColor:Color(x),
      ),
    );
  }
}

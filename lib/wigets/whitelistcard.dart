import 'package:flutter/material.dart';

class WhiteCard extends StatelessWidget {
  
  const WhiteCard({super.key});

  @override
  Widget build(BuildContext context) {
    return  ListTile(
      leading: CircleAvatar() ,
      title: Text('Whatsapp'),
      trailing: IconButton(onPressed: (){}, icon: Icon(Icons.delete,color: Colors.orange,)),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:smart_phone_addiction/wigets/whitelistcard.dart';

class WhiteListPage extends StatefulWidget {
  const WhiteListPage({super.key});

  @override
  State<WhiteListPage> createState() => _WhiteListPageState();
}

class _WhiteListPageState extends State<WhiteListPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
            const SizedBox(height: 10,),
            const Text('WHITELISTED APP'),
            const SizedBox(height: 10,),
            Expanded(
              child: ListView.builder(
                  itemCount: 4,
                  itemBuilder: (context,index)=> WhiteCard()),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100)
        ),
        backgroundColor: Colors.orange,
        onPressed: (){},
        tooltip: 'Add',
        child: const Icon(Icons.add,color: Colors.white,),
      ), // This tr
    );
  }




}

import 'package:flutter/material.dart';

class AddReport extends StatelessWidget {
  int memesID;
  AddReport({super.key, required this.memesID});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Report'),
      ),
      body: Column(
        children: [
          Text(memesID.toString()),
        ],
      ),
    );
  }
}

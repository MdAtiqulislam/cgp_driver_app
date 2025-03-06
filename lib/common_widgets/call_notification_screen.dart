
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CallNotificationScreen extends StatelessWidget {
  final String callerName;
  final String callerNumber;

  const CallNotificationScreen({
    super.key,
    required this.callerName,
    required this.callerNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Incoming Call'),
        actions: [
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {
              // Handle call answer action
            },
          ),
          IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: () {
              // Handle call reject action
              Get.back();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Incoming call from: $callerName'),
            Text('Phone number: $callerNumber'),
          ],
        ),
      ),
    );
  }
}

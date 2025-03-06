import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class CustomOverlay extends StatelessWidget {
  final String requestId;
  final String notificationId;
  final RemoteMessage message;

  const CustomOverlay({super.key, required this.requestId, required this.notificationId,required this.message});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.black54,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Ride share Request',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              ElevatedButton(
                onPressed: () {
                 // NotificationServices.handleMessageClick(context, message);
                },
                child: const Text('View'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

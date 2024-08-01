import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cgp_driver_app/services/notification_services.dart';

class CustomOverlay extends StatelessWidget {
  final String requestId;
  final String notificationId;
  final RemoteMessage message;

  CustomOverlay({required this.requestId, required this.notificationId,required this.message});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.black54,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Rideshare Request',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              ElevatedButton(
                onPressed: () {
                 // NotificationServices.handleMessageClick(context, message);
                },
                child: Text('View'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

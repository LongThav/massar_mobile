import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

class NotificationAPI {
  final _firebaseMessageing = FirebaseMessaging.instance;

  Future<void> handleBackgroundMessage(RemoteMessage message)async{
    debugPrint("title: ${message.notification?.title}");
    debugPrint("Body: ${message.notification?.body}");
    debugPrint("Payload: ${message.data}");
  }

  Future<void> initNotifications() async {
    await _firebaseMessageing.requestPermission();
    final fCMToken = await _firebaseMessageing.getToken();
    debugPrint("Token: $fCMToken");
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}

//  e4XFiBeDRdiELZ6HSQSC70:APA91bFZOAxJa-kHKSlgvAZCyiqA77wbG5vqp-f6pTwJYE6AMCTRLfgixkbmkFF9dCbgzlFhtldU6iTGAYr-wLpuOOQ0gIWNbhDbA_7u9M-CWZ

//e4XFiBeDRdiELZ6HSQSC70:APA91bFZOAouFPOyUrHkYfbesxJa-kHKSlgvAZCyiqA77wbG5vqp-f6pTwJYE6AMCTRLfgixkbmkFF9dCbgzz3T2ObRs34iP2qSlFhtldU6iTGAYr-wLpuOOQ0gIWNbhDbA_7u9M-CWZ
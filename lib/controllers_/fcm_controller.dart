/*
import 'dart:convert';
// import 'package:firebase_messaging/firebase_messaging.dart';

import '../utility/shared_preference.dart';

const fcmActionBalanceUpdate = 'BalanceUpdate';
listenToFCM() async{
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    carPlay: false,
    criticalAlert: true,
    provisional: false,
    sound: true,
  );
  await messaging.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );
  print('FCM User granted permission: ${settings.authorizationStatus}');
  FirebaseMessaging.onMessage.listen(_handleMessage);
  // Also handle any interaction when the app is in the background via a
  // Stream listener
  FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  FirebaseMessaging.onBackgroundMessage(_handleMessage);
  // Get any messages which caused the application to open from
  // a terminated state.
  RemoteMessage? initialMessage = await messaging.getInitialMessage();
  if (initialMessage != null) {
    _handleMessage(initialMessage);
  }
  messaging.onTokenRefresh.listen(_onTokenRefresh);

}

Future<void> _onTokenRefresh(String token) async{
  print('FCM token refreshed $token');
}

Future<void> _handleMessage(RemoteMessage message) async {
  Map<String,dynamic> fcmData = message.data;
  print('FCM data: $fcmData');
  String fcmAction = fcmData['action'];
  switch(fcmAction){
    case fcmActionBalanceUpdate:
      Map<String,dynamic> creditData = json.decode(fcmData['data']);
      //  print(creditData);
      var balance = creditData['balance'];
      updateUserCredit(balance);
      break;
  }
  if (message.notification != null) {
    print('Message also contained a notification: ${message.notification}');
  }
}

updateUserCredit(var updatedBalance) async{
 // print('updating user credit');
  UserPreferences.setBalance(updatedBalance.toString());
}*/

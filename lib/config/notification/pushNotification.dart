// import 'dart:developer';

// import 'package:pickme_mobile/service/navigationService.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// import '../../main.dart';
// import '../globalFunction.dart';
// import '../locator.dart';

// class PushNotificationService {
//   final NavigationService _navigationService = locator<NavigationService>();
//   Map<String, dynamic>? _payload;

//   onNotificationSettings() async {
//     FirebaseMessaging.instance
//         .getInitialMessage()
//         .then((RemoteMessage? message) {
//       if (message != null) {
//         print("message notification $message");
//       }
//     });

//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print("message notification app open ${message.data}");
//       _payload = message.data;
//       _serialiseAndNavigate(_payload!);
//     });

//     FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
//       RemoteNotification notification = message!.notification!;
//       // AndroidNotification android = message.notification!.android!;

//       flutterLocalNotificationsPlugin.show(
//         notification.hashCode,
//         notification.title,
//         notification.body,
//         NotificationDetails(
//           android: AndroidNotificationDetails(
//             channel.id,
//             channel.name,
//             channelDescription: channel.description,
//             icon: "app_icon",
//           ),
//           iOS: IOSNotificationDetails(),
//         ),
//       );
//       _payload = message.data;
//       print("message notification listen $_payload");
//     });

//     var initializationSettingsAndroid =
//         AndroidInitializationSettings('app_icon');
//     var initializationSettingsIOS = IOSInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );

//     var initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//     );

//     await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onSelectNotification: (String? payload) {
//       _serialiseAndNavigate(_payload!);
//       return;
//     });

//     subscribeTopic();
//   }

//   Future _serialiseAndNavigate(Map<String, dynamic>? message) async {
//     log("serialise $message");
//     String screen = message!["from_screen"];
//     print(screen);

//     // if (screen.toLowerCase() == "dispatch_details") {
//     //   // var decodeMeta = json.decode(message["from_meta"]);
//     //   var decodeMeta = message["from_meta"];
//     //   String from = message["from_sender_id"];
//     //   Map<String, dynamic> argument = {
//     //     "meta": decodeMeta,
//     //     "from": from,
//     //     "screen": screen,
//     //   };
//     //   _navigationService.navigateTo(
//     //     MetaLoaderPageRoute,
//     //     arguments: argument,
//     //   );
//     // } else if (screen.toLowerCase() == "driver_dispatch_details") {
//     //   // var decodeMeta = json.decode(message["from_meta"]);
//     //   var decodeMeta = message["from_meta"];
//     //   String from = message["from_sender_id"];
//     //   Map<String, dynamic> argument = {
//     //     "meta": decodeMeta,
//     //     "from": from,
//     //     "screen": screen,
//     //   };
//     //   _navigationService.navigateTo(
//     //     MetaLoaderPageRoute,
//     //     arguments: argument,
//     //   );
//     // }
//   }
// }

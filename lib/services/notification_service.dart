import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart'; // Add the device_info_plus package for emulator check

// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:audioplayers/audioplayers.dart';
import 'package:city_customer_app/app/app.router.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

import 'package:city_customer_app/app/app.locator.dart';
import 'package:city_customer_app/app/app.logger.dart';
// import 'package:city_customer_app/services/local_storage_service.dart';
import 'package:stacked_services/stacked_services.dart';

class NotificationService {
  // final _localStorageService = locator<LocalStorageService>();
  final log = getLogger('NotificationService');
  final _fcm = FirebaseMessaging.instance;

  String? fcmToken;

  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  String type = '';
  int orderId = 0;

  int? chatUserId;
  AudioPlayer player = AudioPlayer();

  final BehaviorSubject<ReceivedNotification>
      didReceivedLocalNotificationSubject =
      BehaviorSubject<ReceivedNotification>();

  /// init local notification
  _initFlutterLocalNotificationPlugin() async {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'default',
        'High Importance Notifications',
        importance: Importance.high,
        description: "This is ewanc channel",
        playSound: true,
        enableLights: true,
      );
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// init android settings
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings("@mipmap/ic_launcher");

      /// init ios settings without onDidReceiveLocalNotification
      final DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings();

      /// init settings
      final InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      /// init local notification plugin with onDidReceiveNotificationResponse
      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (response) =>
            _onNotificationClick(response),
      );

      /// create channel
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// set options
      await _fcm.setForegroundNotificationPresentationOptions(
          alert: true, badge: true, sound: true);
    }
  }

  ///
  ///Initializing Notification services that includes FLN, ANDROID NOTIFICATION CHANNEL setting
  ///FCM NOTIFICATION SETTINGS, and also listeners for OnMessage and for onMessageOpenedApp
  ///
  initConfigure() async {
    log.d("@initFCMConfigure/started");
    await _initFlutterLocalNotificationPlugin();
    askPermission();

    /// Check if running on emulator
    if (await isEmulator()) {
      log.wtf("Running on emulator. Skipping APNS token retrieval.");
    } else {
      /// Now finally get the token from FCM
      await _fcm.getToken().then((token) {
        log.wtf("FCM TOKEN IS ===>$token");
        fcmToken = token;
      });
    }

    ///
    /// When the app is in terminated state and user clicks on notification
    ///
    _fcm.getInitialMessage().then((message) {
      if (message != null) {
        log.wtf('I am invoked from terminated state');
        log.wtf('Notification Message is: ${message.toMap()}');
        orderId = int.parse(message.data['order_id'].toString());

        _goToOrderScreen();
      }
    });

    ///
    /// When app is in foreground state and user receives notification
    ///
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log.wtf('@onMessage');

      const alarmAudioPath = "mp3/custom_sound.mp3";
      player.play(AssetSource(alarmAudioPath));

      if (!kIsWeb) {
        /// if user is not in the chat screen
        getLogger("Notification").wtf(message.toMap());
        handleNotification(message);
      }
    });

    ///
    /// When app is in background(opened) and user clicks on notification
    ///
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log.wtf('I am invoked from background state');
      log.wtf('Notification message is: ${message.toMap()}');

      orderId = int.parse(message.data['order_id'].toString());
      _goToOrderScreen();
    });
  }

  /// Check if the app is running on an emulator or physical device
  Future<bool> isEmulator() async {
    if (Platform.isIOS) {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final iosInfo = await deviceInfo.iosInfo;
      return !iosInfo.isPhysicalDevice;
    }
    return false; // No emulator check needed for Android
  }

  /// get fcm token
  Future<String?> getFcmToken() async {
    return await _fcm.getToken();
  }

  askPermission() async {
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );
    log.d('User granted permission: ${settings.authorizationStatus}');
  }

  handleNotification(RemoteMessage message) {
    log.wtf('@handleNotification');
    log.w("NotificatioMesssage: ${message.notification}");
    if (message.notification != null) {
      orderId = 0;
      if (message.data['order_id'] != null) {
        orderId = int.parse(message.data['order_id'].toString());
      }
      _showLocalNotification(message.notification!);
    }
  }

  _goToOrderScreen() {
    if (orderId == 0) {
      return;
      // locator<NavigationService>().navigateToHomeView();
    } else {
      locator<NavigationService>().navigateToOrderDetailView(orderId: orderId);
    }
  }

  /// show local notification (Heads up notification)
  void _showLocalNotification(RemoteNotification notification) {
    log.wtf("@_showLocalNotification");
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        iOS: DarwinNotificationDetails(subtitle: channel.description),
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          onlyAlertOnce: true,
          importance: Importance.max,
          priority: Priority.high,
          channelDescription: channel.description,
          icon: "@mipmap/ic_launcher",
          styleInformation: BigTextStyleInformation(
            notification.body ?? 'Body Text',
            contentTitle: notification.title ?? 'Title Text',
          ),
        ),
      ),
    );
  }

  /// Executes when user clicks on notification in foreground state
  void _onNotificationClick(NotificationResponse response) {
    log.wtf('Tapped on notification in foreground state');
    _goToOrderScreen();
  }
}

class ReceivedNotification {
  final int? id;
  final String? title;
  final String? body;
  final String? payload;

  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });
}

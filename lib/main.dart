import 'dart:io'; // ✅ Added this import

import 'package:audioplayers/audioplayers.dart';
import 'package:city_customer_app/app/app.logger.dart';
import 'package:city_customer_app/constants/app_theme.dart';
import 'package:city_customer_app/firebase_options.dart';
import 'package:city_customer_app/ui/views/cart/cart_viewmodel.dart';
import 'package:city_customer_app/viewModels/create_order_view_model.dart';
import 'package:city_customer_app/viewModels/location_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:city_customer_app/app/app.bottomsheets.dart';
import 'package:city_customer_app/app/app.dialogs.dart';
import 'package:city_customer_app/app/app.locator.dart';
import 'package:city_customer_app/app/app.router.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:upgrader/upgrader.dart';

Future<void> main() async {
  // ✅ CRITICAL: Initialize Flutter binding FIRST before any async operations
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations early
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  // Initialize Firebase in background (non-blocking)
  final firebaseInit = Firebase.initializeApp(
      name: "cityeatsapp", options: DefaultFirebaseOptions.currentPlatform);

  // Load environment variables
  final dotenvLoad = dotenv.load(fileName: "assets/.env");

  // Setup locator (lightweight, can run in parallel)
  final locatorSetup = setupLocator();

  // Run lightweight operations in parallel
  await Future.wait([
    ScreenUtil.ensureScreenSize(),
    Upgrader.clearSavedSettings(),
    firebaseInit,
    dotenvLoad,
    locatorSetup,
  ]);

  // Setup UI after locator is ready
  setupDialogUi();
  setupBottomSheetUi();

  // Configure Stripe
  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? "";

  // Setup Firebase messaging background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Run app immediately - subscribe to topic in background
  runApp(const MainApp());

  // Subscribe to topic in background (non-blocking for app startup)
  subscribeToCustomerTopic().catchError((error) {
    print("⚠️ Failed to subscribe to customer topic: $error");
  });
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) => MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (context) => GlobalLocationViewModel()),
          ChangeNotifierProvider(create: (context) => CartViewModel()),
          ChangeNotifierProvider(create: (context) => CreateOrderViewModel()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppThemes().lightTheme,
          initialRoute: Routes.startupView,
          onGenerateRoute: StackedRouter().onGenerateRoute,
          navigatorKey: StackedService.navigatorKey,
          navigatorObservers: [
            StackedService.routeObserver,
          ],
        ),
      ),
    );
  }
}

AudioPlayer player = AudioPlayer();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final log = getLogger('main');
  await Firebase.initializeApp();

  const alarmAudioPath = "mp3/custom_sound.mp3";
  player.play(AssetSource(alarmAudioPath));

  log.i('Handling a background message: ${message.messageId}');
  log.i('Notification Message is: ${message.toMap()}');
}

Future<void> subscribeToCustomerTopic() async {
  final messaging = FirebaseMessaging.instance;

  // Request permissions (important for iOS)
  await messaging.requestPermission();

  // ✅ APNs token check for iOS only
  if (Platform.isIOS) {
    String? apnsToken;
    int attempts = 0;
    while (apnsToken == null && attempts < 5) {
      apnsToken = await messaging.getAPNSToken();
      if (apnsToken == null) {
        await Future.delayed(const Duration(seconds: 1));
        attempts++;
      }
    }

    if (apnsToken == null) {
      print("APNs token not available, skipping topic subscription.");
      return;
    }
  }

  await messaging.subscribeToTopic("customer");
  print("✅ Subscribed to customer topic");
}

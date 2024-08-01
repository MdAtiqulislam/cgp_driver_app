/*
import 'package:cgp_driver_app/services/notification_services.dart';
import 'package:cgp_driver_app/services/socket_service.dart';
import 'package:cgp_driver_app/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'app/modules/tripRequest/controllers/trip_request_controller.dart';
import 'app/routes/app_pages.dart';


void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    //  name: "CGP App",
      // name: "The Mall Bd",
      options:const FirebaseOptions(
        apiKey: 'AIzaSyBbhFT8Iq5hraD98_ZKQrLVO8K3j4s1Zdg',
        appId: '1:1030561817194:android:a7ee0504cc0047543fe013',
        messagingSenderId: '1030561817194',
        projectId: "cgp-app-420416",
      )
  );
  //Stripe.publishableKey = AppStrings.publishableKey;

  Get.put(SocketService(),);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      //systemNavigationBarColor: AppColors.mainColorRed, // navigation bar color
      statusBarColor: Colors.white, // status bar color
      statusBarIconBrightness: Brightness.dark,   // Only honored in Android M and above
      statusBarBrightness: Brightness.dark,
    ),
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessagingHandler);

  runApp(
    const MyApp()
  );
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  FirebaseMessaging messaging=FirebaseMessaging.instance;
  NotificationServices notificationServices=NotificationServices();
  @override
  void initState() {
    super.initState();
    messaging.subscribeToTopic("general_push_notification");
    //messaging.subscribeToTopic("test");
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit(context);
    notificationServices.setupInterruptMessage(context);
    notificationServices.getDeviceToken().then((value) => print("FCM token: $value"));
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          locale: const Locale("en","US"),
          fallbackLocale: const Locale("en","US"),
          //translations: Languages(),
          debugShowCheckedModeBanner: false,
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
          theme: CustomTheme.lightTheme,
          // darkTheme: CustomTheme.darkTheme,
          // themeMode: ThemeMode.light,
        );
      },
    );
  }
}

@pragma('vm:entry-point')
Future<void>_firebaseBackgroundMessagingHandler(RemoteMessage message)async{
 // var myMessages=<RemoteMessage>[].obs;
  await Firebase.initializeApp(
      name: "CGP App",
      // name: "The Mall Bd",
      options:const FirebaseOptions(
    apiKey: 'AIzaSyBbhFT8Iq5hraD98_ZKQrLVO8K3j4s1Zdg',
    appId: '1:1030561817194:android:a7ee0504cc0047543fe013',
    messagingSenderId: '1030561817194',
    projectId: "cgp-app-420416",
  )
  );

  Get.toNamed(Routes.TRIP_REQUEST);

}

*/

import 'package:cgp_driver_app/app/modules/home/controllers/home_controller.dart';
import 'package:cgp_driver_app/services/notification_services.dart';
import 'package:cgp_driver_app/services/socket_service.dart';
import 'package:cgp_driver_app/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'app/routes/app_pages.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  //NotificationServices.showCallScreen(message);
  NotificationServices.showNotificationWithoutContext(message);
}


void main() async {


  WidgetsFlutterBinding.ensureInitialized();
   // Create the channel here

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyBbhFT8Iq5hraD98_ZKQrLVO8K3j4s1Zdg',
      appId: '1:1030561817194:android:a7ee0504cc0047543fe013',
      messagingSenderId: '1030561817194',
      projectId: "cgp-app-420416",
    ),
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  Get.put(SocketService());
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{

  @override
  void initState() {
    super.initState();


    Get.put(HomeController());
    NotificationServices().requestNotificationPermission();
    NotificationServices().createNotificationChannel();
    NotificationServices.firebaseInit(context);
    NotificationServices().setupInterruptMessage(context);
    NotificationServices().getDeviceToken().then((value) => print("FCM token: $value"));


  }


  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          locale: const Locale("en", "US"),
          fallbackLocale: const Locale("en", "US"),
          debugShowCheckedModeBanner: false,
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
          theme: CustomTheme.lightTheme,

        );
      },
    );
  }
}


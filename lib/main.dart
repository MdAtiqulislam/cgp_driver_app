
import 'dart:io';
import 'package:cgp_driver_app/app/modules/home/controllers/home_controller.dart';
import 'package:cgp_driver_app/app/modules/ongoingTrip/controllers/ongoing_trip_controller.dart';
import 'package:cgp_driver_app/other_controllers/my_drawer_controller.dart';
import 'package:cgp_driver_app/services/api_endpoints.dart';
import 'package:cgp_driver_app/services/local_services.dart';
import 'package:cgp_driver_app/services/notification_services.dart';
import 'package:cgp_driver_app/services/remote_services.dart';
import 'package:cgp_driver_app/services/socket_service.dart';
import 'package:cgp_driver_app/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'app/modules/home/models/rider_profile_model.dart';
import 'app/routes/app_pages.dart';
import 'common_widgets/custom_snackbar.dart';
import 'models/rider_model.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  //await LocalServices.initializeStorage(); // Clears secure storage if first install
  NotificationServices.showCallScreen(message);
  NotificationServices.showNotificationWithoutContext(message);
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   // Create the channel here

  await Firebase.initializeApp(
    options:(Platform.isIOS || Platform.isMacOS)
        ? const FirebaseOptions(
        apiKey: "AIzaSyCaWliT3t2vJtznHbruqfXSVAIuMwVmQsk",
        appId: "1:1030561817194:ios:132b8d926f7c7ca73fe013",
        messagingSenderId: "1030561817194",
        projectId: "cgp-app-420416"):
    const FirebaseOptions(
      apiKey: 'AIzaSyBbhFT8Iq5hraD98_ZKQrLVO8K3j4s1Zdg',
      appId: '1:1030561817194:android:a7ee0504cc0047543fe013',
      messagingSenderId: '1030561817194',
      projectId: "cgp-app-420416",
    ),
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  Get.put(SocketService());
  Get.put(NotificationServices());
  Get.put(OngoingTripController());
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

class _MyAppState extends State<MyApp>with WidgetsBindingObserver{
 // static const platform = MethodChannel('com.yourdomain/navigation');

  @override
  void initState() {
    super.initState();
  //  platform.setMethodCallHandler(_handleNativeMethodCall);
    _callApiOnStartOrResume();
    Get.put(HomeController());
    NotificationServices().requestNotificationPermission();
    if(Platform.isAndroid)NotificationServices().createNotificationChannel();
    NotificationServices.firebaseInit(context);
    NotificationServices.foregroundMessage();
    NotificationServices().setupInterruptMessage(context);
    NotificationServices().getDeviceToken().then((value) {
      if (kDebugMode) {
        print("FCM token: $value");
      }
    });
     WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Call the API when the app resumes from the background
      _callApiOnStartOrResume();
    }
  }

  Future<void> _callApiOnStartOrResume() async {

    var token=await LocalServices.getToken();

    if(token!=null){
      var riderProfile=RiderProfileModel();
      var rider=RiderModel();
      var fcmToken=await NotificationServices().getDeviceToken();
      var endPoint=APIEndPoints.getUserData;
      try {
        var response=await RemoteServices.getRequest(endPoint: endPoint);
        riderProfile=RiderProfileModel.fromJson(response);
        rider=riderProfile.data??RiderModel();
       // await LocalServices().storeUser(rider);
        await LocalServices.storeUser(rider);
        if(fcmToken!=rider.activeDeviceToken){
          Get.find<HomeController>().isLoading.value=true;
        await  Get.put(MyDrawerController()).completeLogOut().then((value){
          Get.closeAllSnackbars();
          CustomSnackBar(
              isSuccess: true,
              duration: 5,
              msg: "You have been logged out because your ID is active on another device."
          ).showSnackBar();
        });
        }

      } catch (e) {
        if (kDebugMode) {
          print('Error calling API: $e');
        }
      }
    }
  }

  Future<void> _handleNativeMethodCall(MethodCall call) async {
    if (call.method == "navigateToOngoingTrip") {
      Get.toNamed(Routes.ONGOING_TRIP);
    }
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





/*
import 'dart:io';
import 'package:cgp_driver_app/app/modules/home/controllers/home_controller.dart';
import 'package:cgp_driver_app/app/modules/ongoingTrip/controllers/ongoing_trip_controller.dart';
import 'package:cgp_driver_app/models/rider_model.dart';
import 'package:cgp_driver_app/services/api_endpoints.dart';
import 'package:cgp_driver_app/services/local_services.dart';
import 'package:cgp_driver_app/services/notification_services.dart';
import 'package:cgp_driver_app/services/remote_services.dart';
import 'package:cgp_driver_app/services/socket_service.dart';
import 'package:cgp_driver_app/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'app/modules/home/models/rider_profile_model.dart';
import 'app/routes/app_pages.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  NotificationServices.showNotificationWithoutContext(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options:(Platform.isIOS || Platform.isMacOS)
        ? const FirebaseOptions(
        apiKey: "AIzaSyCaWliT3t2vJtznHbruqfXSVAIuMwVmQsk",
        appId: "1:1030561817194:android:a7ee0504cc0047543fe013",
        messagingSenderId: "1030561817194",
        projectId: "cgp-app-420416"):
    const FirebaseOptions(
      apiKey: 'AIzaSyBbhFT8Iq5hraD98_ZKQrLVO8K3j4s1Zdg',
      appId: '1:1030561817194:android:a7ee0504cc0047543fe013',
      messagingSenderId: '1030561817194',
      projectId: "cgp-app-420416",
    ),
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  Get.put(SocketService());
  Get.put(OngoingTripController());

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

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  static const platform = MethodChannel('com.yourdomain/navigation');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    platform.setMethodCallHandler(_handleNativeMethodCall);

    Get.put(HomeController());
    NotificationServices().requestNotificationPermission();
    NotificationServices().createNotificationChannel();
    NotificationServices.firebaseInit(context);
    NotificationServices().setupInterruptMessage(context);
    NotificationServices().getDeviceToken().then((value) {
      if (kDebugMode) {
        print("FCM token: $value");
      }
    });

    // Call the API when the app starts for the first time
    _callApiOnStartOrResume();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Call the API when the app resumes from the background
      _callApiOnStartOrResume();
    }
  }

  Future<void> _callApiOnStartOrResume() async {

    var token=await LocalServices.getToken();

    if(token!=null){
      var riderProfile=RiderProfileModel();
      var rider=RiderModel();
      var fcmToken=await NotificationServices().getDeviceToken();
      var endPoint=APIEndPoints.getUserData;
      try {
        var response=await RemoteServices.getRequest(endPoint: endPoint);
        riderProfile=RiderProfileModel.fromJson(response);
        rider=riderProfile.data??RiderModel();
        await LocalServices().storeUser(rider);

        print("fcmToken: $fcmToken");
        print("rider.activeDeviceToken: ${rider.activeDeviceToken}");

        if(fcmToken!=rider.activeDeviceToken){
          print("Device token does not matched");
        }

      } catch (e) {
        print('Error calling API: $e');
      }
    }
  }

  Future<void> _handleNativeMethodCall(MethodCall call) async {
    if (call.method == "navigateToOngoingTrip") {
      Get.toNamed(Routes.ONGOING_TRIP);
    }
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


 */

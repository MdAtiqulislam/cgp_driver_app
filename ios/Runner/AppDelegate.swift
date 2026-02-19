

import UIKit
import Flutter
import FirebaseCore
import GoogleMaps
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Initialize Firebase
    FirebaseApp.configure()

    GMSServices.provideAPIKey("AIzaSyBprY90fvqn9LQqEhe4mSIyDf1UekyT2Po")

    // Set UNUserNotificationCenter delegate
    UNUserNotificationCenter.current().delegate = self


      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions,
        completionHandler: { _, _ in }
      )

      application.registerForRemoteNotifications()



    // Register plugins
    GeneratedPluginRegistrant.register(with: self)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Handle notification presentation
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    completionHandler([.alert, .badge, .sound])
  }
}




/*


import Flutter
import UIKit
import GoogleMaps
import FirebaseCore
import FirebaseMessaging
import flutter_local_notifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Provide Google Maps API Key
    GMSServices.provideAPIKey("AIzaSyBprY90fvqn9LQqEhe4mSIyDf1UekyT2Po")
    
   

    // Set up notifications
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
    }
    
    // Register for remote notifications
    application.registerForRemoteNotifications()
      // Configure Firebase
    FirebaseApp.configure()
    
    // Register plugins
    GeneratedPluginRegistrant.register(with: self)
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Handle the presentation of notifications while the app is in the foreground
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    // Display the notification with alert, badge, and sound options
    completionHandler([.alert, .badge, .sound])
  }

  // Handle the user's interaction with the notification when it is received
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    // Process the response
    completionHandler()
  }

  // Called when APNs has assigned a device token to the app
  override func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    // Pass the device token to Firebase
    Messaging.messaging().apnsToken = deviceToken
  }

  // Handle error when failing to register for notifications
  override func application(
    _ application: UIApplication,
    didFailToRegisterForRemoteNotificationsWithError error: Error
  ) {
    print("Failed to register for remote notifications: \(error)")
  }
}
 */

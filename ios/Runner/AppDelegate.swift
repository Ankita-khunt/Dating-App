import UIKit
import Flutter
import FirebaseCore
import Firebase
import FirebaseMessaging
import GoogleMaps


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)
    GMSServices.provideAPIKey("AIzaSyCt5dvJis-NT3n9oBv_WRUh6MF_VI6xxJs")

      if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self
          
          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
                  options: authOptions,
                  completionHandler: {_, _ in })
//          //Setup VOIP
//                let mainQueue = DispatchQueue.main
//                let voipRegistry: PKPushRegistry = PKPushRegistry(queue: mainQueue)
//                voipRegistry.delegate = self
//                voipRegistry.desiredPushTypes = [PKPushType.voIP]
                
        
      }
      application.registerForRemoteNotifications()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

       
   
}

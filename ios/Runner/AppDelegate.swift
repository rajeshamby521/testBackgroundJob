import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    if #available(iOS 10, *) {

        //Notifications get posted to the function (delegate):  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: () -> Void)"


        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in

            guard error == nil else {
                //Display Error.. Handle Error.. etc..
                return
            }

            if granted {
                //Do stuff here..

                //Register for RemoteNotifications. Your Remote Notifications can display alerts now :)
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
            else {
                //Handle user denying permissions..
            }
        }

        //Register for remote notifications.. If permission above is NOT granted, all notifications are delivered silently to AppDelegate.
        application.registerForRemoteNotifications()
    }
    else {
        let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

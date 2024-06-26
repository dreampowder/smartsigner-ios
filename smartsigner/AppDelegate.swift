//
//  AppDelegate.swift
//  smartsigner
//
//  Created by Serdar Coskun on 20.09.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import FirebaseCrashlytics
import FirebaseMessaging
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var folderRefreshTimer:Timer?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        FirebaseApp.configure()
        Crashlytics.initialize()
        ThemeManager.applyDefaultTheme()
        Observers.session_ended_alert.addObserver(observer: self, selector: #selector(didReceiveLogoutNotification))
        URLCache.shared.removeAllCachedResponses()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let mainViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "MainViewController")
        let baseNavigation = BaseNavigationController(rootViewController: mainViewController)
        baseNavigation.isNavigationBarHidden = true
        self.window?.rootViewController = baseNavigation
        if #available(iOS 13.0, *) {
            self.window?.overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        self.window?.makeKeyAndVisible()
        
        Messaging.messaging().delegate = self
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        
//        var appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName")
//        print("appname: \(appName)")
//
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let sendingAppID = options[.sourceApplication]
        print("source application = \(sendingAppID ?? "Unknown")")
        
        guard let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
            let host = components.host,
            let items = components.queryItems else{
                return false
        }
        
        print("path = \(host)")
        items.forEach { (item) in
            print("ITEM: \(item.name), \(item.value ?? "<none>")")
            
        }
        if let guidItem = items.first(where: {$0.name == "GUID"}){
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                Observers.did_complete_ark_signer_sign.post(userInfo: [Observers.keys.sign_queue_guid : guidItem.value ?? "<not_found>", Observers.keys.ark_signer_action : host])
            }
        }
        return true
    }
    
    @objc func didReceiveLogoutNotification(){
        if let vc = self.window?.rootViewController{
            if let presented = vc.presentedViewController{
                presented.dismiss(animated: true) {
                    self.showLogoutAlert(vc:vc)
                }
            }else{
                showLogoutAlert(vc:vc)
            }
            
        }
    }
    
    func showLogoutAlert(vc:UIViewController){
        AlertDialogFactory.showBasicAlertFromViewController(vc: vc, title: LocalizedStrings.session_logout_title.localizedString(), message: LocalizedStrings.session_logout_message.localizedString(), doneButtonTitle: LocalizedStrings.ok.localizedString()) {
            Observers.logout.post(userInfo: nil)
        }
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return [.portrait,.landscape]
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {

  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo
    print("UserInfo: \(userInfo)")
    completionHandler([.alert,.badge,.sound])
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    // Print message ID.
    if let messageID = userInfo["gcmMessageIDKey"] {
      print("Message ID: \(messageID)")
    }

    // Print full message.
    print(userInfo)
    PushRoutingHandler.handlePushMessage(userInfo: userInfo)
    completionHandler()
  }
}

extension AppDelegate : MessagingDelegate {
//  // [START refresh_token]
//  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
////    print("Firebase registration token: \(fcmToken)")
////    let dataDict:[String: String] = ["token": fcmToken]
////    NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
//    // TODO: If necessary send token to application server.
//    // Note: This callback is fired at each app startup and whenever a new token is generated.
//  }
//  // [END refresh_token]
//  // [START ios_10_data_message]
//  // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
//  // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
//  func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
//    print("Received data message: \(remoteMessage.appData)")
//  }
//  // [END ios_10_data_message]
}

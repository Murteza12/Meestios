//
//  AppDelegate.swift
//  meestApp
//
//  Created by Yash on 8/4/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase
import SocketIO
import FirebaseMessaging
import PushKit

@available(iOS 13.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate, PKPushRegistryDelegate {
    
    var window: UIWindow?
    let manager = SocketManager.init(socketURL: URL.init(string: BASEURL.socketURL)!, config: [.compress,.log(true)])
    let gcmMessageIDKey = "gcm.message_id"
    var socket:SocketIOClient!
    var myViewController: RootBaseVC?
    
    var isUserHasLoggedInWithApp: Bool = true
    var checkForIncomingCall: Bool = true
    var userIsHolding: Bool = true
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        if UserDefaults.standard.string(forKey: "launch") == nil {
            UserDefaults.standard.set(true, forKey: "launch")
        } else {
            UserDefaults.standard.set(false, forKey: "launch")
        }
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateInitialViewController()
        APIManager.sharedInstance.getCurrentUser(vc: vc!) { (user) in
            if Token.sharedInstance.getToken() != "" {
                self.socket = self.manager.defaultSocket
                self.addHandlers(userid: user.id, username: user.username)
                self.socket.connect()
            }
        }
        
        
        
        print(try! Realm().configuration.fileURL?.absoluteString ?? "")
        UNUserNotificationCenter.current().delegate = self

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
        Messaging.messaging().delegate = self
        
        let viewAccept = UIMutableUserNotificationAction()
        viewAccept.identifier = "VIEW_ACCEPT"
        viewAccept.title = "Accept"
        viewAccept.activationMode = .foreground
        viewAccept.isDestructive = false
        viewAccept.isAuthenticationRequired =  false

        let viewDecline = UIMutableUserNotificationAction()
        viewDecline.identifier = "VIEW_DECLINE"
        viewDecline.title = "Decline"
        viewDecline.activationMode = .background
        viewDecline.isDestructive = true
        viewDecline.isAuthenticationRequired = false

            let INCOMINGCALL_CATEGORY = UIMutableUserNotificationCategory()
            INCOMINGCALL_CATEGORY.identifier = "INCOMINGCALL_CATEGORY"
        INCOMINGCALL_CATEGORY.setActions([viewAccept,viewDecline], for: .default)

        
        if application.responds(to:#selector(getter: UIApplication.isRegisteredForRemoteNotifications))
            {
                let categories = NSSet(array: [INCOMINGCALL_CATEGORY])
                let types:UIUserNotificationType = ([.alert, .sound, .badge])

                let settings:UIUserNotificationSettings = UIUserNotificationSettings(types: types, categories: categories as? Set<UIUserNotificationCategory>)

                application.registerUserNotificationSettings(settings)
                application.registerForRemoteNotifications()
            }

        
        else{
                let types: UIRemoteNotificationType = [.alert, .badge, .sound]
                application.registerForRemoteNotifications(matching: types)
        }


        //self.PushKitRegistration()
        
        return true
    }

    func PushKitRegistration()
    {

        let mainQueue: Never = dispatchMain()
        // Create a push registry object
        if #available(iOS 8.0, *) {

            let voipRegistry: PKPushRegistry = PKPushRegistry(queue: mainQueue as? DispatchQueue)

        // Set the registry's delegate to self

        voipRegistry.delegate = self

        // Set the push type to VoIP

            voipRegistry.desiredPushTypes = [PKPushType.voIP]

        } else {
        // Fallback on earlier versions
        }


    }
    func addHandlers(userid:String,username:String) {
        socket.on("connection") { data, ack in
            self.socket.on("connected") { data, ack in
                print(data)
                let data = data as! [[String:Any]]
                let msg = data[0]["msg"] as? String ?? ""
                print(msg)
            }
            
            let new = ["userId":userid,"name":username]
            self.socket.emitWithAck("createSession", new).timingOut(after: 20) {data in
                print(data)
                self.socket.on("session") { (dataa, ack) in
                    print(dataa)
                }
                return
            }
            return
        }
    }
    
    // MARK: - UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification
      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)
      // Print message ID.
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }

      // Print full message.
      print(userInfo)
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification
      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)
      // Print message ID.
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }

      // Print full message.
      print(userInfo)

      completionHandler(UIBackgroundFetchResult.newData)
    }
    // [END receive_message]
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
      print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")

      // With swizzling disabled you must set the APNs token here.
      // Messaging.messaging().apnsToken = deviceToken
    }
    
    // Receive displayed notifications for iOS 10 devices.
      func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo

        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
          print("Message ID: \(messageID)")
        }

        // Print full message.
//        print(userInfo)
//        let type = userInfo["type"] as? String ?? ""
//        let group = userInfo["group"] as? String ?? ""
//        let id = userInfo["id"] as? String ?? ""
//        let description = userInfo["description"] as? String ?? ""
//        let userId = userInfo["userId"] as? String ?? ""
//        UserDefaults.standard.set(id, forKey: "roomid")
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "forwardToAudioCall"), object: nil)
        // Change this to your preferred presentation option
        completionHandler([[.alert, .sound]])
      }

      func userNotificationCenter(_ center: UNUserNotificationCenter,didReceive response: UNNotificationResponse,withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
          print("Message ID: \(messageID)")
        }

        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print full message.
        print(userInfo)
        let type = userInfo["type"] as? String
        let group = userInfo["group"] as? String ?? ""
        let id = userInfo["id"] as? String ?? ""
        let description = userInfo["description"] as? String ?? ""
        let userId = userInfo["userId"] as? String ?? ""
        UserDefaults.standard.set(id, forKey: "roomid")
        if type == "Voice Call" {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "forwardToAudioCall"), object: nil)
        } else if type == "Video Call" {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "forwardToVideoCall"), object: nil)
        }
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "forwardToAudioCall"), object: nil)

        completionHandler()
    }
}
    // [END ios_10_message_handling]


@available(iOS 13.0, *)
extension AppDelegate:MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        let dataDict:[String: String] = ["token": fcmToken]
        UserDefaults.standard.set(fcmToken, forKey: "fcm")
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    func application(application: UIApplication,didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        Messaging.messaging().apnsToken = deviceToken as Data
    }
}

@available(iOS 13.0, *)
extension AppDelegate {
       
    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
        
    }
    
        func pushRegistry(registry: PKPushRegistry!, didUpdatePushCredentials credentials: PKPushCredentials!, forType type: String!) {
            // Register VoIP push token (a property of PKPushCredentials) with server

            //let hexString : String = UnsafeBufferPointer<UInt8>(start: UnsafePointer(credentials.token.bytes),
//count: credentials.token.length).map { String(format: "%02x", $0) }.joinWithSeparator("")

          //  print(hexString)


        }


        
        func pushRegistry(registry: PKPushRegistry!, didReceiveIncomingPushWithPayload payload: PKPushPayload!, forType type: String!) {

            // Process the received push

            // Below process is specific to schedule local notification once pushkit payload received

            var arrTemp = [NSObject : AnyObject]()
            //arrTemp = payload.dictionaryPayload

          //  let dict : Dictionary <String, AnyObject> = arrTemp["aps"] as! Dictionary<String, AnyObject>


            if isUserHasLoggedInWithApp // Check this flag then only proceed
            {

                if UIApplication.shared.applicationState == UIApplication.State.background || UIApplication.shared.applicationState == UIApplication.State.inactive
                {

                    if checkForIncomingCall // Check this flag to know incoming call or something else
                    {

                       // var strTitle : String = dict["alertTitle"] as? String ?? ""
                     //   let strBody : String = dict["alertBody"] as? String ?? ""
                      //  strTitle = strTitle + "\n" + strBody

                        let notificationIncomingCall = UILocalNotification()

                       // notificationIncomingCall.fireDate = NSDate(timeIntervalSinceNow: 1)
                      //  notificationIncomingCall.alertBody =  strTitle
                        notificationIncomingCall.alertAction = "Open"
                        notificationIncomingCall.soundName = "SoundFile.mp3"
                       // notificationIncomingCall.category = dict["category"] as? String ?? ""

                        //"As per payload you receive"
                        notificationIncomingCall.userInfo = ["key1": "Value1"  ,"key2": "Value2" ]


                        UIApplication.shared.scheduleLocalNotification(notificationIncomingCall)

                } else {
                    //  something else
                }
            }
        }
    }
}

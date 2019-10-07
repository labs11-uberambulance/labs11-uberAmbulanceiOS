//
//  AppDelegate.swift
//  BirthRide
//
//  Created by Austin Cole on 3/20/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import GoogleSignIn
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate, MessagingDelegate {
    
    var window: UIWindow?
    
    var kGCMMessageIDKey = "gcm.message_id"
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        UNUserNotificationCenter.current().delegate = self
        
       
        
        let rootViewController = WelcomeViewController()
        window!.rootViewController = rootViewController
        window!.makeKeyAndVisible()
        
        //Enable the GoogleMaps and GooglePlaces APIs
        GMSServices.provideAPIKey("AIzaSyBY0jPkmVWOOzWjj2jecBOdWhaer5LP8N8")
        GMSPlacesClient.provideAPIKey("AIzaSyBY0jPkmVWOOzWjj2jecBOdWhaer5LP8N8")
        
        //Use firebase library to configure APIs
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        //Set the FirebaseApp object as sign-in delegate for GoogleID
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.signOut()
        
        // Check if launched from notification
        let notificationOption = launchOptions?[.remoteNotification]
        
        // 1
        if let notification = notificationOption as? [String: AnyObject],
            let aps = notification["aps"] as? [String: AnyObject] {
            
            // 2
            AuthenticationController.shared.requestedRide = RequestedRide.createRideWithDictionary(dictionary: aps)
            
            // 3
            let newRootViewController: UIViewController = PhoneAuthorizationViewController()
            window?.rootViewController = newRootViewController
            
        }
        registerForPushNotifications()
        
        return true
    }
    //This method is calling the `handleURL` method of the GIDSignIn instance, which will properly handle the URL that the application receives at the end of the authentication process.
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    //This deprecated method is being used so that the app can run on iOS 8 and older with the GIDSignIn object
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    //MARK: GIDSignInDelegate methods
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            NSLog(error.localizedDescription)
            return
        }
        
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        // ...
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                // ...
                return
            }
            
            
            let accessToken = signIn.currentUser.authentication.idToken
            AuthenticationController.shared.userToken = accessToken
            AuthenticationController.shared.authenticateUser()
        }
        
        func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
            // Perform any operations when the user disconnects from app here.
            // ...
            signIn.signOut()
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        }
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo["gcmMessageIDKey"] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
        ) {
        Messaging.messaging().setAPNSToken(deviceToken, type: .sandbox)
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        UserDefaults.standard.setValue(token, forKey: "deviceToken")
    }
    
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler completionHandler:
        @escaping (UIBackgroundFetchResult) -> Void
        ) {
        guard let aps = userInfo["aps"] as? [String: [String: AnyObject]] else {
            completionHandler(.failed)
            return
        }
        AuthenticationController.shared.requestedRide = RequestedRide.createRideWithDictionary(dictionary: aps["data"] as! [String : AnyObject])
        completionHandler(.newData)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        UserDefaults.standard.set(userInfo, forKey: "UserInfoKey")
        AuthenticationController.shared.requestedRide = RequestedRide.createRideWithDictionary(dictionary: userInfo as! [String : AnyObject])
    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        
        let dataDict:[String: String] = ["token": fcmToken]
        UserDefaults.standard.set(dataDict, forKey: "FCMToken")
 
        
    }
    
    private func registerForPushNotifications() {
        UNUserNotificationCenter.current() // 1
            .requestAuthorization(options: [.alert, .sound, .badge]) { // 2
                granted, error in
                print("Permission granted: \(granted)") // 3
                guard granted else { return }
                // 1
                let viewAction = UNNotificationAction(
                    identifier: "viewAction", title: "View",
                    options: [.foreground])
                
                // 2
                let rideCategory = UNNotificationCategory(
                    identifier: "rideCategory", actions: [viewAction],
                    intentIdentifiers: [], options: [])
                
                // 3
                UNUserNotificationCenter.current().setNotificationCategories([rideCategory])
                self.getNotificationSettings()
        }
    }
    private func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
}






extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void) {
        let audioPlayer = AudioPlayer()
        // 1
        let userInfo = response.notification.request.content.userInfo
        UserDefaults.standard.set(userInfo, forKey: "UserInfoKey")
        AuthenticationController.shared.requestedRide = RequestedRide.createRideWithDictionary(dictionary: userInfo as! [String : AnyObject])
        // 2
//        if let aps = userInfo["aps"] as? [String: [String: AnyObject]] {
//            rootViewController.ride = RequestedRide.createRideWithDictionary(dictionary: aps["data"] as! [String : AnyObject]) as RequestedRide?
//            window?.rootViewController = rootViewController
//        }
        // 4
        completionHandler()
    }
}

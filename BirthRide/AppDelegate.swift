//
//  AppDelegate.swift
//  BirthRide
//
//  Created by Austin Cole on 3/20/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        
        
        let tabBarController = UITabBarController()
        
        let signUpViewController = SignUpViewController()
        
        let signInViewController = SignInViewController()
        
        tabBarController.addChild(signInViewController)
        tabBarController.addChild(signUpViewController)
        
        let signUpItem = UITabBarItem()
        signUpItem.title = "Sign Up"
        let signInItem = UITabBarItem()
        signInItem.title = "Sign In"
        
        signUpViewController.tabBarItem = signUpItem
        signInViewController.tabBarItem = signInItem
        
        
        let rootViewController = tabBarController
        window!.rootViewController = rootViewController
        window!.makeKeyAndVisible()
        
        //Enable the GoogleMaps and GooglePlaces APIs
        GMSServices.provideAPIKey("AIzaSyBY0jPkmVWOOzWjj2jecBOdWhaer5LP8N8")
        GMSPlacesClient.provideAPIKey("AIzaSyBY0jPkmVWOOzWjj2jecBOdWhaer5LP8N8")
        
        //Use firebase library to configure APIs
        FirebaseApp.configure()
        
        //Set the FirebaseApp object as sign-in delegate for GoogleID
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.signOut()
        
        
        
        
        
        
        
        
        return true
    }
    //This method is calling the `handleURL` method of the GIDSignIn instance, which will properly handle the URL that the application receives at the end of the authentication process.
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: [:])
    }
    
    //This deprecated method is being used so that the app can run on iOS 8 and older with the GIDSignIn object
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
    }
    
    //MARK: GIDSignInDelegate methods
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            NSLog(error.localizedDescription)
            return
        }
        
        
        guard let authentication = user.authentication else { return }
        AuthenticationController.shared.userToken = authentication.accessToken
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        // ...
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                // ...
                return
            }
            
            
            let accessToken = signIn.currentUser.authentication.accessToken
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
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
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
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
}

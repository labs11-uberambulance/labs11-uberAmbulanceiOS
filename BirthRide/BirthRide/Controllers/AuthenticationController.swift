//
//  AuthenticationController.swift
//  BirthRide
//
//  Created by Austin Cole on 3/27/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

@objcMembers
class AuthenticationController {
    
    //MARK: Singleton
    ///This property is the shared singleton instance of the class.
    static let shared = AuthenticationController()
    private init() {}
    
    //MARK: Public Properties
    public var pregnantMom: PregnantMom?
    public var driver: Driver?
    public var genericUser: User?
    public var motherStartLatLong: NSString?
    
    public var userID: NSNumber?
    public var userToken: String?
    public var FCMToken: String?
    
    public var isNewUser: Bool?
    
    
    //MARK: Private Properties
    // I am not sure if this variable belongs here. This is the ride data the app will receive via push notifications from the server. You need to be authenticated to receive this, but you have to be authenticated to do anything beyond signing in, so that's not a very good reason. Anyway, here it is until I find a better place for it.
    public var requestedRide: RequestedRide? {
        didSet {
            NotificationCenter.default.post(name: .didReceiveRideRequest, object: nil)
        }
    }
    
    
    
    /// This method will do all of the networking with Firebase and the BirthRide server to authenticate the user, either whether the user is signing in or signing up. It uses a boolean, isSigningUp, to decide how to authenticate the user.
    ///
    /// - Parameters:
    ///   - email: The email entered by the user to authenticate.
    ///   - password: The password entered by the user to authenticate.
    ///   - viewController: The viewController calling the method.
    public func authenticateUser() {
        authenticationNetworkingRequest()
    }
    
    public func deauthenticateUser() {
        userToken = nil
        driver = nil
        motherStartLatLong = nil
        pregnantMom = nil
        genericUser = nil
        requestedRide = nil
        UserDefaults.standard.set("", forKey: "authVerificationID")
    }
    
    
    
    
    public func authenticateUserSignIn(email: String, password: String, viewController: UIViewController) {
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            if email == "" || password == "" {
                return
            }
            if let error = error {
                NSLog("%@",error.localizedDescription)
                return
            }
            if let user = authDataResult?.user {
                self.userToken = user.uid
                self.authenticateUser()
            }
        }
        
    }
    
    public func authenticateUserSignUp(email: String, password: String,viewController: UIViewController) {
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            if email == "" || password == "" {
                return
            }
            if let error = error {
                NSLog("%@",error.localizedDescription)
                return
            }
            if let user = authDataResult?.user {
                self.userToken = user.uid
                self.authenticateUser()
            }
        }
    }


    
    
    
    /// This method will perform a networking request to authenticate with the back-end. The networking request returns a userArray. From this userArray the user and driver/pregnantMom properties of the AuthenticationController are populated.
    ///
    /// - Parameter viewController: This UIViewControllerProperty is used to determine the viewController in which the error messages should be displayed.
    private func authenticationNetworkingRequest() {
        //        let backgroundOperationQueue = OperationQueue()
        //        backgroundOperationQueue.addOperation({
        guard let userToken = userToken else {return}
        ABCNetworkingController().authenticateUser(withToken: userToken, withCompletion: { (error, userArray, userType)  in
            if let error = error {
                NSLog("error in AuthenticationController.authenticateUserSignIn.")
                NSLog("%@", error.localizedDescription)
                return
            }
            guard let userArray = userArray else {
                NSLog("user is nil in AuthenticationController.authenticateUserSignIn.")
                return
            }
            guard let userType = userType else {
                NSLog("userType is nil in AuthenticationController.authenticateUserSignIn.")
                return
            }
            self.genericUser = userArray[0] as? User
            self.userID = self.genericUser?.userId
            switch userType {
            case "drivers":
                self.driver = userArray[1] as? Driver
            case "mothers":
                self.pregnantMom = userArray[1] as? PregnantMom
            default:
                break
            }
            
            //            })
        })
    }
    
}

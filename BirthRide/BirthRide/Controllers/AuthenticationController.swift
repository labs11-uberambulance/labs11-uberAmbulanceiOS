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
    
    //MARK: Private Properties
    public var pregnantMom: PregnantMom?
    public var driver: Driver?
    public var genericUser: User?
    public var motherStartLatLong: NSString?
    
    public var userToken: String?

    public var requestedRide: RequestedRide?
    
    
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
    }
    
    /// This method will perform a networking request to authenticate with the back-end. The networking request returns a userArray. From this userArray the user and driver/pregnantMom properties of the AuthenticationController are populated.
    ///
    /// - Parameter viewController: This UIViewControllerProperty is used to determine the viewController in which the error messages should be displayed.
    private func authenticationNetworkingRequest() {
//        let backgroundOperationQueue = OperationQueue()
//        backgroundOperationQueue.addOperation({
            guard let userToken = self.userToken else {return}
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

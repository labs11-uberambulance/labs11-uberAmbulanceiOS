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

enum LoginErrorType {
    case invalidInformation
    case requiredFieldsEmpty
    case otherError
}

class AuthenticationController {
    
    //MARK: Singleton
    ///This property is the shared singleton instance of the class.
    static let shared = AuthenticationController()
    private init() {}
    
    //MARK: Private Properties
    public var pregnantMom: PregnantMom?
    public var driver: Driver?
    public var genericUser: User?
    
    public var userToken: String?
    
    
    /// This method displays an error message.
    ///
    /// - Parameters:
    ///   - errorType: The type of error. This property takes an enum case to switch between different error messages.
    ///   - viewController: The viewController calling the method.
    public func displayErrorMessage(errorType: LoginErrorType, viewController: UIViewController) {
        switch errorType {
        case .invalidInformation:
            presentInvalidInformationAlert(viewController: viewController)
        case .otherError:
            presentOtherLoginErrorAlert(viewController: viewController)
        case .requiredFieldsEmpty:
            presentRequiredFieldsEmpty(viewController: viewController)
        }
        
        
    }
    
    
    /// This method will do all of the networking with Firebase and the BirthRide server to authenticate the user, either whether the user is signing in or signing up. It uses a boolean, isSigningUp, to decide how to authenticate the user.
    ///
    /// - Parameters:
    ///   - email: The email entered by the user to authenticate.
    ///   - password: The password entered by the user to authenticate.
    ///   - viewController: The viewController calling the method.
    public func authenticateUser(viewController: UIViewController) {
        authenticationNetworkingRequest(viewController: viewController)
    }
    
    //MARK: Private Methods
    private func presentInvalidInformationAlert(viewController: UIViewController) {
        let alert = UIAlertController(title: "Alert", message: "Your login information was invalid. Please try again or sign up for an account.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    private func presentOtherLoginErrorAlert(viewController: UIViewController) {
        let alert = UIAlertController(title: "Alert", message: "There was an error processing the information. Please try again.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    private func presentRequiredFieldsEmpty(viewController: UIViewController) {
        let alert = UIAlertController(title: "Alert", message: "It is required to fill out all fields. Please try again.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    /// This method will perform a networking request to authenticate with the back-end. The networking request returns a userArray. From this userArray the user and driver/pregnantMom properties of the AuthenticationController are populated.
    ///
    /// - Parameter viewController: This UIViewControllerProperty is used to determine the viewController in which the error messages should be displayed.
    private func authenticationNetworkingRequest(viewController: UIViewController) {
        let backgroundOperationQueue = OperationQueue()
        backgroundOperationQueue.addOperation({
            guard let userToken = self.userToken else {return}
            ABCNetworkingController().authenticateUser(withToken: userToken, withCompletion: { (error, userArray, userType)  in
                if let error = error {
                    AuthenticationController.shared.displayErrorMessage(errorType: .otherError, viewController: viewController)
                    NSLog("%@", error.localizedDescription)
                }
                guard let userArray = userArray else {
                    
                    AuthenticationController.shared.displayErrorMessage(errorType: .otherError, viewController: viewController)
                    NSLog("user is nil in AuthenticationController.authenticateUserSignIn.")
                    return
                }
                guard let userType = userType else {
                    AuthenticationController.shared.displayErrorMessage(errorType: .otherError, viewController: viewController)
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
                
            })
        })
    }
}

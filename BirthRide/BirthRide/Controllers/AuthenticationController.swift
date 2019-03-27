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

    ///This property is used by the class to decide how to authenticate the user.
    var isSigningUp: Bool = false
    
    
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
    public func authenticateUser(email: String, password: String, viewController: UIViewController) {
        switch AuthenticationController.shared.isSigningUp {
        case true:
            authenticateUserSignUp(email: email, password: password, viewController: viewController)
        case false:
            authenticateUserSignIn(email: email, password: password, viewController: viewController)
        }
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
    
    private func authenticateUserSignIn(email: String, password: String, viewController: UIViewController) {
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            if email == "" || password == "" {
                AuthenticationController.shared.displayErrorMessage(errorType: .requiredFieldsEmpty, viewController: viewController)
                return
            }
            if let error = error {
                NSLog("%@",error.localizedDescription)
                AuthenticationController.shared.displayErrorMessage(errorType: .invalidInformation, viewController: viewController)
                return
            }
            if let user = authDataResult?.user {
                ABCNetworkingController().authenticateUser(withToken: user.uid, withCompletion: { (error) in
                    //FIXME: This method should return a user. Need to edit it so that it can do that.
                    if let error = error {
                        AuthenticationController.shared.displayErrorMessage(errorType: .otherError, viewController: viewController)
                        NSLog("%@", error.debugDescription)
                    }
                })
            }
        }
        
    }
    
    private func authenticateUserSignUp(email: String, password: String,viewController: UIViewController) {
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            if email == "" || password == "" {
                AuthenticationController.shared.displayErrorMessage(errorType: .requiredFieldsEmpty, viewController: viewController)
                return
            }
            if let error = error {
                NSLog("%@",error.localizedDescription)
                AuthenticationController.shared.displayErrorMessage(errorType: .invalidInformation, viewController: viewController)
                return
            }
            if let user = authDataResult?.user {
                ABCNetworkingController().authenticateUser(withToken: user.uid, withCompletion: { (error) in
                    //FIXME: This method should return a user. Need to edit it so that it can do that.
                    if let error = error {
                        AuthenticationController.shared.displayErrorMessage(errorType: .otherError, viewController: viewController)
                        NSLog("%@", error.debugDescription)
                    }
                })
            }
        }
    }

}

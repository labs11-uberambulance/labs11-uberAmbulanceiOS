//
//  GoogleIDAuthorizationViewController.swift
//  BirthRide
//
//  Created by Austin Cole on 3/26/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import UIKit
import GoogleSignIn

class GoogleIDAuthorizationViewController: UIViewController, GIDSignInUIDelegate, TransitionBetweenViewControllers {
    
    //MARK: Private Properties
    private var genericUser: User?
    private var gidSignInButton: GIDSignInButton?
    private var gestureRecognizer: UITapGestureRecognizer?
    //MARK: IBOutlets
    @IBOutlet weak var configureView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.signIn()
        
        
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        //        transition(userType: nil)
    }
    //MARK: TransitionBetweenViewControllers methods
    func transition(userType: UserType?) {
        if AuthenticationController.shared.driver == nil && AuthenticationController.shared.pregnantMom == nil {
            let destinationVC = UserTypeViewController()
            self.present(destinationVC, animated: true) {
            }
        } else if AuthenticationController.shared.driver != nil {
            let destinationVC = DriverWorkViewController()
        } else if AuthenticationController.shared.pregnantMom != nil {
            let destinationVC = RequestRideViewController()
            self.present(destinationVC, animated: true) {
            }
        }
    }
    
    
    //MARK: GIDSignInDelegate Methods

}

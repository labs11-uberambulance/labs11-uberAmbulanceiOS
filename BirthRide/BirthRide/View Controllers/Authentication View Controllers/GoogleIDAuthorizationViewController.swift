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
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance()?.signInSilently()
        
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        transition(userType: nil)
        //        transition(userType: nil)
    }
    
    
    //MARK: Private Methods
    private func configureGIDSignInButton() {
        gidSignInButton = GIDSignInButton()
        gidSignInButton?.frame = configureView.frame
        gidSignInButton?.colorScheme = .dark
        gidSignInButton?.style = .standard
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(gidSignInButton!)
        gidSignInButton?.addGestureRecognizer(gestureRecognizer!)
        
    }
    
    //MARK: TransitionBetweenViewControllers methods
    func transition(userType: UserType?) {
        if AuthenticationController.shared.driver == nil && AuthenticationController.shared.pregnantMom == nil {
            let destinationVC = UserTypeViewController()
            destinationVC.user = self.genericUser
            self.present(destinationVC, animated: true) {
            }
        } else if AuthenticationController.shared.driver != nil {
            let destinationVC = RequestOrSearchDriverViewController()
        } else if AuthenticationController.shared.pregnantMom != nil {
            let destinationVC = RequestOrSearchDriverViewController()
            destinationVC.pregnantMom = AuthenticationController.shared.pregnantMom
            self.present(destinationVC, animated: true) {
            }
        }
    }
    
    //I need the GIDSignInUIDelegate because I need to know when the sign-in occurs to get the accessToken from the GIDSignIn object that I may perform authentication.
}

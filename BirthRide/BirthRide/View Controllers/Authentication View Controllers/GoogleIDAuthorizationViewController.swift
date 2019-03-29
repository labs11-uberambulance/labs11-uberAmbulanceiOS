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
//        gidSignInButton?.addTarget(self, action: , for: )
        
    }
    @objc private func gidSignInButtonTapped() {
        NSLog("hooray")
    }
    
    //MARK: TransitionBetweenViewControllers methods
    func transition(userType: UserType?) {
        let destinationVC = OnboardingViewController()
        destinationVC.user = self.genericUser
        self.present(destinationVC, animated: true) {
        }
    }
    
    //MARK: GIDSignInUIDelegate Methods


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

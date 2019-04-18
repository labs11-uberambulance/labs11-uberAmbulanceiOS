//
//  WelcomeViewController.swift
//  BirthRide
//
//  Created by Austin Cole on 4/18/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    //mark: IBActions
    @IBAction func nextButtonTapped(_ sender: Any) {
    }
    
    //MARK:Private Methods
    private func transitionToAuthentication() {
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
        
        
        let destinationVC = tabBarController
        
        present(destinationVC, animated: true, completion: nil)
    }

}

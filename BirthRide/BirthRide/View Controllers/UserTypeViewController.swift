//
//  UserTypeViewController.swift
//  BirthRide
//
//  Created by Austin Cole on 3/21/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import UIKit

class UserTypeViewController: UIViewController, TransitionBetweenViewControllers {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    //MARK: IBActions
    @IBAction func driverButtonTapped(_ sender: Any) {
        transition(userType: UserType.driver)
    }
    @IBAction func pregnantMomButtonTapped(_ sender: Any) {
        transition(userType: UserType.pregnantMom)
    }

    
    func transition(userType: UserType?) {
        let tabBarController = UITabBarController()
        
        let onboardingViewController = OnboardingViewController()
        onboardingViewController.userType = userType
        
        let signInViewController = SignInViewController()
        signInViewController.userType = userType
        
        tabBarController.addChild(signInViewController)
        tabBarController.addChild(onboardingViewController)
        
        let onboardingItem = UITabBarItem()
        onboardingItem.title = "Sign Up"
        let signInItem = UITabBarItem()
        signInItem.title = "Sign In"
        
        onboardingViewController.tabBarItem = onboardingItem
        signInViewController.tabBarItem = signInItem
        
        self.present(tabBarController, animated: true) {
            onboardingViewController.awakeFromNib()
            signInViewController.awakeFromNib()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

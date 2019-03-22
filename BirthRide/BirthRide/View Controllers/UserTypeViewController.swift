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
        transition()
    }
    @IBAction func pregnantMomButtonTapped(_ sender: Any) {
        transition()
    }
    @IBAction func caregiverButtonTapped(_ sender: Any) {
        transition()
    }
    
    func transition() {
        let tabBarController = UITabBarController()
        
        let signUpViewController = SignUpViewController()
        let signInViewController = SignInViewController()
        
        tabBarController.addChild(signUpViewController)
        tabBarController.addChild(signInViewController)
        
        let signUpItem = UITabBarItem()
        signUpItem.title = "Sign Up"
        tabBarController.tabBar.setItems([signUpItem], animated: true)
        
        self.present(tabBarController, animated: true) {
            signUpViewController.awakeFromNib()
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

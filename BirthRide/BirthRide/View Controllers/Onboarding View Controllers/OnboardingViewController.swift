//
//  SignUpViewController.swift
//  BirthRide
//
//  Created by Austin Cole on 3/21/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import UIKit

///This ViewController should be embedded in a TabBarViewController along with the SignInViewController
class OnboardingViewController: UIViewController {
    
    //MARK: IBOutlets
    ///This is not a true containerView. Here we are going to add the view of the intended viewController as a subView
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewControllerAndView()
        // Do any additional setup after loading the view.
    }
    
    func setUpViewControllerAndView() {
        if AuthenticationController.shared.genericUser?.userType == "drivers" {
            let containerViewController = DriverRegistrationViewController()
            containerViewController.isUpdating = false
            containerView.addSubview((containerViewController.view)!)
        }
        else {
            let containerViewController = MotherOrCaretakerRegistrationViewController()
            containerViewController.isUpdating = false
            containerView.addSubview((containerViewController.view)!)
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

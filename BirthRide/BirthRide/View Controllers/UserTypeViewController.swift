//
//  UserTypeViewController.swift
//  BirthRide
//
//  Created by Austin Cole on 3/21/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import UIKit

class UserTypeViewController: UIViewController, TransitionBetweenViewControllers {
    
    //MARK: Other Properties
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: IBActions
    @IBAction func driverButtonTapped(_ sender: Any) {
        transition(userType: UserType.drivers)
    }
    @IBAction func pregnantMomButtonTapped(_ sender: Any) {
        transition(userType: UserType.pregnantMom)
    }
    
    
    func transition(userType: UserType?) {
        AuthenticationController.shared.genericUser = User(userID: nil, name: nil, login: nil, firebaseId: nil, phone: nil, userType: nil, address: nil, village: nil, latitude: nil, longitude: nil, email: nil, location: nil)
        AuthenticationController.shared.genericUser?.userType = userType?.rawValue as NSString?
        let destinationVC = OnboardingViewController()
        self.present(destinationVC, animated: true) {
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

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
    
    //MARK: IBOutlets
    @IBOutlet weak var gidSignInView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        transition(userType: nil)
    }
    
    //MARK: TransitionBetweenViewControllers methods
    func transition(userType: UserType?) {
        let userTypeViewController = UserTypeViewController()
        userTypeViewController.user = self.genericUser
        self.present(userTypeViewController, animated: true) {
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

//
//  EmailAuthorizationViewController.swift
//  BirthRide
//
//  Created by Austin Cole on 3/26/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import UIKit

class EmailAuthorizationViewController: UIViewController, TransitionBetweenViewControllers {
    //MARK: Private Properties
    private var genericUser: User?    

    //MARK: IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    //MARK: IBActions
    @IBAction func doneButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {return}
        AuthenticationController.shared.authenticateUser(email: email, password: password, viewController: self)
        transition(userType: nil)
    }
    
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

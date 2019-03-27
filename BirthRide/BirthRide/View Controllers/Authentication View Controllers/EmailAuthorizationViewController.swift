//
//  EmailAuthorizationViewController.swift
//  BirthRide
//
//  Created by Austin Cole on 3/26/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import UIKit
import Firebase

//We should take this enum out of this file and put it into a seperate class with the displayAlert methods.


class EmailAuthorizationViewController: UIViewController {
    //MARK: Private Properties
    private var genericUser: User?
    private var networkingController: ABCNetworkingController?
    

    //MARK: IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        networkingController = ABCNetworkingController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    //MARK: IBActions
    @IBAction func doneButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {return}
        authenticateUser(email: email, password: password)
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

//
//  DriverRegistrationViewController.swift
//  BirthRide
//
//  Created by Austin Cole on 3/21/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import UIKit

class DriverRegistrationViewController: UIViewController, TransitionBetweenViewControllers {
    
    //MARK: Private Properties
    private var driver: Driver?
    
    
    //MARK: IBOutlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var bioTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func continueButtonTapped(_ sender: Any) {
        guard let driver = driver else {return}
        UserController().updateDriver(driver: driver, viewController: self, name: nameTextField.text, address: addressTextField.text, email: emailTextField.text, phoneNumber: phoneNumberTextField.text, priceString: priceTextField.text, bio: bioTextView.text)
        transition(userType: nil)
    }
    
    func transition(userType: UserType?) {
        let generalUserRegistrationViewController = GeneralUserRegistrationViewController()
        generalUserRegistrationViewController.driver = driver
        self.present(generalUserRegistrationViewController, animated: true) {
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

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
        setupKeyboardDismissRecognizer()

        // Do any additional setup after loading the view.
    }
    @IBAction func continueButtonTapped(_ sender: Any) {
        UserController().updateDriver(viewController: self, name: nameTextField.text, address: addressTextField.text, email: emailTextField.text, phoneNumber: phoneNumberTextField.text, priceString: priceTextField.text, bio: bioTextView.text, photo: nil)
        transition(userType: nil)
    }
    
    func transition(userType: UserType?) {
        let driverPhotoRegistrationViewController = DriverPhotoRegistrationViewController()
        self.present(driverPhotoRegistrationViewController, animated: true) {
        }
    }
    
    //MARK: Private Methods
    private func setupKeyboardDismissRecognizer(){
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.dismissKeyboard))
        
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc
    private func dismissKeyboard()
    {
        view.endEditing(true)
    }
}

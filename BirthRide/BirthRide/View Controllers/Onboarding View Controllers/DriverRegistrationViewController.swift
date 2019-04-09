//
//  DriverRegistrationViewController.swift
//  BirthRide
//
//  Created by Austin Cole on 3/21/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import UIKit

class DriverRegistrationViewController: UIViewController, TransitionBetweenViewControllers {
    
    //MARK: Other Properties
    var driver: Driver?
    
    
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
        populateLabelsAndTextFields()

        // Do any additional setup after loading the view.
    }
    @IBAction func continueButtonTapped(_ sender: Any) {
        
        guard let name = nameTextField?.text,
            let address = addressTextField.text,
            let email = emailTextField.text,
            let phoneNumber = phoneNumberTextField.text,
            let price = priceTextField.text,
            let bio = bioTextView.text else {
                return
        }
        
        let otherName = name as NSString
        let otherAddress = address as NSString
        let otherEmail = email as NSString
        let otherPhone = phoneNumber as NSString
        let otherPrice = price as NSString
        let otherBio = bio as NSString
        
        UserController().updateDriver(viewController: self, name: otherName, address: otherAddress, email: otherEmail, phoneNumber: otherPhone, priceString: otherPrice, bio: otherBio, photo: nil)
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
    
    private func populateLabelsAndTextFields() {
        if let driver = driver,
            let user = AuthenticationController.shared.genericUser {
            priceTextField.text = driver.price?.stringValue
            bioTextView.text = driver.bio as String?
            phoneNumberTextField.text = user.phone as String?
            nameTextField.text = user.name as String?
        }
    }
}

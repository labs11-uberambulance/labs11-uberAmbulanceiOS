//
//  PhoneAuthorizationViewController.swift
//  BirthRide
//
//  Created by Austin Cole on 3/26/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import UIKit
import Firebase

//Right now we are using reCAPTCHA verification. To enable Apple Push Notifications, we need to use an Apple Developer Program member account, which costs money.

class PhoneAuthorizationViewController: UIViewController, TransitionBetweenViewControllers {
    //MARK: Private Properties
    private let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
    
    //MARK: IBOutlets
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardDismissRecognizer()
        
        // Do any additional setup after loading the view.
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showPhoneAuthAlert()
    }
    @IBAction func doneButtonTapped(_ sender: Any) {
        if AuthenticationController.shared.genericUser == nil {
            if doneButton.titleLabel?.text == "Continue" {
                let phoneNumber = phoneNumberTextField.text
                verifyPhoneNumber(phoneNumber: phoneNumber!)
                phoneNumberTextField.placeholder = "Verification Code"
                doneButton.setTitle("Done", for: .normal)
            } else {
                let verificationCode = phoneNumberTextField.text
                verifyAuthenticationCodeAndID(verificationCode: verificationCode)
            }
        } else {
            transition(userType: nil)
        }
    }
    
    //MARK: Private Methods
    private func verifyPhoneNumber(phoneNumber: String?) {
        guard phoneNumber != "" else {
            return
        }
        PhoneAuthProvider.provider().verifyPhoneNumber("+1\(phoneNumber!)", uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                NSLog("%@", error.localizedDescription)
                return
            }
            if let newVerifcationID = verificationID {
                UserDefaults.standard.set(newVerifcationID, forKey: "authVerificationID")
            }
            
        }
    }
    
    private func verifyAuthenticationCodeAndID(verificationCode: String?) {
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
        guard verificationID != nil else {return}
        guard verificationCode != "" else {return}
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID!,
            verificationCode: verificationCode!)
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                NSLog("Error in PhoneAuthorizationViewController.verifyAuthenticationCodeAndID")
                NSLog("%@", error.localizedDescription)
                return
            }
            guard let authResult = authResult else {return}
            
            authResult.user.getIDToken(completion: { (idToken, error) in
                if let error = error {
                    NSLog("Error in PhoneAuthorizationViewController.verifyAuthenticationCodeandID")
                    NSLog(error.localizedDescription)
                    return
                }
                guard let idToken = idToken else {
                    NSLog("idToken is nil in PhoneAuthorizationViewController.verifyAuthenticationCodeandID")
                    return
                }
                AuthenticationController.shared.userToken = idToken
                
                AuthenticationController.shared.authenticateUser()
                
                DispatchQueue.main.async {
                    self.transition(userType: nil)
                }
            })
        }
    }
    
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
    
    private func showPhoneAuthAlert() {
        var phoneAuthAlert = UIAlertController(title: "Phone Number", message: "Please enter your phone number in the field provided.", preferredStyle: .alert)
        phoneAuthAlert.addTextField { (textField) in
            textField.placeholder = "Phone Number Here"
        }
        let startOverAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        let phoneAuthAction = UIAlertAction(title: "Continue", style: .default) { (alertAction) in
            
            let phoneNumber = phoneAuthAlert.textFields?[0].text
            self.verifyPhoneNumber(phoneNumber: phoneNumber)
            
            phoneAuthAlert = UIAlertController(title: "Verification Number", message: "Please check your phone's text messages for a verification number. Then, enter the verification number in the provided field. If you do not receive a text message, please try again.", preferredStyle: .alert)
            phoneAuthAlert.addTextField(configurationHandler: { (textField) in
                textField.placeholder = "Verification Number Here"
            })
            phoneAuthAlert.addAction(startOverAction)
            phoneAuthAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (alertAction) in
                let verificationNumber = phoneAuthAlert.textFields?[0].text
                self.verifyAuthenticationCodeAndID(verificationCode: verificationNumber)
            }))
            self.present(phoneAuthAlert, animated: true, completion: nil)
        }
        
        phoneAuthAlert.addAction(phoneAuthAction)
        present(phoneAuthAlert, animated: true, completion: nil)
    }
    
    
    
    //MARK: TransitionBetweenViewControllersDelegate methods
    func transition(userType: UserType?) {
        self.dismiss(animated: true, completion: nil)
        if AuthenticationController.shared.driver == nil && AuthenticationController.shared.pregnantMom == nil {
            let destinationVC = UserTypeViewController()
            present(destinationVC, animated: true, completion: nil)
            } else if AuthenticationController.shared.driver != nil {
            let destinationVC = DriverWorkViewController()
            present(destinationVC, animated: true, completion: nil)
        } else if AuthenticationController.shared.pregnantMom != nil {
            let destinationVC = RequestRideViewController()
            present(destinationVC, animated: true, completion: nil)
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

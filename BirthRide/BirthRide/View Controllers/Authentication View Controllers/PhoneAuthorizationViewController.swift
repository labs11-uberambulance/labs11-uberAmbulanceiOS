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
    //FIXME: In order to receive the SMS with the authentication code, the user must put their country code in front. For the US, that means that all mobile US numbers must be preceded by "+1". I should programatically make sure that the number has the relevant country code at the beginning and, if it doesn't, I should add it before using it in the method.
    private func verifyPhoneNumber(phoneNumber: String?) {
        guard phoneNumber != "" else {
            return
        }
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber!, uiDelegate: nil) { (verificationID, error) in
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
    
    
    
    //MARK: TransitionBetweenViewControllersDelegate methods
    func transition(userType: UserType?) {
        if AuthenticationController.shared.driver == nil && AuthenticationController.shared.pregnantMom == nil {
            let destinationVC = UserTypeViewController()
            self.present(destinationVC, animated: true) {
            }
        } else if AuthenticationController.shared.driver != nil {
            let destinationVC = DriverWorkViewController()
            self.present(destinationVC, animated: true, completion: nil)
        } else if AuthenticationController.shared.pregnantMom != nil {
            let destinationVC = RequestRideViewController()
            self.present(destinationVC, animated: true, completion: nil)
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

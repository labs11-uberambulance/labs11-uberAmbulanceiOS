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
enum LoginErrorType {
    case invalidInformation
    case otherError
}

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
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            if let error = error {
                NSLog("%@",error.localizedDescription)
                self.displayErrorMessage(errorType: .invalidInformation)
            }
            else if let user = authDataResult?.user {
                self.networkingController?.authenticateUser(withToken: user.uid, withCompletion: { (error) in
                    //This method should return a user. Need to edit it so that it can do that.
                    if let error = error {
                        self.displayErrorMessage(errorType: .otherError)
                        NSLog("%@", error.debugDescription)
                    }
                })
            }
        }
    }
    
    //We should pull these methods out of this file and put them in a seperate class with the LoginErrorType enum.
    func displayErrorMessage(errorType: LoginErrorType) {
        switch errorType {
        case .invalidInformation:
            presentInvalidInformationAlert()
        case .otherError:
            presentOtherLoginErrorAlert()
        }
        
    }
    func presentInvalidInformationAlert() {
        let alert = UIAlertController(title: "Alert", message: "Your login information was invalid. Please try again or sign up for an account.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func presentOtherLoginErrorAlert() {
        let alert = UIAlertController(title: "Alert", message: "There was an error processing the information. Please try again.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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

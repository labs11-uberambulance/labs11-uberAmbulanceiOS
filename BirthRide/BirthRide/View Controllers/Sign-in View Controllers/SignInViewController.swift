//
//  SignInViewController.swift
//  BirthRide
//
//  Created by Austin Cole on 3/21/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import UIKit

///This ViewController should be embedded in a TabBarViewController along with the SignUpViewController
class SignInViewController: UIViewController {
    
    //MARK: Other Properties
    var userType: UserType?
    
    //MARK: IBOutlets
    @IBOutlet weak var loginFieldView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signInWithGoogleIDButtonTapped(_ sender: Any) {
        populateLoginFieldView(loginMethod: .googleID)
    }
    @IBAction func signInWithEmailTapped(_ sender: Any) {
        populateLoginFieldView(loginMethod: .email)
    }
    @IBAction func signInWithPhoneNumberTapped(_ sender: Any) {
        populateLoginFieldView(loginMethod: .phoneNumber)
    }
    
    //MARK: Private Methods
    private func populateLoginFieldView(loginMethod: SignInMethod) {
        switch loginMethod {
        case .googleID:
            let loginFieldViewController = GoogleIDAuthorizationViewController()
            loginFieldView.addSubview(loginFieldViewController.view)
        case .email:
            let loginFieldViewController = EmailAuthorizationViewController()
            loginFieldView.addSubview(loginFieldViewController.view)

        case .phoneNumber:
            let loginFieldViewController = PhoneAuthorizationViewController()
            loginFieldView.addSubview(loginFieldViewController.view)
        }
    }
    //MARK: Private Enum
    private enum SignInMethod {
        case googleID
        case email
        case phoneNumber
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

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
    //MARK: Private Properties
    //The viewController methods were not getting called until I added this private variable to the class scope. Originally I was declaring this variable three times in the populateLoginFieldView method. The ViewController methods were not getting hit at all. Now they are. So when using .xib files and placing them into views, you need to have a class-scope property to hold the ViewController. I don't know why.
    private var loginFieldViewController: UIViewController?
    
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
            loginFieldViewController = GoogleIDAuthorizationViewController()
            guard loginFieldViewController != nil else {return}
            loginFieldView.addSubview((loginFieldViewController?.view)!)
        case .email:
            loginFieldViewController = EmailAuthorizationViewController()
            guard loginFieldViewController != nil else {return}
            loginFieldView.addSubview((loginFieldViewController?.view)!)

        case .phoneNumber:
            loginFieldViewController = PhoneAuthorizationViewController()
            guard loginFieldViewController != nil else {return}
            loginFieldView.addSubview((loginFieldViewController?.view)!)
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

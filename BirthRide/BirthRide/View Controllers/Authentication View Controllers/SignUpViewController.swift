//
//  SignUpViewController.swift
//  BirthRide
//
//  Created by Austin Cole on 3/27/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import UIKit

///This ViewController should be embedded in a TabBarViewController along with the SignInViewController
class SignUpViewController: UIViewController {
    //MARK: Private Properties
    //The viewController methods were not getting called until I added this private variable to the class scope. Originally I was declaring this variable three times in the populateLoginFieldView method. The ViewController methods were not getting hit at all. Now they are. So when using .xib files and placing them into views, you need to have a class-scope property to hold the ViewController. I don't know why.
    private var signUpFieldViewController: UIViewController?
    
    //MARK: Other Properties
    var userType: UserType?
    
    //MARK: IBOutlets
    @IBOutlet weak var signUpFieldView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AuthenticationController.shared.isSigningUp = true
    }
    
    @IBAction func signUpWithGoogleIDButtonTapped(_ sender: Any) {
        populateLoginFieldView(loginMethod: .googleID)
    }
    @IBAction func signUpWithEmailTapped(_ sender: Any) {
        populateLoginFieldView(loginMethod: .email)
    }
    @IBAction func signUpWithPhoneNumberTapped(_ sender: Any) {
        populateLoginFieldView(loginMethod: .phoneNumber)
    }
    
    //MARK: Private Methods
    private func populateLoginFieldView(loginMethod: SignInMethod) {
        switch loginMethod {
        case .googleID:
            signUpFieldViewController = GoogleIDAuthorizationViewController()
            guard signUpFieldViewController != nil else {return}
            signUpFieldView.addSubview((signUpFieldViewController?.view)!)
        case .email:
            signUpFieldViewController = EmailAuthorizationViewController()
            guard signUpFieldViewController != nil else {return}
            signUpFieldView.addSubview((signUpFieldViewController?.view)!)
            
        case .phoneNumber:
            signUpFieldViewController = PhoneAuthorizationViewController()
            guard signUpFieldViewController != nil else {return}
            signUpFieldView.addSubview((signUpFieldViewController?.view)!)
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

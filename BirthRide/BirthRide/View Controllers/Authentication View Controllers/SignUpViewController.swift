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
        AuthenticationController.shared.isNewUser = true
    }
    
    @IBAction func signUpWithPhoneNumberTapped(_ sender: Any) {
        populateLoginFieldView()
    }
    
    //MARK: Private Methods
    private func populateLoginFieldView() {
        signUpFieldViewController = PhoneAuthorizationViewController()
        guard signUpFieldViewController != nil else {return}
        signUpFieldView.addSubview((signUpFieldViewController?.view)!)
    }
}

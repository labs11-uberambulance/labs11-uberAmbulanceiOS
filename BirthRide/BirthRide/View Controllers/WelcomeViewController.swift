//
//  WelcomeViewController.swift
//  BirthRide
//
//  Created by Austin Cole on 4/18/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    //mark: IBActions
    @IBAction func nextButtonTapped(_ sender: Any) {
        transitionToAuthentication()
    }
    
    //MARK:Private Methods
    private func transitionToAuthentication() {
        let destinationVC = PhoneAuthorizationViewController()
        present(destinationVC, animated: true, completion: nil)
    }

}
